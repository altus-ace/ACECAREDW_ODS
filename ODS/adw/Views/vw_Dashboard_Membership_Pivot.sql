

/***
04.22.2021 Version 4	Change [adw].[tvf_AllClient_ProviderRoster_DevPR_ByClient] to adw.tvf_AllClient_ProviderRoster
06.02.2021 Version 5	Add AmerigroupMA and AmerigroupMedicaid
06.02.2021 Version 5 Changed adw.fctProviderRoster_DevPR to adw.tvf_AllClient_ProviderRoster

SELECT * FROM [adw].[tvf_AllClient_ProviderRoster] (0,getdate(),1)		WHERE NPI = '1003074881'
SELECT * FROM [adw].[tvf_AllClient_ProviderRoster_DevPR_ByClient] (0)	WHERE NPI = '1003074881'

Usage:
adw.tvf_AllClient_ProviderRoster(0, '04/12/2021', 1) ClientKey,EffectDate,IsActive
***/

CREATE VIEW [adw].[vw_Dashboard_Membership_Pivot]
AS

WITH CTE AS (			-- Attributed Memberhip by MCO
SELECT AttribNPI AS MbrNPI 
	,SUM(UHCMedicaid  ) as UHCMedicaid
	,SUM(MSSP			) as MSSP
	,SUM(AetnaMA		) as AetnaMA
	,SUM(CignaMA		) as CignaMA
	,SUM(DevotedMA		) as DevotedMA
	,SUM(WellcareMA	) as WellcareMA
	,SUM(AetnaComm		) as AetnaComm
	,SUM(BCBSComm		) as BCBSComm
	,SUM(AmerigroupMA				) as AmerigroupMA
	,SUM(AmerigroupMedicaid		) as AmerigroupMedicaid
	,SUM(Other			) as Other
	,SUM(UHCMedicaid	)
	+SUM(MSSP			)
	+SUM(AetnaMA		)
	+SUM(CignaMA		)
	+SUM(DevotedMA		)
	+SUM(WellcareMA	)
	+SUM(AetnaComm		)
	+SUM(BCBSComm		)
	+SUM(AmerigroupMA				)
	+SUM(AmerigroupMedicaid		)
	+SUM(Other			)	as Total
	,RowEffectiveDate
	,RowExpirationDate
	--INTO #tmpCTE
FROM (
	SELECT EffYYYYMM, AttribNPI,ClientName --, n.AccountType, n.PracticeTIN, n.PracticeName
			,CASE WHEN ClientKey = 1  THEN SUM(MbrCnt) ELSE 0 END as UHCMedicaid
			,CASE WHEN ClientKey = 2  THEN SUM(MbrCnt) ELSE 0 END as WellcareMA
			,CASE WHEN ClientKey = 3  THEN SUM(MbrCnt) ELSE 0 END as AetnaMA
			,CASE WHEN ClientKey = 9  THEN SUM(MbrCnt) ELSE 0 END as AetnaComm
			,CASE WHEN ClientKey = 11 THEN SUM(MbrCnt) ELSE 0 END as DevotedMA
			,CASE WHEN ClientKey = 12 THEN SUM(MbrCnt) ELSE 0 END as CignaMA
			,CASE WHEN ClientKey = 16 THEN SUM(MbrCnt) ELSE 0 END as MSSP
			,CASE WHEN ClientKey = 20 THEN SUM(MbrCnt) ELSE 0 END as BCBSComm
			,CASE WHEN ClientKey = 21 THEN SUM(MbrCnt) ELSE 0 END as AmerigroupMA
			,CASE WHEN ClientKey = 22 THEN SUM(MbrCnt) ELSE 0 END as AmerigroupMedicaid
			,CASE WHEN ClientKey NOT IN (1,2,3,9,11,12,16,20,21,22) THEN SUM(MbrCnt) ELSE 0 END as Other
			,RowEffectiveDate
			,RowExpirationDate
	FROM (			
		SELECT * FROM (
			SELECT m.ClientName																as ClientName
		      ,m.ClientKey
		      ,1																					as MbrCnt
				,CASE WHEN m.AttribNPI IS NULL THEN '1111111111' ELSE CASE WHEN m.AttribNPI <> 0 THEN m.AttribNPI ELSE '1111111111' END END as AttribNPI
		      --,m.AttribNPI																	as AttribNPI
				,m.EffYYYYMM																	as EffYYYYMM
				,m.EffectiveAsOfDate															as RowEffectiveDate
				,'2099-12-31'																	as RowExpirationDate
				,ROW_NUMBER() OVER (PARTITION BY ClientKey, ClientMemberKey ORDER BY EffectiveAsOfDate DESC) as rn
			FROM dbo.z_tmp_AttribMembers_FINAL m WHERE EffectiveAsOfDate = (SELECT MAX(EffectiveAsOfDate) FROM dbo.z_tmp_AttribMembers_FINAL m)														-- Most Current Attrib Members
			AND EffYYYYMM = (SELECT MAX(EffYYYYMM) FROM dbo.z_tmp_AttribMembers_FINAL WHERE EffectiveAsOfDate = (SELECT MAX(EffectiveAsOfDate) FROM dbo.z_tmp_AttribMembers_FINAL))		-- Most Current Attrib Members
		) x WHERE rn = 1 -- eliminates duplicates, if any
			) n
	GROUP BY EffYYYYMM, RowEffectiveDate, RowExpirationDate, AttribNPI, ClientKey, ClientName
	) a
GROUP BY RowEffectiveDate, RowExpirationDate, AttribNPI 
)
, CTE_PR_EXC AS	-- Provider Roster by MCO, includes NPI in CTE that are not in CTE_PR
(
SELECT RowEffectiveDate, RowExpirationDate, MbrNPI as MbrNPI, 0 as ActiveFlg
	,CASE WHEN UHCMedicaid	= 0 THEN 0 ELSE 1 END as UHCMedicaid
	,CASE WHEN MSSP			= 0 THEN 0 ELSE 1 END as MSSP
	,CASE WHEN AetnaMA		= 0 THEN 0 ELSE 1 END as AetnaMA
	,CASE WHEN CignaMA		= 0 THEN 0 ELSE 1 END as CignaMA
	,CASE WHEN DevotedMA		= 0 THEN 0 ELSE 1 END as DevotedMA
	,CASE WHEN WellcareMA	= 0 THEN 0 ELSE 1 END as WellcareMA
	,CASE WHEN AetnaComm		= 0 THEN 0 ELSE 1 END as AetnaComm
	,CASE WHEN BCBSComm		= 0 THEN 0 ELSE 1 END as BCBSComm
	,CASE WHEN AmerigroupMA				= 0 THEN 0 ELSE 1 END as AmerigroupMA
	,CASE WHEN AmerigroupMedicaid		= 0 THEN 0 ELSE 1 END as AmerigroupMedicaid
	,CASE WHEN Other			= 0 THEN 0 ELSE 1 END as Other
	,9															 as Total
	--INTO #tmpCTE_PR_EXC
FROM CTE WHERE MbrNPI IN (
	SELECT DISTINCT MbrNPI FROM CTE
	EXCEPT
	SELECT DISTINCT NPI FROM adw.tvf_AllClient_ProviderRoster (0,getdate(),1))				-- Most Current Provider Roster
) 
, CTE_PR AS			-- Provider Roster by MCO
(
SELECT RowEffectiveDate,RowExpirationDate, PR_NPI, 1 as ActiveFlg									-- Associated with HP, 1 - yes, 0 - no
	,SUM(UHCMedicaid  )	as UHCMedicaid
	,SUM(MSSP		)		as MSSP
	,SUM(AetnaMA   )		as AetnaMA
	,SUM(CignaMA	)		as CignaMA
	,SUM(DevotedMA )		as DevotedMA
	,SUM(WellcareMA)		as WellcareMA
	,SUM(AetnaComm )		as AetnaComm
	,SUM(BCBSComm  )		as BCBSComm
	,SUM(AmerigroupMA				) as AmerigroupMA
	,SUM(AmerigroupMedicaid		) as AmerigroupMedicaid
	,SUM(Other )			as Other
	,SUM(UHCMedicaid ) 
	+SUM(MSSP		)	
	+SUM(AetnaMA   )	
	+SUM(CignaMA	)	
	+SUM(DevotedMA )	
	+SUM(WellcareMA)	
	+SUM(AetnaComm )	
	+SUM(BCBSComm  )	
	+SUM(AmerigroupMA				)
	+SUM(AmerigroupMedicaid		)
	+SUM(Other )			as Total
	--INTO #tmpCTE_PR
FROM (
		SELECT DISTINCT NPI															as PR_NPI
			,CASE WHEN ClientKey = 1  THEN 1 ELSE 0 END as UHCMedicaid
			,CASE	WHEN ClientKey = 2  THEN 1 ELSE 0 END as WellcareMA
			,CASE	WHEN ClientKey = 3  THEN 1 ELSE 0 END as AetnaMA
			,CASE	WHEN ClientKey = 9  THEN 1 ELSE 0 END as AetnaComm
			,CASE	WHEN ClientKey = 11 THEN 1 ELSE 0 END as DevotedMA
			,CASE	WHEN ClientKey = 12 THEN 1 ELSE 0 END as CignaMA
			,CASE	WHEN ClientKey = 16 THEN 1 ELSE 0 END as MSSP
			,CASE	WHEN ClientKey = 20 THEN 1 ELSE 0 END as BCBSComm
			,CASE	WHEN ClientKey = 21 THEN 1 ELSE 0 END as AmerigroupMA
			,CASE	WHEN ClientKey = 22 THEN 1 ELSE 0 END as AmerigroupMedicaid
			,CASE	WHEN ClientKey NOT IN (1,2,3,9,11,12,16,20,21,22) THEN 1 ELSE 0 END as Other
			,RowEffectiveDate, RowExpirationDate
			FROM adw.tvf_AllClient_ProviderRoster (0,getdate(),1)
			WHERE NPI <> '1111111111'
			AND ClientKey <> 0
			--ORDER BY NPI
		) c
GROUP BY PR_NPI, RowEffectiveDate, RowExpirationDate
UNION SELECT '1900-01-01','2099-12-31','1111111111',1,1,1,1,1,1,1,1,1,1,1,1,9
--UNION SELECT '1900-01-01','2099-12-31','1174522031',0,1,1,1,1,1,1,1,1,1,1,1,9	-- MSSP
--UNION SELECT '1900-01-01','2099-12-31','1477872505',0,1,1,1,1,1,1,1,1,1,1,1,9	-- MSSP
--UNION SELECT '1900-01-01','2099-12-31','1891104659',0,1,1,1,1,1,1,1,1,1,1,1,9	-- MSSP
--UNION SELECT '1900-01-01','2099-12-31','1790998706',1,1,1,1,1,1,1,1,1,1,1,1,9	-- WLC
--UNION SELECT '1900-01-01','2099-12-31','1821409780',1,1,1,1,1,1,1,1,1,1,1,1,9	-- WLC
--UNION SELECT '1900-01-01','2099-12-31','1912084120',1,1,1,1,1,1,1,1,1,1,1,1,9	-- WLC
--UNION SELECT '1900-01-01','2099-12-31','1932225679',1,1,1,1,1,1,1,1,1,1,1,1,9	-- WLC
UNION SELECT * FROM CTE_PR_EXC																						-- Get NPIs that are in Members but not in PR
), CTE_PR_D AS																												-- Used to get the latest Info for the NPI, based on Most Current Provider Roster, duplicate NPIs
(
	SELECT * 
		--INTO #tmpCTE_PR_D 
	FROM (
	SELECT DISTINCT ClientKey, NPI, CONCAT(LastName,',',FirstName) as FullName,CASE WHEN AccountType IN ('SHCN_SMG','SHCN_AFF') THEN AccountType ELSE 'ACE' END as AcctType, Chapter, AttribTIN as TIN
		,ROW_NUMBER() OVER (PARTITION BY NPI, ClientKey ORDER BY fctProviderRosterSkey DESC) as rn
	FROM ACECAREDW.adw.tvf_AllClient_ProviderRoster (0,getdate(),1)) m WHERE rn = 1 AND ClientKey IN (1,2,3,9,11,12,16,20,21,22)
--Replaced on 06.02.2021
--SELECT DISTINCT NPI 
--	,CONCAT(LastName,',',FirstName) as FullName, CASE WHEN AccountType IN ('SHCN_SMG','SHCN_AFF') THEN AccountType ELSE 'ACE' END as AcctType, Chapter, TIN --, GroupName
--FROM adw.fctProviderRoster_DevPR PR																					-- Most Current Provider Roster
--	WHERE GetDate() BETWEEN RowEffectiveDate AND RowExpirationDate
--	AND IsActive = 1 AND ClientKey <> 0
--	--OR NPI IN (SELECT REPLACE(MbrNPI,'*','') FROM CTE_PR_EXC))
--GROUP BY NPI, LastName, FirstName, AccountType, Chapter, TIN --, GroupName
), CTE_PR_S AS																												-- Used to get the latest Info for the NPI, based on Most Current Provider Roster, distinct NPIs
(
SELECT NPI as PR_NPI
	,FullName = STUFF((
		SELECT DISTINCT '; ' + FullName FROM CTE_PR_D t1
		WHERE t1.NPI = t2.NPI
		FOR XML PATH('')) , 1, 1, '')
	,AcctType = STUFF((
		SELECT DISTINCT '; ' + AcctType FROM CTE_PR_D t1
		WHERE t1.NPI = t2.NPI
		FOR XML PATH('')) , 1, 1, '')
	,Chapter = STUFF((
		SELECT DISTINCT '; ' + Chapter FROM CTE_PR_D t1
		WHERE t1.NPI = t2.NPI
		FOR XML PATH('')) , 1, 1, '')
	,Practice = STUFF((
		SELECT DISTINCT '; ' + TIN FROM CTE_PR_D t1
		WHERE t1.NPI = t2.NPI
		FOR XML PATH('')) , 1, 1, '')
		FROM CTE_PR_D t2
GROUP BY NPI
UNION
SELECT MbrNPI,'*','*','*','*' FROM CTE_PR_EXC
)
-- Main
SELECT EffectiveAsOfDate, AttribNPI, MbrNPI, NPIMatchFlg, ActiveFlg, s.FullName, s.AcctType, s.Chapter, s.Practice
	,CASE WHEN UHCMedicaid IS NULL THEN 0 ELSE UHCMedicaid  END as UHCMedicaid						-- NPI is associated with Client but does not have any members
	,CASE WHEN MSSP		  IS NULL THEN 0 ELSE MSSP		 	  END as MSSP		 
	,CASE WHEN AetnaMA	  IS NULL THEN 0 ELSE AetnaMA	 	  END as AetnaMA	 
	,CASE WHEN CignaMA	  IS NULL THEN 0 ELSE CignaMA	 	  END as CignaMA	 
	,CASE WHEN DevotedMA	  IS NULL THEN 0 ELSE DevotedMA	  END as DevotedMA	 
	,CASE WHEN WellcareMA  IS NULL THEN 0 ELSE WellcareMA   END as WellcareMA 
	,CASE WHEN AetnaComm	  IS NULL THEN 0 ELSE AetnaComm	  END as AetnaComm	 
	,CASE WHEN BCBSComm	  IS NULL THEN 0 ELSE BCBSComm	  END as BCBSComm	 
	,CASE WHEN AmerigroupMA				IS NULL THEN 0 ELSE AmerigroupMA	  END as  AmerigroupMA	 
	,CASE WHEN AmerigroupMedicaid		IS NULL THEN 0 ELSE AmerigroupMedicaid	  END as AmerigroupMedicaid
	,CASE WHEN Other		  IS NULL THEN 0 ELSE Other		  END as Other		 
	,CASE WHEN Total		  IS NULL THEN 0 ELSE Total		  END as Total
FROM (
		SELECT DISTINCT d.EffectiveDate as EffectiveAsOfDate, a.MbrNPI, p.PR_NPI as AttribNPI, p.ActiveFlg
			,CASE WHEN p.UHCMedicaid   = 0 THEN '99999' ELSE a.UHCMedicaid	 END as UHCMedicaid  -- NPI is not associated with Client
			,CASE WHEN p.MSSP				= 0 THEN '99999' ELSE a.MSSP			 END as MSSP
			,CASE WHEN p.AetnaMA			= 0 THEN '99999' ELSE a.AetnaMA		 END as AetnaMA
			,CASE WHEN p.CignaMA			= 0 THEN '99999' ELSE a.CignaMA		 END as CignaMA
			,CASE WHEN p.DevotedMA		= 0 THEN '99999' ELSE a.DevotedMA	 END as DevotedMA
			,CASE WHEN p.WellcareMA		= 0 THEN '99999' ELSE a.WellcareMA	 END as WellcareMA
			,CASE WHEN p.AetnaComm		= 0 THEN '99999' ELSE a.AetnaComm	 END as AetnaComm
			,CASE WHEN p.BCBSComm		= 0 THEN '99999' ELSE a.BCBSComm		 END as BCBSComm
			,CASE WHEN p.AmerigroupMA		= 0 THEN '99999' ELSE a.AmerigroupMA		 END as AmerigroupMA
			,CASE WHEN p.AmerigroupMedicaid		= 0 THEN '99999' ELSE a.AmerigroupMedicaid	 END as AmerigroupMedicaid
			,CASE WHEN p.Other			= 0 THEN '99999' ELSE a.Other			 END as Other
			,a.Total
			,CASE WHEN a.MbrNPI IS NULL THEN 0 ELSE 1			 END as NPIMatchFlg						-- NPIMatchFlg = 0 if no match between PR and Membership
		FROM CTE_PR	p
		LEFT JOIN CTE  a 	ON  p.PR_NPI		= a.MbrNPI
		CROSS JOIN (SELECT MAX(RowEffectiveDate) as EffectiveDate FROM CTE) d
		) m
LEFT JOIN CTE_PR_S s ON m.AttribNPI	 = s.PR_NPI
/***
Usage:
SELECT EffectiveAsOfDate, AttribNPI, FullName, AcctType, Chapter, Practice
	,REPLACE(REPLACE (UHCMedicaid,99999,'-')	,99998,'0')				as UHCMedicaid	
	,REPLACE(REPLACE (MSSP,99999,'-') 			,99998,'0')				as MSSP		 
	,REPLACE(REPLACE (AetnaMA,99999,'-') 		,99998,'0')				as AetnaMA	 
	,REPLACE(REPLACE (CignaMA,99999,'-') 		,99998,'0')				as CignaMA	 
	,REPLACE(REPLACE (DevotedMA,99999,'-') 	,99998,'0')				as DevotedMA	
	,REPLACE(REPLACE (WellcareMA,99999,'-') 	,99998,'0')				as WellcareMA 
	,REPLACE(REPLACE (AetnaComm,99999,'-') 	,99998,'0')				as AetnaComm	
	,REPLACE(REPLACE (BCBSComm,99999,'-') 		,99998,'0')				as BCBSComm	 
	,REPLACE(REPLACE (AmerigroupMA,99999,'-') 				,99998,'0')				as AmerigroupMA
	,REPLACE(REPLACE (AmerigroupMedicaid ,99999,'-') 		,99998,'0')				as AmerigroupMedicaid 
	,REPLACE(REPLACE (Other,99999,'-') 			,99998,'0')				as Other		 
	,REPLACE(REPLACE (Total,99999,'-') 			,99998,'0')				as Total
FROM adw.vw_Dashboard_Membership_Pivot p
ORDER BY FullName

SELECT	 MbrNPI
			,Sum(UHCMedicaid)		as UHCMedicaid
			,Sum(MSSP		 	)	as MSSP		 
			,Sum(AetnaMA	 	)	as AetnaMA	 
			,Sum(CignaMA	 	)	as CignaMA	 
			,Sum(DevotedMA	)		as DevotedMA	
			,Sum(WellcareMA )		as WellcareMA 
			,Sum(AetnaComm	)		as AetnaComm	
			,Sum(BCBSComm	)		as BCBSComm	  
			,Sum(Other		)		as Other		  
			,Sum(Total		)		as Total
FROM #tmpCTE m
JOIN adw.tvf_AllClient_ProviderRoster (16,getdate(),1) p
ON m.MbrNPI = p.NPI
GROUP BY MbrNPI

SELECT * FROM #tmpCTE_PR where PR_npi  in ( '1023029287','1427230614','1104808765','1326208257')
SELECT * FROM #tmpCTE WHERE MbrNPI = '1932225679'
SELECT * FROM #tmpCTE_PR_EXC WHERE MbrNPI = '1932225679'

SELECT * FROM #tmpCTE
SELECT * FROM #tmpCTE_PR_EXC
SELECT * FROM #tmpCTE_PR	WHERE pr_NPI = '1740642172'

SELECT * FROM #tmpCTE_PR_D WHERE NPI = '1740642172'
SELECT *
FROM adw.tvf_AllClient_ProviderRoster (0,getdate(),0)
WHERE NPI = '1740642172'
***/

