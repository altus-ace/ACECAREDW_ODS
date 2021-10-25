
CREATE  VIEW [dbo].[zz_vw_AllClient_ProviderRoster_LoadFctSource_V1]
AS    
    /* Objective: Extract from the SalesForce Data Dump tables, the currently loaded set of providers 
				for loading into the fctProviderRoster
	   Version History:
	   7/13/2020: GK: Changed the query to use the ProviderClient Table instead of the ContractInformation 
				    table as the custom object(provider client) was holding all the data and the 
				    standard object (ContractInfo) only has some of the info. 
	   */

    SELECT *,
	 CASE WHEN (PR.HealthPlan = 'AETNA'	   and 	PR.LOB = 'Commercial')					THEN  9
		  WHEN (PR.HealthPlan = 'AETNA'	   and 	PR.LOB = 'Medicare Advantage')			THEN  3
		  WHEN (PR.HealthPlan = 'CIGNA'	   and 	PR.LOB = 'Commercial')					THEN  17
		  WHEN (PR.HealthPlan = 'MOLINA'	   and 	PR.LOB = 'Market Place')					THEN  19
		  WHEN (PR.HealthPlan = 'MOLINA'	   and 	PR.LOB = 'Medicaid')					THEN  19
		  WHEN (PR.HealthPlan = 'UHC'		   and 	PR.LOB = 'Medicaid')					THEN  1
		  WHEN (PR.HealthPlan = 'CIGNA'	   and 	PR.LOB = 'Medicare Advantage')			THEN  12
		  WHEN (PR.HealthPlan = 'DEVOTED'	   and 	PR.LOB = 'Medicare Advantage')			THEN  11
		  WHEN (PR.HealthPlan = 'IMPERIAL'	   and 	PR.LOB = 'Medicare Advantage')			THEN  18
		  WHEN (PR.HealthPlan = 'MOLINA'	   and 	PR.LOB = 'Medicare Advantage')			THEN  19
		  WHEN (PR.HealthPlan = 'OSCAR'	   and 	PR.LOB = 'Medicare Advantage')			THEN  15
		  WHEN (PR.HealthPlan = 'WELLCARE'	   and 	PR.LOB = 'Medicare Advantage')			THEN  2
		  WHEN (PR.HealthPlan = 'OSCAR'	   and 	PR.LOB = 'Medicare Advantage;Commercial')	THEN  15
		  WHEN (PR.HealthPlan = 'OSCAR'	   and 	PR.LOB = 'Medicare Advantage;Market Place')	THEN  15
		  WHEN (PR.HealthPlan = 'OSCAR'	   and 	PR.LOB = 'Medicare;Medicare Advantage')		THEN  15
		  WHEN (PR.HealthPlan = 'SHCN_MSSP')	 	THEN  16
		  WHEN (PR.HealthPlan is NULL)												THEN  0
		  ELSE 0
	   END AS CalcClientKey
    FROM (SELECT DISTINCT
	          AceMetaData.[adi].[udf_GetCleanString](SF_Contact.Provider_NPI__c) AS 'NPI',
	          AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL(SF_Contact.LASTNAME, ' '))) AS 'LastName',
	          AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL(SF_Contact.FIRSTNAME, ' '))) AS 'FirstName',
	          AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL(UPPER(CAST(STUFF(
	                                       (
	                                           SELECT ','+RTRIM(DEGREE_NAME__C)
	                                           FROM tmpSalesforce_Provider_Degree__c TD
	                                           WHERE TD.CONTACT__C = SF_ProviderDegree.CONTACT__C
	                                                 AND TD.DEGREE_NAME__C NOT IN('(OTHER)', ' ') FOR XML PATH('')
	                                       ), 1, 1, '') AS VARCHAR(100))), ' '))) AS Degree,
	          AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL(SF_Account.Tax_ID_Number__c, ' '))) AS TIN, --'TAX ID',
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
	          AceMetaData.[adi].[udf_GetCleanString](UPPER(ISNULL(SF_ProviderClient.ProvHealthPlans, ' '))) AS 'HealthPlan',
	   	  case when AceMetaData.[adi].[udf_GetCleanString](SF_ProviderClient.Line_of_Business__c) ='Medicare' then 'Medicare Advantage' 
				else SF_ProviderClient.ProvHealthPlans end as LOB,
	   	  CONVERT(DATE, AceMetaData.[adi].[udf_GetCleanDate](SF_ProviderClient.effective_date__C)) AS EffectiveDate,
	   	  CONVERT(DATE, AceMetaData.[adi].[udf_GetCleanDate](ISNULL(SF_ProviderClient.Term_Date__c, '12/31/2099'))) AS ExpirationDate,
	   	  AceMetaData.[adi].[udf_GetCleanString](ISNULL(SF_ProviderClient.Provider_Client_ID__c, '')) AS ClientProviderID	   			  
		  , AceMetaData.[adi].[udf_GetCleanString](SF_Contact.Status__c) AS Status
		  , AceMetaData.[adi].[udf_GetCleanString](SF_Account.TYPE__c) AS AccountType
		  , AceMetaData.[adi].[udf_GetCleanString](SF_Account.NETWORK_CONTACT__c) AS NetworkContact
		  , AceMetaData.[adi].[udf_GetCleanString](SF_Location.Chapter) AS Chapter
		  , upper(isnull(AceMetaData.[adi].[udf_GetCleanString](SF_Contact.Type__c),' ')) as 'ProviderType'
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
		   --LEFT JOIN tmpSalesforce_Contract_Information__c AS SF_ContractInfo ON SF_ContractInfo.Account_Name__c = SF_Account.id
	                                                             -- AND TCI.Health_Plans__c = 'Aetna'
		   LEFT JOIN (SELECT cl.Provider_Name__c, cl.Name, cl.Line_of_Business__c, cl.ProvHealthPlans, cl.Effective_Date__c, cl.Term_Date__c
				FROM dbo.tmpSalesforce_Provider_Client__c cl) SF_ProvContractInfo
			 ON SF_Contact.Id = SF_ProvContractInfo.Provider_Name__c
				AND GETDATE() BETWEEN SF_ProvContractInfo.Effective_Date__c 
				AND COALESCE(NULLIF(SF_ProvContractInfo.Term_Date__c,''), '12/31/2099')
	        LEFT JOIN dbo.tmpSalesforce_Provider_Client__c AS SF_ProviderClient ON SF_ProviderClient.provider_name__c = SF_Contact.id 
	   		 --AND SF_ContractInfo.Health_Plans__c = SF_ProviderClient.ProvHealthPlans
			 AND SF_ProviderClient.ProvHealthPlans = SF_ProviderClient.ProvHealthPlans
		  LEFT JOIN dbo.tmpSalesforce_Location__c AS SF_Location ON SF_Contact.ID = SF_Location.Provider_Name__c
			 
	   WHERE 
		  ---SF_Contact.Status__c IN ('ACTIVE') AND   -Removed as the fact load queries by effective dates, so this is redundant 
		  --SF_Contact.Type__c IN('PCP') AND 
		  SF_CONTACT.LASTNAME NOT IN('TEST', 'TESTLAST', 'TESTACE', 'ACETEST') AND 
		  SF_Account.in_Network__c = '1'		  
	   ) pr	   

