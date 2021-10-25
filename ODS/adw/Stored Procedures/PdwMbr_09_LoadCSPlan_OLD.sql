
CREATE PROCEDURE [adw].[PdwMbr_09_LoadCSPlan_OLD]
    @LoadDate Date,
    @ClientKey INT,
	@InsertCount INT OUTPUT,
	@UpdateCount INT OUTPUT
AS  
    /* 02/22/2021: gk added exception wrapper to capture and log issue to ace metadata table if error encountered */
    DECLARE @ExpirationDate DATE = '12/31/2099';
    DECLARE @Plan varchar(20) = 'Medicare';    
    DECLARE @PlanDualCoverage VARCHAR(1) = '0';
    
    /* SET UP OUTPUT TABLES and CODES */
	   /* OutPutType: INT 
	   1 = working set insert 
	   2	= Insert New
	   3 = Version working Set
	   4 = Version Term
	   5 = version Insert
	   6 = Termed Member */
    DECLARE @OutPutType TABLE (OutputType TinyInt, Descrip VARCHAR(30));
    INSERT INTO @OutPutType (OutputType, Descrip)
    VALUES (1,'Working Set insert')
		 ,(2,'Insert New')
		 ,(3,'Version working Set')
		 ,(4,'Version Term')
		 ,(5, 'Version Insert')
		 ,(6, 'Termed Member');
    DECLARE @OutputTbl TABLE (ID INT, OutputType INT);

    /* create working table Mbr Plan, 
	   This should be a permant stucture:
		  with a status field per row, so etl can be more failure safe */
    IF OBJECT_ID('tempdb..#MbrCsPlan') IS NOT NULL 
        DROP TABLE #MbrCsPlan
    CREATE TABLE #MbrCsPlan (mbrLoadHistoryKey INT, mbrMemberKey INT, mbrCsPlanKey INT
    			 , NewEffective DATE, NewExpiration DATE, loadType CHAR(1)
    			 , NewProductSubPlan VARCHAR(50), NewProductSubPlanName VARCHAR(50)
    			 , NewLoadDate DATE, NewDataDate Date
    			 , CurProductSubPlan VARCHAR(50), CurProductSubPlanName VARCHAR(50));

    /* LOAD WORKING SET */
    INSERT INTO #MbrCsPlan (mbrLoadHistoryKey, mbrMemberKey, mbrCsPlanKey
    			 , NewEffective, NewExpiration, loadType
    			 , NewProductSubPlan, NewProductSubPlanName
    			 , NewLoadDate, NewDataDate
    			 , CurProductSubPlan, CurProductSubPlanName
    			 )
    OUTPUT inserted.mbrCsPlanKey ,1 INTO @OutputTbl(ID, OutputType)     
    SELECT lh.mbrLoadHistoryKey, mbr.MbrMemberKey, p.mbrCsPlanKey
		  , m.NewEffDate, m.NewExpDate, m.LoadType
		  , m.plnProductPlan AS NewProductSubPlan , m.PlanName AS NewProductSubPlanName 
		  , m.loaddate AS NewLoadDate, m.DataDate AS NewDataDate
		  , p.MbrCsSubPlan CurSubPlan, p.MbrCsSubPlanName CurSubPlanName		  
	   FROM  (SELECT s.ClientSUbscriberId, s.AdiKey, s.LoadType, s.AdiTableName,s.NewEffDate
			 , s.NewExpDate,s.cPlanName PlanName, s.cplnProductPlan plnProductPlan
			 , s.LoadDate , s.DataDate
		  FROM (SELECT m.AdiKey, m.adiTableName, m.LoadType, m.ClientSubscriberId
				    , CASE WHEN (m.LoadType = 'P')  
					   THEN CONVERT(DATE, DATEADD(DAY, (-1*DATEPART(day,@LoadDate)+1), @LoadDate)) 
       				   ELSE @LoadDate END AS NewEffDate 
				    , case when (plnName.TargetValue is null) THEN m.plnProductPlan
					   else plnName.TargetValue END as cPlanName
				    , case when (plnName.TargetValue is null) THEN m.plnProductSubPlan
					   else plnName.TargetValue END as cplnProductPlan
				    , @ExpirationDate AS NewExpDate, m.LoadDate, m.DataDate
				, ROW_NUMBER() OVER(PARTITION BY m.ClientSubscriberID ORDER BY m.LoadDATE ASC) arn				
				--, plnname.SourceValue, plnName.TargetValue 
				FROM ast.MbrStg2_MbrData m  
				    LEFT JOIN lst.lstPlanMapping plnName 
					   ON ((m.plnProductPlan = plnName.SourceValue And m.ClientKey = m.ClientKey) 
						  OR  (m.plnProductSubPlan = plnName.SourceValue))
					   AND @loadDate BETWEEN plnName.EffectiveDate AND plnName.ExpirationDate					   
					   AND plnName.TargetSystem = 'CS_AHS'									
				WHERE m.LoadDate = @LoadDate
				    AND m.CLientKey = @ClientKey
				    AND m.stgRowStatus = 'Valid'
				) s
			 WHERE s.arn = 1
			 ) m
		  JOIN adw.MbrLoadHistory Lh ON m.adiKey = lh.AdiKey AND m.AdiTableName = lh.AdiTableName
		  JOIN adw.MbrMember mbr ON m.ClientSubscriberId = mbr.ClientMemberKey		  
		  LEFT JOIN adw.MbrCSPlanHistory p ON mbr.MbrMemberKey = p.MbrMemberKey
			 		AND GETDATE() BETWEEN p.EffectiveDate AND p.ExpirationDate
	   WHERE m.LoadDate = @LoadDate;


    /* INSERT NEW ROWS: WHERE MbrPlanKey is NULL */
    /* version History: GK: 2/22/2021 Added Try/catch to capture error and send to meta failure log */
    BEGIN TRY      
	   BEGIN TRAN      
	
	   INSERT INTO adw.mbrCSPlanHistory ([MbrMemberKey],[MbrLoadKey],[EffectiveDate],[ExpirationDate]
               ,[MbrCsSubPlan],[MbrCsSubPlanName],[planHistoryStatus],[LoadDate],[DataDate])
        OUTPUT inserted.mbrCsPlanKey, 2 INTO @OutputTbl(ID, OutputType)  
        SELECT src.MbrMemberKey, src.mbrLoadHistoryKey, src.NewEffective, src.NewExpiration
    	   , src.NewProductSubPlan, src.NewProductSubPlanName, 1 AS PlanHistStatus, GETDATE() AS LoadDate, src.NewDataDate 
        FROM #MbrCsPlan AS src
        WHERE src.mbrCsPlanKey is Null;
    
       COMMIT TRAN;        	   
    END TRY      
    BEGIN CATCH      
	   EXEC AceMetaData.amd.TCT_DbErrorWrite;          
	   IF (XACT_STATE()) = -1      
		  BEGIN      
		  ROLLBACK TRANSACTION          
		  END    	   
	   IF (XACT_STATE()) = 1      
		  BEGIN      
		  COMMIT TRANSACTION    ;         
		  END       
	   /* write error log close */          
--	   SET @ActionStopTime = getdate();              
--	   SELECT @SourceCount = COUNT(*) 
--		 FROM adi.vw_PstSrc_CopWlcTxM ;      
--	   SELECT @DestinationCount= 0;      
--	   SET @ErrorCount = @SourceCount;      
--	   SET @JobStatus = 3 -- error      
--	   EXEC AceMetaData.amd.sp_AceEtlAudit_Close       
--		  @AuditId = @AuditID      
--		  , @ActionStopTime = @ActionStopTime      
--		  , @SourceCount = @SourceCount          
--		  , @DestinationCount = @DestinationCount      
--		  , @ErrorCount = @ErrorCount      
--		  , @JobStatus = @JobStatus      
--		  ;      
	   ;THROW      
    END CATCH;
        

    /* PREPARE VERSION SET */	   
    BEGIN TRY      
	   BEGIN TRAN      
	   
	   IF OBJECT_ID('tempdb..#MbrCsPlanToVersion') IS NOT NULL 
		  DROP TABLE #MbrCsPlanToVersion;
	   CREATE TABLE #MbrCsPlanToVersion (mbrCsPlanKey INT);
    
       
	   INSERT INTO #MbrCsPlanToVersion(mbrCsPlanKey)
	   OUTPUT inserted.mbrCsPlanKey,3 INTO @OutputTbl(ID,OutputType)
	   SELECT src.mbrCsPlanKey
	   FROM #MbrCsPlan AS src
	   WHERE NOT src.mbrCsPlanKey is Null
	      and (src.CurProductSubPlan <> NewProductSubPlan 
	   		 OR src.CurProductSubPlanName <> NewProductSubPlanName);
	   /* TERM PRIOR ROW: SET Expiration date = src.NewEffectiveDate */
	   UPDATE adw.MbrCSPlanHistory
	      SET ExpirationDate = DATEADD(day, -1, src.NewEffective)/* calc a day 1 less than new effective */
	   OUTPUT inserted.mbrCsPlanKey, 4 INTO @OutputTbl(ID, OutputType)
	   FROM adw.mbrCSPlanHistory m
	      JOIN #MbrCsPlan AS src ON src.mbrCsPlanKey = m.mbrCsPlanKey
	      JOIN #MbrCsPlanToVersion AS v ON src.mbrCsPlanKey = v.mbrCsPlanKey;

	   /* INSERT NEW VERSION OF ROW:  */

	   INSERT INTO [adw].[mbrCsPlanHistory]
	              ([MbrMemberKey]
	              ,[MbrLoadKey]
	              ,[EffectiveDate]
	              ,[ExpirationDate]
	              ,[MbrCsSubPlan]
	              ,[MbrCsSubPlanName]	           
	              ,[planHistoryStatus]
	              ,[LoadDate]
	              ,[DataDate])
	   OUTPUT inserted.mbrCsPlanKey, 5 INTO @OutputTbl(ID,OutputType)
	   SELECT src.MbrMemberKey, src.mbrLoadHistoryKey, src.NewEffective, src.NewExpiration
	      , src.NewProductSubPlan, src.NewProductSubPlanName, 1 AS PlanHistStatus
	      , GETDATE(), src.NewDataDate
	   FROM #MbrCsPlan AS src
	      JOIN #MbrCsPlanToVersion v ON src.mbrCsPlanKey = v.mbrCsPlanKey;

	   COMMIT TRAN;        
	   
    END TRY      
    BEGIN CATCH      
	   EXEC AceMetaData.amd.TCT_DbErrorWrite;          
	   IF (XACT_STATE()) = -1      
		  BEGIN      
		  ROLLBACK TRANSACTION          
		  END    	   
	   IF (XACT_STATE()) = 1      
		  BEGIN      
		  COMMIT TRANSACTION    ;         
	   END       
	   /* write error log close */          
	--   SET @ActionStopTime = getdate();              
	--   SELECT @SourceCount = COUNT(*) 
	--	 FROM adi.vw_PstSrc_CopWlcTxM ;      
	--   SELECT @DestinationCount= 0;      
	--   SET @ErrorCount = @SourceCount;      
	--   SET @JobStatus = 3 -- error      
	--   EXEC AceMetaData.amd.sp_AceEtlAudit_Close       
	--	  @AuditId = @AuditID      
	--	  , @ActionStopTime = @ActionStopTime      
	--	  , @SourceCount = @SourceCount          
	--	  , @DestinationCount = @DestinationCount      
	--	  , @ErrorCount = @ErrorCount      
	--	  , @JobStatus = @JobStatus      
	--	  ;      
	   ;THROW      
    END CATCH        
    
	   
    SELECT @InsertCount = COUNT(*) 
    FROM @OutputTbl o
	   JOIN @OutPutType t ON o.OutputType = t.OutputType
    WHERE o.OutputType = 2
    GROUP BY t.Descrip ;
    
    SELECT @UpdateCount = COUNT(*) 
    FROM @OutputTbl o
	   JOIN @OutPutType t ON o.OutputType = t.OutputType
    WHERE o.OutputType = 5
    GROUP BY t.Descrip ;
    RETURN;
