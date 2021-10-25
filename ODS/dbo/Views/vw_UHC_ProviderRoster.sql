


CREATE VIEW [dbo].[vw_UHC_ProviderRoster]
AS
SELECT DISTINCT
	  UPPER(ISNULL(TMPSALESFORCE_CONTACT.FIRSTNAME, ' ')) AS 'PHYSICIANS FIRST NAME',
       UPPER(ISNULL(TMPSALESFORCE_CONTACT.LASTNAME, ' ')) AS 'PHYSICIANS LAST NAME',			 
       
	  
      
       UPPER(ISNULL(UPPER(CAST(STUFF(
                                    (
                                        SELECT ','+RTRIM(DEGREE_NAME__C)
                                        FROM tmpSalesforce_Provider_Degree__c TD
                                        WHERE TD.CONTACT__C = TD2.CONTACT__C
                                              AND TD.DEGREE_NAME__C NOT IN('(OTHER)', ' ') FOR XML PATH('')
                                    ), 1, 1, '') AS VARCHAR(100))), ' ')) AS DEGREE,
      
       UPPER(ISNULL(TMPSALESFORCE_PROVIDER_Specialties__C.Speciality_Name_CAQH__c, ' ')) AS 'PRIMARY SPECIALTY',
	  TMPSALESFORCE_CONTACT.PROVIDER_NPI__C AS 'NPI',
	   UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c, ' ')) AS 'TAX ID',
       UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.NAME, ' ')) AS 'GROUP NAME',
	  UPPER(ISNULL(TL2.Address_1__c+' '+TL2.Address_2__c, ' ')) AS 'BILLING STREET ADDRESS',
       UPPER(ISNULL(TL2.City__c, ' ')) AS 'BILLING CITY',
       UPPER(ISNULL(TL2.State__c, ' ')) AS 'BILLING STATE',
       UPPER(ISNULL(TZ1.NAME, ' ')) AS 'BILLING ZIPCODE',
       UPPER(ISNULL(TZ1.Quadrant__c, ' ')) AS 'BILLING POD',
       UPPER(ISNULL(TL2.Phone__c, ' ')) AS 'BILLING ADDRESS PHONE#',
	  'P' as 'SERVICE ADDRESS TYPE P = Primary Service Address S = Secondary Service Address',
       UPPER(ISNULL((tmpSalesforce_Account_Locations__c.Address_1__c+' '+tmpSalesforce_Account_Locations__c.Address_2__c), ' ')) AS 'SERVICE STREET ADDRESS',
       UPPER(ISNULL(tmpSalesforce_Account_Locations__c.City__c, ' ')) AS 'SERVICE CITY',
       UPPER(ISNULL(tmpSalesforce_Account_Locations__c.State__c, ' ')) AS 'SERVICE STATE',
       UPPER(ISNULL(tmpSalesforce_Zip_Code__c.NAME, ' ')) AS 'SERVICE ZIPCODE',
       UPPER(ISNULL(tmpsalesforce_zip_code__c.Quadrant__c, ' ')) AS 'SERVICE POD',
       UPPER(ISNULL(tmpSalesforce_Account_LocationS__C.Phone__c, ' ')) AS 'SERVICE ADDRESS PHONE#',    
       'COMMENTS' = ' '
	 -- tmpSalesforce_Contact.Status__c
FROM TMPSALESFORCE_CONTACT
     LEFT JOIN tmpSalesforce_Provider_Degree__c TD2 ON TD2.CONTACT__C = TMPSALESFORCE_CONTACT.ID
     LEFT JOIN tmpSalesforce_Account ON TMPSALESFORCE_CONTACT.ACCOUNTID = tmpSalesforce_Account.ID
                                        AND tmpSalesforce_Account.IN_NETWORK__c = 1
     LEFT JOIN TMPSALESFORCE_PROVIDER_Specialties__C ON TMPSALESFORCE_PROVIDER_SPECIALTIES__C.Provider_Name__c = TMPSALESFORCE_CONTACT.ID
                                                        AND Specialtiy_Type__c = 'PRIMARY'
     LEFT JOIN tmpSalesforce_Account_Locations__c ON tmpSalesforce_Account_Locations__c.Account_Name__c = TMPSALESFORCE_ACCOUNT.ID
                                                     AND tmpSalesforce_Account_Locations__c.Location_Type__c = 'PRIMARY'
     LEFT JOIN tmpSalesforce_Account_Locations__c TL2 ON TL2.Account_Name__c = TMPSALESFORCE_ACCOUNT.ID
                                                         AND TL2.Location_Type__c = 'BILLING'
     LEFT JOIN tmpSalesforce_Zip_Code__c ON tmpSalesforce_Account_Locations__c.Zip_Code__c = tmpSalesforce_Zip_Code__c.ID
     LEFT JOIN tmpSalesforce_Zip_Code__c TZ1 ON TL2.Zip_Code__c = TZ1.ID
	inner JOIN [tmpSalesforce_Contract_Information__c] tc on tc.Account_Name__c=tmpSalesforce_Account.Id and tc.Health_Plans__c='UHC'
WHERE 
   tmpSalesforce_Contact.Status__c ='Active'
     AND 
	 tmpsalesforce_Contact.Type__c IN('PCP')
     AND LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST')
AND tmpsalesforce_Account.in_Network__c = '1';

