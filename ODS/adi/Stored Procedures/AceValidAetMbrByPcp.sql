CREATE PROCEDURE [adi].[AceValidAetMbrByPcp]
    @ShowDetail tinyInt = 0
AS 
    /* this should write to a table, all validations then query out the correct result set */
    SELECT '0 = no, 1 = Yes, Adds details for some validations.'[@ShowDetail], 'Use Stored Proc: adi.AceValidMbr_Aet with a above id to explore details.' AS [HowToUse]
    		
    DECLARE @refreshLoadDates tinyint = 1
    -- get the load dates
    if @refreshLoadDates = 1 
    BEGIN
        IF OBJECT_ID('tempdb..#AdiValMbrEligLoadDates', 'U') IS NOT NULL
    	   DROP TABLE #AdiValMbrEligLoadDates;  
        CREATE TABLE #AdiValMbrEligLoadDates( loadDate date, rowNumber INT primary key not null)
        INSERT INTO #AdiValMbrEligLoadDates (loadDate, rowNumber)
        SELECT ld.*
            ,ROW_NUMBER() OVER (ORDER BY loadDATE desc)  AS arn
        FROM (SELECT loaddate    
        	   FROM adi.MbrAetMbrByPcp w
        	   GROUP BY loaddate) ld;
    END;
    
    DECLARE @cld DATE; /* Current/Most recent Load Date */
    DECLARE @lld DATE; /* Last Load Date */
    
    SELECT @cld = loadDate FROM #AdiValMbrEligLoadDates	 ld WHERE ld.rowNumber = 1;
    SELECT @lld = loadDate FROM #AdiValMbrEligLoadDates	 ld WHERE ld.rowNumber = 2;
    
    SELECT @cld AS 'Current Load', @lld AS 'Last Load';
    
    SELECT count(*) MaxMbrAetCurLoad from adi.MbrAetMbrByPcp m where m.LoadDate = @cld;

    SELECT 'mbrsWithMutlipleRowsInAdi' AS 'mbrsWithMutlipleRowsInAdi',m.aetsubscriberID, count(*) MultRowCnt 
    FROM adi.MbrAetMbrByPcp m 
    WHERE m.LoadDate = @cld
    GROUP BY m.AetSubscriberID 
    HAVING count(*) > 1;


    IF OBJECT_ID('tempdb.dbo.#ValidAetAdiMappings', 'U') IS NOT NULL
	   DROP TABLE #ValidAetAdiMappings; 
    CREATE TABLE #ValidAetAdiMappings
	   (urn INT NOT NULL PRIMARY KEY IDENTITY(1,1)
		  ,AetSubscriberID VARCHAR(50) NOT NULL 
		  , TIN_src varchar(20)
		  , TIN_MapOut varchar(20)
		  , PcpAutoAssign_src varchar(20)
		  , PcpAutoAssign_MapOut varchar(20)
		  , Product_Src varchar(20)
		  , ProductSubPlan_MapOut varchar(20)
		  , ProductName_Src varchar(20)
		  , ProductName_MapOut varchar(20));

    INSERT INTO  #ValidAetAdiMappings
    SELECT d.AetSubscriberID	
		  , d.TIN
		  , tns.TIN MappedOutput
		  , d.MSCIndicator PcpAutoAssign
		  , msc.Destination PcpAutoAssignMappedOutput
		  , d.Product ProductSubPlan
		  , subplan.TargetValue ProductSubPlanMappedOutput
		  , d.Product ProductNameSource 
		  , subplanName.TargetValue ProductNameMappedOutput    
    FROM adi.MbrAetMbrByPcp d    
        LEFT JOIN lst.ListAceMapping Msc ON d.MSCIndicator = msc.Source AND msc.MappingTYpeKey = 9     
        LEFT JOIN lst.lstPlanMapping SubPlan  
    		  ON d.Product = subPlan.SourceValue 
    		  AND SubPlan.TargetSystem = 'ACDW'
    		  AND @cld BETWEEN SubPlan.EffectiveDate and SubPlan.ExpirationDate	
        LEFT JOIN lst.lstPlanMapping SubPlanName 
    		  ON d.Product = subPlanName.SourceValue
    		  AND SubPlanName.TargetSystem = 'ACDW'
    		  AND @cld BETWEEN SubPlanName.EffectiveDate AND SubPlanName.ExpirationDate
    		  /* gk 3/11/2019  
    			 Added LOB and TIN expriration support: 
    				IF the LOB changes from Medicare Advantage, we will need to fix the Hard coded value
    				*/
         LEFT JOIN (SELECT DISTINCT vp.TIN --, EffectiveDate, TermDate, LOB 
				    FROM adw.tvf_Get_AetMa_ValidProviderTinsByDate(GETDATE()) vp
				    --adw.tvf_GetValidProviderTinsByDate(GETDATE()) vp
				    WHERE vp.LOB = 'Medicare Advantage'
					   AND ISNULL(vp.TermDate, '1/1/2099') > GETDATE()
				    GROUP BY vp.TIN ) tns ON d.TIN = Tns.TIN-- AND d.NPI = tns.NPI /**/
    WHERE d.LoadDate = @cld
	   ;

    /* do calcs with temp table */
    SELECT 'Member has multiple/duplicate rows' AS validation, v.AetSubscriberID
    FROM #ValidAetAdiMappings v
    group by v.AetSubscriberID
    Having count(*) > 1;
    
    SELECT 'TIN is in Aetna Provider Roster' AS validation, COUNT(v.AetSubscriberID)
    FROM #ValidAetAdiMappings v
    WHERE NOT v.TIN_MapOut is null
    
    SELECT 'TIN is not in Aetna Provider Roster' AS validation, COUNT(v.AetSubscriberID) [cntNon-ContractTins]
    FROM #ValidAetAdiMappings v
    WHERE v.TIN_MapOut is null
    
    IF @ShowDetail = 1 
    BEGIN
	   SELECT 'TIN is not in Aetna Provider Roster' AS validation, v.AetSubscriberID, v.TIN_Src
	   FROM #ValidAetAdiMappings v
	   WHERE v.TIN_MapOut is null
	   ORDER BY v.TIN_Src asc;
    END;
    
    SELECT 'PcpAutoAssign not mapped by lstAceMapping' AS validation, v.AetSubscriberID, v.PcpAutoAssign_src
    FROM #ValidAetAdiMappings v
    WHERE v.PcpAutoAssign_MapOut is null;
    
    SELECT 'Product Sub Plan is not mapped by lstAceMapping' AS validation, v.AetSubscriberID, v.Product_Src
    FROM #ValidAetAdiMappings v
    WHERE v.ProductSubPlan_MapOut is null;
    
    SELECT 'Product Name is not mapped by lstAceMapping' AS validation, v.AetSubscriberID, v.Product_Src
    FROM #ValidAetAdiMappings v
    WHERE v.ProductName_MapOut is null;
    
      /* XXXXXXXXXXXXX Termed: Existed on last load, not on current load XXXXXXXXXXXXX*/    
    
    SELECT src.ChangeSet, COUNT(*) countTermedMembers
    FROM(SELECT distinct ll.AetSubscriberID, 'Termed Members'as ChangeSet
	   FROM adi.MbrAetMbrByPcp ll
	   WHERE ll.LoadDate = @lld
	   EXCEPT
	   SELECT distinct cl.AetSubscriberID, 'Termed Members'as ChangeSet
	   FROM adi.MbrAetMbrByPcp cl
	   WHERE cl.LoadDate = @cld
	   ) src
    GROUP BY src.ChangeSet
    ;

    /* XXXXXXXXXXXXX New: Exists on current load, not on prior load XXXXXXXXXXXXX */
    SELECT src.ChangeSet, COUNT(*) countNewMembers
    FROM (SELECT distinct cl.AetSubscriberID, 'New Members'as ChangeSet
		  FROM adi.MbrAetMbrByPcp cl
		  WHERE cl.LoadDate = @cld
		  EXCEPT
		  SELECT distinct ll.AetSubscriberID, 'New Members'as ChangeSet
		  FROM adi.MbrAetMbrByPcp ll
		  WHERE ll.LoadDate = @lld
		  )src
    GROUP BY src.ChangeSet
    ;

   /* invalid PCP in Mbr Model */   
    SELECT 'Invalid Pcp in Mbr Model' Validation, p.*, provLookup.[TAX ID]
    FROM adw.MbrPcp p    
	   JOIN adw.mbrMember m ON p.mbrMemberKey = m.MbrMemberKey
	   LEFT JOIN (SELECT [TAX ID], term_date__C, LOB 
				FROM DBO.vw_Aetna_ProviderRoster 
				WHERE lob in ('Medicare Advantage') 
			 	    and term_date__C is null) provLookup 
				ON convert(int,p.tin) = convert(int,provLookup.[tax id])
	   WHERE provLookup.[tax id] is null and m.ClientKey = 3
