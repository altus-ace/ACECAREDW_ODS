CREATE VIEW [dbo].[vw_RP_ProviderReferenceTool_HQ]
AS
/* GK: this view uses the SF tmp tables, it should use th pRovider roster, but there is discovery to be done first */
-- Change GK: added Cigna Ma: 8/6/2020
SELECT DISTINCT 
       UPPER(ISNULL(LTRIM(RTRIM(TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c)), ' ')) AS 'TAX_ID', 
       UPPER(ISNULL(LTRIM(RTRIM(TMPSALESFORCE_ACCOUNT.NAME)), ' ')) AS 'PRACTICE_NAME',
       CASE WHEN LTRIM(RTRIM(UPPER(tc1.Health_Plans__c))) = 'UHC' THEN 'X'
		  ELSE ' 'END AS UHC,
       CASE WHEN(LTRIM(RTRIM(UPPER(CAST(STUFF((
		  SELECT ', ' + provider_Client_id__c
		  FROM tmpSalesforce_Provider_Client__c tsccl
		  WHERE tsccl.Provider_Name__c = PC.Provider_Name__c FOR XML PATH('')), 1, 1, '') AS VARCHAR(100)))))) IS NULL THEN '' ELSE 'X'
       END AS 'WELLCARE',
       CASE
           WHEN LTRIM(RTRIM(UPPER(tc2.Health_Plans__c))) = 'AETNA'
           THEN 'X'
           ELSE ' '
       END AS 'AETNA MEDICARE'
	  ,CASE
           WHEN LTRIM(RTRIM(UPPER(tcCignaMa.ProvHealthPlans))) = 'Cigna'
           THEN 'X'
           ELSE ' '
       END AS 'CIGNA MA'
       ,  -- Changed by RH ON 6/28/2019
       --CASE WHEN   ltrim(rtrim(UPPER(tc2.Health_Plans__c))) ='AETNA' THEN 'X' ELSE ' ' END AS AETNA
       CASE
           WHEN LTRIM(RTRIM(UPPER(tc6.Health_Plans__c))) = 'AETNA'
           THEN 'X'
           ELSE ' '
       END AS 'AETNA COMM'
       ,  -- Changed by RH ON 6/28/2019
       CASE
           WHEN LTRIM(RTRIM(UPPER(tc3.Health_Plans__c))) = 'MOLINA'
           THEN 'X'
           ELSE ' '
       END AS MOLINA,
       CASE
           WHEN LTRIM(RTRIM(UPPER(tc5.Health_Plans__c))) = 'IMPERIAL'
           THEN 'X'
           ELSE ' '
       END AS IMPERIAL,
       CASE
           WHEN LTRIM(RTRIM(UPPER(tc7.Health_Plans__c))) = 'DEVOTED'
           THEN 'X'
           ELSE ' '
       END AS DEVOTED,
       CASE
           WHEN LTRIM(RTRIM(UPPER(tc4.Health_Plans__c))) IS NULL
           THEN 'X'
           ELSE ' '
       END AS 'NO CONTRACT', 
       LTRIM(RTRIM(TMPSALESFORCE_ACCOUNT.[Group_NPI_Number__c])) AS 'GROUP_NPI', 
       UPPER(ISNULL(LTRIM(RTRIM(tmpSalesforce_Account.Type__c)), ' ')) AS 'PRACTICE_TYPE', 
       UPPER(ISNULL(LTRIM(RTRIM(SF_Contact.FIRSTNAME)), ' ')) AS 'PROVIDER_FIRST_NAME', 
       UPPER(ISNULL(LTRIM(RTRIM(SF_Contact.LASTNAME)), ' ')) AS 'PROVIDER_LAST_NAME', 
       UPPER(CAST(STUFF((
		  SELECT ', ' + Degree_Name__c
		  FROM tmpSalesforce_Provider_Degree__c td
		  WHERE td.Contact__c = td2.Contact__c FOR XML PATH('')
		  ), 1, 1, '') AS VARCHAR(100))) AS DEGREE, 
       UPPER(ISNULL(SF_Contact.Type__c, ' ')) AS PROVIDER_TYPE, 
       UPPER(ISNULL(SF_Contact.[Provider_CAQH_Number__c], '')) AS 'PROVIDER_CAQH_NUMBER', 
       SF_Contact.PROVIDER_NPI__C AS 'PROVIDER_NPI', 
       LTRIM(RTRIM(UPPER(CAST(STUFF((
    SELECT ', ' + Speciality_Name_CAQH__c
    FROM TMPSALESFORCE_PROVIDER_Specialties__C tssl
    WHERE tssl.Provider_Name__c = TMPSALESFORCE_PROVIDER_Specialties__C.Provider_Name__c FOR XML PATH('')
), 1, 1, '') AS VARCHAR(100))))) AS 'PRIMARY_SPECIALTY', 
       UPPER(ISNULL((LTRIM(RTRIM(tmpSalesforce_Location__c.[Address_1__c])) + ' ' + LTRIM(RTRIM(tmpSalesforce_Location__c.[Address_2__c]))), ' ')) AS 'PROVIDER_PRIMARY_ADDRESS', 
       UPPER(ISNULL(LTRIM(RTRIM(tmpSalesforce_Location__c.City__c)), ' ')) AS 'PRIMARY_CITY', 
       UPPER(ISNULL(LTRIM(RTRIM(tmpSalesforce_Location__c.State__c)), ' ')) AS 'PRIMARY_STATE', 
       UPPER(ISNULL(LTRIM(RTRIM(tmpSalesforce_Zip_Code__c.NAME)), ' ')) AS 'PRIMARY_ZIPCODE', 
       UPPER(ISNULL(LTRIM(RTRIM(tmpsalesforce_zip_code__c.Quadrant__c)), ' ')) AS 'PRIMARY_POD', 
       UPPER(ISNULL(LTRIM(RTRIM(tmpsalesforce_zip_code__c.POD__C)), ' ')) AS 'PRIMARY_QUADRANT', 
       UPPER(ISNULL(LTRIM(RTRIM(SF_Contact.Phone)), ' ')) AS 'PROVIDER_PHONE#', 
       UPPER(ISNULL(LTRIM(RTRIM(SF_Contact.FAX)), ' ')) AS 'PROVIDER_FAX#', 
       UPPER(ISNULL(LTRIM(RTRIM(SF_Contact.Email)), ' ')) AS 'PROVIDER_EMAIL#', 
       LTRIM(RTRIM(UPPER(CAST(STUFF(
(
    SELECT ', ' + Name
    FROM [tmpSalesforce_Additional_Contact__c] tsl
    WHERE tsl.Account_Name__c = [tmpSalesforce_Additional_Contact__c].Account_Name__c FOR XML PATH('')
), 1, 1, '') AS VARCHAR(100))))) AS 'OFFICE_MANAGERS', 
       LTRIM(RTRIM(UPPER(CAST(STUFF(
(
    SELECT ', ' + PHONE_NUMBER__C
    FROM [tmpSalesforce_Additional_Contact__c] tsAl
    WHERE tsAl.Account_Name__c = [tmpSalesforce_Additional_Contact__c].Account_Name__c FOR XML PATH('')
), 1, 1, '') AS VARCHAR(100))))) AS 'OFFICE_MANAGERS_PHONE', 
       LTRIM(RTRIM(UPPER(CAST(STUFF(
(
    SELECT ', ' + Email__c
    FROM [tmpSalesforce_Additional_Contact__c] tscl
    WHERE tscl.Account_Name__c = [tmpSalesforce_Additional_Contact__c].Account_Name__c FOR XML PATH('')
), 1, 1, '') AS VARCHAR(100))))) AS 'OFFICE_MANAGERS_EMAIL', 
       LTRIM(RTRIM(UPPER(tmpSalesforce_Account.[EMR__c]))) AS EMR
-- tmpSalesforce_Contact.Status__c
FROM TMPSALESFORCE_CONTACT SF_Contact
     LEFT JOIN tmpSalesforce_Provider_Degree__c TD2 ON TD2.CONTACT__C = SF_Contact.ID
                                                       AND td2.Degree_Name__c <> '(OTHER)'
                                                       AND td2.Degree_Name__c <> ' '
     LEFT JOIN tmpSalesforce_Account ON SF_Contact.ACCOUNTID = tmpSalesforce_Account.ID
                                        AND tmpSalesforce_Account.IN_NETWORK__c = 1
     LEFT JOIN TMPSALESFORCE_PROVIDER_Specialties__C ON TMPSALESFORCE_PROVIDER_SPECIALTIES__C.Provider_Name__c = SF_Contact.ID
                                                        AND Specialtiy_Type__c = 'PRIMARY'
     LEFT JOIN tmpSalesforce_Location__c ON tmpSalesforce_Location__c.[Provider_Name__c] = SF_Contact.ID
                                            AND tmpSalesforce_Location__c.[Address_Type__c] = 'PRIMARY'
     LEFT JOIN tmpSalesforce_Zip_Code__c ON tmpSalesforce_Location__c.[ZipCode_New__c] = tmpSalesforce_Zip_Code__c.ID
     LEFT JOIN [dbo].[tmpSalesforce_Additional_Contact__c] ON [dbo].[tmpSalesforce_Additional_Contact__c].Account_Name__c = tmpSalesforce_Account.id
                                                              AND [tmpSalesforce_Additional_Contact__c].Title__c LIKE 'Office%'
     
	LEFT JOIN [tmpSalesforce_Contract_Information__c] tc1 ON tc1.Account_Name__c = tmpSalesforce_Account.Id
                                                              AND tc1.Health_Plans__c = 'UHC'
     LEFT JOIN [tmpSalesforce_Contract_Information__c] tc2 ON tc2.Account_Name__c = tmpSalesforce_Account.Id
                                                              AND tc2.Health_Plans__c = 'AETNA'
                                                              AND tc2.[Line_of_Business__c] IN('Medicare', 'Medicare Advantage')   -- Changed by RH ON 6/28/2019
     LEFT JOIN [tmpSalesforce_Contract_Information__c] tc6 ON tc6.Account_Name__c = tmpSalesforce_Account.Id
                                                              AND tc6.Health_Plans__c = 'AETNA'
                                                              AND tc6.[Line_of_Business__c] = 'Commercial'   -- Changed by RH ON 6/28/2019
     LEFT JOIN [tmpSalesforce_Contract_Information__c] tc3 ON tc3.Account_Name__c = tmpSalesforce_Account.Id
                                                              AND tc3.Health_Plans__c = 'MOLINA'
     LEFT JOIN [tmpSalesforce_Contract_Information__c] tc4 ON tc4.Account_Name__c = tmpSalesforce_Account.Id
     LEFT JOIN [tmpSalesforce_Contract_Information__c] tc5 ON tc5.Account_Name__c = tmpSalesforce_Account.Id
                                                              AND tc5.Health_Plans__c = 'IMPERIAL'
     LEFT JOIN [tmpSalesforce_Contract_Information__c] tc7 ON tc7.Account_Name__c = tmpSalesforce_Account.Id
                                                              AND tc7.Health_Plans__c = 'Devoted' -- added by RA 02/12/2020
	LEFT JOIN [tmpSalesforce_Provider_Client__c] tcCignaMa ON tcCignaMa.Provider_Name__c = SF_Contact.Id 	   
												  and RTRIM(LTRIM(tcCignaMa.ProvHealthPlans))='Cigna'	
												  AND tcCignaMa.Line_of_Business__c = 'Medicare Advantage'												  
												  --AND tcCignaMa.provider_Client_id__c <> '' WE do not know what this field is, but is null for all cigna values.
												  AND tcCignaMa.term_date__c = ' '
     LEFT JOIN tmpSalesforce_Provider_Client__c pc ON pc.Provider_Name__c = SF_Contact.id
                                                      AND PC.term_date__c = ' '
                                                      AND PC.provHealthplans = 'Wellcare'
                                                      AND PC.provider_Client_id__c <> ''
WHERE SF_Contact.Status__c = 'Active'
    AND SF_Contact.Type__c NOT IN('UHC PCP')
    AND LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST')
    AND TMPSALESFORCE_ACCOUNT.NAME NOT LIKE '%TEST%';


