
CREATE VIEW adi.ProvRost_DataQuality_06_WellcareNpiWithoutClientProviderId
/*  PURPOSE: Wellcare NPIs with no Health pLan ID
*/
AS 
    SELECT p.NPI, p.ClientProviderID, p.EffectiveDate, p.ExpirationDate, 'PURPOSE: Wellcare NPIs with no Health pLan ID' Purpose
    FROM ast. vw_Get_FctProvRoster_NPIData_DevPR p
    WHERE p.HealthPlan = 'WELLCARE'
	   and isnull(p.ClientProviderID,'') = ''
	   and GETDATE() between p.EffectiveDate and CASE WHEN (ISNULL(p.ExpirationDate, '12/31/2099') in ('1900-01-01', '')) THEN '12/31/2099' else p.ExpirationDate end
