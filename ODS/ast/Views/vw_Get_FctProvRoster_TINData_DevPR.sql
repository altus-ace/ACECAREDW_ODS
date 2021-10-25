

CREATE  VIEW [ast].[vw_Get_FctProvRoster_TINData_DevPR]  
AS 
    /* version history
	   gk: changed wellcare from:  PR.TinLOB LIKE '%Medicare Advantage%')		THEN  2	  
					    TO:    PR.TinLOB LIKE '%Medicare%')		THEN  2	  
					    */
    SELECT 	NPI, TIN, AceAccountID
	, [adi].[udf_ConvertToCamelCase](PrimarySpeciality)		AS PrimarySpeciality
	, [adi].[udf_ConvertToCamelCase](Sub_Speciality)		AS Sub_Speciality
	, [adi].[udf_ConvertToCamelCase](GroupName)				AS GroupName
	, [adi].[udf_ConvertToCamelCase](PrimaryAddress)		AS PrimaryAddress
	, [adi].[udf_ConvertToCamelCase](PrimaryCity)			AS PrimaryCity
	, PrimaryState, PrimaryZipcode, PrimaryPOD, PrimaryQuadrant, PrimaryAddressPhoneNumber
	, [adi].[udf_ConvertToCamelCase](BillingAddress)	AS BillingAddress
	, [adi].[udf_ConvertToCamelCase](BillingCity)		AS BillingCity
	, BillingState, BillingZipcode, BillingPOD, BillingAddressPhoneNumber, Fax, AccountType
	, NetworkContact
	, [adi].[udf_ConvertToCamelCase](TinHealthPlan)	AS TinHealthPlan
	, TinLOB
	, [adi].[udf_ConvertToCamelCase](TinLOB_Clnd) as TinLOB_Clnd
	, TinHpEffectiveDate, TinHpExpirationDate
	,  [adi].[udf_ConvertToCamelCase](County__c) AS County__c
		, 	   -- Ignore  clients --4 UHC-MI, --5 UHC-CP-PCPi, --6 CCACO --7 OKC, --8	ECAP, --13 mpulse, --14 Ace
	   CASE WHEN (PR.TinHealthPlan = 'AETNA'	  and 	PR.TinLOB LIKE '%Commercial%')			   THEN  9	  --9	Aetna Comercial	AetCom
		  WHEN (PR.TinHealthPlan = 'AETNA'		  and 	PR.TinLOB LIKE '%Medicare Advantage%')		   THEN  3	  --3	Aetna	Aetna
		  WHEN (PR.TinHealthPlan = 'CIGNA'		  and 	PR.TinLOB LIKE '%Commercial')				   THEN  17	  -- 17	CIGNA Commercial	CignaCom
		  WHEN (PR.TinHealthPlan = 'MOLINA'	  and 	PR.TinLOB LIKE '%Market Place')			   THEN  19	  --19	Molina	Mol
		  WHEN (PR.TinHealthPlan = 'MOLINA'	  and 	PR.TinLOB LIKE '%Medicaid')				   THEN  19	  --19	Molina	Mol
		  WHEN (PR.TinHealthPlan = 'UHC'		  and 	PR.TinLOB LIKE '%Medicaid')				   THEN  1	  --1	United Health Care	UHC
		  WHEN (PR.TinHealthPlan = 'CIGNA'		  and 	PR.TinLOB LIKE '%Medicare Advantage%')		   THEN  12	  --12	Cigna MA	Cigna_MA
		  WHEN (PR.TinHealthPlan = 'DEVOTED'	  and 	PR.TinLOB LIKE '%Medicare Advantage%')		   THEN  11	  --11	Devoted Health Plan of Texas, Inc	Devoted
		  WHEN (PR.TinHealthPlan = 'IMPERIAL'	  and 	PR.TinLOB LIKE '%Medicare Advantage%')		   THEN  18	  -- 18	Imperial	Imp
		  WHEN (PR.TinHealthPlan = 'MOLINA'	  and 	PR.TinLOB LIKE '%Medicare Advantage%')		   THEN  19	  -- 19	Molina	Mol
		  WHEN (PR.TinHealthPlan = 'OSCAR'		  and 	PR.TinLOB LIKE '%Medicare Advantage%')		   THEN  15	  --15	Oscar Health	Oscar
		  WHEN (PR.TinHealthPlan = 'WELLCARE'	  and 	PR.TinLOB LIKE '%Medicare%')				   THEN  2	  --2	Wellcare Health Plans	Wellcare
		  WHEN (PR.TinHealthPlan = 'OSCAR'		  and 	PR.TinLOB LIKE '%Medicare Advantage%')		   THEN  15	  -- 15	Oscar Health	Oscar		  
		  WHEN (PR.TinHealthPlan = 'SHCN_MSSP'	  and 	PR.TinLOB LIKE '%Medicare%')	 			   THEN  16	  --16	Steward Health Care Network MSSP	SHCN_MSSP
		  WHEN (PR.TinHealthPlan = 'SHCN_BCBS'	  and 	PR.TinLOB LIKE '%Commercial%')	 		   THEN  20	  --20	Steward Health Care Network BCBS	SHCN_BCBS
		  WHEN (PR.TinHealthPlan = 'AMERIGROUP'	  and 	PR.TinLOB LIKE '%Medicare Advantage%')		   THEN 21
		  WHEN (PR.TinHealthPlan = 'AMERIGROUP'	  and 	PR.TinLOB LIKE '%Medicaid%')				   THEN 22
		  
		  WHEN (PR.TinHealthPlan is NULL)													   THEN  0	  --0	Unknown Client	Unkn
		  ELSE 0																			  --0	Unknown Client	Unkn							


	   END AS CalcClientKey
    FROM (SELECT 
	            AceMetaData.adi.udf_GetCleanString(SF_Contact.Provider_NPI__c )AS 'NPI'          
	          , AceMetaData.adi.udf_GetCleanString(UPPER(ISNULL(SF_Account.Tax_ID_Number__c, ' '))) AS TIN
			  , AceMetaData.adi.udf_GetCleanString(SF_Account.ACE_Acct_ID1__c + SF_Account.ACE_Acct_ID2__c) AS AceAccountID
	          , AceMetaData.adi.udf_GetCleanString(ISNULL(SF_ProvSpecialties.Speciality_Name_CAQH__c, ' ')) AS 'PrimarySpeciality'
	   	      , AceMetaData.adi.udf_GetCleanString(ISNULL(SF_ProvSpecialties.Specialty_sub_specialty__C, ' ')) AS 'Sub_Speciality'
	          , AceMetaData.adi.udf_GetCleanString(ISNULL(SF_Account.NAME, ' ')) AS 'GroupName'
	          , AceMetaData.adi.udf_GetCleanString(ISNULL(PrimaryPracticeLocation.Address_1__c+' '+PrimaryPracticeLocation.Address_2__c , ' ')) AS 'PrimaryAddress'
	          , AceMetaData.adi.udf_GetCleanString(ISNULL(PrimaryPracticeLocation.City__c, ' ')) AS 'PrimaryCity'
	          , AceMetaData.adi.udf_GetCleanString(ISNULL(PrimaryPracticeLocation.State__c, ' ')) AS 'PrimaryState'
	          , AceMetaData.adi.udf_GetCleanString(ISNULL(PrimaryPracticeZipCode.NAME, ' ')) AS 'PrimaryZipcode'
	          , AceMetaData.adi.udf_GetCleanString(ISNULL(PrimaryPracticeZipCode.Quadrant__c, ' ')) AS 'PrimaryPOD'
			  , AceMetaData.adi.udf_GetCleanString(ISNULL(PrimaryPracticeZipCode.pod__c, ' ')) AS 'PrimaryQuadrant'
	          , [adw].[AceCleanPhoneNumber](AceMetaData.adi.udf_GetCleanString(ISNULL(PrimaryPracticeLocation.Phone__c, ' '))) AS 'PrimaryAddressPhoneNumber'
	          , AceMetaData.adi.udf_GetCleanString(ISNULL(BillingPracticeLocation.Address_1__c+' '+BillingPracticeLocation.Address_2__c, ' ')) AS 'BillingAddress'
	          , AceMetaData.adi.udf_GetCleanString(ISNULL(BillingPracticeLocation.City__c, ' ')) AS 'BillingCity'
	          , AceMetaData.adi.udf_GetCleanString(ISNULL(BillingPracticeLocation.State__c, ' ')) AS 'BillingState'
	          , AceMetaData.adi.udf_GetCleanString(ISNULL(BillingPracticeZipCode.NAME, ' ')) AS 'BillingZipcode'
	          , AceMetaData.adi.udf_GetCleanString(ISNULL(BillingPracticeZipCode.Quadrant__c, ' ')) AS 'BillingPOD'
	          , [adw].[AceCleanPhoneNumber](AceMetaData.adi.udf_GetCleanString(ISNULL(BillingPracticeLocation.Phone__c, ' '))) AS 'BillingAddressPhoneNumber'
			  , [adw].[AceCleanPhoneNumber](AceMetaData.adi.udf_GetCleanString(Ltrim(rtrim(ISNULL(SF_Account.Fax, ''))))) as Fax
			  , AceMetaData.adi.udf_GetCleanString(SF_Account.TYPE__c) AS AccountType
			  , AceMetaData.adi.udf_GetCleanString(SF_Account.NETWORK_CONTACT__c) AS NetworkContact
			  , AceMetaData.adi.udf_GetCleanString(UPPER(ISNULL(SF_ContractInfo.Health_Plans__c, ' '))) AS 'TinHealthPlan'
	   		  , AceMetaData.adi.udf_GetCleanString(ISNULL(SF_ContractInfo.Line_of_business__C, '')) as TinLOB
			  , AceMetaData.adi.udf_GetCleanString(case when SF_ContractInfo.Line_of_business__C ='Medicare' then 'Medicare Advantage' else ISNULL(SF_ContractInfo.Line_of_business__C,'') end) as TinLOB_Clnd
	   		  , AceMetaData.adi.udf_GetCleanString(CONVERT(DATE, ISNULL(SF_ContractInfo.effective_date__C, '01/01/1900'))) AS TinHpEffectiveDate
	   	      , AceMetaData.adi.udf_GetCleanString(CONVERT(DATE, ISNULL(SF_ContractInfo.term_date__C, '12/31/2099'))) AS TinHpExpirationDate
			  , AceMetaData.adi.udf_GetCleanString(ISNULL(PrimaryPracticeLocation.County__c, '')) AS County__c
	   FROM TMPSALESFORCE_CONTACT AS SF_Contact	        
	        LEFT JOIN tmpSalesforce_Account SF_Account ON SF_Contact.ACCOUNTID = SF_Account.ID
	        LEFT JOIN TMPSALESFORCE_PROVIDER_Specialties__C AS SF_ProvSpecialties ON SF_ProvSpecialties .Provider_Name__c = SF_Contact.ID
	           AND Specialtiy_Type__c = 'PRIMARY'
	        LEFT JOIN tmpSalesforce_Account_Locations__c AS PrimaryPracticeLocation ON PrimaryPracticeLocation.Account_Name__c = SF_Account.ID
	           AND PrimaryPracticeLocation.Location_Type__c = 'PRIMARY'
	        LEFT JOIN tmpSalesforce_Account_Locations__c AS BillingPracticeLocation ON BillingPracticeLocation.Account_Name__c = SF_Account.ID
			 AND BillingPracticeLocation.Location_Type__c = 'BILLING'
	        LEFT JOIN tmpSalesforce_Zip_Code__c AS PrimaryPracticeZipCode ON PrimaryPracticeLocation.Zip_Code__c = PrimaryPracticeZipCode.ID
	        LEFT JOIN tmpSalesforce_Zip_Code__c AS BillingPracticeZipCode ON BillingPracticeLocation.Zip_Code__c = BillingPracticeZipCode.ID
		   LEFT JOIN tmpSalesforce_Contract_Information__c AS SF_ContractInfo ON SF_ContractInfo.Account_Name__c = SF_Account.id
		  LEFT JOIN dbo.tmpSalesforce_Provider_Language_Spoken__c SF_LangSpoken ON   SF_Contact.id = SF_LangSpoken.Provider_Name__c  
	   WHERE 		  
		  SF_Contact.Type__c NOT IN('UHC_PCP') AND -- add this back to remove the decomissioned types
		  SF_CONTACT.LASTNAME NOT IN('TEST', 'TESTLAST', 'TESTACE', 'ACETEST') AND 
		  --SF_Account.Name NOT IN ('TEST', 'TESTLAST', 'TESTACE', 'ACETEST') AND 
		  SF_Account.in_Network__c = '1'		  
		--  and SF_ContractInfo.Health_Plans__c= 'SHCN_MSSP'

    ) pr

