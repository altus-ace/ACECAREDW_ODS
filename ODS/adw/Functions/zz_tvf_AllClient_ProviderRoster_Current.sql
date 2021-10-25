CREATE FUNCTION [adw].[zz_tvf_AllClient_ProviderRoster_Current] (
     @ClientKey INT = 0
	)
RETURNS TABLE
    /* ALWAYS RETURNS THE LATEST PROVIDER ROSTER: RowEffectiveDate/RowExpirationDate
	   Select by client key, as of date between Prov/tin HP EFF dates and TIN HP = Prov HP on the AS OF date */
AS RETURN    

   SELECT Src.NPI, Src.LastName, Src.FirstName, 
       Src.AttribTIN, Src.AttribTINName, Src.AccountType, 
       Src.Chapter, Src.PrimaryCounty, Src.ClientKey, Src.MbrHealthPlan, Src.ClientProviderID,
       Src.TINHealthPlan, Src.TinLOB, Src.TinHPEffectiveDate, Src.TinHPExpirationDate, 
       Src.NpiHealthPlan, Src.NpiLOB, Src.NpiHpEffectiveDate, Src.NpiHpExpirationDate, 
       Src.LastUpdatedDate, 
       Src.RowEffectiveDate, Src.RowExpirationDate,Src.ARN, src.fctProviderRosterSkey
    FROM (SELECT 
           pr.NPI, 
           pr.LastName, 
           FirstName, 
           TIN AS AttribTIN, 
           GroupName AS AttribTINName,
           CASE WHEN AccountType IN('SHCN_SMG', 'SHCN_AFF') THEN AccountType
               ELSE CONCAT('ACE-', AccountType) END AS AccountType,
           CASE WHEN pr.PrvdrHealthPlan = 'Aetna'AND pr.PrvdrLOB LIKE '%Commercial%'	   THEN 'AETCOM'
			 WHEN pr.PrvdrHealthPlan = 'Aetna'AND pr.PrvdrLOB LIKE '%Advantage%'	   THEN 'AET'
			 WHEN pr.PrvdrHealthPlan = 'Amerigroup'							   THEN 'AMG'
			 WHEN pr.PrvdrHealthPlan = 'Cigna'AND pr.PrvdrLOB LIKE '%Commercial%'	   THEN 'CIGNA_COM'
			 WHEN pr.PrvdrHealthPlan = 'Cigna'AND pr.PrvdrLOB LIKE '%Advantage%'	   THEN 'CIGNA_MA'
			 WHEN pr.PrvdrHealthPlan = 'SHCN_MSSP'							   THEN 'SHCN_MSSP'
			 WHEN pr.PrvdrHealthPlan = 'SHCN_BCBS'							   THEN 'SHCN_BCBS'
			 WHEN pr.PrvdrHealthPlan = 'UHC'								   THEN 'UHC'
			 WHEN pr.PrvdrHealthPlan = 'Wellcare'							   THEN 'WLC'
			 WHEN pr.PrvdrHealthPlan = 'Oscar'								   THEN 'Oscar'
			 WHEN pr.PrvdrHealthPlan = 'Devoted'							   THEN 'DHTX'
			 ELSE 'Other'			    END AS MbrHealthPlan, 
           Pr.Chapter AS Chapter, 
           Pr.PrimaryCounty , 
           Pr.ClientKey AS ClientKey, 		 
		 pr.TinClientKey,
           Pr.TinHealthPlan AS TINHealthPlan, 			  
           Pr.TinLOB, 
           pr.RowEffectiveDate AS RowEffectiveDate, 
           pr.RowExpirationDate AS RowExpirationDate, 
           pr.TinHpEffDate AS TinHPEffectiveDate, 
           pr.TinHpExpDate AS TinHPExpirationDate, 
		 pr.PrvdrClientKey AS NpiClientKey, 
           pr.PrvdrHealthPlan AS NpiHealthPlan, 
           pr.PrvdrLOB		  AS NpiLOB, 
           pr.PrvdrHpEffDate AS NpiHpEffectiveDate, 
           pr.PrvdrHpExpDate AS NpiHpExpirationDate, 
		 pr.ClientProviderID,
		 pr.ProviderType, 
           pr.LastUpdatedDate, 
           ROW_NUMBER() OVER(PARTITION BY NPI, TIN, PrvdrHealthplan, PrvdrLOB ORDER BY PrvdrHpEffDate asc, PrvdrHpExpDate DESC) AS ARN
    --		,ROW_NUMBER() OVER(PARTITION BY ClientKey,NPI ORDER BY fctProviderRostersKey DESC) arn
    		, pr.fctProviderRosterSkey								 
    FROM adw.fctProviderRoster_DevPR PR
    WHERE((@ClientKey <> 0 AND pr.ClientKey = @ClientKey)OR (@ClientKey = 0))	
	   AND (SELECT MAX(RowEffectiveDate)FROM adw.fctProviderRoster_DevPR ) BETWEEN pr.RowEffectiveDate AND pr.RowExpirationDate
	   AND pr.IsActive = 1  -- ROW IS ACTIVE: 
    ) Src
    WHERE src.ARN = 1;

