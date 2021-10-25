
CREATE VIEW adi.ProvRost_DataQuality_05_NpiHlthPlnNotInTinHlthPln
/*  PURPOSE: NPI HP not found in the TIN HP
*/
AS 
    SELECT n.NPI, t.TIN, n.HealthPlan, n.LOB, t.TinHealthPlan, t.TinLOB
	   , 'PURPOSE: NPI HP not found in the TIN HP' Purpose
    FROM ast. vw_Get_FctProvRoster_NPIData_DevPR n
	   LEFT JOIN ast. vw_Get_FctProvRoster_TINData_DevPR t
	   ON n.npi = t.NPI 
		  AND n.TIN = t.TIN
		  AND n.HealthPlan = t.TinHealthPlan
	WHERE ( n.HealthPlan <> t.TinHealthPlan)
	   --(ISNULL(t.TinHealthPlan, '') <> '' OR 
