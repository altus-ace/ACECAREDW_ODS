
CREATE VIEW [dbo].[vw_RP_NCQA_Specialist]
AS
     SELECT DISTINCT
		-- UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.NAME, ' ')) AS 'PRACTICE NAME',
		--   UPPER(ISNULL(tmpSalesforce_Account_LocationS__C.NAME,' ')) AS 'PRACTICE SITE NAME',
		   UPPER(ISNULL(TMPSALESFORCE_Contact.FirstName,' '))+' '+UPPER(ISNULL(TMPSALESFORCE_Contact.LastName,' ')) AS 'PROVIDER NAME',
		  -- tmpSalesforce_Contact.Type__c,
          
	  
	          UPPER(ISNULL((tmpSalesforce_Account_Locations__c.Address_1__c), ' ')) AS 'ADDRESS 1',
		  UPPER(ISNULL((tmpSalesforce_Account_Locations__c.Address_2__c), ' ')) AS 'ADDRESS 2',
            UPPER(ISNULL(tmpSalesforce_Account_Locations__c.City__c, ' ')) AS 'CITY',
            UPPER(ISNULL(tmpSalesforce_Account_Locations__c.State__c, ' ')) AS ' STATE',
            UPPER(ISNULL(tmpSalesforce_Zip_Code__c.NAME, ' ')) AS 'ZIPCODE',
            UPPER(ISNULL(tmpSalesforce_Account.Main_Contact__c, ' ')) AS 'CONTACT FIRST AND LAST NAME',
            UPPER(ISNULL(tmpSalesforce_Account_LocationS__C.Phone__c, ' ')) AS 'PHONE NUMBER',
		   UPPER(ISNULL(t.SPECIALTY_new,' ')) as 'PROVIDER SPECIALTY',
		  --UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c, ' ')) AS 'TAX ID',
		--  '' AS 'ADDITIONAL HEALTH CARE PROVIDERS(SELECT FROM LIST):',
		  '' AS  'IF SELECTED "OTHER" AS TYPE OF PROVIDER,DEFINE HERE:',
		  '' AS 'NO OF FACILITIES/SITES,IF APPLICATBLE:'
		   FROM TMPSALESFORCE_Contact
          LEFT JOIN tmpSalesforce_Provider_Degree__c TD2 ON TD2.CONTACT__C = TMPSALESFORCE_CONTACT.ID
          LEFT JOIN tmpSalesforce_Account ON TMPSALESFORCE_CONTACT.ACCOUNTID = tmpSalesforce_Account.ID
                                             AND tmpSalesforce_Account.IN_NETWORK__c = 1
          LEFT JOIN tmpSalesforce_Account_Locations__c ON tmpSalesforce_Account_Locations__c.Account_Name__c = TMPSALESFORCE_ACCOUNT.ID
	     AND tmpSalesforce_Account_Locations__c.Location_Type__c='PRIMARY'
          LEFT JOIN tmpSalesforce_Zip_Code__c ON tmpSalesforce_Account_Locations__c.Zip_Code__c = tmpSalesforce_Zip_Code__c.ID
		  Left Join
		  ( select distinct [tax id] as tax_id,
	UPPER(CAST(STUFF(
                            (
                                SELECT ';'+SPECIALTY
                                FROM (SELECT distinct	  
            UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c, ' ')) AS 'TAX ID',
           UPPER(ISNULL(TMPSALESFORCE_PROVIDER_Specialties__C.Speciality_Name_CAQH__c, ' ')) AS 'SPECIALTY'
	                FROM TMPSALESFORCE_Contact
            LEFT JOIN tmpSalesforce_Account ON TMPSALESFORCE_CONTACT.ACCOUNTID = tmpSalesforce_Account.ID
                                             AND tmpSalesforce_Account.IN_NETWORK__c = 1
          LEFT JOIN TMPSALESFORCE_PROVIDER_Specialties__C ON TMPSALESFORCE_PROVIDER_SPECIALTIES__C.Provider_Name__c = TMPSALESFORCE_CONTACT.ID
                                                             AND Specialtiy_Type__c = 'PRIMARY'
                WHERE tmpSalesforce_Contact.Status__c IS NULL
           AND tmpsalesforce_Contact.Type__c IN('Specialist')
          AND LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST',' CAINTEST')
     AND tmpsalesforce_Account.in_Network__c = '1') tsl
                                WHERE tsl.[TAX ID] = ts2.[tax id] FOR XML PATH('')
                            ), 1, 1, '') AS VARCHAR(100))) AS [SPECIALTY_new] 
					 From (
	SELECT distinct	  
            UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c, ' ')) AS 'TAX ID',
           UPPER(ISNULL(TMPSALESFORCE_PROVIDER_Specialties__C.Speciality_Name_CAQH__c, ' ')) AS 'SPECIALTY'
	                FROM TMPSALESFORCE_Contact
            LEFT JOIN tmpSalesforce_Account ON TMPSALESFORCE_CONTACT.ACCOUNTID = tmpSalesforce_Account.ID
                                             AND tmpSalesforce_Account.IN_NETWORK__c = 1
          LEFT JOIN TMPSALESFORCE_PROVIDER_Specialties__C ON TMPSALESFORCE_PROVIDER_SPECIALTIES__C.Provider_Name__c = TMPSALESFORCE_CONTACT.ID
                                                             AND Specialtiy_Type__c = 'PRIMARY'
                WHERE tmpSalesforce_Contact.Status__c IS NULL
           AND tmpsalesforce_Contact.Type__c IN('Specialist')
          AND LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST','  CAINTEST')
     AND tmpsalesforce_Account.in_Network__c = '1') as ts2) as t on t.tax_id=TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c
          WHERE tmpSalesforce_Contact.Status__c IS NULL
           AND tmpsalesforce_Contact.Type__c IN('Specialist')
          AND LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST','  CAINTEST')
		AND FIRSTNAME NOT IN ('TEST', 'TESTLAST', 'ACETEST','  CAINTEST')
     AND tmpsalesforce_Account.in_Network__c = '1'

	UNION

	SELECT DISTINCT
		-- UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.NAME, ' ')) AS 'PRACTICE NAME',
		--   UPPER(ISNULL(tmpSalesforce_Account_LocationS__C.NAME,' ')) AS 'PRACTICE SITE NAME',
		   UPPER(ISNULL(TMPSALESFORCE_Contact.FirstName,' '))+' '+UPPER(ISNULL(TMPSALESFORCE_Contact.LastName,' ')) AS 'PROVIDER NAME',
		  -- tmpSalesforce_Contact.Type__c,
          
	  
	          UPPER(ISNULL((tmpSalesforce_Account_Locations__c.Address_1__c), ' ')) AS 'ADDRESS 1',
		  UPPER(ISNULL((tmpSalesforce_Account_Locations__c.Address_2__c), ' ')) AS 'ADDRESS 2',
            UPPER(ISNULL(tmpSalesforce_Account_Locations__c.City__c, ' ')) AS 'CITY',
            UPPER(ISNULL(tmpSalesforce_Account_Locations__c.State__c, ' ')) AS ' STATE',
            UPPER(ISNULL(tmpSalesforce_Zip_Code__c.NAME, ' ')) AS 'ZIPCODE',
            UPPER(ISNULL(tmpSalesforce_Account.Main_Contact__c, ' ')) AS 'CONTACT FIRST AND LAST NAME',
            UPPER(ISNULL(tmpSalesforce_Account_LocationS__C.Phone__c, ' ')) AS 'PHONE NUMBER',
		   UPPER(ISNULL(t.SPECIALTY_new,' ')) as 'PROVIDER SPECIALTY',
		  --UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c, ' ')) AS 'TAX ID',
		--  '' AS 'ADDITIONAL HEALTH CARE PROVIDERS(SELECT FROM LIST):',
		  '' AS  'IF SELECTED "OTHER" AS TYPE OF PROVIDER,DEFINE HERE:',
		  '' AS 'NO OF FACILITIES/SITES,IF APPLICATBLE:'
		   FROM TMPSALESFORCE_Contact
          LEFT JOIN tmpSalesforce_Provider_Degree__c TD2 ON TD2.CONTACT__C = TMPSALESFORCE_CONTACT.ID
          LEFT JOIN tmpSalesforce_Account ON TMPSALESFORCE_CONTACT.ACCOUNTID = tmpSalesforce_Account.ID
                                             AND tmpSalesforce_Account.IN_NETWORK__c = 1
          LEFT JOIN tmpSalesforce_Account_Locations__c ON tmpSalesforce_Account_Locations__c.Account_Name__c = TMPSALESFORCE_ACCOUNT.ID
	     AND tmpSalesforce_Account_Locations__c.Location_Type__c='PRIMARY'
          LEFT JOIN tmpSalesforce_Zip_Code__c ON tmpSalesforce_Account_Locations__c.Zip_Code__c = tmpSalesforce_Zip_Code__c.ID
		  Left Join
		  ( select distinct [tax id] as tax_id,
	UPPER(CAST(STUFF(
                            (
                                SELECT ';'+SPECIALTY
                                FROM (SELECT distinct	  
            UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c, ' ')) AS 'TAX ID',
           UPPER(ISNULL(TMPSALESFORCE_PROVIDER_Specialties__C.Speciality_Name_CAQH__c, ' ')) AS 'SPECIALTY'
	                FROM TMPSALESFORCE_Contact
            LEFT JOIN tmpSalesforce_Account ON TMPSALESFORCE_CONTACT.ACCOUNTID = tmpSalesforce_Account.ID
                                             AND tmpSalesforce_Account.IN_NETWORK__c = 1
          LEFT JOIN TMPSALESFORCE_PROVIDER_Specialties__C ON TMPSALESFORCE_PROVIDER_SPECIALTIES__C.Provider_Name__c = TMPSALESFORCE_CONTACT.ID
                                                             AND Specialtiy_Type__c = 'PRIMARY'
                WHERE tmpSalesforce_Contact.Status__c IN ('ACTIVE')
           AND tmpsalesforce_Contact.Type__c IN('Specialist')
          AND LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST',' CAINTEST')
     AND tmpsalesforce_Account.in_Network__c = '1') tsl
                                WHERE tsl.[TAX ID] = ts2.[tax id] FOR XML PATH('')
                            ), 1, 1, '') AS VARCHAR(100))) AS [SPECIALTY_new] 
					 From (
	SELECT distinct	  
            UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c, ' ')) AS 'TAX ID',
           UPPER(ISNULL(TMPSALESFORCE_PROVIDER_Specialties__C.Speciality_Name_CAQH__c, ' ')) AS 'SPECIALTY'
	                FROM TMPSALESFORCE_Contact
            LEFT JOIN tmpSalesforce_Account ON TMPSALESFORCE_CONTACT.ACCOUNTID = tmpSalesforce_Account.ID
                                             AND tmpSalesforce_Account.IN_NETWORK__c = 1
          LEFT JOIN TMPSALESFORCE_PROVIDER_Specialties__C ON TMPSALESFORCE_PROVIDER_SPECIALTIES__C.Provider_Name__c = TMPSALESFORCE_CONTACT.ID
                                                             AND Specialtiy_Type__c = 'PRIMARY'
                WHERE tmpSalesforce_Contact.Status__c IN ('ACTIVE')
           AND tmpsalesforce_Contact.Type__c IN('Specialist')
          AND LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST','  CAINTEST')
     AND tmpsalesforce_Account.in_Network__c = '1') as ts2) as t on t.tax_id=TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c
          WHERE tmpSalesforce_Contact.Status__c IN ('ACTIVE')
           AND tmpsalesforce_Contact.Type__c IN('Specialist')
          AND LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST','  CAINTEST')
		AND FIRSTNAME NOT IN ('TEST', 'TESTLAST', 'ACETEST','  CAINTEST')
     AND tmpsalesforce_Account.in_Network__c = '1'
	