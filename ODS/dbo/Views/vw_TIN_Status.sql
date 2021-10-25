Create View vw_TIN_Status
As
SELECT DISTINCT
	  
	   UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c, ' ')) AS 'TAX ID',
       UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.NAME, ' ')) AS 'GROUP NAME',
	 tc.Health_Plans__c,
	 tc.[Effective_Date__c] as TIN_Start_Date,
	 --tmpSalesforce_Account.[Total_number_of_Locations__c],
	 tc.Term_Date__c as TIN_Stop_Date
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
	inner JOIN [tmpSalesforce_Contract_Information__c] tc on tc.Account_Name__c=tmpSalesforce_Account.Id --and tc.Health_Plans__c='UHC'
WHERE 
   --tmpSalesforce_Contact.Status__c ='Active'
   --  AND 
	 tmpsalesforce_Contact.Type__c IN('PCP')
     AND LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST')
AND tmpsalesforce_Account.in_Network__c = '1';

