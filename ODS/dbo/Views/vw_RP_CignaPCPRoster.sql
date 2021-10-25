



CREATE VIEW [dbo].[vw_RP_CignaPCPRoster]
AS
SELECT DISTINCT
	  UPPER(ISNULL(TMPSALESFORCE_CONTACT.FIRSTNAME, ' ')) AS 'PROVIDER_FIRST_NAME',
       UPPER(ISNULL(TMPSALESFORCE_CONTACT.LASTNAME, ' ')) AS 'PROVIDER_LAST_NAME',			 
       UPPER(ISNULL(UPPER(CAST(STUFF(
                                    (
                                        SELECT ','+RTRIM(DEGREE_NAME__C)
                                        FROM tmpSalesforce_Provider_Degree__c TD
                                        WHERE TD.CONTACT__C = TD2.CONTACT__C
                                              AND TD.DEGREE_NAME__C NOT IN('(OTHER)', ' ') FOR XML PATH('')
                                    ), 1, 1, '') AS VARCHAR(100))), ' ')) AS PROVIDER_DEGREE,
	   TMPSALESFORCE_CONTACT.TYPE__c AS PROVIDER_TYPE,
      TMPSALESFORCE_CONTACT.PROVIDER_NPI__C AS 'NPI',
       UPPER(ISNULL(TMPSALESFORCE_PROVIDER_Specialties__C.Speciality_Name_CAQH__c, ' ')) AS 'PROVIDER_PRIMARY_SPECIALTY',
	  UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c, ' ')) AS 'TAX_ID',
       UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.NAME, ' ')) AS 'PRACTICE_NAME',
       UPPER(ISNULL((tmpSalesforce_Account_Locations__c.Address_1__c+' '+tmpSalesforce_Account_Locations__c.Address_2__c), ' ')) AS 'PRIMARY_PRACTICE_ADDRESS',
       UPPER(ISNULL(tmpSalesforce_Account_Locations__c.City__c, ' ')) AS 'PRIMARY_PRACTICE_CITY',
       UPPER(ISNULL(tmpSalesforce_Account_Locations__c.State__c, ' ')) AS 'PRIMARY_PRACTICE_STATE',
       UPPER(ISNULL(tmpSalesforce_Zip_Code__c.NAME, ' ')) AS 'PRIMARY_PRACTICE_ZIPCODE',
      -- UPPER(ISNULL(tmpsalesforce_zip_code__c.Quadrant__c, ' ')) AS 'PRIMARY_PRACTICE_POD',
       UPPER(ISNULL(tmpSalesforce_Account_LocationS__C.Phone__c, ' ')) AS 'PRIMARY_PRACTICE_PHONE#' ,  
       CONVERT(DATE,TMPSALESFORCE_CONTACT.Date_of_Birth__c)  as' PROVIDER_DATE_OF_BIRTH',
	  CASE WHEN  [tmpSalesforce_Provider_Medical_License__c].State__c='TX' THEN
	   [tmpSalesforce_Provider_Medical_License__c].[Medical_License__c] ELSE '' END AS PROVIDER_TEXAS_MEDICAL_LICENSE_NUMBER
	  --[tmpSalesforce_Provider_Medical_License__c].State__c
	 -- tmpSalesforce_Contact.Status__c
FROM TMPSALESFORCE_CONTACT
     LEFT JOIN tmpSalesforce_Provider_Degree__c TD2 ON TD2.CONTACT__C = TMPSALESFORCE_CONTACT.ID
     LEFT JOIN tmpSalesforce_Account ON TMPSALESFORCE_CONTACT.ACCOUNTID = tmpSalesforce_Account.ID
                                        AND tmpSalesforce_Account.IN_NETWORK__c = 1
     LEFT JOIN TMPSALESFORCE_PROVIDER_Specialties__C ON TMPSALESFORCE_PROVIDER_SPECIALTIES__C.Provider_Name__c = TMPSALESFORCE_CONTACT.ID
                                                        AND Specialtiy_Type__c = 'PRIMARY'
     LEFT JOIN tmpSalesforce_Account_Locations__c ON tmpSalesforce_Account_Locations__c.Account_Name__c = TMPSALESFORCE_ACCOUNT.ID
                                                     AND tmpSalesforce_Account_Locations__c.Location_Type__c = 'PRIMARY'
     LEFT JOIN tmpSalesforce_Zip_Code__c ON tmpSalesforce_Account_Locations__c.Zip_Code__c = tmpSalesforce_Zip_Code__c.ID
	LEFT JOIN [tmpSalesforce_Provider_Medical_License__c] ON [tmpSalesforce_Provider_Medical_License__c].Provider_Name__c=TMPSALESFORCE_CONTACT.ID
WHERE 
   tmpSalesforce_Contact.Status__c ='Active'
     AND 
	 tmpsalesforce_Contact.Type__c IN('PCP')
     AND LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST')
	and TMPSALESFORCE_ACCOUNT.NAME not like '%TEST%'
AND tmpsalesforce_Account.in_Network__c = '1';


