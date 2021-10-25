CREATE PROCEDURE [ast].[pstCopExportStagingToAdw] 
    @QMDate DATE
    , @ClientKey INT
AS
 
      /* Log Export to adw */    
    DECLARE @AuditID INT 
    DECLARE @AuditStatus SmallInt= 1 -- 1 in process , 2 Completed
    DECLARE @JobType SmallInt     ;
    DECLARE @JobStatus tinyInt = 1	;
    DECLARE @JobName VARCHAR(200) ;
    DECLARE @ActionStartTime DATETIME = getdate();
    DECLARE @ActionStopTime DATETIME = getdate()
    DECLARE @InputSourceName VARCHAR(200) = 'No Name given';	   
    DECLARE @DestinationName VARCHAR(200) = 'No Name given';	   
    DECLARE @ErrorName VARCHAR(200)	  = 'No Name given';	   
    DECLARE @SourceCount int = 0;         
    DECLARE @DestinationCount int = 0;    
    DECLARE @ErrorCount int = 0;    
    
    /* Log adw Insert */
    SET @AuditID = null;
    SET @AuditStatus = 1 -- 1 in process , 2 Completed
    SET @JobType	= 8	   -- 8 adw Load
    SET @JobName = 'pstCopExportStagingToAdw';
    SET @ActionStartTime = getdate();
    SELECT @InputSourceName = DB_NAME() + '.ast.QM_ResultByMember_History';
    SELECT @DestinationName = DB_NAME() + '.adw.QM_ResultByMember_History';    
    SELECT @ErrorName	   = DB_NAME() + '.ast.QM_ResultByMember_History';        
            	
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

    SELECT @SourceCount = COUNT(*)
	   FROM ast.QM_ResultByMember_History ast
	   WHERE astRowStatus = 'Valid'
		  AND ast.ClientKey = @ClientKey 
		  AND ast.QMDate = @QMDate;

    /* adikey + ClientKey are a logical key for the staging table, and available as output from the insert */
    DECLARE @AdwExportOutput TABLE (adiKey INT, ClientKey INT, adwKey INT);
    INSERT INTO adw.QM_ResultByMember_History(
	   ClientKey
	   , [ClientMemberKey]
        , [QmMsrId]
        , [QmCntCat]
        , [QMDate] 
	   , adiKey)
    OUTPUT inserted.AdiKey, inserted.ClientKey, inserted.QM_ResultByMbr_HistoryKey INTO @AdwExportOutput(adiKey, CLientKey, adwKey)
    SELECT ClientKEy
	   , CLientMEmberKey
	   , QmMsrId
	   , QmCntCat
	   , QmDate
	   , adiKey	   
    FROM ast.QM_ResultByMember_History ast
	   WHERE astRowStatus = 'Valid'
		  AND ast.ClientKey = @ClientKey 
		  AND ast.QMDate = @QMDate
		  ;
    
    /* Updated staging rowStatus after Export: JOin to export result to limit your update to only rows exported. 
	   XXX NOTE XXX If this code is broken out into functions, this will need to be redesigned into a persistent OUTPUT table
	   */  
    UPDATE  trg
    SET trg.astRowStatus = src.NewStatus	   
    FROM ast.QM_ResultByMember_History trg
	   JOIN (SELECT DISTINCT ast.pstQM_ResultByMbr_HistoryKey, 'Exported' NewStatus
			 FROM @AdwExportOutput InsertTable
				JOIN ast.QM_ResultByMember_History ast  
				    ON InsertTable.adiKey = ast.AdiKey 
					   AND InsertTable.ClientKey = ast.ClientKey
					   AND ast.astRowStatus = 'Valid'
			 ) src
		  ON trg.pstQM_ResultByMbr_HistoryKey = src.pstQM_ResultByMbr_HistoryKey
    ;

    /* close auditl log */    
    SET @ActionStopTime = getdate();    
    SELECT @DestinationCount= COUNT(adwKey) FROM @AdwExportOutput
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
    
    SELECT @DestinationCount;
