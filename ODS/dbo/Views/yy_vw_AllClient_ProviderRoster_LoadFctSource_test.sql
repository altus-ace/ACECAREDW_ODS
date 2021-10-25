CREATE VIEW [dbo].[yy_vw_AllClient_ProviderRoster_LoadFctSource_test]
AS    
    /* Objective: Extract from the SalesForce Data Dump tables, the currently loaded set of providers 
				for loading into the fctProviderRoster
	   Version History:
	   9/3/2020: gk added fields to the extract to provide data for new AHS Provider Extract:
		  add Ace Provider ID -- dea number + state number	 varchar(15) NULL
		  Add Ace Account ID --  Dea NUmber + State NUmber	 Varchar(15) NULL
		  Add Ethnicity								 Varchar(50) NULL
		  Add LanguagesSpoken							 Varchar(50) NULL -- this has to be pivoted
		  add Provider_DOB								 date	   NULL
		  Add Provider_Gender							 CHAR(1)	   NULL
	   7/13/2020: GK: Changed the query to use the ProviderClient Table instead of the ContractInformation 
				    table as the custom object(provider client) was holding all the data and the 
				    standard object (ContractInfo) only has some of the info. 
	   7/14/2020: GK: Changes Rolled back as they produced unexpected output
	   7/15/2020: GK: Pending
	   -- this needs to be Converted to a Table ne 
	   --    as a table (aceMapping type Salesforce Health Plan to client 
	   --					 -- source = HEalthPlan + '_' + LOB
	   --					 -- dest = List of client keys 
	   --  THEN we can join it to list_client 
	   */

    SELECT *, 	   -- Ignore  clients --4 UHC-MI, --5 UHC-CP-PCPi, --6 CCACO --7 OKC, --8	ECAP, --13 mpulse, --14 Ace
	 CASE WHEN (PR.HealthPlan = 'AETNA'	   and 	PR.LOB like '%Commercial%')				THEN  9	  --9	Aetna Comercial	AetCom
		  --WHEN (PR.HealthPlan = 'AETNA'	   and 	PR.LOB = 'Medicare;Commercial')			THEN  9	  --9	Aetna Comercial	AetCom	 
		  WHEN (PR.HealthPlan = 'AETNA'	   and 	PR.LOB like '%Medicare Advantage%')			THEN  3	  --3	Aetna	Aetna
		  --WHEN (PR.HealthPlan = 'AETNA'	   and 	PR.LOB = 'Medicare Advantage;Commercial') 	THEN  3	  --3	Aetna	Aetna
		  WHEN (PR.HealthPlan = 'CIGNA'	   and 	PR.LOB like '%Commercial%')					THEN  17	  -- 17	CIGNA Commercial	CignaCom
		  WHEN (PR.HealthPlan = 'CIGNA'	   and 	PR.LOB like '%Medicare Advantage%')			THEN  12	  --12	Cigna MA	Cigna_MA
		  WHEN (PR.HealthPlan = 'MOLINA'	   /*and 	PR.LOB = 'Market Place'*/)					THEN  19	  --19	Molina	Mol		  
		  --WHEN (PR.HealthPlan = 'MOLINA'	   and 	PR.LOB = 'Medicare Advantage')			THEN  19	  -- 19	Molina	Mol
		  WHEN (PR.HealthPlan = 'UHC'		   and 	PR.LOB = 'Medicaid')					THEN  1	  --1	United Health Care	UHC		  
		  WHEN (PR.HealthPlan = 'DEVOTED'	   and 	PR.LOB = 'Medicare Advantage')			THEN  11	  --11	Devoted Health Plan of Texas, Inc	Devoted
		  WHEN (PR.HealthPlan = 'IMPERIAL'	   and 	PR.LOB = 'Medicare Advantage')			THEN  18	  -- 18	Imperial	Imp		  
		  WHEN (PR.HealthPlan = 'WELLCARE'	   and 	PR.LOB = 'Medicare Advantage')			THEN  2	  --2	Wellcare Health Plans	Wellcare
		  WHEN (PR.HealthPlan = 'OSCAR'	   and 	PR.LOB like '%Medicare Advantage%')			THEN  15	  --15	Oscar Health	Oscar		  
		  --WHEN (PR.HealthPlan = 'OSCAR'	   and 	PR.LOB = 'Medicare Advantage;Commercial')	THEN  15	  -- 15	Oscar Health	Oscar
		  --WHEN (PR.HealthPlan = 'OSCAR'	   and 	PR.LOB = 'Medicare Advantage;Market Place')	THEN  15	  -- 15	Oscar Health	Oscar
		  --WHEN (PR.HealthPlan = 'OSCAR'	   and 	PR.LOB = 'Medicare;Medicare Advantage')		THEN  15	  -- 15	Oscar Health	Oscar
		  WHEN (PR.HealthPlan = 'SHCN_MSSP')	 										THEN  16	  --16	Steward Health Care Network MSSP	SHCN_MSSP
		  WHEN (PR.HealthPlan = 'SHCN_BCBS')	 										THEN  20	  --20	Steward Health Care Network BCBS	SHCN_BCBS
		  WHEN (PR.HealthPlan is NULL)												THEN  0	  --0	Unknown Client	Unkn
		  ELSE 0																			  --0	Unknown Client	Unkn							
	   END AS CalcClientKey
    FROM (SELECT DISTINCT
	          AceMetaData.[adi].[udf_GetCleanString](SF_Contact.Provider_NPI__c) AS 'NPI',
	          AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL(SF_Contact.LASTNAME, ' '))) AS 'LastName',
	          AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL(SF_Contact.FIRSTNAME, ' '))) AS 'FirstName',
			SF_Contact.ACE_Provider_ID1__c + SF_Contact.ACE_Provider_ID2__c AS [AceProviderID], 
			SF_Contact.Provider_Ethnicity__c AS ETHNICITY, 
			SF_Contact.Date_of_Birth__c  AS DateOfBirth,
			SF_Contact.Gender__c	 AS Gender,			 
	          AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL(UPPER(CAST(STUFF(
	                                       (
	                                           SELECT ','+RTRIM(DEGREE_NAME__C)
	                                           FROM tmpSalesforce_Provider_Degree__c TD
	                                           WHERE TD.CONTACT__C = SF_ProviderDegree.CONTACT__C
	                                                 AND TD.DEGREE_NAME__C NOT IN('(OTHER)', ' ') FOR XML PATH('')
	                                       ), 1, 1, '') AS VARCHAR(100))), ' '))) AS Degree,
	          AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL(SF_Account.Tax_ID_Number__c, ' '))) AS TIN, --'TAX ID',
			SF_Account.ACE_Acct_ID1__c + SF_Account.ACE_Acct_ID2__c AS AceAccountID,     
	          AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL(SF_ProvSpecialties.Speciality_Name_CAQH__c, ' '))) AS 'PrimarySpeciality',
	   	     AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL(SF_ProvSpecialties.Specialty_sub_specialty__C, ' '))) AS 'Sub_Speciality',
	          AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL(SF_Account.NAME, ' '))) AS 'GroupName',
	          AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL((PrimaryPracticeLocation.Address_1__c+' '+PrimaryPracticeLocation.Address_2__c), ' '))) AS 'PrimaryAddress',
	          AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL(PrimaryPracticeLocation.City__c, ' '))) AS 'PrimaryCity',
	          AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL(PrimaryPracticeLocation.State__c, ' '))) AS 'PrimaryState',
	          AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL(PrimaryPracticeZipCode.NAME, ' '))) AS 'PrimaryZipcode',
	          AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL(PrimaryPracticeZipCode.Quadrant__c, ' '))) AS 'PrimaryPOD',
			AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL(PrimaryPracticeZipCode.pod__c, ' '))) AS 'PrimaryQuadrant',
	          AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL(PrimaryPracticeLocation.Phone__c, ' '))) AS 'PrimaryAddressPhoneNumber',
	          AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL(BillingPracticeLocation.Address_1__c+' '+BillingPracticeLocation.Address_2__c, ' '))) AS 'BillingAddress',
	          AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL(BillingPracticeLocation.City__c, ' '))) AS 'BillingCity',
	          AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL(BillingPracticeLocation.State__c, ' '))) AS 'BillingState',
	          AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL(BillingPracticeZipCode.NAME, ' '))) AS 'BillingZipcode',
	          AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL(BillingPracticeZipCode.Quadrant__c, ' '))) AS 'BillingPOD',
	          AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL(BillingPracticeLocation.Phone__c, ' '))) AS 'BillingAddressPhoneNumber',
			AceMetaData.[adi].[udf_GetCleanString](UPPER(Ltrim(rtrim(SF_Account.Fax)))) as Fax, 
	          'Comments' = ' ',	   	  
--	          AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL(SF_ProviderClient.ProvHealthPlans, ' '))) AS 'HealthPlan',
--	   	  case when AceMetaData.[adi].[udf_GetCleanString](SF_ProviderClient.Line_of_Business__c) ='Medicare' then 'Medicare Advantage' 
--				else SF_ProviderClient.ProvHealthPlans end as LOB,
--	   	  CONVERT(DATE, AceMetaData.[adi].[udf_GetCleanDate](SF_ProviderClient.effective_date__C)) AS EffectiveDate,
--	   	  CONVERT(DATE, AceMetaData.[adi].[udf_GetCleanDate](ISNULL(SF_ProviderClient.Term_Date__c, '12/31/2099'))) AS ExpirationDate,
	   	  AceMetaData.[adi].[udf_GetCleanString](ISNULL(SF_ProviderClient.Provider_Client_ID__c, '')) AS ClientProviderID	   			  
		  , AceMetaData.[adi].[udf_GetCleanString](SF_Contact.Status__c) AS Status
		  , AceMetaData.[adi].[udf_GetCleanString](SF_Account.TYPE__c) AS AccountType
		  , AceMetaData.[adi].[udf_GetCleanString](SF_Account.NETWORK_CONTACT__c) AS NetworkContact
		  , AceMetaData.[adi].[udf_GetCleanString](SF_Location.Chapter) AS Chapter
		  , upper(isnull(AceMetaData.[adi].[udf_GetCleanString](SF_Contact.Type__c),' ')) as 'ProviderType'
		  
		  , UPPER(ISNULL(SF_ContractInfo.Health_Plans__c, ' ')) AS 'HealthPlan',
	   	  case when SF_ContractInfo.Line_of_business__C ='Medicare' then 'Medicare Advantage' else SF_ContractInfo.Line_of_business__C end as LOB,
	   	  CONVERT(DATE, SF_ContractInfo.effective_date__C) AS EffectiveDate,
	   	  CONVERT(DATE, ISNULL(SF_ContractInfo.term_date__C, '12/31/2099')) AS ExpirationDate
		  ,  UPPER(CAST(STUFF((SELECT ';' + Language_Name__c
				FROM dbo.tmpSalesforce_Provider_Language_Spoken__c pl
				WHERE pl.Provider_Name__c = SF_LangSpoken.Provider_Name__c FOR XML PATH('')
				), 1, 1, '') AS VARCHAR(100))) AS [LANGUAGESSPOKEN]
	   FROM TMPSALESFORCE_CONTACT AS SF_Contact
	        LEFT JOIN tmpSalesforce_Provider_Degree__c AS SF_ProviderDegree ON SF_ProviderDegree.CONTACT__C = SF_Contact.ID
	        LEFT JOIN tmpSalesforce_Account SF_Account ON SF_Contact.ACCOUNTID = SF_Account.ID
	           AND SF_Account.IN_NETWORK__c = 1
	        LEFT JOIN TMPSALESFORCE_PROVIDER_Specialties__C AS SF_ProvSpecialties ON SF_ProvSpecialties .Provider_Name__c = SF_Contact.ID
	           AND Specialtiy_Type__c = 'PRIMARY'
	        LEFT JOIN tmpSalesforce_Account_Locations__c AS PrimaryPracticeLocation ON PrimaryPracticeLocation.Account_Name__c = SF_Account.ID
	           AND PrimaryPracticeLocation.Location_Type__c = 'PRIMARY'
	        LEFT JOIN tmpSalesforce_Account_Locations__c AS BillingPracticeLocation ON BillingPracticeLocation.Account_Name__c = SF_Account.ID
			 AND BillingPracticeLocation.Location_Type__c = 'BILLING'
	        LEFT JOIN tmpSalesforce_Zip_Code__c AS PrimaryPracticeZipCode ON PrimaryPracticeLocation.Zip_Code__c = PrimaryPracticeZipCode.ID
	        LEFT JOIN tmpSalesforce_Zip_Code__c AS BillingPracticeZipCode ON BillingPracticeLocation.Zip_Code__c = BillingPracticeZipCode.ID
	        /* Removed to conform with discovery in SF, custom table Provider Client replaced this */
		   LEFT JOIN tmpSalesforce_Contract_Information__c AS SF_ContractInfo ON SF_ContractInfo.Account_Name__c = SF_Account.id
	        LEFT JOIN (SELECT cl.Provider_Name__c, cl.Name, cl.Line_of_Business__c, cl.ProvHealthPlans, cl.Effective_Date__c, cl.Term_Date__c
				FROM dbo.tmpSalesforce_Provider_Client__c cl) SF_ProvContractInfo
			 ON SF_Contact.Id = SF_ProvContractInfo.Provider_Name__c
				AND GETDATE() BETWEEN SF_ProvContractInfo.Effective_Date__c 
				AND COALESCE(NULLIF(SF_ProvContractInfo.Term_Date__c,''), '12/31/2099')
	        LEFT JOIN dbo.tmpSalesforce_Provider_Client__c AS SF_ProviderClient ON SF_ProviderClient.provider_name__c = SF_Contact.id 
	   		 --AND SF_ContractInfo.Health_Plans__c = SF_ProviderClient.ProvHealthPlans
			 AND SF_ProviderClient.ProvHealthPlans = SF_ProviderClient.ProvHealthPlans
		  LEFT JOIN dbo.tmpSalesforce_Location__c AS SF_Location ON SF_Contact.ID = SF_Location.Provider_Name__c
		  LEFT JOIN dbo.tmpSalesforce_Provider_Language_Spoken__c SF_LangSpoken ON   SF_Contact.id = SF_LangSpoken.Provider_Name__c  
	   WHERE 
		  ---SF_Contact.Status__c IN ('ACTIVE') AND   -Removed as the fact load queries by effective dates, so this is redundant 
		  SF_Contact.Type__c NOT IN('UHC_PCP') AND -- add this back to remove the decomissioned types
		  SF_CONTACT.LASTNAME NOT IN('TEST', 'TESTLAST', 'TESTACE', 'ACETEST') AND 
		  SF_Account.in_Network__c = '1'		  
	   ) pr	   

