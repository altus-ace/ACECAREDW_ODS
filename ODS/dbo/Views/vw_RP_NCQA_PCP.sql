



CREATE VIEW [dbo].[vw_RP_NCQA_PCP]
AS

SELECT DISTINCT
		 UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.NAME, ' ')) AS 'PRACTICE NAME',
       UPPER(ISNULL(tmpSalesforce_Account_Locations__c.NAME, ' ')) AS 'PRACTICE SITE NAME',
       UPPER(ISNULL(t.SPECIALTY_new, ' ')) AS 'PROVIDER FACILITY SPECIALTY',
	  UPPER(ISNULL(tmpSalesforce_Account_Locations__c.Location_Type__c,'')) AS 'ADDRESS TYPE',
       UPPER(ISNULL((tmpSalesforce_Account_Locations__c.Address_1__c), ' ')) AS 'ADDRESS 1',
       UPPER(ISNULL((tmpSalesforce_Account_Locations__c.Address_2__c), ' ')) AS 'ADDRESS 2',
       UPPER(ISNULL(tmpSalesforce_Account_Locations__c.City__c, ' ')) AS 'CITY',
       UPPER(ISNULL(tmpSalesforce_Account_Locations__c.State__c, ' ')) AS ' STATE',
       UPPER(ISNULL(tmpSalesforce_Zip_Code__c.NAME, ' ')) AS 'ZIPCODE',
	  UPPER(ISNULL(tmpSalesforce_Account.Main_Contact__c, ' ')) AS 'CONTACT FIRST AND LAST NAME',
       UPPER(ISNULL(tmpSalesforce_Account_LocationS__C.Phone__c, ' ')) AS 'PHONE NUMBER',
       UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c, ' ')) AS 'TAX ID',
       '' AS 'NCQA PCMH RECOGNITION?(SELECT YES OR NO)',
       '' AS 'MEDICAL HOME PROGRAM & RECOGNITION LEVEL (SELECT FROM LIST):',
       '' AS 'IF RECOGNIZED, EXPIRATION DATE(XX/XX/XX)',
	 case when tmpSalesforce_Account_Locations__c.Location_Type__c='PRIMARY' then  AM.N  else 0 end AS 'LIST THE NUMBER OF PATIENTS THAT ARE SEEN AT THIS PRACTICE',
	  UPPER(ISNULL(tmpSalesforce_Zip_Code__c.quadrant__c, ' ')) AS 'POD',
	  UPPER(ISNULL(tmpSalesforce_Contract_Information__c.Line_of_Business__c, ' ')) AS 'LOB',
	  '' as 'PANEL(OPEN/CLOSE)',
	  '' AS 'PATIENT AGE GROUP(ACCEPTED)',
	  ' ' AS COMMENTS
FROM TMPSALESFORCE_Contact
     LEFT JOIN tmpSalesforce_Provider_Degree__c TD2 ON TD2.CONTACT__C = TMPSALESFORCE_CONTACT.ID
     LEFT JOIN tmpSalesforce_Account ON TMPSALESFORCE_CONTACT.ACCOUNTID = tmpSalesforce_Account.ID
                                        AND tmpSalesforce_Account.IN_NETWORK__c = 1
     LEFT JOIN tmpSalesforce_Account_Locations__c ON tmpSalesforce_Account_Locations__c.Account_Name__c = TMPSALESFORCE_ACCOUNT.ID
	--	 AND tmpSalesforce_Account_Locations__c.Location_Type__c='PRIMARY'
     LEFT JOIN tmpSalesforce_Zip_Code__c ON tmpSalesforce_Account_Locations__c.Zip_Code__c = tmpSalesforce_Zip_Code__c.ID
	Left Join tmpSalesforce_Contract_Information__c  on tmpSalesforce_Contract_Information__c.Account_Name__c=TMPSALESFORCE_Contact.ACCOUNTID
	and tmpSalesforce_Contract_Information__c.Health_Plans__c='UHC'
   
	 JOIN
(
    SELECT DISTINCT
           [tax id] AS tax_id,
           UPPER(CAST(STUFF(
                           (
                               SELECT ';'+SPECIALTY
                               FROM
                               (
                                   SELECT DISTINCT
                                          UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c, ' ')) AS 'TAX ID',
                                          UPPER(ISNULL(TMPSALESFORCE_PROVIDER_Specialties__C.Speciality_Name_CAQH__c, ' ')) AS 'SPECIALTY'
                                   FROM TMPSALESFORCE_Contact
                                        LEFT JOIN tmpSalesforce_Account ON TMPSALESFORCE_CONTACT.ACCOUNTID = tmpSalesforce_Account.ID
                                                                           AND tmpSalesforce_Account.IN_NETWORK__c = 1
                                        LEFT JOIN TMPSALESFORCE_PROVIDER_Specialties__C ON TMPSALESFORCE_PROVIDER_SPECIALTIES__C.Provider_Name__c = TMPSALESFORCE_CONTACT.ID
                                                                                           AND Specialtiy_Type__c = 'PRIMARY'
                                   WHERE tmpSalesforce_Contact.Status__c IN('ACTIVE')
                                        AND tmpsalesforce_Contact.Type__c IN('PCP')
                                   AND LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST')
                               AND tmpsalesforce_Account.in_Network__c = '1'
                               ) tsl
                               WHERE tsl.[TAX ID] = ts2.[tax id] FOR XML PATH('')
                           ), 1, 1, '') AS VARCHAR(100))) AS [SPECIALTY_new]
    FROM
    (
        SELECT DISTINCT
               UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c, ' ')) AS 'TAX ID',
               UPPER(ISNULL(TMPSALESFORCE_PROVIDER_Specialties__C.Speciality_Name_CAQH__c, ' ')) AS 'SPECIALTY'
        FROM TMPSALESFORCE_Contact
             LEFT JOIN tmpSalesforce_Account ON TMPSALESFORCE_CONTACT.ACCOUNTID = tmpSalesforce_Account.ID
                                                AND tmpSalesforce_Account.IN_NETWORK__c = 1
             LEFT JOIN TMPSALESFORCE_PROVIDER_Specialties__C ON TMPSALESFORCE_PROVIDER_SPECIALTIES__C.Provider_Name__c = TMPSALESFORCE_CONTACT.ID
                                                                AND Specialtiy_Type__c = 'PRIMARY'
        WHERE tmpSalesforce_Contact.Status__c IN('ACTIVE')
             AND tmpsalesforce_Contact.Type__c IN('PCP')
        AND LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST')
    AND tmpsalesforce_Account.in_Network__c = '1'
    ) AS ts2
) AS t ON t.tax_id = TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c
     left JOIN
(
    SELECT COUNT(V.N) AS N,
           V.PCP_PRACTICE_TIN
    FROM
    (
        SELECT 1 AS N,
               PCP_PRACTICE_TIN
        FROM vw_UHC_ActiveMembers
    ) AS V
    GROUP BY V.N,
             V.PCP_PRACTICE_TIN
) AS AM ON CONVERT(INT, AM.PCP_PRACTICE_TIN) = CONVERT(INT, TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c)
WHERE tmpSalesforce_Contact.Status__c IN('ACTIVE')
		--AND TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c IN ('432109907')
AND tmpsalesforce_Contact.Type__c IN('PCP')
AND LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST')
AND tmpsalesforce_Account.in_Network__c = '1';

