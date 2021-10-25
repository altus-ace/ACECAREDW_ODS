


CREATE PROCEDURE [ast].[pstCopValidateStaging]
    (@QMDate DATE, @ClientKey INT)
AS 
    /* Validations: 
	   1. is the qm in list qm? If a qm is not mapped it will be loaded with a value not in the list ('null' as a word currently)
	   2. If the qm is in the list, is it active?

	   */
	   
     DECLARE @OutputTbl TABLE (ID INT);	
    --DECLARE @LoadDate Date = CONVERT(date, GETDATE()) ;	

    /* Log Stag Load */    
    DECLARE @AuditID INT 
    DECLARE @AuditStatus SmallInt= 1 -- 1 in process , 2 Completed
    DECLARE @JobType SmallInt     ;
    DECLARE @JobStatus tinyInt = 1	;
    DECLARE @JobName VARCHAR(200) = 'pstCopValidateStaging'
    DECLARE @ActionStartTime DATETIME = getdate();
    DECLARE @ActionStopTime DATETIME = getdate()
    DECLARE @InputSourceName VARCHAR(200) ;
	   SELECT @InputSourceName = DB_NAME() + '.ast.QM_ResultByMember_History'	    
    DECLARE @DestinationName VARCHAR(200) ;
	   SELECT @DestinationName = DB_NAME() + '.ast.QM_ResultByMember_History';    
    DECLARE @ErrorName VARCHAR(200);
	   SELECT @ErrorName = DB_NAME() + '.ast.QM_ResultByMember_History';        
    DECLARE @SourceCount int = 0;         
    DECLARE @DestinationCount int = 0;    
    DECLARE @ErrorCount int = 0;    

    /* XXXXXXXXXXXXXXXXXXXXX Valdation of business rules : refactor to  ast.Pdw_QM_Validate XXXXXXXXXXXXX */
    /* Log validation process*/        
    SET @JobType	= 11	   -- 11 ast validation        
    SET @ActionStartTime = getdate();        
        	
    EXEC AceMetaData.amd.sp_AceEtlAudit_Open 
        @AuditID = @AuditID OUTPUT
        , @AuditStatus = @AuditStatus
        , @JobType = @JobType
        , @ClientKey = @ClientKey
        , @JobName = @JobName
        , @ActionStartTime = @ActionStartTime
        , @InputSourceName = @InputSourceName
        , @DestinationName = @DestinationName
        , @ErrorName = @ErrorName
        ;

    /* get the count of the source prior to updates */
     SELECT @SourceCount = COUNT(ast.pstQM_ResultByMbr_HistoryKey) 
	   FROM ast.QM_ResultByMember_History ast
	   WHERE ast.ClientKey = @ClientKey 
		  AND ast.QMDate = @QMDate
		  AND ast.astRowStatus IN ('Loaded');
		  
    /* validate using business rules, none provided yet */
    BEGIN TRY /*
	   Update Trg 
	      SET Trg.astRowStatus = src.NewStatus -- New status
	      OUTPUT inserted.[pstQM_ResultByMbr_HistoryKey] INTO @OutputTbl(ID)    
	   FROM ast.QM_ResultByMember_History Trg
	      JOIN (SELECT ast.pstQM_ResultByMbr_HistoryKey, ast.astRowStatus, ast.qmMsrId, qm.qm,
				 CASE WHEN (ast.QmMsrId = 'NULL') THEN 'Not Valid' 
				    --WHEN ( ast.QmMsrId <> 'NULL' AND qm.ACTIVE = 'N') THEN 'Not Valid'			  
				    ELSE 'Valid' END AS NewStatus
	   		 FROM ast.QM_ResultByMember_History ast
				JOIN AceMasterData.lst.LIST_QM_Mapping qm  
				    ON ast.QmMsrId = qm.QM AND ast.QMDate BETWEEN qm.EffectiveDate and qm.ExpirationDate
	   		 WHERE ast.astRowStatus IN ('Loaded')
	   			AND  ISNULL(ast.QmMsrId,'')  <> '' -- Business Rule: All Measures must be mapped to QM Mapping: if not it is not a valid row
	   			AND ast.QMDate = @QMDate
	   			AND ast.ClientKey = @ClientKey 
	   		 ) SRC ON trg.pstQM_ResultByMbr_HistoryKey = src.pstQM_ResultByMbr_HistoryKey    
	      ; 
		  */

		  --Invalid QM_MsrID
		;WITH CTE_NotValid
		AS
		(
		SELECT astRowStatus,QmMsrId,QmCntCat
				,LoadDate 
		FROM	ACECAREDW.ast.QM_ResultByMember_History
		WHERE	ClientKey = @ClientKey 
		AND		QMDate = @QMDate
		AND		QmMsrId IS NULL
		)
		UPDATE CTE_NotValid
		SET		astRowStatus = 'Not Valid'

		---Valid QMMsrID
		;WITH CTE_Valid
		AS
		(
		SELECT astRowStatus,QmMsrId,QmCntCat
				,LoadDate 
		FROM	ACECAREDW.ast.QM_ResultByMember_History
		WHERE	ClientKey = @ClientKey 
		AND		QMDate = @QMDate
		AND		QmMsrId IS NOT NULL
		)
		UPDATE CTE_Valid
		SET		astRowStatus = 'Valid'
			  
		  --Validation 2
		/*Invalidate inactive Members*/
		UPDATE		ACECAREDW.[ast].[QM_ResultByMember_History]
		SET			astRowStatus = 'InActive' --- SELECT DISTINCT trg.ClientMemberKey,CLIENT_SUBSCRIBER_ID
		FROM		ACECAREDW.[ast].[QM_ResultByMember_History] trg
		LEFT JOIN	(
					SELECT		DISTINCT stg.ClientMemberKey,vw.CLIENT_SUBSCRIBER_ID
					FROM		ACECAREDW.[ast].[QM_ResultByMember_History] stg
					LEFT JOIN	ACECAREDW.dbo.vw_ActiveMembers vw
					ON			stg.ClientMemberKey = vw.CLIENT_SUBSCRIBER_ID
					WHERE		stg.QMDate = @QMDATE --'2021-08-15'
					AND			stg.ClientKey = @ClientKey -- 20
					)src
		ON			trg.ClientMemberKey = src.ClientMemberKey
		WHERE		trg.QMDate = @QMDATE -- '2021-08-15'
		AND			trg.ClientKey = @ClientKey
		AND			src.CLIENT_SUBSCRIBER_ID IS NULL
		     
    END TRY
    BEGIN CATCH
	   EXEC AceMetaData.amd.TCT_DbErrorWrite;	   
	   IF (XACT_STATE()) = -1
		  BEGIN
		  ROLLBACK TRANSACTION		  
		  END
	 -- Transaction committable
	   IF (XACT_STATE()) = 1
		  BEGIN
		  COMMIT TRANSACTION    ;		 
		  END 
	   /* write error log close */    
	   SET @ActionStopTime = getdate();    	   	   
	   SELECT @DestinationCount= 0;
	   SET @ErrorCount = @SourceCount;
	   SET @JobStatus = 3 -- error
	   EXEC AceMetaData.amd.sp_AceEtlAudit_Close 
		  @AuditId = @AuditID
		  , @ActionStopTime = @ActionStopTime
		  , @SourceCount = @SourceCount		  
		  , @DestinationCount = @DestinationCount
		  , @ErrorCount = @ErrorCount
		  , @JobStatus = @JobStatus
		  ;
	   ;THROW
    END CATCH

    /* close validate staging Log record */    
    SET @ActionStopTime = getdate();   
    SELECT @DestinationCount= COUNT(ID) FROM @OutputTbl;
    SET @ErrorCount = 0
    SET @JobStatus = 2

    EXEC AceMetaData.amd.sp_AceEtlAudit_Close 
        @AuditId = @AuditID
        , @ActionStopTime = @ActionStopTime
        , @SourceCount = @SourceCount		  
        , @DestinationCount = @DestinationCount
        , @ErrorCount = @ErrorCount
        , @JobStatus = @JobStatus
	   ;
