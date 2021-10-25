CREATE PROCEDURE [ast].[PST_FctProvRoster_LoadToStg_DevPR]( 
    @LoadDate DATE = '01/01/1900'
    , @DataDate DATE = '01/01/1900'
    )
AS 
BEGIN    
    --DECLARE @LoadDate DATE = GETDATE();
    --DECLARE @DataDate DATE = GETDATE();
    DECLARE @EndDate DATE = '12/31/2099';
    IF @LoadDate = '01/01/1900' 
	   SET @LoadDate = GETDATE();
    IF @DataDate = '01/01/1900'  
	   SET @DataDate = GETDATE();
    
    -- do the loging stuff here    
    DECLARE @JobName VARCHAR(50) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);

    /* update Staging previous load, that is active on the load date to be termed the day before*/    
    DECLARE @TermDate DATE = DATEADD(day, -1, @LoadDate);
    --SELECT pr.RowEffectiveDate, pr.RowExpirationDate, @TermDate
    UPDATE pr set pr.RowExpirationDate = @TermDate
    FROM ast.fctProviderRoster_DevPR pr
    WHERE @LoadDate between pr.RowEffectiveDate AND pr.RowExpirationDate	 
    ;

    INSERT INTO ast.fctProviderRoster_DevPR (
		  SourceJobName, LoadDate, DataDate, IsActive, 
		  RowEffectiveDate, RowExpirationDate,        
		  PrvdrTin, PrvdrClientKey, PrvdrLOB, PrvdrHealthPlan, PrvdrHpEffDate, PrvdrHpExpDate,
		  ClientProviderID, NPI,
		  LastName, FirstName, Degree, 
		  GroupName,  
		  Comments, 
		  AccountType, NetworkContact, Chapter, ProviderType, 
		  AceProviderID, AceAccountID, 
		  Ethnicity, LanguagesSpoken, Provider_DOB, 
		  Provider_Gender, PrimaryCounty
	  )	  
    SELECT DISTINCT 
        @JobName, @LoadDate ld, @DataDate dd, 1 active,
    	   @LoadDate RwEffDate, @EndDate RwExpDate, 
    	   p.TIN, p.calcclientKey,   p.LOB,p.HealthPlan, p.EffectiveDate, CASE WHEN (p.ExpirationDate = '1900-01-01') THEN @EndDate ELSE p.ExpirationDate END AS PrvHpExpDate,
    	   p.ClientProviderID , p.NPI, 
	   p.LastName, p.FirstName, p.Degree,
	   p.GroupName,    	  
	   p.Comments,
    	   p.AccountType, p.NetworkContact, p.Chapter, p.ProviderType,
    	   p.AceProviderID, p.AceAccountID, 
    	   p.ETHNICITY, p.LANGUAGESSPOKEN, p.DateOfBirth, 
    	   p.Gender, p.PrimaryCounty
    FROM ast.vw_Get_FctProvRoster_NPIData_DevPR p ;
    
     /* Create tmp table for Unpivot of the TIN LOB */
    
    SELECT NPI, TIN, TinLOB, TinHealthPlan, TinHpEffectiveDate, TinHpExpirationDate, GroupName , PrimarySpeciality, PrimaryCounty, Sub_Speciality, ClnLOB
    INTO #tmpUnpivotTinLob
    FROM ( SELECT DISTINCT ast.NPI, ast.TIN, ast.TinLOB, ast.TinHealthPlan, ast.TinHpEffectiveDate, ast.TinHpExpirationDate, ast.GroupName
		  , ast.PrimarySpeciality, ast.Sub_Speciality, ast.County__c AS PrimaryCounty
		  ,     CASE WHEN (ast.tinLob LIKE '%Commercial%'	   ) THEN 'Commercial'		 ELSE 'NOT' END AS ClnLOB
		  FROM ast.vw_Get_FctProvRoster_TINData_DevPR ast
		  WHERE ast.TinLOB like '%;%'
		  UNION 
		  SELECT DISTINCT ast.NPI, ast.TIN, ast.TinLOB, ast.TinHealthPlan, ast.TinHpEffectiveDate, ast.TinHpExpirationDate, ast.GroupName
		     , ast.PrimarySpeciality, ast.Sub_Speciality, ast.County__c AS PrimaryCounty
		     , CASE WHEN (ast.tinLob LIKE '%Market Place%'	   ) THEN 'Market Place'		 ELSE 'NOT' END AS ClnLOB
		  FROM ast.vw_Get_FctProvRoster_TINData_DevPR ast
		  WHERE ast.TinLOB like '%;%'
		  UNION
		  SELECT DISTINCT ast.NPI, ast.TIN, ast.TinLOB, ast.TinHealthPlan, ast.TinHpEffectiveDate, ast.TinHpExpirationDate, ast.GroupName
		     , ast.PrimarySpeciality, ast.Sub_Speciality, ast.County__c AS PrimaryCounty
		     , CASE WHEN (ast.tinLob LIKE '%Medicaid%'		   ) THEN 'Medicaid'		 ELSE 'NOT' END AS ClnLOB
		  FROM ast.vw_Get_FctProvRoster_TINData_DevPR ast
		  WHERE ast.TinLOB like '%;%'
		  UNION
		  SELECT DISTINCT ast.NPI, ast.TIN, ast.TinLOB, ast.TinHealthPlan, ast.TinHpEffectiveDate, ast.TinHpExpirationDate, ast.GroupName
		     , ast.PrimarySpeciality, ast.Sub_Speciality, ast.County__c AS PrimaryCounty
		     , CASE WHEN ((ast.tinLob LIKE '%Medicare%') AND NOT (ast.tinLob LIKE '%Medicare Advantage%'))THEN 'Medicare'		 ELSE 'NOT' END AS ClnLOB
		  FROM ast.vw_Get_FctProvRoster_TINData_DevPR ast
		  WHERE ast.TinLOB like '%;%'
		  UNION
		  SELECT DISTINCT ast.NPI, ast.TIN, ast.TinLOB, ast.TinHealthPlan, ast.TinHpEffectiveDate, ast.TinHpExpirationDate, ast.GroupName
		     , ast.PrimarySpeciality, ast.Sub_Speciality, ast.County__c AS PrimaryCounty
		     , CASE WHEN (ast.tinLob LIKE '%Medicare Advantage%') THEN 'Medicare Advantage' ELSE 'NOT' END AS ClnLOB
		  FROM ast.vw_Get_FctProvRoster_TINData_DevPR ast
		  WHERE ast.TinLOB like '%;%'
		  ) src
    WHERE ClnLOB <> 'NOT';
    INSERT INTO #tmpUnpivotTinLob (NPI, TIN, TinLOB, TinHealthPlan, TinHpEffectiveDate, TinHpExpirationDate, GroupName, 
	   PrimarySpeciality, Sub_Speciality, PrimaryCounty, ClnLOB)
    SELECT DISTINCT ast.NPI, ast.TIN, ast.TinLOB, ast.TinHealthPlan, ast.TinHpEffectiveDate, ast.TinHpExpirationDate, ast.GroupName
	   , ast.PrimarySpeciality, ast.Sub_Speciality, ast.County__c PrimaryCounty, ast.TinLOB AS ClnLOB
		FROM ast.vw_Get_FctProvRoster_TINData_DevPR ast
		WHERE ast.TinLOB NOT like '%;%'
    ;

    /* get TIN INFO */
    -- goal: get NPI Level data loaded, then load TIN in  until it is complete or it indicates what is missing
    -- 1 at Tin/Npi level add   Calc
   UPDATE ast SET 	   
	     ast.TIN					    = Tin.TIN
	   , ast.GroupName				    = tin.GroupName
	   , ast.TinClientKey			    = tin.CalcClientKey
	   , ast.TinLob				    = tin.TinLOB
	   , ast.TinHealthPlan			    = Tin.TinHealthPlan
	   , ast.TinHpEffDate			    = Tin.TinHpEffectiveDate
	   , ast.TinHpExpDate			    = tin.TinHpExpirationDate
	   , ast.PrimarySpeciality		    = Tin.PrimarySpeciality
	   , ast.Sub_Speciality			    = tin.Sub_Speciality  
	   , ast.PrimaryCounty			    = tin.PrimaryCounty
   FROM ast.fctProviderRoster_DevPR ast
	   RIGHT JOIN (SELECT TIN.*,
		      CASE WHEN ( Tin.TinHealthPlan = 'AETNA'	   and 	Tin.ClnLOB LIKE '%Commercial%')				THEN  9	  --9	Aetna Comercial	AetCom
		  		  WHEN (Tin.TinHealthPlan = 'AETNA'	   and 	Tin.ClnLOB LIKE '%Medicare Advantage%')		THEN  3	  --3	Aetna	Aetna
		  		  WHEN (Tin.TinHealthPlan = 'CIGNA'	   and 	Tin.ClnLOB LIKE '%Commercial')				THEN  17	  -- 17	CIGNA Commercial	CignaCom
		  		  WHEN (Tin.TinHealthPlan = 'MOLINA'	   and 	Tin.ClnLOB LIKE '%Market Place')				THEN  19	  --19	Molina	Mol
		  		  WHEN (Tin.TinHealthPlan = 'MOLINA'	   and 	Tin.ClnLOB LIKE '%Medicaid')					THEN  19	  --19	Molina	Mol
		  		  WHEN (Tin.TinHealthPlan = 'UHC'		   and 	Tin.ClnLOB LIKE '%Medicaid')					THEN  1	  --1	United Health Care	UHC
		  		  WHEN (Tin.TinHealthPlan = 'CIGNA'	   and 	Tin.ClnLOB LIKE '%Medicare Advantage%')		THEN  12	  --12	Cigna MA	Cigna_MA
		  		  WHEN (Tin.TinHealthPlan = 'DEVOTED'	   and 	Tin.ClnLOB LIKE '%Medicare Advantage%')		THEN  11	  --11	Devoted Health Plan of Texas, Inc	Devoted
		  		  WHEN (Tin.TinHealthPlan = 'IMPERIAL'	   and 	Tin.ClnLOB LIKE '%Medicare Advantage%')		THEN  18	  -- 18	Imperial	Imp
		  		  WHEN (Tin.TinHealthPlan = 'MOLINA'	   and 	Tin.ClnLOB LIKE '%Medicare Advantage%')		THEN  19	  -- 19	Molina	Mol
		  		  WHEN (Tin.TinHealthPlan = 'OSCAR'	   and 	Tin.ClnLOB LIKE '%Medicare Advantage%')		THEN  15	  --15	Oscar Health	Oscar
		  		  WHEN (Tin.TinHealthPlan = 'WELLCARE'	   and 	Tin.ClnLOB LIKE '%Medicare%')			    THEN  2	  --2	Wellcare Health Plans	Wellcare -- '%Medicare Advantage%')		THEN  2	  --2	Wellcare Health Plans	Wellcare
		  		  WHEN (Tin.TinHealthPlan = 'OSCAR'	   and 	Tin.ClnLOB LIKE '%Medicare Advantage%')		THEN  15	  -- 15	Oscar Health	Oscar		  
		  		  WHEN (Tin.TinHealthPlan = 'SHCN_MSSP'   and 	Tin.ClnLOB LIKE '%Medicare%')	 			THEN  16	  --16	Steward Health Care Network MSSP	SHCN_MSSP
		  		  WHEN (Tin.TinHealthPlan = 'SHCN_BCBS'   and 	Tin.ClnLOB LIKE '%Commercial%')	 			THEN  20	  --20	Steward Health Care Network BCBS	SHCN_BCBS
		  		  WHEN (Tin.TinHealthPlan = 'AMERIGROUP'  and 	TIN.ClnLOB LIKE '%Medicare Advantage%')		THEN 21
				  WHEN (Tin.TinHealthPlan = 'AMERIGROUP'  and 	Tin.ClnLOB LIKE '%Medicaid%')				THEN 22
				  WHEN (Tin.TinHealthPlan is NULL)												THEN  0	  --0	Unknown Client	Unkn
		  		  ELSE 0																			  --0	Unknown Client	Unkn							
		  	   END AS CalcClientKey
		  FROM  #tmpUnpivotTinLob tin
	   )Tin 
	   ON ast.NPI = tin.NPI
		  and ast.PrvdrTin = tin.TIN
		  and ast.PrvdrHealthPlan = Tin.TinHealthPlan
		  and ast.PrvdrLOB = Tin.ClnLOB    
    WHERE @LoadDate BETWEEN ast.RowEffectiveDate and ast.RowExpirationDate	   	   
   ;


   /* Next take the tin is null rows and add details 1 detail at a time to find the issue line by line 
   */

	   -- do the loggin stuff here 
END;