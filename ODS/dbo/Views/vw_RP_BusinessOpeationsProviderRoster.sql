create view vw_RP_BusinessOpeationsProviderRoster
as
SELECT DISTINCT
       TMPSALESFORCE_CONTACT.PROVIDER_NPI__C AS 'NPI',
       LTRIM(RTRIM(UPPER(ISNULL(TMPSALESFORCE_CONTACT.FIRSTNAME, ' '))))+' '+LTRIM(RTRIM(UPPER(ISNULL(TMPSALESFORCE_CONTACT.LASTNAME, ' ')))) AS 'PHYSICIAN_NAME',
       LTRIM(RTRIM(tmpsalesforce_Contact.Type__c)) AS 'PCP/SPCIALTY',
       LTRIM(RTRIM(UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c, ' ')))) AS 'TAX_ID',
       LTRIM(RTRIM(UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.NAME, ' ')))) AS 'PRACTICE_NAME',
	  TMPSALESFORCE_CONTACT.Provider_CAQH_Number__c AS 'CAQH_NUMBER',
       UPPER(CAST(STUFF(
(
    SELECT ';'+TSL.Speciality_Name_CAQH__c
    FROM tmpSalesforce_Provider_Specialties__c tsl
    WHERE tsl.Provider_Name__c = TMPSALESFORCE_PROVIDER_Specialties__C.Provider_Name__c FOR XML PATH('')
), 1, 1, '') AS VARCHAR(100))) AS [PHYSICIAN_SPECIALTY],
       LTRIM(RTRIM(UPPER(ISNULL(TMPSALESFORCE_CONTACT.Date_of_Birth__c, ' ')))) AS 'PROVIDER_DOB',
       LTRIM(RTRIM(UPPER(ISNULL(TMPSALESFORCE_CONTACT.GENDER__c, ' ')))) AS 'PROVIDER_GENDER',
       LTRIM(RTRIM(UPPER(ISNULL(TMPSALESFORCE_CONTACT.Provider_Social_Security_Number__c, ' ')))) AS 'PROVIDER_SSN',
	      LTRIM(RTRIM(UPPER(ISNULL(TMPSALESFORCE_CONTACT.Phone, ' ')))) AS 'PROVIDER_PHONE#',
       LTRIM(RTRIM(UPPER(ISNULL(TMPSALESFORCE_CONTACT.FAX, ' ')))) AS 'PROVIDER FAX#',
       LTRIM(RTRIM(UPPER(ISNULL(TMPSALESFORCE_CONTACT.Email, ' ')))) AS 'PROVIDER EMAIL#',
       LTRIM(RTRIM(UPPER(ISNULL((LTRIM(RTRIM(tmpSalesforce_Location__c.[Address_1__c]))+' '+LTRIM(RTRIM(tmpSalesforce_Location__c.[Address_2__c]))), ' ')))) AS 'PRIMARY_OFFICE_ADDRESS',
       LTRIM(RTRIM(UPPER(ISNULL(tmpSalesforce_Location__c.City__c, ' ')))) AS 'PRIMARY_CITY',
       LTRIM(RTRIM(UPPER(ISNULL(tmpSalesforce_Location__c.State__c, ' ')))) AS 'PRIMARY_STATE',
       LTRIM(RTRIM(UPPER(ISNULL(tmpSalesforce_Zip_Code__c.NAME, ' ')))) AS 'PRIMARY_ZIPCODE',
       LTRIM(RTRIM(UPPER(ISNULL(tmpsalesforce_zip_code__c.Quadrant__c, ' ')))) AS 'PRIMARY_POD',
       tmpSalesforce_Location__c.Phone__c AS PRIMARY_LOCATION_PHONE,
       LTRIM(RTRIM(UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.Main_Contact__c, ' ')))) AS 'CONTACT_PERSON',
       LTRIM(RTRIM(UPPER(ISNULL((LTRIM(RTRIM(TLC.[Address_1__c]))+' '+LTRIM(RTRIM(TLC.[Address_2__c]))), ' ')))) AS 'SECONDARY_OFFICE_ADDRESS',
       LTRIM(RTRIM(UPPER(ISNULL(TLC.City__c, ' ')))) AS 'SECONDARY_CITY',
       LTRIM(RTRIM(UPPER(ISNULL(TLC.State__c, ' ')))) AS 'SECONDARY_STATE',
       LTRIM(RTRIM(UPPER(ISNULL(TZ.NAME, ' ')))) AS 'SECONDARY_ZIPCODE',
       LTRIM(RTRIM(UPPER(ISNULL(TZ.Quadrant__c, ' ')))) AS 'SECONDARY_POD',
       TMPSALESFORCE_ACCOUNT.[Group_NPI_Number__c] AS 'GROUP_NPI',
       UPPER(CAST(STUFF(
(
    SELECT ';'+TD2.DEGREE_NAME__c
    FROM tmpSalesforce_Provider_Degree__c TD2
    WHERE TD2.CONTACT__c = D.CONTACT__c FOR XML PATH('')
), 1, 1, '') AS VARCHAR(100))) AS PROVIDER_DEGREE,
       UPPER(CAST(STUFF(
(
    SELECT ';'+PM1.Medical_License__c
    FROM tmpSalesforce_Provider_Medical_License__c pm1
    WHERE  pm1.Provider_Name__c = PML.Provider_Name__c FOR XML PATH('')
), 1, 1, '') AS VARCHAR(100))) AS PROVIDER_LICENSES,
       UPPER(CAST(STUFF(
(
    SELECT ';'+CONVERT(NVARCHAR,CONVERT(DATE,PM3.EXPIRATION_DATE__C))
    FROM tmpSalesforce_Provider_Medical_License__c pm3
    WHERE pm3.Provider_Name__c = PML.Provider_Name__c FOR XML PATH('')
), 1, 1, '') AS VARCHAR(100))) AS LICENSE_EXPIRATION_DATE,
       UPPER(CAST(STUFF(
(
    SELECT ';'+DEA1.DEA_NUMBER__c
    FROM tmpSalesforce_Provider_DEA_License__c DEA1
    WHERE   DEA1.Provider_Name__c = DEA.Provider_Name__c FOR XML PATH('')
), 1, 1, '') AS VARCHAR(100))) AS DEA_LICENSES,
       UPPER(CAST(STUFF(
(
    SELECT ';'+CONVERT(NVARCHAR,CONVERT(DATE,DEA2.DEA_EXPIRATION_DATE__C))
    FROM tmpSalesforce_Provider_DEA_License__c DEA2
    WHERE DEA2.Provider_Name__c = DEA.Provider_Name__c FOR XML PATH('')
), 1, 1, '') AS VARCHAR(100))) AS DEA_EXPIRATION_DATE,
       
       UPPER(CAST(STUFF(
(
    SELECT ';'+P1.MEDICARE_NUMBER__c
    FROM tmpSalesforce_Provider_Medicare_Licenses__c P1
    WHERE P1.Provider_Name__c = PMED.Provider_Name__c FOR XML PATH('')
), 1, 1, '') AS VARCHAR(100))) AS MEDICARE_ID,
       UPPER(CAST(STUFF(
(
    SELECT ';'+P2.medicaid_number__C
    FROM tmpSalesforce_Provider_Medicaid_License__c P2
    WHERE P2.Provider_Name__c = PM2.Provider_Name__c FOR XML PATH('')
), 1, 1, '') AS VARCHAR(100))) AS MEDICAID_ID,

	      UPPER(CAST(STUFF(
(
    SELECT ';'+PTI2.Insurance_Name__c
    FROM tmpSalesforce_Provider_Insurance__c PTI2
    WHERE PTI2.Provider_Name__c = TPI.Provider_Name__c FOR XML PATH('')
), 1, 1, '') AS VARCHAR(100))) AS MALPRACTICE_COVERAGE,
'' AS LIMITS_OF_LIABILITY,
'' AS MALPRACTICE_EXPIRATION_DATE,
	     UPPER(CAST(STUFF(
(
    SELECT ';'+PTI2.Policy_Number__c
    FROM tmpSalesforce_Provider_Insurance__c PTI2
    WHERE PTI2.Provider_Name__c = TPI.Provider_Name__c FOR XML PATH('')
), 1, 1, '') AS VARCHAR(100))) AS MALPRACTICE_POLICY#,
       UPPER(CAST(STUFF(
(
    SELECT ';'+TBC2.Board__c
    FROM tmpSalesforce_Provider_Boards_Certifications__c TBC2
    WHERE TBC2.Provider_Name__c = TBC.Provider_Name__c FOR XML PATH('')
), 1, 1, '') AS VARCHAR(100))) AS BOARD_CERTIFICATION,
       UPPER(CAST(STUFF(
(
    SELECT ';'+CONVERT(VARCHAR, CONVERT(DATE, TBC2.Certification_Date__c))
    FROM tmpSalesforce_Provider_Boards_Certifications__c TBC2
    WHERE TBC2.Provider_Name__c = TBC.Provider_Name__c FOR XML PATH('')
), 1, 1, '') AS VARCHAR(100))) AS BOARD_CERTIFICATION_ISSUE_DATE,
'' AS 'MEDICAL_SCHOOL',
'' AS 'RESIDENCY_TYPE',
'' AS 'FELLOWSHIP_TYPE',
'' AS 'FELLOWSHIP_DURATION',
    UPPER(CAST(STUFF(
(
    SELECT ';'+ TL1.LANGUAGE_NAME__c
    FROM tmpSalesforce_Provider_Language_Spoken__c TL1
    WHERE TL1.Provider_Name__c = L.Provider_Name__c FOR XML PATH('')
), 1, 1, '') AS VARCHAR(100))) AS PROVIDER_LANGUAGE,
   '' AS LANGUAGE_OFFICE,
   '' AS HOSPITAL_WHERE_PRIVILEGED

FROM TMPSALESFORCE_CONTACT
     LEFT JOIN tmpSalesforce_Provider_Degree__c TD2 ON TD2.CONTACT__C = TMPSALESFORCE_CONTACT.ID
     LEFT JOIN tmpSalesforce_Account ON TMPSALESFORCE_CONTACT.ACCOUNTID = tmpSalesforce_Account.ID
                                        AND tmpSalesforce_Account.IN_NETWORK__c = 1
     LEFT JOIN TMPSALESFORCE_PROVIDER_Specialties__C ON TMPSALESFORCE_PROVIDER_SPECIALTIES__C.Provider_Name__c = TMPSALESFORCE_CONTACT.ID
                                                        AND Specialtiy_Type__c = 'PRIMARY'
     LEFT JOIN tmpSalesforce_Location__c ON tmpSalesforce_Location__c.[Provider_Name__c] = TMPSALESFORCE_CONTACT.ID
                                            AND tmpSalesforce_Location__c.[Address_Type__c] = 'PRIMARY'
     LEFT JOIN tmpSalesforce_Location__c tlc ON tlc.[Provider_Name__c] = TMPSALESFORCE_CONTACT.ID
                                                AND tlc.[Address_Type__c] = 'SECONDARY'
     LEFT JOIN tmpSalesforce_Zip_Code__c ON tmpSalesforce_Location__c.[ZipCode_New__c] = tmpSalesforce_Zip_Code__c.ID
     LEFT JOIN tmpSalesforce_Zip_Code__c TZ ON TLC.[ZipCode_New__c] = TZ.ID
     LEFT JOIN tmpSalesforce_Provider_DEA_License__c DEA ON DEA.PROVIDER_NAME__c = TMPSALESFORCE_CONTACT.id 
     LEFT JOIN tmpSalesforce_Provider_Medical_License__c PML ON PML.PROVIDER_NAME__c = TMPSALESFORCE_CONTACT.id   
     LEFT JOIN tmpSalesforce_Provider_Medicare_Licenses__c PMED ON PMED.PROVIDER_NAME__c = TMPSALESFORCE_CONTACT.id
     LEFT JOIN tmpSalesforce_Provider_Medicaid_License__c PM2 ON PM2.PROVIDER_NAME__c = TMPSALESFORCE_CONTACT.id
     LEFT JOIN tmpSalesforce_Provider_Boards_Certifications__c tbc ON tbc.Provider_name__C = TMPSALESFORCE_CONTACT.id
     LEFT JOIN tmpSalesforce_Provider_Degree__c D ON D.CONTACT__c = TMPSALESFORCE_CONTACT.id
	LEFT JOIN tmpSalesforce_Provider_Language_Spoken__c L ON L.PROVIDER_NAME__c=TMPSALESFORCE_CONTACT.id
	LEFT JOIN tmpSalesforce_Provider_Insurance__c TPI ON TPI.PROVIDER_NAME__c=TMPSALESFORCE_CONTACT.id
WHERE LTRIM(RTRIM(tmpsalesforce_Contact.Type__c)) = 'PCP'
      AND tmpSalesforce_Contact.Status__c = 'Active'
      AND LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST')
     AND TMPSALESFORCE_ACCOUNT.NAME NOT LIKE 'ACETEST%'
     AND TMPSALESFORCE_CONTACT.PROVIDER_NPI__C IS NOT NULL
     AND tmpsalesforce_Account.in_Network__c = '1'
     AND tmpSalesforce_Account.name NOT LIKE '%test%'
--ORDER BY NPI;