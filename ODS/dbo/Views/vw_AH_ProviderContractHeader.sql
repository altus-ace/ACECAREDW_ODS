


CREATE VIEW [dbo].[vw_AH_ProviderContractHeader]
AS
    /* Purpose Get provider contracts for AH Export 
	   1. SF sources 
	   2. union in 
		  a. UHC not in SF
		  b. Aet Not in SF
    DO WE NEED TO Export WLC prodiders?
    Added fix for try_convert instead of convert for npi from sales force
		  */
  SELECT *
  FROM (
     SELECT DISTINCT  sfCont.Provider_NPI__c AS PROVIDER_ID,
            CASE WHEN sfContInfo.Health_plans__c IS NULL THEN 'UHC'
                ELSE sfContInfo.Health_plans__c END AS CLIENT_ID, 
            ISNULL(sfContInfo.Health_Plans__c, 'UHC') AS LOB, 
            ISNULL(NULL, 'Benefit plan test value') AS BENEFIT_PLAN,
            CASE WHEN sfContInfo.Health_Plans__c IS NULL THEN ISNULL(NULL, 'Participation flag test value')
                ELSE 'PAR' END AS [PARTICIPATION FLAG], 
            ISNULL(sfContInfo.Effective_Date__c, '2017-01-01 00:00:00') AS EFFECTIVE_DATE,            
            CONVERT(DATE, ISNULL(CONVERT(DATE, sfContInfo.Term_Date__c), '12/31/2199'), 101) AS TERM_DATE, 
            sfAcct.Tax_ID_Number__c AS TAX_ID, 
            sfAcct.Type__c AS TYPE
     FROM dbo.tmpSalesforce_Contact AS sfCont
          LEFT OUTER JOIN dbo.tmpSalesforce_Account  AS sfAcct ON sfCont.AccountId = sfAcct.Id
          LEFT OUTER JOIN dbo.tmpSalesforce_Contract_Information__c AS sfContInfo ON sfAcct.Id = sfContInfo.Account_Name__c
     -- AND dbo.tmpSalesforce_Contract_Information__c.Health_Plans__c IN('UHC','Wellcare')
     WHERE(sfCont.Provider_NPI__c <> ' ')
          AND (sfCont.Type__c IN('PCP', 'PA', 'NP', 'FNP', 'Allied Health', 'DDS', 'LPC', 'UHC PCP', 'SPECIALIST', 'Mid Level'))
          AND (sfAcct.In_network__c = '1')
          AND (sfCont.FirstName NOT LIKE '%TEST%')
          AND (sfCont.Provider_NPI__c IS NOT NULL)
		AND sfCont.Provider_NPI__c = '1003273731'
     UNION /* get uhc not in SF */
     (SELECT DISTINCT CASE WHEN pcp_npi = '' THEN RTRIM(ta.[Group_NPI_Number__c])
					   ELSE RTRIM(PCP_NPI) END AS [PROVIDER_ID], 
                'UHC' AS [CLIENT_ID], 
                'UHC' AS [LOB], 
                'Benefit plan test value' AS [BENEFIT_PLAN], 
                'Participation flag test value' AS [PARTICIPATION FLAG], 
                '2018-01-01 00:00:00' AS [EFFECTIVE_DATE], 
                '12/31/2199' AS [TERM_DATE], 
                RTRIM(PCP_PRACTICE_TIN) AS [TAX_ID], 
                ta.type__C AS [TYPE]
         FROM vw_UHC_ActiveMembers um
              INNER JOIN tmpSalesforce_Account ta ON CAST(ta.Tax_id_number__C AS INT) = CAST(um.PCP_PRACTICE_TIN AS INT)
         WHERE CAST(pcp_NPI AS INT) IN
		  (SELECT DISTINCT  PCP_NPI
			 FROM(SELECT DISTINCT TRY_CAST(va.PCP_NPI AS INT) AS PCP_NPI
				    FROM vw_UHC_ActiveMembers va
				    EXCEPT
				    SELECT TRY_CAST(Provider_NPI__c AS INT)
				    FROM tmpsalesforce_contact tc) AS s	)         
    UNION    /* get Aetna not in SF */
    (SELECT provider_id, 
		  Client_id, 
		  'Aetna' AS LOB, 
		  'Benefit plan test value' AS 'Benefit_plan', 
		  'PAR' AS 'PARTICIPATION FLAG', 
		  '2018-01-01 00:00:00' AS EFFECTIVE_DATE, 
		  '2199-12-31' AS TERM_DATE, 
		  s.TIN AS TAX_ID, 
		  'AetnaPCP' AS type
     FROM(SELECT DISTINCT CONVERT(NVARCHAR(50), p1.NPI) AS [PROVIDER_ID], 
			 'Aetna' AS [CLIENT_ID], 
                CONVERT(NVARCHAR(50), p1.NPI) AS [PROVIDER_NPI], 
                CONVERT(NVARCHAR(100), p1.PhysicianName) AS [PROVIDER_FULLNAME], 
                p1.tinName AS [AFFILIATED_GROUP_NAME], 
			 p1.tin, 
                A.NPI
          FROM adi.MbrAetMbrByPcp p1
		  LEFT JOIN vw_Aetna_ProviderRoster a ON a.[tax ID] = p1.TIN
			 AND p1.npi IS NULL
          WHERE CONVERT(NVARCHAR(50), p1.tin) IS NOT NULL) AS S		  
         ) 	   
     ) 	
    )src
    WHERE GETDATE() between src.EFFECTIVE_DATE and src.TERM_DATE
	   AND LOB IN ('UHC', 'Aetna', 'Wellcare')
;
