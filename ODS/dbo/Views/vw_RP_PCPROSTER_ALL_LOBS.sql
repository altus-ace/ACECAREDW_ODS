create view vw_RP_PCPROSTER_ALL_LOBS
as
SELECT DISTINCT
   UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c, ' ')) AS 'TAX ID',
      UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.NAME, ' ')) AS 'ACCOUNT NAME',
	  UPPER(ISNULL(TMPSALESFORCE_CONTACT.FIRSTNAME, ' ')) AS 'PROVIDER FIRST NAME',
       UPPER(ISNULL(TMPSALESFORCE_CONTACT.LASTNAME, ' ')) AS 'PROVIDER LAST NAME',			 
       UPPER(ISNULL(TMPSALESFORCE_CONTACT.[Provider_CAQH_Number__c] ,'')) AS 'PROVIDER CAQH NUMBER' ,    
       TMPSALESFORCE_ACCOUNT.[Group_NPI_Number__c] AS 'GROUP NPI',
	  TMPSALESFORCE_CONTACT.PROVIDER_NPI__C AS 'PROVIDER NPI',
	   UPPER(ISNULL(TMPSALESFORCE_PROVIDER_Specialties__C.Speciality_Name_CAQH__c, ' ')) AS 'PRIMARY SPECIALTY',
       UPPER(ISNULL((tmpSalesforce_Location__c.[Address_1__c]+' '+tmpSalesforce_Location__c.[Address_2__c]), ' ')) AS 'PRIMARY STREET ADDRESS',
       UPPER(ISNULL(tmpSalesforce_Location__c.City__c, ' ')) AS 'PRIMARY CITY',
       UPPER(ISNULL(tmpSalesforce_Location__c.State__c, ' ')) AS 'PRIMARY STATE',
       UPPER(ISNULL(tmpSalesforce_Zip_Code__c.NAME, ' ')) AS 'PRIMARY ZIPCODE',
       UPPER(ISNULL(tmpsalesforce_zip_code__c.Quadrant__c, ' ')) AS 'PRIMARY POD',
       UPPER(ISNULL(TMPSALESFORCE_CONTACT.Phone, ' ')) AS 'PROVIDER PHONE#',    
	  UPPER(ISNULL(TMPSALESFORCE_CONTACT.FAX, ' ')) AS 'PROVIDER FAX#',  
	 UPPER(ISNULL(TMPSALESFORCE_CONTACT.Email, ' ')) AS 'PROVIDER EMAIL#',
       tc.Health_Plans__c AS 'HEALTH PLANS'
	 -- tmpSalesforce_Contact.Status__c
FROM TMPSALESFORCE_CONTACT
     LEFT JOIN tmpSalesforce_Provider_Degree__c TD2 ON TD2.CONTACT__C = TMPSALESFORCE_CONTACT.ID
     LEFT JOIN tmpSalesforce_Account ON TMPSALESFORCE_CONTACT.ACCOUNTID = tmpSalesforce_Account.ID
                                        AND tmpSalesforce_Account.IN_NETWORK__c = 1
     LEFT JOIN TMPSALESFORCE_PROVIDER_Specialties__C ON TMPSALESFORCE_PROVIDER_SPECIALTIES__C.Provider_Name__c = TMPSALESFORCE_CONTACT.ID
                                                        AND Specialtiy_Type__c = 'PRIMARY'
     LEFT JOIN tmpSalesforce_Location__c ON tmpSalesforce_Location__c.[Provider_Name__c] = TMPSALESFORCE_CONTACT.ID
                                                     AND tmpSalesforce_Location__c.[Address_Type__c] = 'PRIMARY'
         LEFT JOIN tmpSalesforce_Zip_Code__c ON tmpSalesforce_Location__c.[ZipCode_New__c] = tmpSalesforce_Zip_Code__c.ID
     	inner JOIN [tmpSalesforce_Contract_Information__c] tc on tc.Account_Name__c=tmpSalesforce_Account.Id-- and tc.Health_Plans__c='UHC'
WHERE 
   tmpSalesforce_Contact.Status__c ='Active'
     AND 
	 tmpsalesforce_Contact.Type__c IN('PCP')
     AND LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST')
	AND TMPSALESFORCE_ACCOUNT.NAME NOT LIKE 'ACETEST%'
AND tmpsalesforce_Account.in_Network__c = '1';
