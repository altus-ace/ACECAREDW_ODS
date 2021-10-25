
CREATE PROCEDURE [ast].[PdwCop_Load_Uhc_Old]
AS 
    /* version History: 
	   1. created using adi.vw_pdwSrc_CopUhcPcor as source. adi.CopUhcPcor (pivoted src)
		  This source is pivoted and hard to modify/add measures. This was a known issue.
		  This source controled what adi candidtate rows where loaded. This was a known issue
	   2. Created using adi.vw_pdwSrc_CopUhcPcor as source. Using table adi.CopUhcPcorMeasureView, unpivoted, and scalable.
		   */
    /* load to staging -- ast.Pdw_QM_LoadStaging */
   DECLARE @OutputTbl TABLE (ID INT);	
   DECLARE @LoadDate Date = CONVERT(date, GETDATE()) ;	    
   
   /* Validation Code: check for missing mapping */ 
    DECLARE @cntMissingMapping INT
    EXEC @cntMissingMapping = adi.[AceValidCopUhcCareOps] 
    -- the error output here should be exported to a table so a data steward task can be completed prior to new load attempt
    -- IF errors found exit.
    IF @cntMissingMapping >0 
	   raiserror('Ace invalid Mapping found: PdwCop_Load_Uhc, for info review ast.AceValidationLog for details.', 20, -1) with log
    
    /* Log Stag Load */    
    DECLARE @AuditID INT 
    DECLARE @AuditStatus SmallInt= 1 -- 1 in process , 2 Completed
    DECLARE @JobType SmallInt = 2	   -- 1 adi load, 2 dw load????
    DECLARE @ClientKey INT	 = 1  
    DECLARE @JobName VARCHAR(200) = 'Pst_Cop_Uhc'
    DECLARE @ActionStartTime DATETIME2 = getdate();
    DECLARE @InputSourceName VARCHAR(200) 
	   SELECT @InputSourceName = DB_NAME() + '.adi.UHCQualityGapReport'	    
    DECLARE @DestinationName VARCHAR(200) = 'No Destination Name Provided'	
	   SELECT @DestinationName = DB_NAME() + '.ast.QM_ResultByMember_History';    
    DECLARE @ErrorName VARCHAR(200) = 'No Error Name Provided'	
    	
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
    /* QM are loaded in 2 passes. 
		  1st load Num and COP (1 row in for every row found in input set) 
		  2nd load DEN (1 row for every row in input set)
		  */
    /* load to staging table insert set for Num and Cop */
    INSERT INTO [ast].[QM_ResultByMember_History]
           ([ClientKey]
           ,[ClientMemberKey]
           ,[QmMsrId]
           ,[QmCntCat]
           ,[QMDate]
           ,[astRowStatus]
           ,[adiTableName]
           ,[adiKey]
           ,[LoadDate])
    OUTPUT inserted.[pstQM_ResultByMbr_HistoryKey] INTO @OutputTbl(ID)
    SELECT 
	     Client.ClientKey
	   , adiData.MemberId    	
	   , CASE WHEN (qm.QM is null) THEN 'NULL' ELSE qm.QM END as QM_ID--, lstAceMap.Source
	   , (CASE WHEN AdiData.[Compliance] = 'Yes' THEN 'NUM'
	   		  WHEN adiData.[Compliance] = 'No'   THEN 'COP'
	   	  ELSE 'Unk'END) as CopMsrStatus
	   , adiData.[DataDate] as QM_Date   
	   , 'Loaded' AS astRowStatus
	   , 'adi.UHCQualityGapReport' AS adiTableName
	   , adiData.UhcQualityGapReportKey AS AdiKey
	   , CONVERT(date, GETDATE()) aS LoadDate	   
	   --, adiData.MeasureID, adidata.SubMeasureID, adiData.MeasureDescription, adiData.SubmeasureDescription  	   
    FROM [adi].UHCQualityGapReport adiData
	   JOIN lst.List_Client Client ON 1 = Client.ClientKey
	   LEFT JOIN aceMasterData.lst.ListAceMapping lstAceMap
	      ON Client.ClientShortName +'_'+adiData.MeasureId + '_'+ adidata.SubmeasureId = lstAceMap.Source
	   	  and lstAceMap.MappingTypeKey = 14 and lstAceMap.IsActive = 1
	   LEFT JOIN (SELECT QM, QM_DESC, qm.EffectiveDate, qm.ExpirationDate
	   			FROM aceMasterData.[lst].[LIST_QM_Mapping] qm  
				WHERE qm.qm like 'UHC%') qm 
	   		ON lstAceMap.Destination = qm.QM	
			 AND adiData.DataDate BETWEEN qm.EffectiveDate and qm.ExpirationDate			 
    WHERE adiData.MemberID <> '' 
	   AND ISNULL(adiData.[COMPLIANCE], '') <> ''	   
	   AND adiData.CopLoadStatus = 0	   	   
    ;

        /* insert a second time all as DEN */
    INSERT INTO [ast].[QM_ResultByMember_History]
           ([ClientKey]
           ,[ClientMemberKey]
           ,[QmMsrId]
           ,[QmCntCat]
           ,[QMDate]
           ,[astRowStatus]
           ,[adiTableName]
           ,[adiKey]
           ,[LoadDate])
    OUTPUT inserted.[pstQM_ResultByMbr_HistoryKey] INTO @OutputTbl(ID)
     SELECT 
	     Client.ClientKey
	   , adiData.MemberId    	
	   , CASE WHEN (qm.QM is null) THEN 'NULL' ELSE qm.QM END as QM_ID
	   , 'DEN'  as CopMsrStatus
	   , adiData.[DataDate] as QM_Date    
	   , 'Loaded' AS astRowStatus
	   , 'adi.UHCQualityGapReport' AS adiTableName
	   , adiData.UhcQualityGapReportKey AS AdiKey
	   , CONVERT(date, GETDATE()) aS LoadDate	   
	   --, adiData.MeasureID, adidata.SubMeasureID, adiData.MeasureDescription, adiData.SubmeasureDescription   
    FROM [adi].UHCQualityGapReport adiData
	   JOIN lst.List_Client Client ON 1 = Client.ClientKey
	   LEFT JOIN aceMasterData.lst.ListAceMapping lstAceMap
	      ON Client.ClientShortName +'_'+adiData.MeasureId + '_'+ adidata.SubmeasureId = lstAceMap.Source
	   	  and lstAceMap.MappingTypeKey = 14 and lstAceMap.IsActive = 1
	   LEFT JOIN (SELECT QM, QM_DESC, qm.EffectiveDate, qm.ExpirationDate
	   		  FROM aceMasterData.[lst].[LIST_QM_Mapping] qm  ) qm 
	   		ON lstAceMap.Destination = qm.QM	
			 AND adiData.DataDate BETWEEN qm.EffectiveDate and qm.ExpirationDate
    WHERE adiData.MemberID <> '' 
	   AND ISNULL(adiData.[COMPLIANCE], '') <> ''
	   AND adiData.CopLoadStatus = 0
    ;
    
    /* Update Adi load status value = 1 so it is not considered for future loads */    
    UPDATE adiData SET adiData.CopLoadStatus = 1
    --SELECT adiData.copLoadStatus, adiData.UHCQualityGapReportKey, ast.adiKey, ast.astRowStatus, ast.pstQM_ResultByMbr_HistoryKey, ast.CreateDate
    FROM adi.UHCQualityGapReport adiData
	   JOIN ast.QM_ResultByMember_History ast 
		  ON adiData.UHCQualityGapReportKey = ast.adiKey 
			 and ast.ClientKey = 1
			 and ast.astRowStatus = 'Loaded'
    WHERE adiData.CopLoadStatus = 0;

    

    /* close load Staging Log record */    
    DECLARE @ActionStopTime DATETIME = getdate()
    DECLARE @SourceCount int; --= 25
	   SELECT @SourceCount = COUNT(ID) FROM @OutputTbl;
    DECLARE @DestinationCount int; -- = 23
	   SELECT @SourceCount = COUNT(ID) FROM @OutputTbl;
    DECLARE @ErrorCount int = 0
    DECLARE @JobStatus tinyInt = 2

    EXEC AceMetaData.amd.sp_AceEtlAudit_Close 
        @AuditId = @AuditID
        , @ActionStopTime = @ActionStopTime
        , @SourceCount = @SourceCount		  
        , @DestinationCount = @DestinationCount
        , @ErrorCount = @ErrorCount
        , @JobStatus = @JobStatus
	   ;
	 
    /* transform */

    -- none currently

    /* validate -- ast.Pdw_QM_Validate */
    MERGE ast.QM_ResultByMember_History TRG
    USING(SELECT ast.pstQM_ResultByMbr_HistoryKey, ast.astRowStatus, ast.QmMsrId, qm.Active,
		  CASE WHEN (ast.QmMsrId = 'NULL') THEN 'Not Valid' 
			  WHEN ( ast.QmMsrId <> 'NULL' AND qm.ACTIVE = 'N') THEN 'Not Valid'			  
			 ELSE 'Valid' END AS NewStatus
		  FROM ast.QM_ResultByMember_History ast
			 LEFT JOIN acemasterdata.lst.LIST_QM_Mapping qm ON ast.QmMsrId = qm.QM
				AND ast.QMDate BETWEEN qm.EffectiveDate and qm.ExpirationDate
		  WHERE ast.astRowStatus IN ('Loaded') AND
			 ast.ClientKey = @ClientKey  AND
			 ast.LoadDate = @LoadDate    			 
		  ) SRC
    ON trg.pstQM_ResultByMbr_HistoryKey = src.pstQM_ResultByMbr_HistoryKey
    WHEN MATCHED THEN UPDATE 
	   SET TRG.astRowStatus = SRC.NewStatus
	   ;    

    /* xport -- ast.Pdw_QM_Export */
    DECLARE @InsertTable TABLE (adiKey INT);	
    INSERT INTO adw.QM_ResultByMember_History(
	   ClientKey
	   , [ClientMemberKey]
        , [QmMsrId]
        , [QmCntCat]
        , [QMDate] 
	   , adiKey)
    OUTPUT inserted.AdiKey INTO @InsertTable(adiKey)
    SELECT ClientKEy
	   , CLientMEmberKey
	   , QmMsrId
	   , QmCntCat
	   , QmDate
	   , adiKey
    FROM ast.QM_ResultByMember_History
	   WHERE astRowStatus = 'Valid'
    
    /* Updated staging rowStatus after Export: JOin to export result to limit your update to only rows exported. 
	   XXX NOTE XXX If this code is broken out into functions, this will need to be redesigned into a persistent OUTPUT table
	   */        
    MERGE ast.QM_ResultByMember_History trg
    USING (SELECT DISTINCT ast.pstQM_ResultByMbr_HistoryKey, 'Exported' NewStatus
		 FROM @InsertTable InsertTable
		  JOIN ast.QM_ResultByMember_History ast  ON InsertTable.adiKey = ast.AdiKey
			 AND ast.astRowStatus = 'Valid'
		  ) src
    ON trg.pstQM_ResultByMbr_HistoryKey = src.pstQM_ResultByMbr_HistoryKey
    WHEN MATCHED THEN UPDATE 
	   set trg.astRowStatus = src.NewStatus
	   ;
    
    declare @InsertCount INT;
    SELECT @InsertCount = COUNT(*)
    FROM @OutputTbl ;
    
    

    RETURN;
    
