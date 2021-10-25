
CREATE VIEW [dbo].[vw_AlliedHealthProfessionals]
AS
     SELECT DISTINCT
            TMPSALESFORCE_CONTACT.PROVIDER_NPI__C AS 'NPI',
		  RTRIM(TMPSALESFORCE_CONTACT.Provider_CAQH_Number__c) AS 'CAQH NUMBER',
		  RTRIM(TMPSALESFORCE_CONTACT.Type__c) AS 'PROVIDER TYPE',
            UPPER(ISNULL(TMPSALESFORCE_CONTACT.LASTNAME, ' ')) AS 'LAST NAME',
            UPPER(ISNULL(TMPSALESFORCE_CONTACT.FIRSTNAME, ' ')) AS 'FIRST NAME',
            UPPER(ISNULL(UPPER(CAST(STUFF(
                                         (
                                             SELECT ','+RTRIM(DEGREE_NAME__C)
                                             FROM tmpSalesforce_Provider_Degree__c TD
                                             WHERE TD.CONTACT__C = TD2.CONTACT__C
                                                   AND TD.DEGREE_NAME__C NOT IN('(OTHER)', ' ') FOR XML PATH('')
                                         ), 1, 1, '') AS VARCHAR(100))), ' ')) AS DEGREE,
            UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c, ' ')) AS 'TAX ID',
            UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.NAME, ' ')) AS 'GROUP NAME',
            UPPER(ISNULL((tmpSalesforce_Account_Locations__c.Address_1__c+' '+tmpSalesforce_Account_Locations__c.Address_2__c), ' ')) AS 'PRIMARY ADDRESS',
            UPPER(ISNULL(tmpSalesforce_Account_Locations__c.City__c, ' ')) AS 'PRIMARY CITY',
            UPPER(ISNULL(tmpSalesforce_Account_Locations__c.State__c, ' ')) AS 'PRIMARY STATE',
            UPPER(ISNULL(tmpSalesforce_Zip_Code__c.NAME, ' ')) AS 'PRIMARY ZIPCODE',
            UPPER(ISNULL(tmpsalesforce_zip_code__c.Quadrant__c, ' ')) AS 'PRIMARY POD',
            UPPER(ISNULL(tmpSalesforce_Account_LocationS__C.Phone__c, ' ')) AS 'PRIMARY ADDRESS PHONE#'
            FROM TMPSALESFORCE_CONTACT
          LEFT JOIN tmpSalesforce_Provider_Degree__c TD2 ON TD2.CONTACT__C = TMPSALESFORCE_CONTACT.ID
          LEFT JOIN tmpSalesforce_Account ON TMPSALESFORCE_CONTACT.ACCOUNTID = tmpSalesforce_Account.ID
                                             AND tmpSalesforce_Account.IN_NETWORK__c = 1
          LEFT JOIN tmpSalesforce_Account_Locations__c ON tmpSalesforce_Account_Locations__c.Account_Name__c = TMPSALESFORCE_ACCOUNT.ID
                                                          AND tmpSalesforce_Account_Locations__c.Location_Type__c = 'PRIMARY'
         LEFT JOIN tmpSalesforce_Zip_Code__c ON tmpSalesforce_Account_Locations__c.Zip_Code__c = tmpSalesforce_Zip_Code__c.ID
         WHERE tmpSalesforce_Contact.Status__c IS NULL
           AND tmpsalesforce_Contact.Type__c IN('FNP', 'NP', 'PA', 'Allied Health')
          AND LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST')
     AND tmpsalesforce_Account.in_Network__c = '1'
     UNION
     SELECT DISTINCT
            TMPSALESFORCE_CONTACT.PROVIDER_NPI__C AS 'NPI',
		  RTRIM(TMPSALESFORCE_CONTACT.Provider_CAQH_Number__c) AS 'CAQH NUMBER',
		  RTRIM(TMPSALESFORCE_CONTACT.Type__c) AS 'PROVIDER TYPE',
            UPPER(ISNULL(TMPSALESFORCE_CONTACT.LASTNAME, ' ')) AS 'LAST NAME',
            UPPER(ISNULL(TMPSALESFORCE_CONTACT.FIRSTNAME, ' ')) AS 'FIRST NAME',
            UPPER(ISNULL(UPPER(CAST(STUFF(
                                         (
                                             SELECT ','+RTRIM(DEGREE_NAME__C)
                                             FROM tmpSalesforce_Provider_Degree__c TD
                                             WHERE TD.CONTACT__C = TD2.CONTACT__C
                                                   AND TD.DEGREE_NAME__C NOT IN('(OTHER)', ' ') FOR XML PATH('')
                                         ), 1, 1, '') AS VARCHAR(100))), ' ')) AS DEGREE,
            UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c, ' ')) AS 'TAX ID',
            UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.NAME, ' ')) AS 'GROUP NAME',
            UPPER(ISNULL((tmpSalesforce_Account_Locations__c.Address_1__c+' '+tmpSalesforce_Account_Locations__c.Address_2__c), ' ')) AS 'PRIMARY ADDRESS',
            UPPER(ISNULL(tmpSalesforce_Account_Locations__c.City__c, ' ')) AS 'PRIMARY CITY',
            UPPER(ISNULL(tmpSalesforce_Account_Locations__c.State__c, ' ')) AS 'PRIMARY STATE',
            UPPER(ISNULL(tmpSalesforce_Zip_Code__c.NAME, ' ')) AS 'PRIMARY ZIPCODE',
            UPPER(ISNULL(tmpsalesforce_zip_code__c.Quadrant__c, ' ')) AS 'PRIMARY POD',
            UPPER(ISNULL(tmpSalesforce_Account_LocationS__C.Phone__c, ' ')) AS 'PRIMARY ADDRESS PHONE#'
              FROM TMPSALESFORCE_CONTACT
          LEFT JOIN tmpSalesforce_Provider_Degree__c TD2 ON TD2.CONTACT__C = TMPSALESFORCE_CONTACT.ID
          LEFT JOIN tmpSalesforce_Account ON TMPSALESFORCE_CONTACT.ACCOUNTID = tmpSalesforce_Account.ID
                                             AND tmpSalesforce_Account.IN_NETWORK__c = 1
          LEFT JOIN tmpSalesforce_Account_Locations__c ON tmpSalesforce_Account_Locations__c.Account_Name__c = TMPSALESFORCE_ACCOUNT.ID
                                                          AND tmpSalesforce_Account_Locations__c.Location_Type__c = 'PRIMARY'
          LEFT JOIN tmpSalesforce_Zip_Code__c ON tmpSalesforce_Account_Locations__c.Zip_Code__c = tmpSalesforce_Zip_Code__c.ID
           WHERE tmpSalesforce_Contact.Status__c IN('Active')
          AND tmpsalesforce_Contact.Type__c IN('FNP', 'NP', 'PA', 'Allied Health')
AND LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST')
AND tmpsalesforce_Account.in_Network__c = '1';

