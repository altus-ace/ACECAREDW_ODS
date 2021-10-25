

CREATE VIEW [adw].[z_vw_Dashboard_Membership_Pivot]
AS

WITH CTE AS (			-- Active Member by AttribNPI, MCO with Totals
SELECT CASE WHEN AttribNPI IS NULL THEN 'NA' ELSE CASE WHEN AttribNPI <> 0 THEN AttribNPI ELSE 'NA-0' END END AS MbrNPI
	,SUM(UHCMcaid  ) as UHCMcaid
	,SUM(MSSP		) as MSSP
	,SUM(AetnaMA   ) as AetnaMA
	,SUM(CignaMA	) as CignaMA
	,SUM(DevotedMA ) as DevotedMA
	,SUM(WellcareMA) as WellcareMA
	,SUM(AetnaComm ) as AetnaComm
	,SUM(BCBSComm  ) as BCBSComm
	,SUM(OscarComm ) as OscarComm
	,SUM(Other )	  as Other
	,SUM(UHCMcaid  )
	+SUM(MSSP		)
	+SUM(AetnaMA   )
	+SUM(CignaMA	)
	+SUM(DevotedMA )
	+SUM(WellcareMA)
	+SUM(AetnaComm )
	+SUM(BCBSComm  )
	+SUM(OscarComm ) 
	+SUM(Other)	as Total
FROM (								-- Pivot by AttribNPI
	SELECT AttribNPI					
		,CASE WHEN MCO = 'AET'			THEN SUM(MbrCnt) ELSE 0 END						as AetnaMA
		,CASE WHEN MCO = 'AETCOM'		THEN SUM(MbrCnt) ELSE 0 END						as AetnaComm
		,CASE WHEN MCO = 'CIGNA_MA'		THEN SUM(MbrCnt) ELSE 0 END						as CignaMA
		,CASE WHEN MCO = 'DHTX'			THEN SUM(MbrCnt) ELSE 0 END						as DevotedMA
		,CASE WHEN MCO = 'OSCAR'		THEN SUM(MbrCnt) ELSE 0 END						as OscarComm
		,CASE WHEN MCO = 'SHCN_MSSP'	THEN SUM(MbrCnt) ELSE 0 END						as MSSP
		,CASE WHEN MCO = 'SHCN_BCBS'	THEN SUM(MbrCnt) ELSE 0 END						as BCBSComm
		,CASE WHEN MCO = 'UHC'			THEN SUM(MbrCnt) ELSE 0 END						as UHCMcaid
		,CASE WHEN MCO = 'WLC'			THEN SUM(MbrCnt) ELSE 0 END						as WellcareMA
		,CASE WHEN MCO NOT IN  ('AET','AETCOM','CIGNA_MA','DHTX','OSCAR','SHCN_MSSP','SHCN_BCBS','UHC','WLC') 
		 THEN	SUM(MbrCnt) ELSE 0 END as Other
	FROM (							-- Get Active Members and their corresponding NPI
		SELECT UPPER(m.[CLIENT])													as MCO
		      ,m.[clientKey]														as ClientKey
		      ,1																	as MbrCnt
		      ,m.[NPI]																as AttribNPI
			  --,p.HP																as HealthPlan
		FROM [ACECAREDW].[dbo].[vw_ActiveMembers] m
		--LEFT JOIN (
		--		SELECT DISTINCT NPI													as AttribNPI
		--			,CASE WHEN HealthPlan   = 'Aetna'		AND LOB LIKE '%Commercial%' THEN 'AETCOM'	
		--					WHEN HealthPlan = 'Aetna'		AND LOB LIKE '%Advantage%' THEN 'AET'	
		--					WHEN HealthPlan = 'Amerigroup'	THEN 'AMG'
		--					WHEN HealthPlan = 'Cigna'		THEN 'CIGNA_MA'
		--					WHEN HealthPlan = 'SHCN_MSSP'	THEN 'SHCN_MSSP'
		--					WHEN HealthPlan = 'SHCN_BCBS'	THEN 'SHCN_BCBS'
		--					WHEN HealthPlan = 'UHC'			THEN 'UHC'
		--					WHEN HealthPlan = 'Wellcare'	THEN 'WLC'
		--					WHEN HealthPlan = 'Oscar'		THEN 'Oscar'
		--					WHEN HealthPlan = 'Devoted'		THEN 'DHTX'
		--					WHEN HealthPlan = 'Imperial'	THEN 'IMP'
		--					WHEN HealthPlan = 'Molina'		THEN 'MOL'
		--				ELSE 'Other'		END	as HP
		--		FROM adw.fctProviderRoster r
		--		WHERE GETDATE() BETWEEN r.RowEffectiveDate AND r.RowExpirationDate
		--		) p
		--ON		m.NPI		= p.AttribNPI
		--AND	m.CLIENT	= p.HP		-- End
		) n
	GROUP BY AttribNPI, MCO--, n.AccountType, n.PracticeTIN , n.PracticeName, MCO		-- End
) a
GROUP BY AttribNPI
), CTE_PR AS			-- Provider Roster by MCO
(
SELECT PR_NPI
	,SUM(UHCMcaid  ) as UHCMcaid
	,SUM(MSSP		) as MSSP
	,SUM(AetnaMA   ) as AetnaMA
	,SUM(CignaMA	) as CignaMA
	,SUM(DevotedMA ) as DevotedMA
	,SUM(WellcareMA) as WellcareMA
	,SUM(AetnaComm ) as AetnaComm
	,SUM(BCBSComm  ) as BCBSComm
	,SUM(OscarComm ) as OscarComm
	,SUM(Imperial )		as Imperial
	,SUM(Molina )		as Molina
	,SUM(Other )		as Other
FROM (
	SELECT PR_NPI																		
		,CASE WHEN HP = 'AET'			THEN 1 ELSE 0 END						as AetnaMA
		,CASE WHEN HP = 'AETCOM'		THEN 1 ELSE 0 END						as AetnaComm
		,CASE WHEN HP = 'CIGNA_MA'		THEN 1 ELSE 0 END						as CignaMA
		,CASE WHEN HP = 'DHTX'			THEN 1 ELSE 0 END						as DevotedMA
		,CASE WHEN HP = 'OSCAR'			THEN 1 ELSE 0 END						as OscarComm
		,CASE WHEN HP = 'SHCN_MSSP'		THEN 1 ELSE 0 END						as MSSP
		,CASE WHEN HP = 'SHCN_BCBS'		THEN 1 ELSE 0 END						as BCBSComm
		,CASE WHEN HP = 'UHC'			THEN 1 ELSE 0 END						as UHCMcaid
		,CASE WHEN HP = 'WLC'			THEN 1 ELSE 0 END						as WellcareMA
		,CASE WHEN HP = 'IMPTX'			THEN 1 ELSE 0 END						as Imperial
		,CASE WHEN HP = 'MOLTX'			THEN 1 ELSE 0 END						as Molina
		,CASE WHEN HP = 'Other'			THEN 1 ELSE 0 END						as Other
	FROM (
		SELECT DISTINCT NPI															as PR_NPI
			,healthplan
			,CASE WHEN HealthPlan = 'Aetna' AND LOB LIKE '%Commercial%' THEN 'AETCOM'	
					WHEN HealthPlan = 'Aetna' AND LOB LIKE '%Advantage%' THEN 'AET'	
					WHEN HealthPlan = 'Amerigroup' THEN 'AMG'
					WHEN HealthPlan = 'Cigna' THEN 'CIGNA_MA'
					WHEN HealthPlan = 'SHCN_MSSP' THEN 'SHCN_MSSP'
					WHEN HealthPlan = 'SHCN_BCBS' THEN 'SHCN_BCBS'
					WHEN HealthPlan = 'UHC' THEN 'UHC'
					WHEN HealthPlan = 'Wellcare' THEN 'WLC'
					WHEN HealthPlan = 'Oscar' THEN 'Oscar'
					WHEN HealthPlan = 'Devoted' THEN 'DHTX'
					WHEN HealthPlan = 'Imperial' THEN 'IMPTX'
					WHEN HealthPlan = 'Molina' THEN 'MOLTX'
				ELSE 'Other'		END	as HP
			FROM adw.fctProviderRoster r
			WHERE GETDATE() BETWEEN r.RowEffectiveDate AND r.RowExpirationDate
		) c) m
	GROUP BY PR_NPI
	UNION SELECT 'NA',1,1,1,1,1,1,1,1,1,1,1,1
	UNION SELECT 'NA-0',1,1,1,1,1,1,1,1,1,1,1,1
	UNION SELECT '1111111111',1,1,1,1,1,1,1,1,1,1,1,1
	UNION SELECT '1093186728',1,1,1,1,1,1,1,1,1,1,1,1
	UNION SELECT '1235527391',1,1,1,1,1,1,1,1,1,1,1,1
	UNION SELECT '1265568042',1,1,1,1,1,1,1,1,1,1,1,1
	UNION SELECT '1285664763',1,1,1,1,1,1,1,1,1,1,1,1
	UNION SELECT '1316193386',1,1,1,1,1,1,1,1,1,1,1,1
	UNION SELECT '1407837156',1,1,1,1,1,1,1,1,1,1,1,1
	UNION SELECT '1932664091',1,1,1,1,1,1,1,1,1,1,1,1
), CTE_UR AS		-- Unique Records for each NPI in Provider Roster
(
SELECT AttribNPI, AttribPCPName
    ,CASE WHEN [AccountType] NOT IN ('SHCN_SMG','SHCN_AFF') THEN 'ACE' 
			 WHEN [AccountType] IS NULL THEN 'N/A' 
			 ELSE [AccountType] END as AccountType
FROM (
	SELECT DISTINCT 	NPI													as AttribNPI
		,CONCAT(LastName, ',',FirstName)									as AttribPCPName
		,AccountType
		,ROW_NUMBER() OVER(PARTITION BY NPI ORDER BY LastName, FirstName DESC) arn
	FROM adw.fctProviderRoster r
	WHERE GETDATE() BETWEEN r.RowEffectiveDate AND r.RowExpirationDate
	) m
WHERE m.arn = 1
), CTE_Tmp AS
(
SELECT MbrNPI											 as PR_NPI
	,CASE WHEN UHCMcaid  = 0 THEN 0 ELSE 1 END as UHCMcaid
	,CASE WHEN MSSP		= 0 THEN 0 ELSE 1 END as MSSP
	,CASE WHEN AetnaMA   = 0 THEN 0 ELSE 1 END as AetnaMA
	,CASE WHEN CignaMA	= 0 THEN 0 ELSE 1 END as CignaMA
	,CASE WHEN DevotedMA = 0 THEN 0 ELSE 1 END as DevotedMA
	,CASE WHEN WellcareMA= 0 THEN 0 ELSE 1 END as WellcareMA
	,CASE WHEN AetnaComm = 0 THEN 0 ELSE 1 END as AetnaComm
	,CASE WHEN BCBSComm  = 0 THEN 0 ELSE 1 END as BCBSComm
	,CASE WHEN OscarComm = 0 THEN 0 ELSE 1 END as OscarComm
	,CASE WHEN Other		= 0 THEN 0 ELSE 1 END as Other
FROM CTE
)
--Validate missing NPIs in ProviderRoster
--SELECT DISTINCT a.MbrNPI
--	,a.UHCMcaid
--	,a.MSSP
--	,a.AetnaMA
--	,a.CignaMA
--	,a.DevotedMA
--	,a.WellcareMA
--	,a.AetnaComm
--	,a.BCBSComm
--	,a.OscarComm
--	,a.Other
--FROM CTE a
--RIGHT JOIN CTE_PR p
--ON  p.PR_NPI			= a.MbrNPI
--WHERE a.MbrNPI IS NOT NULL

--SELECT * FROM CTE_UR
--SELECT * FROM CTE_PR p
--SELECT * FROM CTE_Tmp

-- Main
--SELECT DISTINCT p.PR_NPI as AttribNPI -- set 99999 to n/a 
--	,CASE WHEN p.UHCMcaid     = 1 THEN a.UHCMcaid   ELSE '99999' END as UHCMcaid
--	,CASE WHEN p.MSSP		     = 1 THEN a.MSSP		   ELSE '99999' END as MSSP
--	,CASE WHEN p.AetnaMA      = 1 THEN a.AetnaMA    ELSE '99999' END as AetnaMA
--	,CASE WHEN p.CignaMA	     = 1 THEN a.CignaMA	   ELSE '99999' END as CignaMA
--	,CASE WHEN p.DevotedMA    = 1 THEN a.DevotedMA  ELSE '99999' END as DevotedMA
--	,CASE WHEN p.WellcareMA   = 1 THEN a.WellcareMA ELSE '99999' END as WellcareMA
--	,CASE WHEN p.AetnaComm    = 1 THEN a.AetnaComm  ELSE '99999' END as AetnaComm
--	,CASE WHEN p.BCBSComm     = 1 THEN a.BCBSComm   ELSE '99999' END as BCBSComm
--	,CASE WHEN p.OscarComm    = 1 THEN a.OscarComm  ELSE '99999' END as OscarComm
--	,CASE WHEN p.Other		  = 1 THEN a.Other		ELSE '99999' END as Other
--	,a.Total
--	,CASE WHEN p.CignaMA	     = 0 THEN 0				ELSE a.CignaMA END 
--	+CASE WHEN p.AetnaMA	     = 0 THEN 0				ELSE a.AetnaMA END 
--	+CASE WHEN p.MSSP				= 0 THEN 0				ELSE a.MSSP END 
--	as sumTest
--FROM CTE_PR	p
--LEFT JOIN CTE  a
--	ON  p.PR_NPI		= a.MbrNPI
---

SELECT DISTINCT p.PR_NPI as AttribNPI , u.AttribPCPName as AttribNPIName, u.AccountType
	,CASE WHEN p.UHCMcaid     = 1 THEN a.UHCMcaid   ELSE '-' END as UHCMcaid
	,CASE WHEN p.MSSP		     = 1 THEN a.MSSP		   ELSE '-' END as MSSP
	,CASE WHEN p.AetnaMA      = 1 THEN a.AetnaMA    ELSE '-' END as AetnaMA
	,CASE WHEN p.CignaMA	     = 1 THEN a.CignaMA	   ELSE '-' END as CignaMA
	,CASE WHEN p.DevotedMA    = 1 THEN a.DevotedMA  ELSE '-' END as DevotedMA
	,CASE WHEN p.WellcareMA   = 1 THEN a.WellcareMA ELSE '-' END as WellcareMA
	,CASE WHEN p.AetnaComm    = 1 THEN a.AetnaComm  ELSE '-' END as AetnaComm
	,CASE WHEN p.BCBSComm     = 1 THEN a.BCBSComm   ELSE '-' END as BCBSComm
	,CASE WHEN p.OscarComm    = 1 THEN a.OscarComm  ELSE '-' END as OscarComm
	,CASE WHEN p.Other		  = 1 THEN a.Other		ELSE '-' END as Other
	,a.Total
FROM CTE_Tmp	p
LEFT JOIN CTE a		-- Use CTE_PR for Roster, CTE_Tmp for all NPI
ON		a.MbrNPI = p.PR_NPI
LEFT JOIN CTE_UR	u
ON		p.PR_NPI	=	u.AttribNPI
WHERE a.MbrNPI IS NOT NULL
UNION
SELECT 'Total','',''
	,SUM(UHCMcaid  ) as UHCMcaid
	,SUM(MSSP		) as MSSP
	,SUM(AetnaMA   ) as AetnaMA
	,SUM(CignaMA	) as CignaMA
	,SUM(DevotedMA ) as DevotedMA
	,SUM(WellcareMA) as WellcareMA
	,SUM(AetnaComm ) as AetnaComm
	,SUM(BCBSComm  ) as BCBSComm
	,SUM(OscarComm ) as OscarComm
	,SUM(Other )		as Other
	,SUM(UHCMcaid  ) 
		+SUM(MSSP		) 
		+SUM(AetnaMA   ) 
		+SUM(CignaMA	) 
		+SUM(DevotedMA ) 
		+SUM(WellcareMA) 
		+SUM(AetnaComm ) 
		+SUM(BCBSComm  ) 
		+SUM(OscarComm ) 
		+SUM(Other )		
FROM CTE a

--select NPI, HealthPlan, LOB FROM adw.fctProviderRoster where NPI = '1932664091' --and GETDATE() BETWEEN RowEffectiveDate AND RowExpirationDate
--select distinct GroupName FROM adw.fctProviderRoster WHERE TIN = '134334288'
/***
Usage:
SELECT * FROM adw.z_vw_Dashboard_Membership_Pivot 
***/


 


