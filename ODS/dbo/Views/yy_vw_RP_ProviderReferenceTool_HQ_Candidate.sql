
CREATE VIEW [dbo].[yy_vw_RP_ProviderReferenceTool_HQ_Candidate]
AS
/* 09/04: GK: This is now the provider refernce tool. the other version was decommisioned.
	   1. change all SF table to use ProviderRoster where possible
    8/19: GK: this view uses the SF tmp tables, it should use th pRovider roster, but there is discovery to be done first */
-- Change GK: added Cigna Ma: 8/6/2020
SELECT DISTINCT 
       UPPER(ISNULL(LTRIM(RTRIM(SF_Account.Tax_ID_Number__c)), ' ')) AS 'TAX_ID', 
       UPPER(ISNULL(LTRIM(RTRIM(SF_Account.NAME)), ' ')) AS 'PRACTICE_NAME',
       CASE WHEN LTRIM(RTRIM(UPPER(tcUhc.ProvHealthPlans))) = 'UHC' THEN 'X'
		  ELSE ' 'END AS UHC,
       CASE WHEN(LTRIM(RTRIM(UPPER(CAST(STUFF((
		  SELECT ', ' + provider_Client_id__c
		  FROM tmpSalesforce_Provider_Client__c tsccl
		  WHERE tsccl.Provider_Name__c = tcWlc.Provider_Name__c FOR XML PATH('')), 1, 1, '') AS VARCHAR(100)))))) IS NULL THEN '' ELSE 'X'
       END AS 'WELLCARE',
       CASE
           WHEN LTRIM(RTRIM(UPPER(tcAetnaMa.ProvHealthPlans))) = 'AETNA'
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
           WHEN LTRIM(RTRIM(UPPER(tcAetnaCom.ProvHealthPlans))) = 'AETNA'
           THEN 'X'
           ELSE ' '
       END AS 'AETNA COMM'
       ,  -- Changed by RH ON 6/28/2019
       CASE
           WHEN LTRIM(RTRIM(UPPER(tcMolina.ProvHealthPlans))) = 'MOLINA'
           THEN 'X'
           ELSE ' '
       END AS MOLINA,
       CASE
           WHEN LTRIM(RTRIM(UPPER(tcImperial.ProvHealthPlans))) = 'IMPERIAL'
           THEN 'X'
           ELSE ' '
       END AS IMPERIAL,
       CASE
           WHEN LTRIM(RTRIM(UPPER(tcDevoted.ProvHealthPlans))) = 'DEVOTED'
           THEN 'X'
           ELSE ' '
       END AS DEVOTED,
       CASE
           WHEN LTRIM(RTRIM(UPPER(tc4.ProvHealthPlans))) IS NULL
           THEN 'X'
           ELSE ' '
       END AS 'NO CONTRACT', 
       LTRIM(RTRIM(SF_Account.[Group_NPI_Number__c])) AS 'GROUP_NPI', 
       UPPER(ISNULL(LTRIM(RTRIM(SF_Account.Type__c)), ' ')) AS 'PRACTICE_TYPE', 
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
       LTRIM(RTRIM(UPPER(CAST(STUFF((
			 SELECT ', ' + Name
			 FROM [tmpSalesforce_Additional_Contact__c] tsl
			 WHERE tsl.Account_Name__c = SF_AddContact.Account_Name__c FOR XML PATH('')
		  ), 1, 1, '') AS VARCHAR(100))))) AS 'OFFICE_MANAGERS', 
       LTRIM(RTRIM(UPPER(CAST(STUFF((
			 SELECT ', ' + PHONE_NUMBER__C
			 FROM dbo.[tmpSalesforce_Additional_Contact__c] tsAl
			 WHERE tsAl.Account_Name__c = SF_AddContact.Account_Name__c FOR XML PATH('')
		  ), 1, 1, '') AS VARCHAR(100))))) AS 'OFFICE_MANAGERS_PHONE', 
       LTRIM(RTRIM(UPPER(CAST(STUFF((
			 SELECT ', ' + Email__c
			 FROM dbo.[tmpSalesforce_Additional_Contact__c] tscl
			 WHERE tscl.Account_Name__c = SF_AddContact.Account_Name__c FOR XML PATH('')
		  ), 1, 1, '') AS VARCHAR(100))))) AS 'OFFICE_MANAGERS_EMAIL', 
       LTRIM(RTRIM(UPPER(SF_Account.[EMR__c]))) AS EMR	  
-- tmpSalesforce_Contact.Status__c
FROM dbo.vw_AllClient_ProviderRoster ProvRost
    JOIN  TMPSALESFORCE_CONTACT SF_Contact ON ProvRost.NPI = SF_Contact.Provider_NPI__c 
     LEFT JOIN tmpSalesforce_Provider_Degree__c TD2 ON TD2.CONTACT__C = SF_Contact.ID
                                                       AND td2.Degree_Name__c <> '(OTHER)'
                                                       AND td2.Degree_Name__c <> ' '
     LEFT JOIN tmpSalesforce_Account SF_Account ON SF_Contact.ACCOUNTID = SF_Account.ID
                                        AND SF_Account.IN_NETWORK__c = 1
     LEFT JOIN TMPSALESFORCE_PROVIDER_Specialties__C ON TMPSALESFORCE_PROVIDER_SPECIALTIES__C.Provider_Name__c = SF_Contact.ID
                                                        AND Specialtiy_Type__c = 'PRIMARY'
     LEFT JOIN tmpSalesforce_Location__c ON tmpSalesforce_Location__c.[Provider_Name__c] = SF_Contact.ID
                                            AND tmpSalesforce_Location__c.[Address_Type__c] = 'PRIMARY'
     LEFT JOIN tmpSalesforce_Zip_Code__c ON tmpSalesforce_Location__c.[ZipCode_New__c] = tmpSalesforce_Zip_Code__c.ID
     LEFT JOIN [dbo].[tmpSalesforce_Additional_Contact__c] SF_AddContact ON SF_AddContact.Account_Name__c = SF_Account.id
                                                              AND SF_AddContact.Title__c LIKE 'Office%'
     
	LEFT JOIN dbo.tmpSalesforce_Provider_Client__c tcUhc ON tcUhc.Provider_Name__c = SF_Contact.Id
                                                              and RTRIM(LTRIM(tcUhc.ProvHealthPlans))='UHC'
												  AND tcUhc.term_date__c = ' '
     LEFT JOIN dbo.tmpSalesforce_Provider_Client__c tcAetnaMa ON tcAetnaMa.Provider_Name__c = SF_Contact.Id
                                                              AND tcAetnaMa.ProvHealthPlans = 'AETNA'
                                                              AND tcAetnaMa.[Line_of_Business__c] IN('Medicare', 'Medicare Advantage')   -- Changed by RH ON 6/28/2019
     LEFT JOIN  dbo.tmpSalesforce_Provider_Client__c tcAetnaCom ON tcAetnaCom.Provider_Name__c = SF_Contact.Id
                                                              AND tcAetnaCom.ProvHealthPlans= 'AETNA'
                                                              AND tcAetnaCom.[Line_of_Business__c] = 'Commercial'   -- Changed by RH ON 6/28/2019
     LEFT JOIN dbo.tmpSalesforce_Provider_Client__c tcMolina ON tcMolina.Provider_Name__c = SF_Contact.Id
                                                              AND tcMolina.ProvHealthPlans = 'MOLINA'
     LEFT JOIN  dbo.tmpSalesforce_Provider_Client__c tc4 ON tc4.Provider_Name__c = SF_Contact.Id
     LEFT JOIN  dbo.tmpSalesforce_Provider_Client__c tcImperial ON tcImperial.Provider_Name__c = SF_Contact.Id
                                                              AND tcImperial.ProvHealthPlans = 'IMPERIAL'
     LEFT JOIN  dbo.tmpSalesforce_Provider_Client__c tcDevoted ON tcDevoted.Provider_Name__c = SF_Contact.Id
                                                              AND tcDevoted.ProvHealthPlans = 'Devoted' -- added by RA 02/12/2020
	LEFT JOIN dbo.[tmpSalesforce_Provider_Client__c] tcCignaMa ON tcCignaMa.Provider_Name__c = SF_Contact.Id 	   
												  and RTRIM(LTRIM(tcCignaMa.ProvHealthPlans))='Cigna'	
												  AND tcCignaMa.Line_of_Business__c = 'Medicare Advantage'												  
												  --AND tcCignaMa.provider_Client_id__c <> '' WE do not know what this field is, but is null for all cigna values.
												  AND tcCignaMa.term_date__c = ' '
     LEFT JOIN dbo.tmpSalesforce_Provider_Client__c tcWlc ON tcWlc.Provider_Name__c = SF_Contact.id
                                                      AND tcWlc.term_date__c = ' '
                                                      AND tcWlc.provHealthplans = 'Wellcare'
                                                      AND tcWlc.provider_Client_id__c <> ''
WHERE SF_Contact.Status__c = 'Active'
    AND SF_Contact.Type__c NOT IN('UHC PCP')
    AND SF_Contact.LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST')
    AND SF_Account.NAME NOT LIKE '%TEST%';


