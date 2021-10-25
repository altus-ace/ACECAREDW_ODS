
 CREATE VIEW [dbo].[vw_NetworkRosterN]
 As 

 SELECT DISTINCT
            TMPSALESFORCE_CONTACT.PROVIDER_NPI__C AS 'NPI',
		  upper(isnull(tmpsalesforce_Contact.Type__c,' ')) as 'PROVIDER TYPE',
                  UPPER(ISNULL(TMPSALESFORCE_CONTACT.LASTNAME, ' ')) AS 'LAST NAME',
            UPPER(ISNULL(TMPSALESFORCE_CONTACT.FIRSTNAME, ' ')) AS 'FIRST NAME',
            UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c, ' ')) AS 'TAX ID',
            --UPPER(ISNULL(TMPSALESFORCE_PROVIDER_Specialties__C.Speciality_Name_CAQH__c, ' ')) AS 'PRIMARY SPECIALTY',
		  --UPPER(ISNULL(TSS2.Speciality_Name_CAQH__c, ' ')) AS 'SECONDARY SPECIALTY',
		  UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.NAME, ' ')) AS 'PRACTICE NAME',
            UPPER(ISNULL((tmpSalesforce_Account_Locations__c.Address_1__c+' '+tmpSalesforce_Account_Locations__c.Address_2__c), ' ')) AS 'PRIMARY ADDRESS',
            UPPER(ISNULL(tmpSalesforce_Account_Locations__c.City__c, ' ')) AS 'PRIMARY CITY',
            UPPER(ISNULL(tmpSalesforce_Account_Locations__c.State__c, ' ')) AS 'PRIMARY STATE',
            UPPER(ISNULL(tmpSalesforce_Zip_Code__c.NAME, ' ')) AS 'PRIMARY ZIPCODE',
            UPPER(ISNULL(tmpsalesforce_zip_code__c.Quadrant__c, ' ')) AS 'PRIMARY POD',
		  UPPER(ISNULL(tmpsalesforce_zip_code__c.pod__c, ' ')) AS 'PRIMARY Quadrant',
            UPPER(ISNULL(tmpSalesforce_Account_LocationS__C.Phone__c, ' ')) AS 'PRIMARY ADDRESS PHONE#',
		  UPPER(ISNULL(tmpSalesforce_Contact.Status__c,' ')) AS STATUS
		 --, tc.Health_Plans__c as CLIENT
		 ,tmpSalesforce_Account.TYPE__c AS 'ACCOUNT TYPE'
		 ,tmpSalesforce_Account.NETWORK_CONTACT__c
	       ,   UPPER(ISNULL(TMPSALESFORCE_PROVIDER_Specialties__C.Speciality_Name_CAQH__c, ' ')) AS 'PrimarySpeciality'
	   	   ,UPPER(ISNULL(TMPSALESFORCE_PROVIDER_Specialties__C.Specialty_sub_specialty__C, ' ')) AS 'Sub_Speciality'
		 	,UPPER(Ltrim(rtrim(TMPSALESFORCE_CONTACT.Fax))) as Fax
           FROM (
			SELECT *
			FROM (SELECT *
				  ,RANK() OVER (PARTITION BY [Provider_NPI__c] ORDER BY [LastModifiedDate] DESC) AS RANK
			  FROM [ACECAREDW].[dbo].[tmpSalesforce_Contact]) A
			  WHERE RANK = 1
			  --AND Provider_NPI__c in ('1013209964','1326209354','1336375013')
			) TMPSALESFORCE_CONTACT
           LEFT JOIN tmpSalesforce_Account ON TMPSALESFORCE_CONTACT.ACCOUNTID = tmpSalesforce_Account.ID
                                             AND tmpSalesforce_Account.IN_NETWORK__c = 1
          LEFT JOIN TMPSALESFORCE_PROVIDER_Specialties__C ON TMPSALESFORCE_PROVIDER_SPECIALTIES__C.Provider_Name__c = TMPSALESFORCE_CONTACT.ID
                                                             AND Specialtiy_Type__c = 'PRIMARY'
	   LEFT JOIN TMPSALESFORCE_PROVIDER_Specialties__C TSS2 ON TSS2.Provider_Name__c = TMPSALESFORCE_CONTACT.ID
                                                             AND TSS2.Specialtiy_Type__c = 'SECONDARY'
          LEFT JOIN tmpSalesforce_Account_Locations__c ON tmpSalesforce_Account_Locations__c.Account_Name__c = TMPSALESFORCE_ACCOUNT.ID
                                                          AND tmpSalesforce_Account_Locations__c.Location_Type__c = 'PRIMARY'
                  LEFT JOIN tmpSalesforce_Zip_Code__c ON tmpSalesforce_Account_Locations__c.Zip_Code__c = tmpSalesforce_Zip_Code__c.ID
			 	--inner JOIN [tmpSalesforce_Contract_Information__c] tc on tc.Account_Name__c=tmpSalesforce_Account.Id
              WHERE --tmpSalesforce_Contact.Status__c In ('ACTIVE')
          --AND 
			tmpsalesforce_Contact.Type__c  NOT IN('UHC PCP')
          AND LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST')
		and tmpSalesforce_Account.Name not like '%Test%'
     AND tmpsalesforce_Account.in_Network__c = '1'
	 
	 --AND PROVIDER_NPI__C = '1003971755'





