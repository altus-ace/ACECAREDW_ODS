







CREATE view [dbo].[vw_RP_GapsInNetworkbypod]
AS

SELECT DISTINCT
            TMPSALESFORCE_CONTACT.PROVIDER_NPI__C AS 'NPI',
		  UPPER(TMPSALESFORCE_CONTACT.FirstName+' '+TMPSALESFORCE_CONTACT.LASTNAME) as 'PROVIDER NAME',
              UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c, ' ')) AS 'TAX ID',
		    UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.NAME, ' ')) AS 'PRACTICE NAME',
		    UPPER(ISNULL(tmpSalesforce_Contract_Information__c.Health_Plans__c,' ')) AS 'MCO',
		    UPPER(ISNULL(tmpSalesforce_Contract_Information__c.LINE_OF_BUSINESS__c ,' ')) AS 'LOB',
         	   UPPER(ISNULL(TMPSALESFORCE_PROVIDER_Specialties__C.Speciality_Name_CAQH__c, ' ')) AS 'PRIMARY SPECIALTY',
            --UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.NAME, ' ')) AS 'PRACTICE NAME',
            UPPER(ISNULL(tmpsalesforce_zip_code__c.Quadrant__c, ' ')) AS 'PRIMARY POD',
		  UPPER(ISNULL(tmpsalesforce_contact.type__C,' ')) as 'PROVIDER TYPE',
		 UPPER(ISNULL(tmpsalesforce_contact.Status__c,' ')) as 'PROVIDER STATUS',
		 UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.Termination_with_cause__c, ' ')) AS 'Practice Status'
             FROM TMPSALESFORCE_CONTACT
               LEFT JOIN tmpSalesforce_Account ON TMPSALESFORCE_CONTACT.ACCOUNTID = tmpSalesforce_Account.ID
                                             AND tmpSalesforce_Account.IN_NETWORK__c = 1
          LEFT JOIN TMPSALESFORCE_PROVIDER_Specialties__C ON TMPSALESFORCE_PROVIDER_SPECIALTIES__C.Provider_Name__c = TMPSALESFORCE_CONTACT.ID
                                                             AND Specialtiy_Type__c = 'PRIMARY'
          LEFT JOIN tmpSalesforce_Account_Locations__c ON tmpSalesforce_Account_Locations__c.Account_Name__c = TMPSALESFORCE_ACCOUNT.ID
                                                          AND tmpSalesforce_Account_Locations__c.Location_Type__c = 'PRIMARY'
         
          LEFT JOIN tmpSalesforce_Zip_Code__c ON tmpSalesforce_Account_Locations__c.Zip_Code__c = tmpSalesforce_Zip_Code__c.ID
		LEFT JOIN tmpSalesforce_Contract_Information__c ON tmpSalesforce_Contract_Information__c.Account_Name__c=tmpSalesforce_Account.Id
          
     WHERE --tmpSalesforce_Contact.Status__c In ('ACTIVE')
         tmpsalesforce_Contact.Type__c not IN('UHC PCP')
AND LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST')
and TMPSALESFORCE_ACCOUNT.NAME not like '%TEST%'
AND tmpsalesforce_Account.in_Network__c = '1';






