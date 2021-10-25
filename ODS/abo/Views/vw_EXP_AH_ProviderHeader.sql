

CREATE VIEW [abo].[vw_EXP_AH_ProviderHeader]
AS 
     /* Objective: Extract from the provider roster the data for AHS Provider Headers
        Version History:
    	   9/3/2020: Created view from old view dbo.vw_AH_ProviderContractHeader
    	   */
    SELECT pr.NPI AS PROVIDER_ID
        , Client.ClientShortName AS CLIENT_ID
        , Client.CS_Export_LobName AS LOB
        , 'Benefit plan test value' AS BENEFIT_PLAN
        , CASE WHEN pr.HealthPlan IS NULL THEN ISNULL(NULL, 'Participation flag test value') ELSE 'PAR' END AS [PARTICIPATION FLAG]
        , Pr.EffectiveDate AS EFFECTIVE_DATE
        , pr.ExpirationDate TERM_DATE
        , pr.TIN AS TAX_ID
        , pr.ProviderType AS TYPE
    FROM [dbo].[vw_AllClient_ProviderRoster] pr
        JOIN lst.List_Client Client ON pr.CalcClientKey = Client.ClientKey
    WHERE getdate() between pr.RowEffectiveDate and pr.RowExpirationDate
        AND pr.NPI is NOT null
    

