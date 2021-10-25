

CREATE VIEW   vw_Dashboard_CONS_KPIByNPISummary
AS
    /* Creator: JK/NC
	   Date: 10/21/2021
	   Objective: This view is for consolidated KPIs (MMSP/BCBS/UHC)
	 */
	
 
SELECT DISTINCT  --MSSP KPI SUMMARY
	  '16' as ClientKey
	  ,'MSSP' as Client
	  ,[EffectiveAsOfDate]
      ,[KPIEffYear]
      ,[KPIEffMth]
      ,[AttribNPI]
      ,[AttribNPIName]
      ,[AttribTIN]
      ,[AttribTINName]
      ,KPI.[Chapter]
	  ,PR.AccountType
      ,[MbrMths]
      ,[Admits]
      ,[AdmitsPK]
      ,[ALOS]
      ,[BedDays]
      ,[BedDaysPK]
      ,[EDVisits]
      ,[EDVisitsPK]
      ,[EDToIPVisits]
      ,[EDToIPVisitsPK]
      ,[Readmissions]
      ,[ReadmissionsPK]
      ,[HospiceVisits]
      ,[HospiceVisitsPK]
      ,[HHAVisits]
      ,[HHAVisitsPK]
      ,[LTACVisits]
      ,[LTACVisitsPK]
      ,[IRFVisits]
      ,[IRFVisitsPK]
      ,[SNFAdmits]
      ,[SNFAdmitsPK]
      ,[SNFDays]
      ,[SNFDaysPK]
      ,[SNFLOSPref]
      ,[SNFLOSPrefPK]
      ,[SNFLOSNonPref]
      ,[SNFLOSNonPrefPK]
      ,[AWV]
      ,[AWVPct]
      ,[AWVSeen]
      ,[AWVSeenPct]
      ,[TME]
      ,[PMPM]
  FROM [ACDW_CLMS_SHCN_MSSP].[adw].[vw_Dashboard_ME_KPIByNPISummary] KPI
  LEFT JOIN (SELECT DISTINCT NPI,Chapter,AccountType FROM
		 ACECAREDW.[adw].[tvf_AllClient_ProviderRoster] (16, GETDATE(),1)) PR
				ON KPI.AttribNPI = PR.NPI
            
UNION ALL -- BCBS KPI SUMMARY

SELECT DISTINCT
	  '20' as ClientKey
	  ,'BCBS' as Client
      ,[EffectiveAsOfDate]
      ,[KPIEffYear]
      ,[KPIEffMth]
      ,[AttribNPI]
      ,[AttribNPIName]
      ,[AttribTIN]
      ,[AttribTINName]
      ,KPI.[Chapter]
	  ,PR.AccountType
      ,[MbrMths]
      ,[Admits]
      ,[AdmitsPK]
      ,[ALOS]
      ,[BedDays]
      ,[BedDaysPK]
      ,[EDVisits]
      ,[EDVisitsPK]
      ,[EDToIPVisits]
      ,[EDToIPVisitsPK]
      ,[Readmissions]
      ,[ReadmissionsPK]
      ,[HospiceVisits]
      ,[HospiceVisitsPK]
      ,[HHAVisits]
      ,[HHAVisitsPK]
      ,[LTACVisits]
      ,[LTACVisitsPK]
      ,[IRFVisits]
      ,[IRFVisitsPK]
      ,[SNFAdmits]
      ,[SNFAdmitsPK]
      ,[SNFDays]
      ,[SNFDaysPK]
      ,[SNFLOSPref]
      ,[SNFLOSPrefPK]
      ,[SNFLOSNonPref]
      ,[SNFLOSNonPrefPK]
      ,[AWV]
      ,[AWVPct]
      ,[AWVSeen]
      ,[AWVSeenPct]
      ,[TME]
      ,[PMPM]
  FROM [ACDW_CLMS_SHCN_BCBS].[adw].[vw_Dashboard_ME_KPIByNPISummary] KPI
    LEFT JOIN (SELECT DISTINCT NPI,Chapter,AccountType FROM
		 ACECAREDW.[adw].[tvf_AllClient_ProviderRoster] (20, GETDATE(),1)) PR
				ON KPI.AttribNPI = PR.NPI


UNION ALL --UHC KPI SUMMARY

SELECT DISTINCT
	  '1' as ClientKey
	  ,'UHC' as Client
      ,[EffectiveAsOfDate]
      ,[KPIEffYear]
      ,[KPIEffMth]
      ,[AttribNPI]
      ,[AttribNPIName]
      ,[AttribTIN]
      ,[AttribTINName]
      ,KPI.[Chapter]
	  ,PR.AccountType
      ,[MbrMths]
      ,[Admits]
      ,[AdmitsPK]
      ,[ALOS]
      ,[BedDays]
      ,[BedDaysPK]
      ,[EDVisits]
      ,[EDVisitsPK]
      ,[EDToIPVisits]
      ,[EDToIPVisitsPK]
      ,[Readmissions]
      ,[ReadmissionsPK]
      ,[HospiceVisits]
      ,[HospiceVisitsPK]
      ,[HHAVisits]
      ,[HHAVisitsPK]
      ,[LTACVisits]
      ,[LTACVisitsPK]
      ,[IRFVisits]
      ,[IRFVisitsPK]
      ,[SNFAdmits]
      ,[SNFAdmitsPK]
      ,[SNFDays]
      ,[SNFDaysPK]
      ,[SNFLOSPref]
      ,[SNFLOSPrefPK]
      ,[SNFLOSNonPref]
      ,[SNFLOSNonPrefPK]
      ,[AWV]
      ,[AWVPct]
      ,[AWVSeen]
      ,[AWVSeenPct]
      ,[TME]
      ,[PMPM]
  FROM [ACDW_CLMS_UHC].[adw].[vw_Dashboard_ME_KPIByNPISummary] KPI
    LEFT JOIN (SELECT DISTINCT NPI,Chapter,AccountType FROM
		 ACECAREDW.[adw].[tvf_AllClient_ProviderRoster] (1, GETDATE(),1)) PR
				ON KPI.AttribNPI = PR.NPI


