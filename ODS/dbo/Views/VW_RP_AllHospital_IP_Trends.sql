CREATE VIEW [dbo].[VW_RP_AllHospital_IP_Trends]
AS
     -- from claims
     SELECT DISTINCT 
            'UHC' AS Client, 
			subscriber_id as Member_id, 
            VEND_FULL_NAME, 
            b.pcp_practice_name,
            COUNT(DISTINCT subscriber_id) AS IP_Visits, 
            PRIMARY_SVC_DATE AS VisitDate, 
            ICD_PRIM_DIAG AS Prim_diag_code, 
--			ee.MULTI_CCS_LVL1_LABEL,
     case when ee.MULTI_CCS_LVL1_LABEL is not null then  first_value(ee.MULTI_CCS_LVL1_LABEL) over(partition by MULTI_CCS_LVL1_LABEL order by ICD_PRIM_DIAG desc) end AS CCS_Desc, 
            'UHC_Claims' Src
     FROM ACECAREDW_TEST.dbo.claims_headers a
          JOIN ACECAREDW.dbo.Uhc_MembersbyPCP b ON b.uhc_subscriber_id = a.subscriber_id and month(a.primary_svc_date) = month(A_last_update_date) and YEAR(a.primary_svc_date) = YEAR(a_last_update_date)
          LEFT JOIN acecaredw_test.[dbo].[ICDCCS] ee ON LEFT(ee.[ICD-10-CM_CODE], 4) = replace(LEFT(A.ICD_PRIM_DIAG, 5), '.', '')
     WHERE CATEGORY_OF_SVC = 'INPATIENT'                
           AND YEAR(PRIMARY_SVC_DATE) >= 2018
     GROUP BY Subscriber_id, 
				VEND_FULL_NAME, 
              b.pcp_practice_name, 
              prov_type, 
              prov_spec, 
              PRIMARY_SVC_DATE, 
              ICD_PRIM_DIAG, 
              MULTI_CCS_LVL1_LABEL
     UNION
     -- from IP census
     SELECT DISTINCT 
            'UHC' AS Client, 			
			UHC_SUBSCRIBER_ID as Member_id, 
            HospitalName AS VEND_FULL_NAME, 
            b.pcp_practice_name, 
            count(DISTINCT patientidentifier) AS IP_Visits, 
            DischargeDate AS VisitDate, 
            PrimaryDiagnosisCode AS Prim_diag_code, 
            ee.MULTI_CCS_LVL1_LABEL AS CCS_Desc,
            --          CAST(concat(MONTH(AdmissionDate), '-01-', YEAR(AdmissionDate)) AS DATE) AS VisitMonth, 
            'UHC_IP_Census' Src
     FROM ACECAREDW.adi.ntfuhcipcensus a
          JOIN ACECAREDW.dbo.Uhc_MembersbyPCP b ON b.uhc_subscriber_id = a.PatientIdentifier and month(a.DischargeDate) = month(A_last_update_date) and YEAR(a.DischargeDate) = YEAR(a_last_update_date)
          LEFT JOIN acecaredw_test.[dbo].[ICDCCS] ee ON LEFT(ee.[ICD-10-CM_CODE], 4) = replace(LEFT(A.PrimaryDiagnosisCode, 5), '.', '')
     WHERE DischargeDate >= '1/1/2018'                 
           AND DischargeDate is not Null		   
     GROUP BY UHC_SUBSCRIBER_ID, 
			  DischargeDate, 
              PCP_PRACTICE_NAME, 
              HospitalName, 
              PrimaryDiagnosisCode, 
              MULTI_CCS_LVL1_LABEL
     UNION
     -- from GHH data
     SELECT DISTINCT 
            d.ClientShortName AS Client,
			b.ClientMemberKey as Member_id,
            admithospital AS VEND_FULL_NAME, 
            c.pcp_practice_name, 
            COUNT(DISTINCT b.ClientMemberKey) AS IP_Visits, 
            CONVERT(DATE, dischargedatetime, 101) AS VisitDate, 
			A.diagnosiscode AS Prim_diag_code, 
            ee.MULTI_CCS_LVL1_LABEL AS CCS_Desc, 
            'GHH' Src
     FROM ACECAREDW.adi.NtfGhhNotifications a
          JOIN
     (
         SELECT ms.MstrMrnKey, 
                clientkey, 
                ClientMemberKey
         FROM acempi.adw.MPI_ClientMemberAssociationHistoryODS od
              JOIN acempi.adw.MPI_MstrMrn ms ON od.MstrMrnKey = ms.MstrMrnKey
     ) b ON b.MstrMrnKey = a.AceID
          JOIN ACECAREDW.dbo.Uhc_MembersbyPCP c ON c.uhc_subscriber_id = b.ClientMemberKey and month(a.dischargedatetime) = month(A_last_update_date) and YEAR(a.dischargedatetime) = YEAR(a_last_update_date)
          LEFT JOIN acecaredw_test.[dbo].[ICDCCS] ee ON LEFT(ee.[ICD-10-CM_CODE], 4) = replace(LEFT(A.diagnosiscode, 5), '.', '')
          JOIN ACECAREDW.lst.List_Client d ON d.ClientKey = b.ClientKey
     WHERE a.DischargeDateTime >= '1/1/2018'
	 and a.PatientClass in (
'I',
'101',
'107',
'108',
'129'
	 )
     --      AND AdmitHospital = 'SJMC'
     --and pcp_practice_name = 'EL CENTRO DE CORAZON'
     --	  and dischargedatetime = '2019-08-30'
     GROUP BY d.ClientShortName, b.ClientMemberKey,
              admithospital, 
              c.pcp_practice_name, 
              CONVERT(DATE, dischargedatetime, 101), 
              A.diagnosiscode, 
              MULTI_CCS_LVL1_LABEL;
