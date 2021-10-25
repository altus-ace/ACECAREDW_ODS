




CREATE VIEW [dbo].[VW_RP_SJMC_IP_Trends_Dev]
AS
    /*  OBJECTIVE: get claims and Ntf for all UHC IP Admits, for the targetd list of facilities */
     -- from claims
	/* change log:
	   11/04/2020: GK: for JK: added filters for patienttype and ntfsource 
	*/
     SELECT DISTINCT 
            'UHC' AS Client, 
		  ClmHdr.subscriber_id as Member_id, 
            ClmHdr.VEND_FULL_NAME, 
            Mbrs.pcp_practice_name,
		  COUNT(DISTINCT CONCAT (ClmHdr.subscriber_id, ClmHdr.PRIMARY_SVC_DATE)) AS IP_Visits,
            ClmHdr.PRIMARY_SVC_DATE AS VisitDate, 
            ClmHdr.ICD_PRIM_DIAG AS Prim_diag_code,
		  case when IcdCcs.MULTI_CCS_LVL1_LABEL is not null 
			 then  first_value(IcdCcs.MULTI_CCS_LVL1_LABEL) over(partition by IcdCcs.MULTI_CCS_LVL1_LABEL order by ClmHdr.ICD_PRIM_DIAG desc) 
			 end AS CCS_Desc, 
            'UHC_Claims' Src
     FROM ACECAREDW_TEST.dbo.claims_headers ClmHdr
          JOIN ACECAREDW.dbo.Uhc_MembersbyPCP Mbrs     -- THIS IS ONLY FOR ACE MEMBERS ADMITS TO THE TRAGET FACILTY LIST 
		  ON Mbrs.uhc_subscriber_id = ClmHdr.subscriber_id 
			 and month(ClmHdr.primary_svc_date) = month(Mbrs.A_last_update_date) 
			 and YEAR(ClmHdr.primary_svc_date) = YEAR(Mbrs.a_last_update_date)
          LEFT JOIN acecaredw_test.[dbo].[ICDCCS] IcdCcs
		  ON LEFT(IcdCcs.[ICD-10-CM_CODE], 4) = replace(LEFT(ClmHdr.ICD_PRIM_DIAG, 5), '.', '')
     WHERE ClmHdr.CATEGORY_OF_SVC = 'INPATIENT'
                 AND ClmHdr.VEND_FULL_NAME IN( 'TEXAS CHILDREN''S HOSPITAL','WOMANS HOSPITAL OF TEXAS LP','ST JOSEPH MEDICAL CENTER LLC'
           ,'PARK PLAZA HOSPITAL','HARRIS COUNTY HOSPITAL DISTRICT','ST LUKES MEDICAL CENTER','CHI ST LUKES BAYLOR COL'
           ,'MEMORIAL MEDICAL CENTER','MHHS HERMANN HOSPITAL','MEMORIAL HERMANN MEDICAL GROUP','METHODIST HOSPITAL','BEN TAUB HOSPITAL'
           ,'ST JOSEPH MEDICAL CENTER', 'ST JOSEPH MEDICAL CENTER LLC', 'ST JOSEPH REGIONAL HEALTH CENTER', 'ST JOSEPHS HOSP & MEDICAL CTR'
           , 'ST JOSEPHS HOSPITAL INC')
           AND YEAR(PRIMARY_SVC_DATE) >= 2018
     GROUP BY ClmHdr.Subscriber_id, 
		    ClmHdr.VEND_FULL_NAME, 
              Mbrs.pcp_practice_name, 
              --Mbrs.prov_type, 
              --Mbrs.prov_spec, 
              ClmHdr.PRIMARY_SVC_DATE, 
              ClmHdr.ICD_PRIM_DIAG, 
              IcdCcs.MULTI_CCS_LVL1_LABEL
     UNION
     -- from IP census
     SELECT DISTINCT 
            'UHC' AS Client, 			
		  Ntf.ClientMemberKey as Member_id, 
            Ntf.AdmitHospital AS VEND_FULL_NAME, 
            Mbrs.pcp_practice_name, 
		  count(DISTINCT CONCAT (Ntf.ClientMemberKey, CONVERT(DATE, NTF.[AdmitDateTime]))) AS IP_Visits, 
            Ntf.ActualDischargeDate AS VisitDate, 
            Ntf.DiagnosisCode AS Prim_diag_code, 
            IcdCcs.MULTI_CCS_LVL1_LABEL AS CCS_Desc,            
            'Adw.NtfNotifications' Src
     FROM ACECAREDW.adw.NtfNotification Ntf
          JOIN ACECAREDW.dbo.Uhc_MembersbyPCP Mbrs 
		  ON Mbrs.uhc_subscriber_id = Ntf.ClientMemberKey
			 and month(Ntf.ActualDischargeDate) = month(Mbrs.A_last_update_date) 
			 and YEAR(Ntf.ActualDischargeDate) = YEAR(Mbrs.a_last_update_date)
          LEFT JOIN acecaredw_test.[dbo].[ICDCCS] IcdCcs 
		  ON LEFT(IcdCcs.[ICD-10-CM_CODE], 4) = replace(LEFT(Ntf.DiagnosisCode, 5), '.', '')
     WHERE Ntf.ActualDischargeDate >= '1/1/2018'
	     AND ntf.AdmitHospital IN('ST JOSEPH MEDICAL CENTER','ST JOSEPH REGIONAL HEALTH','ST JOSEPH REGIONAL HEALTH CENTER',
			 'ST JOSEPH HOSPITAL','ST JOSEPH MEDICAL CENTER-TX','TEXAS CHILDRENS HOSP','WOMANS HOSPITAL OF TEXAS',
			 'PARK PLAZA HOSPITAL','HARRIS CNTY HOSP DIST','CHI St. Lukes Health Baylor College of,HO',
			 'MHHS HERMANN HOSPITAL','Memorial Hermann Hospital','METHODIST HOSPITAL','BEN TAUB HOSPITAL',
			 'MEMORIAL MEDICAL CENTER LIVINGSTON','CHI ST LUKES - MEDICAL CENTER' )
           AND ntf.ActualDischargeDate is not Null	
		 And ntf.ClientKey = 1 -- limit to UHC to match claims	   
		 AND ntf.ntfsource in ('GHH','uhcIP')
		 AND ntf.ntfpatienttype = 'IP'
     GROUP BY Ntf.ClientMemberKey,
		  Ntf.ActualDischargeDate, 
		  Mbrs.PCP_PRACTICE_NAME, 
		  Ntf.AdmitHospital, 
            Ntf.DiagnosisCode, 
		  IcdCcs.MULTI_CCS_LVL1_LABEL
    ;
