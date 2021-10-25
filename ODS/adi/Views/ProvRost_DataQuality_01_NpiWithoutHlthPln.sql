
CREATE VIEW adi.ProvRost_DataQuality_01_NpiWithoutHlthPln
/*  PURPOSE: NPIs with no HPs
*/
AS 
SELECT NPI, p.HealthPlan, p.LOB, p.CalcClientKey, 'PURPOSE: NPIs with no HPs' Purpose
FROM ast. vw_Get_FctProvRoster_NPIData_DevPR p
WHERE ISNULL(p.Healthplan,'') = ''

