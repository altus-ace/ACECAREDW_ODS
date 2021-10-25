CREATE VIEW [dbo].[vw_ACE_NETWORK_PROVIDER]
AS  -- ther fct provider roster should be able to provider the source for both of these queries. 
     SELECT DISTINCT 
            pr.npi, 
            MAX(pr.[primaryzipcode]) AS zip, 
            (pr.LastName + ',' + pr.FirstName) AS ProviderName, 
            pr.providerType AS typpe
     FROM [dbo].[vw_AllClient_ProviderRoster] pr
	WHERE pr.providerType in ('PCP')
     GROUP BY pr.npi, 
              pr.LastName, 
              pr.FirstName,
		    pr.providerType
     UNION
     SELECT DISTINCT
            ([NPI]), 
            [PRIMARY ZIPCODE] AS zip, 
            [LAST NAME] + ',' + [FIRST NAME] AS ProviderName, 
            'SPECIALIST' AS typpe
     FROM [ACECAREDW].[dbo].[vw_Specialist_ProviderRoster];
