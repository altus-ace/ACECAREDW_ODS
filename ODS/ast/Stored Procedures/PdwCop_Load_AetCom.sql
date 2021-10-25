CREATE PROCEDURE [ast].[PdwCop_Load_AetCom]
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
    EXEC @cntMissingMapping = adi.AceValidUhcCareOpsPcor 
    -- the error output here should be exported to a table so a data steward task can be completed prior to new load attempt
    -- IF errors found exit.
    IF @cntMissingMapping >0 
	   raiserror('Ace invalid Mapping found: PdwCop_Load_Uhc', 20, -1) with log
    
    /* Log Stag Load */    
    DECLARE @AuditID INT 
    DECLARE @AuditStatus SmallInt= 1 -- 1 in process , 2 Completed
    DECLARE @JobType SmallInt = 2	   -- 1 adi load, 2 dw load????
    DECLARE @ClientKey INT	 = 9  
    DECLARE @JobName VARCHAR(200) = 'Pst_Cop_AetCom'
    DECLARE @ActionStartTime DATETIME2 = getdate();
    DECLARE @InputSourceName VARCHAR(200) 
	   SELECT @InputSourceName = DB_NAME() + 'adi.tvf_pdwSrc_CopAetComCareopps'    
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
	    adiSrc.ClientKey
    	   ,adiSrc.ClientMemberKey
    	   ,adiSrc.QmMsrID
    	   ,adiSrc.QmCntCat
    	   ,adiSrc.QmDate	      	   
	   , 'Loaded' AS astRowStatus
	   , adiSrc.AdiTableName
	   ,adiSrc.adiKey  
	   ,@LoadDate
    FROM adi.tvf_pdwSrc_CopAetComCareopps((SELECT MAX(stg.DataDate) MaxDataDate FROM adi.copAetComCareopps stg )) AS adiSrc        
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
	    adiSrc.ClientKey
    	   ,adiSrc.ClientMemberKey
    	   ,adiSrc.QmMsrID
    	   ,'DEN'   as QmCntCat
    	   ,adiSrc.QmDate	      	   
	   , 'Loaded' AS astRowStatus
	   , adiSrc.AdiTableName
	   ,adiSrc.adiKey  
	   ,@LoadDate
    FROM adi.tvf_pdwSrc_CopAetComCareopps((SELECT MAX(stg.DataDate) MaxDataDate FROM adi.copAetComCareopps stg )) AS adiSrc
    
    	   

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
    USING(SELECT ast.pstQM_ResultByMbr_HistoryKey, ast.astRowStatus, 'Valid' NewStatus
		  FROM ast.QM_ResultByMember_History ast
		  WHERE ast.ClientKey = @ClientKey 
			 AND ast.LoadDate = @LoadDate
			 AND ast.astRowStatus IN ('Loaded')
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
    
