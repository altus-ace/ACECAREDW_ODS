

/*****************************************************************
CREATED BY : TS
CREATE DATE : 01/31/2020
DESCRIPTION : 

The Object is created to get All Providers and Specialist details together
The other reference objects are:
1. [ACECAREDW].[dbo].[vw_Specialist_ProviderRoster]
2.ACECAREDW.[dbo].[vw_AllClient_ProviderRoster] 


MODIFICATION:
USER        DATE        COMMENT


 
******************************************************************/

CREATE VIEW [dbo].[yy_vw_AllClient_ProviderRoster_PCPANDSPEC]
AS
    -- if the providerType is not filtered the union should pull in any missing provider, this might cause dups this needs to be fully converted to the fact.

	
     SELECT DISTINCT 
            npi, 
            MAX([primaryzipcode]) AS primaryzip, 
            (LastName + ',' + FirstName) AS ProviderName, 
            'PCP' AS typpe, 
            TIN, 
            BillingPOD
			, AccountType
     FROM [dbo].[vw_AllClient_ProviderRoster]
     GROUP BY npi, 
              LastName, 
              FirstName, 
              TIN, 
              BillingPOD
			  , AccountType
     UNION
     SELECT DISTINCT
            ([NPI]), 
            [PRIMARY ZIPCODE] AS primaryzip, 
            [LAST NAME] + ',' + [FIRST NAME] AS ProviderName, 
            'SPECIALIST' AS typpe, 
            [TAX ID] AS TIN, 
            [BILLING POD] AS BillingPOD, '' AS AccountType
     FROM [ACECAREDW].[dbo].[vw_Specialist_ProviderRoster];
