CREATE PROCEDURE [adw].[PdwMbr_08_LoadPlan]
    @LoadDate Date,
    @ClientKey INT, 
	@InsertCount INT OUTPUT,
	@UpdateCount INT OUTPUT
AS
    DECLARE @ExpirationDate DATE = '12/31/2099';  
    
    
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
    IF OBJECT_ID('tempdb..#mbrPlan') IS NOT NULL 
        DROP TABLE #mbrPlan;
    CREATE TABLE #mbrPlan (mbrLoadHistoryKey INT, mbrMemberKey INT, mbrPlanKey INT, loadType CHAR(1)
    			 , NewEffective DATE, NewExpiration DATE, NewProductPlan VARCHAR(50), NewProductSubPlan VARCHAR(50)
			 , NewProductSubPlanName VARCHAR(50), NewMbrIsDualCoverage TinyInt, NewClientPlanEffective DATE
			 , NewLoadDate DATE, NewDataDate Date
    			 , curPlanEffective DATE, curPlanExpiration DATE,  CurProductPlan VARCHAR(50), CurProductSubPlan VARCHAR(50)
    			 , CurProductSubPlanName VARCHAR(50), CurMbrIsDualCoverage TinyInt, CurClientPlanEffective DATE
			 , curLoadDate DATE, curDataDate DATE);
    
    /* LOAD WORKING SET */
    INSERT INTO #mbrPlan (mbrLoadHistoryKey, mbrMemberKey, mbrPlanKey, loadType
    			 , NewEffective, NewExpiration, NewProductPlan, NewProductSubPlan
    			 , NewProductSubPlanName, NewMbrIsDualCoverage, NewClientPlanEffective
    			 , NewLoadDate, NewDataDate
			 , curPlanEffective, curPlanExpiration, CurProductPlan, CurProductSubPlan
    			 , CurProductSubPlanName, CurMbrIsDualCoverage, CurClientPlanEffective
			 , curLoadDate, curDataDate)
    OUTPUT inserted.mbrPlanKey,1 INTO @OutputTbl(ID, OutputType)     
    SELECT lh.mbrLoadHistoryKey, mbr.MbrMemberKey, p.mbrPlanKey, m.loadType
		   , CASE WHEN (m.LoadType = 'P') 
       				THEN CONVERT(DATE, DATEADD(DAY, (-1*DATEPART(day,@LoadDate)+1), @LoadDate)) 
       				ELSE @LoadDate END AS NewEffDate , @ExpirationDate AS NewExpDate, m.plnProductPlan, m.plnProductSubPlan
		  , m.plnProductSubPlanName, isnull(m.plnMbrIsDualCoverage, 0) AS plnMbrIsDualCoverage,  m.plnClientPlanEffective
		  , m.loadDate, m.DataDate AS NewDataDate
		  , p.EffectiveDate, p.ExpirationDate, p.ProductPlan, p.ProductSubPlan CurSubPlan
		  , p.ProductSubPlanName CurSubPlanName, p.MbrIsDualCoverage, p.clientplanEffective 
		  , p.LoadDate, p.DataDate
	   FROM  (SELECT s.ClientSubscriberId, s.AdiKey, s.AdiTableName, LoadType 
			 , s.plnProductPlan, s.plnProductSubPlan, s.plnProductSubPlanName, s.plnMbrIsDualCoverage, s.plnClientPlanEffective, s.LoadDate, s.DataDate
		  FROM (SELECT d.ClientSubscriberId,d.AdiKey, d.AdiTableName, d.LoadType
				, d.plnProductPlan,d.plnProductSubPlan,d.plnProductSubPlanName, d.plnMbrIsDualCoverage,d.plnClientPlanEffective, d.LoadDate,d.DataDate
				    , ROW_NUMBER() OVER(PARTITION BY d.clientSUbscriberID ORDER BY d.LoadDATE ASC) arn
				FROM ast.MbrStg2_MbrData d				
				WHERE not d.plnProductPlan IS NULL		  				  
				    AND d.LoadDate = @LoadDate
				    AND d.CLientKey = @ClientKey
				    AND d.stgRowStatus = 'Valid'
				) s
			 WHERE s.arn = 1) m
		  JOIN adw.MbrLoadHistory Lh ON m.AdiKey = lh.AdiKey AND m.AdiTableName = lh.AdiTableName
		  JOIN adw.MbrMember mbr ON m.ClientSubscriberID = mbr.ClientMemberKey		  
		  LEFT JOIN adw.MbrPlan p ON mbr.MbrMemberKey = p.MbrMemberKey
			 		AND GETDATE() BETWEEN p.EffectiveDate AND p.ExpirationDate
	   WHERE m.LoadDate = @LoadDate;

    /* INSERT NEW ROWS: WHERE MbrPlanKey is NULL */

           

    INSERT INTO adw.MbrPlan (MbrMemberKey, MbrLoadKey, EffectiveDate, ExpirationDate
	   , ProductPlan, ProductSubPlan, ProductSubPlanName, MbrIsDualCoverage,ClientPlanEffective
	   , LoadDate, DataDate)
    OUTPUT inserted.mbrPlanKey, 2 INTO @OutputTbl(ID, OutputType)
    SELECT src.MbrMemberKey, src.mbrLoadHistoryKey, src.NewEffective, src.NewExpiration
	   , src.NewProductPlan, src.NewProductSubPlan, src.NewProductSubPlanName, src.NewMbrIsDualCoverage, src.NewClientPlanEffective
	   , GETDATE(), src.NewDataDate
    FROM #mbrPlan AS src
    WHERE src.mbrPlanKey is Null;
        

    /* PREPARE VERSION SET */	   
    IF OBJECT_ID('tempdb..#mbrPlanToVersion') IS NOT NULL 
	   DROP TABLE #mbrPlanToVersion;
    CREATE TABLE #mbrPlanToVersion (mbrPlanKey INT);
    
       
    INSERT INTO #mbrPlanToVersion(mbrPlanKey)
    OUTPUT inserted.mbrPlanKey,3 INTO @OutputTbl(ID,OutputType)
    SELECT src.mbrPlanKey
    FROM #mbrPlan AS src
    WHERE NOT src.mbrPlanKey is Null
	   and (src.CurProductPlan <> src.NewProductPlan 
			 OR src.CurProductSubPlan <> NewProductSubPlan 
			 OR src.CurMbrIsDualCoverage <> src.NewMbrIsDualCoverage);
    /* TERM PRIOR ROW: SET Expiration date = src.NewEffectiveDate */
    UPDATE adw.MbrPlan
	   SET ExpirationDate = DATEADD(day, -1, src.NewEffective)/* calc a day 1 less than new effective */
    OUTPUT inserted.mbrPlanKey, 4 INTO @OutputTbl(ID, OutputType)
    FROM adw.mbrPlan m
	   JOIN #mbrPlan AS src ON src.mbrPlanKey = m.mbrPlanKey
	   JOIN #mbrPlanToVersion AS v ON src.mbrPlanKey = v.mbrPlanKey;

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
	   , ClientPlanEffective
	   , LoadDate
	   , DataDate)
    OUTPUT inserted.mbrPlanKey, 5 INTO @OutputTbl(ID,OutputType)
    SELECT src.MbrMemberKey, src.mbrLoadHistoryKey, src.NewEffective, src.NewExpiration
	   , src.NewProductPlan, src.NewProductSubPlan, src.NewProductSubPlanName, src.NewMbrIsDualCoverage, src.NewClientPlanEffective
	   , GETDATE(), src.NewDataDate
    FROM #mbrPlan AS src
	   JOIN #mbrPlanToVersion v ON src.mbrPlanKey = v.mbrPlanKey;


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
