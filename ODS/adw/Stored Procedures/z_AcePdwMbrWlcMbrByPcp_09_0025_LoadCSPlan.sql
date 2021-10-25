
CREATE PROCEDURE [adw].[z_AcePdwMbrWlcMbrByPcp_09_0025_LoadCSPlan]
    @LoadDate Date,
	@InsertCount INT OUTPUT,
	@UpdateCount INT OUTPUT
AS
    DECLARE @Plan varchar(20) = 'Medicare';    
    DECLARE @PlanDualCoverage VARCHAR(1) = '0';
    DECLARE @AdiTableName VARCHAR(50) = 'MbrWlcMbrByPcp';
    
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
    IF OBJECT_ID('dbo.tmpWlcCsPlan') IS NOT NULL 
        DROP TABLE dbo.tmpWlcCsPlan;
    CREATE TABLE dbo.tmpWlcCsPlan (mbrLoadHistoryKey INT, mbrMemberKey INT, mbrCsPlanKey INT
    			 , NewEffectiveDate DATE, NewExpirationDate DATE, loadType CHAR(1)
    			 , NewProductSubPlan VARCHAR(20), NewProductSubPlanName VARCHAR(50)
    			 , NewDataDate Date
    			 , CurProductSubPlan VARCHAR(20), CurProductSubPlanName VARCHAR(50));
    
    /* LOAD WORKING SET */
    INSERT INTO dbo.tmpWlcCsPlan (mbrLoadHistoryKey, mbrMemberKey, mbrCsPlanKey
    			 , NewEffectiveDate
    			 , NewExpirationDate, loadType
    			 , NewProductSubPlan, NewProductSubPlanName
    			 , NewDataDate
    			 , CurProductSubPlan, CurProductSubPlanName
    			 )
    OUTPUT inserted.mbrCsPlanKey ,1 INTO @OutputTbl(ID, OutputType)      

    SELECT DISTINCT lh.mbrLoadHistoryKey, mbr.MbrMemberKey, p.mbrCsPlanKey
		  , adiMbrs.EffDate AS NewEffDate
		  , '12/31/2099' AS NewExpirationDate, LoadType
		  , adiMbrs.BenePlan AS NewProductSubPlan , CsPlanMap.TargetValue AS NewProductSubPlanName 
		  , adiMbrs.DataDate AS NewDataDate
		  , p.MbrCsSubPlan CurSubPlan, p.MbrCsSubPlanName CurSubPlanName		  
	  FROM  adi.tvf_PdwSrc_Wlc_MemberByPcp(@LoadDate) adiMbrs
		  JOIN lst.lstPlanMapping PlanMap ON AdiMbrs.BenePLAN = PlanMap.SourceValue
					   AND PlanMap.ClientKey = 2 
					   AND PlanMap.TargetSystem = 'ACDW' /* map for ACDW */
					   AND @loadDate BETWEEN PlanMap.EffectiveDate and PlanMap.ExpirationDate		
		  JOIN lst.lstPlanMapping CsPlanMap ON adiMbrs.BenePLAN = CsPlanMap .SourceValue
					   AND CsPlanMap .ClientKey = 2 
					   AND CsPlanMap .TargetSystem = 'CS_AHS'
					   AND @LoadDate between CsPlanMap .EffectiveDate and CsPlanMap .ExpirationDate
		  LEFT JOIN adw.MbrLoadHistory Lh ON adiMbrs.mbrWlcMbrByPcpKey = lh.adiKey and lh.adiTableName = @adiTableName
		  JOIN adw.MbrMember mbr ON adiMbrs.Sub_ID = mbr.ClientMemberKey		  
		  JOIN adw.MbrWlcProviderLookup pl ON AdiMbrs.Prov_id = pl.Prov_id  
			  AND @loaddate <= pl.Term_Date
		  LEFT JOIN (SELECT p.mbrCsPlanKey, p.MbrMemberKey,  p.MbrCsSubPlan, p.MbrCsSubPlanName 
				    FROM adw.MbrCSPlanHistory p 
					   JOIN adw.mbrMember M On p.mbrMemberKey = M.mbrMemberKey 
					   WHERE m.clientKey = 2
						  AND GETDATE() BETWEEN p.EffectiveDate AND p.ExpirationDate) p
					    ON mbr.MbrMemberKey = p.MbrMemberKey			 				
	   WHERE  ISNULL(adiMbrs.BenePLAN, '') <> ''
		  AND adiMbrs.BestMemberRow = 1
		  ;
	   
    /* INSERT NEW ROWS: WHERE MbrPlanKey is NULL */
    INSERT INTO adw.mbrCSPlanHistory ([MbrMemberKey],[MbrLoadKey],[EffectiveDate],[ExpirationDate]
           ,[MbrCsSubPlan],[MbrCsSubPlanName],[planHistoryStatus],[LoadDate],[DataDate])
    OUTPUT inserted.mbrCsPlanKey, 2 INTO @OutputTbl(ID, OutputType)
    SELECT src.MbrMemberKey, src.mbrLoadHistoryKey, src.NewEffectiveDate, src.NewExpirationDate
	   , src.NewProductSubPlan, src.NewProductSubPlanName, 1 AS PlanHistStatus, GETDATE() AS LoadDate, src.NewDataDate 
    FROM dbo.tmpWlcCsPlan AS src
    WHERE src.mbrCsPlanKey is Null;
        

    /* PREPARE VERSION SET */	   
    IF OBJECT_ID('dbo.tmpWlcCsPlanToVersion') IS NOT NULL 
	   DROP TABLE dbo.tmpWlcCsPlanToVersion;
    CREATE TABLE dbo.tmpWlcCsPlanToVersion (mbrCsPlanKey INT);
    
       
    INSERT INTO dbo.tmpWlcCsPlanToVersion(mbrCsPlanKey)
    OUTPUT inserted.mbrCsPlanKey,3 INTO @OutputTbl(ID,OutputType)
    SELECT src.mbrCsPlanKey
    FROM dbo.tmpWlcCsPlan AS src
    WHERE NOT src.mbrCsPlanKey is Null
	   and (src.CurProductSubPlan <> NewProductSubPlan 
			 OR src.CurProductSubPlanName <> NewProductSubPlanName);
    /* TERM PRIOR ROW: SET Expiration date = src.NewEffectiveDate */
    UPDATE adw.MbrCSPlanHistory
	   SET ExpirationDate = DATEADD(day, -1, src.NewEffectiveDate)/* calc a day 1 less than new effective */
    OUTPUT inserted.mbrCsPlanKey, 4 INTO @OutputTbl(ID, OutputType)
    FROM adw.mbrCSPlanHistory m
	   JOIN dbo.tmpWlcCsPlan AS src ON src.mbrCsPlanKey = m.mbrCsPlanKey
	   JOIN dbo.tmpWlcCsPlanToVersion AS v ON src.mbrCsPlanKey = v.mbrCsPlanKey;

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
    SELECT src.MbrMemberKey, src.mbrLoadHistoryKey, src.NewEffectiveDate, src.NewExpirationDate
	   , src.NewProductSubPlan, src.NewProductSubPlanName, 1 AS PlanHistStatus
	   , GETDATE(), src.NewDataDate
    FROM dbo.tmpWlcCsPlan AS src
	   JOIN dbo.tmpWlcCsPlanToVersion v ON src.mbrCsPlanKey = v.mbrCsPlanKey;
	   
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
