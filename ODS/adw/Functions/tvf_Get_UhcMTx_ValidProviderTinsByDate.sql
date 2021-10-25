CREATE FUNCTION [adw].[tvf_Get_UhcMTx_ValidProviderTinsByDate](@EffectiveDate DATE)
RETURNS TABLE
AS
     RETURN
(
    SELECT pr.NPI, 
           pr.TIN, 
           pr.EffectiveDate, 
           pr.ExpirationDate, 
           pr.LOB
    FROM dbo.vw_AllClient_ProviderRoster AS PR
    WHERE PR.HealthPlan = 'UHC'
	   AND  pr.providerType in ('PCP')
	   AND @EffectiveDate BETWEEN PR.EffectiveDate AND ISNULL(pr.ExpirationDate, CONVERT(DATE, '12/31/2099'))
);