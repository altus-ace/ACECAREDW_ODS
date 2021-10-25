
CREATE VIEW [dbo].[zz_vw_AH_ProviderContent_old_02]
AS
     SELECT DISTINCT
            tmpSalesforce_Contact.Provider_NPI__c AS [PROVIDER_ID],
            'UHC' AS CLIENT_ID,
            tmpSalesforce_Contact.Provider_NPI__c AS [PROVIDER_NPI],
            UPPER(FirstName)+' '+UPPER(LastName) AS [PROVIDER_FULLNAME],
            tmpSalesforce_Contact.ACE_Provider_ID1__c + tmpSalesforce_Contact.ACE_Provider_ID2__c AS [ACE_PROVIDER_ID],
            tmpSalesforce_Contact.Type__c AS [PROVIDERTYPE],
            tmpSalesforce_Account.ACE_Acct_ID1__c + tmpSalesforce_Account.ACE_Acct_ID2__c AS [GROUP ID],
            REPLACE(UPPER(tmpSalesforce_Account.Name), ',', ' ') AS [AFFILIATED_GROUP_NAME],
            UPPER(FirstName) AS [FIRSTNAME],
            UPPER(Middle_Initial__c) AS [MIDDLENAME],
            UPPER(LastName) AS [LASTNAME],
            UPPER(CAST(STUFF(
(
    SELECT ';'+Speciality_Name_CAQH__c
    FROM tmpSalesforce_Provider_Specialties__c tsl
    WHERE tsl.Provider_Name__c = ts2.Provider_Name__c FOR XML PATH('')
), 1, 1, '') AS VARCHAR(100))) AS [SPECIALTY],
            UPPER(CAST(STUFF(
(
    SELECT ';'+Degree_Name__c
    FROM tmpSalesforce_Provider_Degree__c td
    WHERE td.Contact__c = td2.Contact__c FOR XML PATH('')
), 1, 1, '') AS VARCHAR(100))) AS DEGREE,
            UPPER(Provider_Ethnicity__c) AS [ETHNICITY],
            UPPER(CAST(STUFF(
(
    SELECT ';'+Language_Name__c
    FROM tmpSalesforce_Provider_Language_Spoken__c pl
    WHERE pl.Provider_Name__c = pl2.Provider_Name__c FOR XML PATH('')
), 1, 1, '') AS VARCHAR(100))) AS [LANGUAGESSPOKEN],
            Date_of_Birth__c AS [PROVIDER_DATE_OF_BIRTH],
            Gender__c AS [PROVIDER_GENDER],
            TMPSALESFORCE_ACCOUNT.NETWORK_CONTACT__c AS ACE_NETWORK_CONTACT
     FROM tmpSalesforce_Contact
          LEFT OUTER JOIN tmpSalesforce_Provider_Medical_License__c tm2 ON tmpSalesforce_contact.id = tm2.Provider_Name__c
          LEFT OUTER JOIN tmpSalesforce_Account ON tmpSalesforce_Contact.AccountId = tmpSalesforce_Account.Id
          LEFT OUTER JOIN tmpSalesforce_Provider_Degree__c td2 ON tmpSalesforce_contact.id = td2.Contact__c
                                                                  AND td2.Degree_Name__c <> '(OTHER)'
                                                                  AND td2.Degree_Name__c <> ' '
          LEFT OUTER JOIN tmpSalesforce_Provider_Specialties__c ts2 ON tmpSalesforce_contact.id = ts2.Provider_Name__c
          LEFT OUTER JOIN tmpSalesforce_Provider_Language_Spoken__c pl2 ON tmpSalesforce_contact.id = pl2.Provider_Name__c
          LEFT OUTER JOIN tmpSalesforce_Provider_DEA_License__c tdl2 ON tmpSalesforce_contact.id = tdl2.Provider_Name__c
          LEFT OUTER JOIN tmpSalesforce_Provider_Hospital_Privilege__c thp2 ON tmpSalesforce_Contact.id = thp2.Provider_Name__c
     WHERE tmpsalesforce_Contact.Type__c IN('PCP', 'PA', 'NP', 'FNP', 'Allied Health', 'DDS', 'LPC', 'UHC PCP', 'SPECIALIST', 'Mid Level')
          AND (dbo.tmpSalesforce_Account.In_network__c = '1')
          AND tmpSalesforce_Contact.FIRSTNAME NOT LIKE '%TEST%'
          AND tmpSalesforce_contact.Provider_NPI__C IS NOT NULL
		UNION
		 SELECT DISTINCT
            case when pcp_npi = '' then rtrim(ta.[Group_NPI_Number__c]) else RTRIM(PCP_NPI) end AS [PROVIDER_ID],
		  'UHC' AS [CLIENT_ID],
		  case when pcp_npi = '' then rtrim(ta.[Group_NPI_Number__c]) else RTRIM(PCP_NPI) end AS [PROVIDER_NPI],
            UPPER(RTRIM(PCP_First_name))+' '+upper(RTRIM(PCP_Last_name)) AS [PROVIDER_FULLNAME] ,
            case when pcp_npi = '' then rtrim(ta.[Group_NPI_Number__c]) else RTRIM(PCP_NPI) end  AS [ACE_PROVIDER_ID],
		  'UHC PCP' AS [PROVIDERTYPE],
            RTRIM(PCP_PRACTICE_TIN) AS GROUP_ID,
            case when pcp_practice_name ='' then upper(ta.name) else RTRIM(PCP_PRACTICE_NAME) end AS [AFFILIATED_GROUP_NAME],
           UPPER(RTRIM(PCP_First_name)) AS [FIRSTNAME],
		 '' AS [MIDDLENAME],
		  UPPER(RTRIM(PCP_Last_name)) aS [LASTNAME],
		  '' AS [SPECIALTY],
		   '' AS [DEGREE]
      ,'' AS [ETHNICITY]
      ,'' AS [LANGUAGESSPOKEN]
      ,'' AS [PROVIDER_DATE_OF_BIRTH]
      ,'' AS [PROVIDER_GENDER]
      ,ta.NETWORK_CONTACT__c  as [ACE_NETWORK_CONTACT]
     FROM vw_UHC_ActiveMembers um
          INNER JOIN tmpSalesforce_Account ta ON CAST(ta.Tax_id_number__C AS INT) = CAST(um.PCP_PRACTICE_TIN AS INT)
     WHERE CAST(pcp_NPI AS INT) IN
( Select Distinct PCP_NPI from (
    SELECT DISTINCT
           CAST(va.PCP_NPI AS INT) AS PCP_NPI
    FROM vw_UHC_ActiveMembers va
    EXCEPT
    SELECT CAST(Provider_NPI__c AS INT)
    FROM tmpsalesforce_contact tc ) as s 
   -- except
  --  Select Cast(Group_NPI_number__c as int) from tmpSalesforce_Account -- where tc.status__C ='Active'
    
);

