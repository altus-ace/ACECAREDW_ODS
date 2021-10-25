





CREATE VIEW [ast].[vw_Get_FctProvRoster_NPIData_DevPR] 
AS 
     SELECT  pr.NPI 
		, [adi].[udf_ConvertToCamelCase](pr.LastName) AS LastName
		, [adi].[udf_ConvertToCamelCase](pr.FirstName)AS FirstName
		, pr.AceProviderID
		, ADI.UDF_convertToCamelCase(pr.ETHNICITY) AS ETHNICITY
		, pr.DateOfBirth
		, [adi].[udf_ConvertToCamelCase](pr.Gender) AS Gender			 
		, pr.Degree
		, pr.TIN --TAX ID
		, pr.AceAccountID     
		, [adi].[udf_ConvertToCamelCase](pr.PrimarySpeciality)		as PrimarySpeciality
		, [adi].[udf_ConvertToCamelCase](pr.Sub_Speciality)			as Sub_Speciality
		, [adi].[udf_ConvertToCamelCase](pr.GroupName)				as GroupName
		, pr.Fax 
		, pr.Comments
		, [adi].[udf_ConvertToCamelCase](pr.HealthPlan)				as HealthPlan
		, pr.LOB
		, [adi].[udf_ConvertToCamelCase](pr.LOB_Clnd)				as LOB_Clnd
		, pr.EffectiveDate
		, pr.ExpirationDate
		, pr.ClientProviderID
		, pr.Status 
		, pr.AccountType 
		, pr.NetworkContact 
		, pr.Chapter 
		, [adi].[udf_ConvertToCamelCase](pr.PrimaryCounty)			as PrimaryCounty 
		, [adi].[udf_ConvertToCamelCase](pr.ProviderType)			as ProviderType 
		, [adi].[udf_ConvertToCamelCase](pr.LANGUAGESSPOKEN) 		as LANGUAGESSPOKEN
	, 	   -- Ignore  clients --4 UHC-MI, --5 UHC-CP-PCPi, --6 CCACO --7 OKC, --8	ECAP, --13 mpulse, --14 Ace
	 CASE WHEN (PR.HealthPlan = 'AETNA'	   and 	PR.LOB LIKE '%Commercial%')				THEN  9	  --9	Aetna Comercial	AetCom
		  WHEN (PR.HealthPlan = 'AETNA'	   and 	PR.LOB LIKE '%Medicare Advantage%')		THEN  3	  --3	Aetna	Aetna
		  WHEN (PR.HealthPlan = 'CIGNA'	   and 	PR.LOB LIKE '%Commercial')				THEN  17	  -- 17	CIGNA Commercial	CignaCom
		  WHEN (PR.HealthPlan = 'MOLINA'	   and 	PR.LOB LIKE '%Market Place')				THEN  19	  --19	Molina	Mol
		  WHEN (PR.HealthPlan = 'MOLINA'	   and 	PR.LOB LIKE '%Medicaid')					THEN  19	  --19	Molina	Mol
		  WHEN (PR.HealthPlan = 'UHC'		   and 	PR.LOB LIKE '%Medicaid')					THEN  1	  --1	United Health Care	UHC
		  WHEN (PR.HealthPlan = 'CIGNA'	   and 	PR.LOB LIKE '%Medicare Advantage%')		THEN  12	  --12	Cigna MA	Cigna_MA
		  WHEN (PR.HealthPlan = 'DEVOTED'	   and 	PR.LOB LIKE '%Medicare Advantage%')		THEN  11	  --11	Devoted Health Plan of Texas, Inc	Devoted
		  WHEN (PR.HealthPlan = 'IMPERIAL'	   and 	PR.LOB LIKE '%Medicare Advantage%')		THEN  18	  -- 18	Imperial	Imp
		  WHEN (PR.HealthPlan = 'MOLINA'	   and 	PR.LOB LIKE '%Medicare Advantage%')		THEN  19	  -- 19	Molina	Mol
		  WHEN (PR.HealthPlan = 'OSCAR'	   and 	PR.LOB LIKE '%Medicare Advantage%')		THEN  15	  --15	Oscar Health	Oscar
		  WHEN (PR.HealthPlan = 'WELLCARE'	   and 	PR.LOB LIKE '%Medicare%')				THEN  2	  --2	Wellcare Health Plans	Wellcare
		  WHEN (PR.HealthPlan = 'OSCAR'	   and 	PR.LOB LIKE '%Medicare Advantage%')		THEN  15	  -- 15	Oscar Health	Oscar		  
		  WHEN (PR.HealthPlan = 'SHCN_MSSP'   and 	PR.LOB LIKE '%Medicare%')	 			THEN  16	  --16	Steward Health Care Network MSSP	SHCN_MSSP
		  WHEN (PR.HealthPlan = 'SHCN_BCBS'   and 	PR.LOB LIKE '%Commercial%')	 			THEN  20	  --20	Steward Health Care Network BCBS	SHCN_BCBS
		  WHEN (PR.HealthPlan = 'AMERIGROUP'  and 	PR.LOB LIKE '%Medicare Advantage%')		THEN 21
		  WHEN (PR.HealthPlan = 'AMERIGROUP'  and 	PR.LOB LIKE '%Medicaid%')				THEN 22		  
		  WHEN (PR.HealthPlan is NULL)												THEN  0	  --0	Unknown Client	Unkn
		  ELSE 0																			  --0	Unknown Client	Unkn							
	   END AS CalcClientKey
    FROM (SELECT DISTINCT 
		  AceMetaData.adi.udf_GetCleanString( SF_Contact.Provider_NPI__c) AS 'NPI',
		  AceMetaData.adi.udf_GetCleanString(UPPER(ISNULL(SF_Contact.LASTNAME, ' '))) AS 'LastName',
		  AceMetaData.adi.udf_GetCleanString(UPPER(ISNULL(SF_Contact.FIRSTNAME, ' '))) AS 'FirstName',
		  AceMetaData.adi.udf_GetCleanString(SF_Contact.ACE_Provider_ID1__c + SF_Contact.ACE_Provider_ID2__c )AS [AceProviderID], 
		  AceMetaData.adi.udf_GetCleanString(ISNULL(SF_Contact.Provider_Ethnicity__c, '') )AS ETHNICITY, 
		  AceMetaData.adi.udf_GetCleanString(ISNULL(SF_Contact.Date_of_Birth__c , '01/01/1900'))AS DateOfBirth,
		  AceMetaData.adi.udf_GetCleanString(ISNULL(SF_Contact.Gender__c	, '') )AS Gender,			 
		  AceMetaData.adi.udf_GetCleanString(UPPER(ISNULL(UPPER(CAST(STUFF(
		     (
		         SELECT ','+RTRIM(DEGREE_NAME__C)
		         FROM tmpSalesforce_Provider_Degree__c TD
		         WHERE TD.CONTACT__C = SF_ProviderDegree.CONTACT__C
		               AND TD.DEGREE_NAME__C NOT IN('(OTHER)', ' ') FOR XML PATH('')
		     ), 1, 1, '') AS VARCHAR(100))), ' ')) )AS Degree,
		  AceMetaData.adi.udf_GetCleanString(UPPER(ISNULL(SF_Account.Tax_ID_Number__c, ' '))) AS TIN, --'TAX ID',
		  AceMetaData.adi.udf_GetCleanString(SF_Account.ACE_Acct_ID1__c + SF_Account.ACE_Acct_ID2__c )AS AceAccountID,     
		  AceMetaData.adi.udf_GetCleanString(ISNULL(SF_ProvSpecialties.Speciality_Name_CAQH__c, ' ') )AS 'PrimarySpeciality',
		  AceMetaData.adi.udf_GetCleanString(ISNULL(SF_ProvSpecialties.Specialty_sub_specialty__C, ' ')) AS 'Sub_Speciality',
		  AceMetaData.adi.udf_GetCleanString(ISNULL(SF_Account.NAME, ' ') )AS 'GroupName',
		  AceMetaData.adi.udf_GetCleanString(Ltrim(rtrim(ISNULL(SF_Account.Fax,'')))) as Fax, 
		  'Comments' = ' ',	   	  
		  AceMetaData.adi.udf_GetCleanString(UPPER(ISNULL(SF_ProviderClient.ProvHealthPlans, ' '))) AS 'HealthPlan',
		  AceMetaData.adi.udf_GetCleanString(ISNULL(SF_ProviderClient.Line_of_Business__c, '')) AS LOB,
		  AceMetaData.adi.udf_GetCleanString(CASE WHEN SF_ProviderClient.Line_of_Business__c ='Medicare' then 'Medicare Advantage'  ELSE ISNULL(SF_ProviderClient.Line_of_Business__c, '') END) AS LOB_Clnd,
		  AceMetaData.adi.udf_GetCleanString(CONVERT(DATE, ISNULL(SF_ProviderClient.effective_date__C, '01/01/1900') ))AS EffectiveDate,
		  AceMetaData.adi.udf_GetCleanString(CONVERT(DATE, ISNULL(SF_ProviderClient.Term_Date__c, '12/31/2099'))) AS ExpirationDate,
		  AceMetaData.adi.udf_GetCleanString(ISNULL(SF_ProviderClient.Provider_Client_ID__c, '')) AS ClientProviderID,
		  AceMetaData.adi.udf_GetCleanString(ISNULL(SF_Contact.Status__c, '')) AS Status, 
		  AceMetaData.adi.udf_GetCleanString(SF_Account.TYPE__c) AS AccountType, 
		  AceMetaData.adi.udf_GetCleanString(SF_Account.NETWORK_CONTACT__c) AS NetworkContact, 
		  AceMetaData.adi.udf_GetCleanString(ISNULL(SF_Location.Chapter, '')) AS Chapter, 
		  AceMetaData.adi.udf_GetCleanString(ISNULL(SF_PrimaryNpiCounty.County__c, '')) AS PrimaryCounty, 
		  AceMetaData.adi.udf_GetCleanString(UPPER(isnull(SF_Contact.Type__c,' '))) as 'ProviderType', 
		  ISNULL(AceMetaData.adi.udf_GetCleanString(UPPER(CAST(STUFF((SELECT ';' + Language_Name__c
				    FROM dbo.tmpSalesforce_Provider_Language_Spoken__c pl
				    WHERE pl.Provider_Name__c = SF_LangSpoken.Provider_Name__c FOR XML PATH('')
				    ), 1, 1, '') AS VARCHAR(100)))), '') AS [LANGUAGESSPOKEN]		  
    FROM TMPSALESFORCE_CONTACT AS SF_Contact
	   LEFT JOIN tmpSalesforce_Provider_Degree__c AS SF_ProviderDegree ON SF_ProviderDegree.CONTACT__C = SF_Contact.ID
	   LEFT JOIN tmpSalesforce_Account SF_Account ON SF_Contact.ACCOUNTID = SF_Account.ID
	   LEFT JOIN TMPSALESFORCE_PROVIDER_Specialties__C AS SF_ProvSpecialties ON SF_ProvSpecialties .Provider_Name__c = SF_Contact.ID
		  AND Specialtiy_Type__c = 'PRIMARY'
	   LEFT JOIN dbo.tmpSalesforce_Provider_Client__c AS SF_ProviderClient ON SF_ProviderClient.provider_name__c = SF_Contact.id 
		  AND SF_ProviderClient.ProvHealthPlans = SF_ProviderClient.ProvHealthPlans
	   LEFT JOIN (SELECT loc.Provider_Name__c, loc.Chapter FROM dbo.tmpSalesforce_Location__c  Loc WHERE isnull(loc.Chapter,'') <> '') AS SF_Location ON SF_Contact.ID = SF_Location.Provider_Name__c
	   LEFT JOIN (SELECT src.Provider_Name__c, src.County__c
				FROM(SELECT loc.Provider_Name__c, loc.County__c, loc.Chapter , ROW_NUMBER() OVER (PARTITION BY loc.Provider_Name__c ORDER BY loc.CreatedDate DESC) ARN
					   FROM dbo.tmpSalesforce_Location__c  Loc 
					   /* change all addresses used come from 'Primary' */
					   WHERE loc.Address_Type__c = 'Primary'
					   /* removed blank provider ID */
						  and loc.Provider_Name__c <> ''					   
						  and ISNULL(loc.County__c, '') <> ''				    )src
				    where src.ARN = 1) SF_PrimaryNpiCounty ON SF_Contact.Id = SF_PrimaryNpiCounty.Provider_Name__c
	   LEFT JOIN dbo.tmpSalesforce_Provider_Language_Spoken__c SF_LangSpoken ON   SF_Contact.id = SF_LangSpoken.Provider_Name__c  
    WHERE SF_Contact.Type__c NOT IN('UHC_PCP') AND -- add this back to remove the decomissioned types
	   SF_CONTACT.LASTNAME NOT IN('TEST', 'TESTLAST', 'TESTACE', 'ACETEST') AND 
	   SF_Account.Name NOT IN ('ACE Test', 'ace test 1','Test Cain','Test SCHN 2', 'Test SCHN 3') AND
	   SF_Account.in_Network__c = '1'		  
	   ) pr	   	
    
