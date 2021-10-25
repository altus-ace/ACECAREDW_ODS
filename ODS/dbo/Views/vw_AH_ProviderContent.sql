CREATE VIEW [dbo].[vw_AH_ProviderContent]
AS
     SELECT DISTINCT 
            scCont.Provider_NPI__c AS [PROVIDER_ID],
            CASE
                WHEN tci.[Health_Plans__c] IS NULL
                THEN 'UHC'
                ELSE tci.[Health_Plans__c]
            END AS CLIENT_ID, 
            scCont.Provider_NPI__c AS [PROVIDER_NPI], 
            UPPER(FirstName) + ' ' + UPPER(LastName) AS [PROVIDER_FULLNAME], 
            scCont.ACE_Provider_ID1__c + scCont.ACE_Provider_ID2__c AS [ACE_PROVIDER_ID], 
            scCont.Type__c AS [PROVIDERTYPE], 
            sfAcct.ACE_Acct_ID1__c + sfAcct.ACE_Acct_ID2__c AS [GROUP ID], 
            REPLACE(UPPER(sfAcct.Name), ',', ' ') AS [AFFILIATED_GROUP_NAME], 
            UPPER(FirstName) AS [FIRSTNAME], 
            UPPER(Middle_Initial__c) AS [MIDDLENAME], 
            UPPER(LastName) AS [LASTNAME], 
            UPPER(CAST(STUFF((
				    SELECT ';' + Speciality_Name_CAQH__c
				    FROM tmpSalesforce_Provider_Specialties__c tsl
				    WHERE tsl.Provider_Name__c = ts2.Provider_Name__c FOR XML PATH('')
				), 1, 1, '') AS VARCHAR(100))) AS [SPECIALTY], 
            UPPER(CAST(STUFF((SELECT ';' + Degree_Name__c
				    FROM tmpSalesforce_Provider_Degree__c td
				    WHERE td.Contact__c = td2.Contact__c FOR XML PATH('')
				), 1, 1, '') AS VARCHAR(100))) AS DEGREE, 
            UPPER(Provider_Ethnicity__c) AS [ETHNICITY], 
            UPPER(CAST(STUFF((SELECT ';' + Language_Name__c
				FROM tmpSalesforce_Provider_Language_Spoken__c pl
				WHERE pl.Provider_Name__c = pl2.Provider_Name__c FOR XML PATH('')
				), 1, 1, '') AS VARCHAR(100))) AS [LANGUAGESSPOKEN], 
            Date_of_Birth__c AS [PROVIDER_DATE_OF_BIRTH], 
            Gender__c AS [PROVIDER_GENDER], 
            sfAcct.NETWORK_CONTACT__c AS ACE_NETWORK_CONTACT
     FROM tmpSalesforce_Contact scCont
          LEFT OUTER JOIN tmpSalesforce_Provider_Medical_License__c tm2 ON scCont.id = tm2.Provider_Name__c
          LEFT OUTER JOIN tmpSalesforce_Account  sfAcct ON scCont.AccountId = sfAcct.Id
          LEFT OUTER JOIN tmpSalesforce_Provider_Degree__c td2 ON scCont.id = td2.Contact__c
                                                                  AND td2.Degree_Name__c <> '(OTHER)'
                                                                  AND td2.Degree_Name__c <> ' '
          LEFT OUTER JOIN tmpSalesforce_Provider_Specialties__c ts2 ON scCont.id = ts2.Provider_Name__c
          LEFT OUTER JOIN tmpSalesforce_Provider_Language_Spoken__c pl2 ON scCont.id = pl2.Provider_Name__c
          LEFT OUTER JOIN tmpSalesforce_Provider_DEA_License__c tdl2 ON scCont.id = tdl2.Provider_Name__c
          LEFT OUTER JOIN tmpSalesforce_Provider_Hospital_Privilege__c thp2 ON scCont.id = thp2.Provider_Name__c
          LEFT OUTER JOIN tmpSalesforce_Contract_Information__c tci ON tci.Account_name__c = sfAcct.id
                                                                       AND tci.Health_Plans__c IN('UHC', 'Wellcare')
     WHERE(sfAcct.In_network__c = '1')
          AND scCont.FIRSTNAME NOT LIKE '%TEST%'
          AND scCont.Provider_NPI__C IS NOT NULL
     UNION
     (
         SELECT DISTINCT 
                CASE
                    WHEN pcp_npi = ''
                    THEN RTRIM(ta.[Group_NPI_Number__c])
                    ELSE RTRIM(PCP_NPI)
                END AS [PROVIDER_ID], 
                'UHC' AS [CLIENT_ID],
                CASE
                    WHEN pcp_npi = ''
                    THEN RTRIM(ta.[Group_NPI_Number__c])
                    ELSE RTRIM(PCP_NPI)
                END AS [PROVIDER_NPI], 
                UPPER(RTRIM(PCP_First_name)) + ' ' + UPPER(RTRIM(PCP_Last_name)) AS [PROVIDER_FULLNAME],
                CASE
                    WHEN pcp_npi = ''
                    THEN RTRIM(ta.[Group_NPI_Number__c])
                    ELSE RTRIM(PCP_NPI)
                END AS [ACE_PROVIDER_ID], 
                'UHC PCP' AS [PROVIDERTYPE], 
                RTRIM(PCP_PRACTICE_TIN) AS GROUP_ID,
                CASE
                    WHEN pcp_practice_name = ''
                    THEN UPPER(ta.name)
                    ELSE RTRIM(PCP_PRACTICE_NAME)
                END AS [AFFILIATED_GROUP_NAME], 
                UPPER(RTRIM(PCP_First_name)) AS [FIRSTNAME], 
                '' AS [MIDDLENAME], 
                UPPER(RTRIM(PCP_Last_name)) AS [LASTNAME], 
                '' AS [SPECIALTY], 
                '' AS [DEGREE], 
                '' AS [ETHNICITY], 
                '' AS [LANGUAGESSPOKEN], 
                '' AS [PROVIDER_DATE_OF_BIRTH], 
                '' AS [PROVIDER_GENDER], 
                ta.NETWORK_CONTACT__c AS [ACE_NETWORK_CONTACT]
         FROM vw_UHC_ActiveMembers um
              INNER JOIN tmpSalesforce_Account ta ON CAST(ta.Tax_id_number__C AS INT) = CAST(um.PCP_PRACTICE_TIN AS INT)
	   
         WHERE CAST(pcp_NPI AS INT) IN
         (
             SELECT DISTINCT 
                    PCP_NPI
             FROM
             (
                 SELECT DISTINCT 
                        TRY_CAST(va.PCP_NPI AS INT) AS PCP_NPI
                 FROM vw_UHC_ActiveMembers va
                 EXCEPT
                 SELECT TRY_CAST(Provider_NPI__c AS INT)
                 FROM tmpsalesforce_contact tc
             ) AS s
         )
         UNION
         (
             SELECT provider_id, 
                    Client_id, 
                    Provider_NPI, 
                    Provider_fullName, 
                    ACE_provider_id, 
                    ProviderType, 
                    [GROUP ID], 
                    Affiliated_group_name, 
                    FirstName, 
                    '' [MIDDLENAME], 
                    '' [LASTNAME], 
                    '' [SPECIALTY], 
                    '' [DEGREE], 
                    '' [ETHNICITY], 
                    '' [LANGUAGESSPOKEN], 
                    '' [PROVIDER_DATE_OF_BIRTH], 
                    '' [PROVIDER_GENDER], 
                    '' [ACE_NETWORK_CONTACT]
             FROM
             (
                 SELECT DISTINCT 
                        CONVERT(NVARCHAR(50), p1.NPI) AS [PROVIDER_ID], 
                        'Aetna' AS [CLIENT_ID], 
                        CONVERT(NVARCHAR(50), p1.NPI) AS [PROVIDER_NPI], 
                        CONVERT(NVARCHAR(100), p1.PhysicianName) AS [PROVIDER_FULLNAME], 
                        '' [ACE_PROVIDER_ID], 
                        'AetnaPCP' AS [PROVIDERTYPE], 
                        '' AS [GROUP ID], 
                        p1.tinName AS [AFFILIATED_GROUP_NAME], 
                        CONVERT(NVARCHAR(100), p1.PhysicianName) [FIRSTNAME], 
                        '' [MIDDLENAME], 
                        '' [LASTNAME], 
                        '' [SPECIALTY], 
                        '' [DEGREE], 
                        '' [ETHNICITY], 
                        '' [LANGUAGESSPOKEN], 
                        '' [PROVIDER_DATE_OF_BIRTH], 
                        '' [PROVIDER_GENDER], 
                        '' [ACE_NETWORK_CONTACT], 
                        p1.tin, 
                        A.NPI
                 FROM adi.MbrAetMbrByPcp p1
                      LEFT JOIN vw_Aetna_ProviderRoster a ON a.[tax ID] = p1.TIN
                                                             AND p1.npi IS NULL
                 WHERE CONVERT(NVARCHAR(50), p1.tin) IS NOT NULL
             ) AS S
         )
     );
