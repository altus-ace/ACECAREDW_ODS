


CREATE PROCEDURE [adw].[z_AcePdwMbrWlcMbrByPcp_08_0025_LoadPlan]
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
    IF OBJECT_ID('dbo.tmpWlcPlan') IS NOT NULL 
        DROP TABLE dbo.tmpWlcPlan;
    CREATE TABLE dbo.tmpWlcPlan (mbrLoadHistoryKey INT, mbrMemberKey INT, mbrPlanKey INT
    			 , NewEffectiveDate DATE, NewExpirationDate DATE, loadType CHAR(1)
    			 , NewProductPlan VARCHAR(20), NewProductSubPlan VARCHAR(20)
    			 , NewProductSubPlanName VARCHAR(50), NewMbrIsDualCoverage TinyInt
    			 , NewDataDate Date
    			 , CurProductPlan VARCHAR(20), CurProductSubPlan VARCHAR(20)
    			 , CurProductSubPlanName VARCHAR(50), CurMbrIsDualCoverage TinyInt);
    
    /* LOAD WORKING SET */
    INSERT INTO dbo.tmpWlcPlan (mbrLoadHistoryKey, mbrMemberKey, mbrPlanKey
    			 , NewEffectiveDate
    			 , NewExpirationDate, loadType
    			 , NewProductPlan, NewProductSubPlan
    			 , NewProductSubPlanName, NewMbrIsDualCoverage
    			 , NewDataDate
    			 , CurProductPlan, CurProductSubPlan, CurProductSubPlanName
    			 , CurMbrIsDualCoverage)
    OUTPUT inserted.mbrPlanKey,1 INTO @OutputTbl(ID, OutputType)          
    SELECT DISTINCT lh.mbrLoadHistoryKey, mbr.MbrMemberKey, p.mbrPlanKey
		  , AdiMbrs.EffDate AS NewEffDate  -- This is the Client supplied effective date for the member. 
								-- It superceeds all of our logic. 
								-- Mbrs will be effective in the future
		  , '12/31/2099' AS NewExpirationDate, LoadType
		  , @Plan AS NewProductPlan, AdiMbrs.BenePlan AS NewProductSubPlan 
		  , planMap.TargetValue AS NewProductSubPlanName , @PlanDualCoverage AS NewMbrIsDualCoverage
		  , AdiMbrs.DataDate AS NewDataDate
		  , p.ProductPlan curProductPlan, p.ProductSubPlan CurSubPlan, p.ProductSubPlanName CurSubPlanName
		  , p.MbrIsDualCoverage CurMbrIsDualCov
	   FROM adi.tvf_PdwSrc_Wlc_MemberByPcp( @LoadDate) AdiMbrs
		  JOIN lst.lstPlanMapping PlanMap ON AdiMbrs.BenePLAN = PlanMap.SourceValue
					   AND PlanMap.ClientKey = 2 
					   AND PlanMap.TargetSystem = 'ACDW' /* map for ACDW */
					   AND @loadDate BETWEEN PlanMap.EffectiveDate and PlanMap.ExpirationDate
		  JOIN lst.lstPlanMapping CsPlanMap ON adiMbrs.BenePLAN = CsPlanMap .SourceValue
					   AND CsPlanMap.ClientKey = 2 
					   AND CsPlanMap.TargetSystem = 'CS_AHS'
					   AND @LoadDate between CsPlanMap .EffectiveDate and CsPlanMap .ExpirationDate					   		
		  left JOIN adw.MbrLoadHistory Lh ON AdiMbrs.mbrWlcMbrByPcpKey = lh.adiKey and lh.adiTableName = @adiTableName
		  JOIN adw.MbrMember mbr ON AdiMbrs.Sub_ID = mbr.ClientMemberKey		  
		  JOIN adw.MbrWlcProviderLookup pl ON AdiMbrs.Prov_id = pl.Prov_id  
			  AND @loaddate <= pl.Term_Date
		  LEFT JOIN (SELECT p.MbrPlanKey, p.MbrMemberKey, p.ProductPlan , p.ProductSubPlan , p.ProductSubPlanName , p.MbrIsDualCoverage 
				    FROM adw.MbrPlan p 
					   JOIN adw.MbrMember m ON p.MbrMemberKey = m.MbrMemberKey
				    WHERE m.ClientKey = 2
			 		AND GETDATE() BETWEEN p.EffectiveDate AND p.ExpirationDate) p
					ON mbr.MbrMemberKey = p.MbrMemberKey		
	   WHERE ISNULL(adiMbrs.BenePLAN, '') <> ''
		  AND adiMbrs.BestMemberRow = 1		
		  ;

    /* INSERT NEW ROWS: WHERE MbrPlanKey is NULL */
    INSERT INTO adw.MbrPlan (MbrMemberKey, MbrLoadKey, EffectiveDate, ExpirationDate
	   , ProductPlan, ProductSubPlan, ProductSubPlanName, MbrIsDualCoverage
	   , LoadDate, DataDate)
    OUTPUT inserted.mbrPlanKey, 2 INTO @OutputTbl(ID, OutputType)
    SELECT src.MbrMemberKey, src.mbrLoadHistoryKey, src.NewEffectiveDate, src.NewExpirationDate
	   , src.NewProductPlan, src.NewProductSubPlan, src.NewProductSubPlanName, src.NewMbrIsDualCoverage
	   , GETDATE(), src.NewDataDate
    FROM dbo.tmpWlcPlan AS src
    WHERE src.mbrPlanKey is Null;
        

    /* PREPARE VERSION SET */	   
    IF OBJECT_ID('dbo.tmpWlcPlanToVersion') IS NOT NULL 
	   DROP TABLE dbo.tmpWlcPlanToVersion;
    CREATE TABLE dbo.tmpWlcPlanToVersion (mbrPlanKey INT);
    
       
    INSERT INTO dbo.tmpWlcPlanToVersion(mbrPlanKey)
    OUTPUT inserted.mbrPlanKey,3 INTO @OutputTbl(ID,OutputType)
    SELECT src.mbrPlanKey
    FROM dbo.tmpWlcPlan AS src
    WHERE NOT src.mbrPlanKey is Null
	   and (src.CurProductPlan <> src.NewProductPlan 
			 OR src.CurProductSubPlan <> NewProductSubPlan 
			 OR src.CurMbrIsDualCoverage <> src.NewMbrIsDualCoverage);
    /* TERM PRIOR ROW: SET Expiration date = src.NewEffectiveDate */
    
    UPDATE adw.MbrPlan
	   SET ExpirationDate = DATEADD(day, -1, src.NewEffectiveDate)/* calc a day 1 less than new effective */
    OUTPUT inserted.mbrPlanKey, 4 INTO @OutputTbl(ID, OutputType)
    FROM adw.mbrPlan m
	   JOIN dbo.tmpWlcPlan AS src ON src.mbrPlanKey = m.mbrPlanKey
	   JOIN dbo.tmpWlcPlanToVersion AS v ON src.mbrPlanKey = v.mbrPlanKey;
	   
    /* INSERT NEW VERSION OF ROW:  */
    INSERT INTO adw.MbrPlan (
	   MbrMemberKey
	   , MbrLoadKey
	   , EffectiveDate
	   , ExpirationDate
	   , ProductPlan
	   , ProductSubPlan
	   , ProductSubPlanName
	   , MbrIsDualCoverage
	   , LoadDate
	   , DataDate)
    OUTPUT inserted.mbrPlanKey, 5 INTO @OutputTbl(ID,OutputType)
    SELECT src.MbrMemberKey, src.mbrLoadHistoryKey, src.NewEffectiveDate, src.NewExpirationDate
	   , src.NewProductPlan, src.NewProductSubPlan, src.NewProductSubPlanName, src.NewMbrIsDualCoverage
	   , GETDATE(), src.NewDataDate
    FROM dbo.tmpWlcPlan AS src
	   JOIN dbo.tmpWlcPlanToVersion v ON src.mbrPlanKey = v.mbrPlanKey;


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
