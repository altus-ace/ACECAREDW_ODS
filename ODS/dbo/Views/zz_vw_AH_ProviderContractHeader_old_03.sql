

/* Adding Termdate from salesforce to show in AHS  provider effective from and to.*/
CREATE VIEW [dbo].[zz_vw_AH_ProviderContractHeader_old_03]
AS
     SELECT DISTINCT
            dbo.tmpSalesforce_Contact.Provider_NPI__c AS PROVIDER_ID,
            'UHC' AS CLIENT_ID,
            ISNULL(dbo.tmpSalesforce_Contract_Information__c.Health_Plans__c, 'UHC') AS LOB,
            ISNULL(NULL, 'Benefit plan test value') AS BENEFIT_PLAN,
            CASE
                WHEN dbo.tmpSalesforce_Contract_Information__c.Health_Plans__c IS NULL
                THEN ISNULL(NULL, 'Participation flag test value')
                ELSE 'PAR'
            END AS [PARTICIPATION FLAG],
            ISNULL(dbo.tmpSalesforce_Contract_Information__c.Effective_Date__c, '2017-01-01 00:00:00') AS EFFECTIVE_DATE,
           -- '12/31/2199' AS TERM_DATE,
		 /* Adding Termdate from salesforce to show in AHS  provider effective from and to.*/
		convert(date,ISNULL(convert(date,dbo.tmpSalesforce_Contract_Information__c.Term_Date__c), '12/31/2199'),101) as TERM_DATE,
            dbo.tmpSalesforce_Account.Tax_ID_Number__c AS TAX_ID,
            dbo.tmpSalesforce_Account.Type__c AS TYPE
     FROM dbo.tmpSalesforce_Contact
          LEFT OUTER JOIN dbo.tmpSalesforce_Account ON dbo.tmpSalesforce_Contact.AccountId = dbo.tmpSalesforce_Account.Id
          LEFT OUTER JOIN dbo.tmpSalesforce_Contract_Information__c ON dbo.tmpSalesforce_Account.Id = dbo.tmpSalesforce_Contract_Information__c.Account_Name__c
                                                                       AND dbo.tmpSalesforce_Contract_Information__c.Health_Plans__c IN('UHC')
     WHERE(dbo.tmpSalesforce_Contact.Provider_NPI__c <> ' ')
          AND (dbo.tmpSalesforce_Contact.Type__c IN('PCP', 'PA', 'NP', 'FNP', 'Allied Health', 'DDS', 'LPC', 'UHC PCP', 'SPECIALIST', 'Mid Level'))
          AND (dbo.tmpSalesforce_Account.In_network__c = '1')
          AND (dbo.tmpSalesforce_Contact.FirstName NOT LIKE '%TEST%')
          AND (dbo.tmpSalesforce_Contact.Provider_NPI__c IS NOT NULL)
		union
		 SELECT DISTINCT
            case when pcp_npi = '' then rtrim(ta.[Group_NPI_Number__c]) else RTRIM(PCP_NPI) end AS [PROVIDER_ID],
		  'UHC' AS [CLIENT_ID],
		  'UHC' AS [LOB],
		  'Benefit plan test value' as [BENEFIT_PLAN],
		  'Participation flag test value' as[PARTICIPATION FLAG],
		  '2018-01-01 00:00:00' as [EFFECTIVE_DATE],
		  '12/31/2199' as [TERM_DATE],
            RTRIM(PCP_PRACTICE_TIN) AS [TAX_ID],
		  ta.type__C as [TYPE]
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
   -- Select Cast(Group_NPI_number__c as int) from tmpSalesforce_Account -- where tc.status__C ='Active'
    
);


