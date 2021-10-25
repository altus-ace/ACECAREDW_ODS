

-- =============================================
-- Author:			<Author,,Name>
-- Create date:	02.20.2021
-- Description:	Get Provider Information from adw.ProviderRoster
-- VERSION HISTORY: 03/10/2020: GK: Added EffectiveDate\ExpirationDate 
--							 Renamed RwEffectiveDate\RwExpirationDate to RowEffectiveDate\RowExpirationDate
-- =============================================
CREATE FUNCTION [adw].[z_tvf_GetFromProviderRoster]
(	
	 @ClientKey				INT
	,@EffectiveAsOfDate	DATE
)
RETURNS TABLE 
AS
RETURN 
(

SELECT * FROM (
	SELECT DISTINCT 	NPI														as AttribNPI
		,CONCAT(LastName, ',',FirstName)										as AttribPCPName
		,CASE WHEN AccountType IN ('SHCN_SMG','SHCN_AFF') THEN AccountType ELSE CONCAT('ACE-',AccountType) END as AccountType
		,TIN																			as AttribTIN
		,GroupName																	as AttribTINName
		,CASE WHEN HealthPlan = 'Aetna' AND LOB LIKE '%Commercial%' THEN 'AETCOM'	
				WHEN HealthPlan = 'Aetna' AND LOB LIKE '%Advantage%'  THEN 'AET'	
				WHEN HealthPlan = 'Amerigroup'	THEN 'AMG'
				WHEN HealthPlan = 'Cigna' AND LOB LIKE '%Commercial%'	THEN 'CIGNA_COM'
				WHEN HealthPlan = 'Cigna' AND LOB LIKE '%Advantage%'	THEN 'CIGNA_MA'
				WHEN HealthPlan = 'SHCN_MSSP'		THEN 'SHCN_MSSP'
				WHEN HealthPlan = 'SHCN_BCBS'		THEN 'SHCN_BCBS'
				WHEN HealthPlan = 'UHC'				THEN 'UHC'
				WHEN HealthPlan = 'Wellcare'		THEN 'WLC'
				WHEN HealthPlan = 'Oscar'			THEN 'Oscar'
				WHEN HealthPlan = 'Devoted'		THEN 'DHTX'
			ELSE 'Other'		END	as MbrHealthPlan
		,HealthPlan						as TINHealthPlan
		,Chapter							as Chapter
		,ClientKey					as ClientKey	
		,LOB								as LOB
		,ROW_NUMBER() OVER(PARTITION BY ClientKey,NPI ORDER BY fctProviderRostersKey DESC) arn
		,r.RowEffectiveDate									as RowEffectiveDate
		,r.RowExpirationDate									as RowExpirationDate
		,r.EffectiveDate										as EffectiveDate
		,r.ExpirationDate										as ExpirationDate
		,r.LastUpdatedDate
	FROM  adw.fctProviderRoster r
	WHERE r.ClientKey	 = @ClientKey
	AND getdate() --@EffectiveAsOfDate 
	BETWEEN r.RowEffectiveDate AND r.RowExpirationDate
	) n
--WHERE ClientKey = 2 --@ClientKey 
WHERE arn = 1

)

/***
Usage:
SELECT * FROM [adw].[tvf_GetFromProviderRoster] (2,getdate()) 

SELECT distinct npi FROM [dbo].[vw_AllClient_ProviderRoster] WHERE CalcClientKey = 2
***/

