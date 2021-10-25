



CREATE VIEW [dbo].[vw_UHC_PCOR]
AS
     SELECT [ClientMemberKey],
            CASE
                WHEN [QmMsrId] = 'UHC_AAP'
                THEN 'Adults Access to Preventive Services'
                WHEN [QmMsrId] = 'UHC_ADD_CM'
                THEN 'FU for Children on  ADHD Medication - C'
                WHEN [QmMsrId] = 'UHC_ADD_I'
                THEN 'FU for Children on ADHD Medication - I'
                WHEN [QmMsrId] = 'UHC_AWC'
                THEN 'Adolescent Well-Care Visits'
                WHEN [QmMsrId] = 'UHC_BCS'
                THEN 'Breast Cancer Screening'
                WHEN [QmMsrId] = 'UHC_CAP'
                THEN 'Children and Adolescents Access to PCP'
                WHEN [QmMsrId] = 'UHC_CBP'
                THEN 'Controlling High BP'
                WHEN [QmMsrId] = 'UHC_CCS'
                THEN 'Cervical Cancer Screening'
                WHEN [QmMsrId] = 'UHC_CDC_G_9'
                THEN 'CDC - *HbA1c Poor Control (>9.0%)'
                WHEN [QmMsrId] = 'UHC_CDC_HB'
                THEN 'CDC- HbA1c (HbA1c) Testing'
                WHEN [QmMsrId] = 'UHC_CDC_L_8'
                THEN 'CDC - HbA1c control (<8.0%)'
                WHEN [QmMsrId] = 'UHC_CHL'
                THEN 'Chlamydia Screening in Women'
                WHEN [QmMsrId] = 'UHC_CIS'
                THEN 'Childhood Immunization Status'
                WHEN [QmMsrId] = 'UHC_COA_MR'
                THEN 'Care for Older Adults -MR'
                WHEN [QmMsrId] = 'UHC_FUH_30'
                THEN 'FUH - 30 Days'
                WHEN [QmMsrId] = 'UHC_FUH_30_0617'
                THEN 'FUH - 30 Days 6-17 years old'
                WHEN [QmMsrId] = 'UHC_FUH_30_1864'
                THEN 'FUH - 30 Days 18- 64 years old'
                WHEN [QmMsrId] = 'UHC_FUH_30_G_65'
                THEN 'FUH - 30 Days 65 years and older'
                WHEN [QmMsrId] = 'UHC_FUH_7'
                THEN 'FUH - 7 Day'
                WHEN [QmMsrId] = 'UHC_FUH_7_0617'
                THEN 'FUH - 7 Day 6-17 years old'
                WHEN [QmMsrId] = 'UHC_FUH_7_1864'
                THEN 'FUH - 7 Day 18- 64 years old'
                WHEN [QmMsrId] = 'UHC_FUH_7_G_65'
                THEN 'FUH - 7 Day 65 years and older'
                WHEN [QmMsrId] = 'UHC_MPM_A'
                THEN 'Patients on Persistent Medications - ARBs'
                WHEN [QmMsrId] = 'UHC_MPM_D'
                THEN 'Patients on Persistent Medications - Diuretics'
                WHEN [QmMsrId] = 'UHC_PPC_POST'
                THEN 'Postpartum Care'
                WHEN [QmMsrId] = 'UHC_PPC_PRE'
                THEN 'Timeliness of Prenatal Care'
                WHEN [QmMsrId] = 'UHC_SSD'
                THEN 'Diabetes Screening - Schizophrenia or Bipolar'
                WHEN [QmMsrId] = 'UHC_URI'
                THEN 'Children Upper Respiratory Infection'
                WHEN [QmMsrId] = 'UHC_W15'
                THEN 'Well-Child Visits 15 Months'
                WHEN [QmMsrId] = 'UHC_W34'
                THEN 'Well-Child Visits 3rd,4th,5th and 6th Years'
                WHEN [QmMsrId] = 'UHC_WCC_BMI'
                THEN 'WCC BMI Percentile'
                WHEN [QmMsrId] = 'UHC_WCC_CN'
                THEN 'WCC Counseling for Nutrition'
                WHEN [QmMsrId] = 'UHC_WCC_PA'
                THEN 'WCC Counseling for Physical Activity'
                WHEN [QmMsrId] = 'UHC_MRP'
                THEN 'MRP-Medication Reconciliation Post-Discharge'
                WHEN [QmMsrId] = 'UHC_SAA'
                THEN 'SAA-Adherence to Antipsychotic Medications for Individuals With Schizophrenia'                ELSE 'O'
            END AS [QmMsr_Tb_Desc], 
            [QmMsrId], 
            [QMDate], 
            LOB, 
            QM_DESC AS MeasureDesc,
            CASE
                WHEN [QmCntCat] = 'DEN'
                THEN 1
                ELSE 0
            END AS MbrDEN,
            CASE
                WHEN [QmCntCat] = 'NUM'
                THEN 1
                ELSE 0
            END AS MbrNUM,
            CASE
                WHEN [QmCntCat] = 'COP'
                THEN 1
                ELSE 0
            END AS MbrCOP, 
            [AGE], 
            [PCP_PRACTICE_TIN], 
            [PCP_PRACTICE_NAME], 
            [PCP_NPI], 
            [PCP_PHONE],
            CASE
                WHEN MeasureID IS NULL
                THEN 'Not Contracted'
                ELSE 'Contracted'
            END AS 'Contract?',
            CASE
                WHEN UHC_SUBSCRIBER_ID IS NULL
                THEN 'NOT ACE_MBR'
                ELSE 'ACE MBR'
            END AS 'ACE MBR?', 
            YEAR(A.ExpirationDate) AS ExpirationYear, 
            A.Score_A / 100 AS Target, 
            a.clientshortname AS Client, 
            a.[Zone] 
            --a.Activity_Flag, 
            --a.Appointment_Flag, 
            --a.Activity_Date, 
            --a.ActivityOutcome, 
            --a.CareActivityTypeName, 
            --a.Appointment_date, 
            --A.AppointmentStatusName
     FROM
     (
         SELECT DISTINCT 
                QM.[ClientMemberKey], 
                QM.[clientkey], 
                QM.[QmMsrId], 
                QM.[QmCntCat], 
                QM.[QMDate],
                CASE
                    WHEN AMT.DESTINATION_VALUE IN('MMP', 'MMP NF', 'MMP  NF', 'MMP Waiver')
                    THEN 'MMP'
                    WHEN AMT.DESTINATION_VALUE IN('STARKIDS', 'STARKIDS IDD')
                    THEN 'STARKIDS'
                    WHEN AMT.DESTINATION_VALUE IN('STARPLUS IDD', 'STARPLUS NHC', 'STARPLUS NHR', 'TX-STAR+PLUS', 'TX STAR+PLUS 111', 'TX STAR+PLUS 120', 'TX STAR+PLUS 123', 'TX STAR+PLUS 901')
                    THEN 'STARPLUS'
                    WHEN AMT.DESTINATION_VALUE IN('TX-CHIP', 'TX-CHIP Pregnant Women')
                    THEN 'TX-CHIP'
                    WHEN AMT.DESTINATION_VALUE IN('TX-STAR', 'TX-STAR Pregnant Women')
                    THEN 'TX-STAR'
                END AS LOB, 
                LQM.QM, 
                LQM.QM_DESC, 
                MP.[AGE], 
                MP.[PCP_PRACTICE_TIN], 
                MP.[PCP_PRACTICE_NAME], 
                MP.[PCP_NPI], 
                MP.[PCP_PHONE], 
                MP.UHC_SUBSCRIBER_ID, 
                CP.MeasureID, 
                MP.LoadType, 
                SCOR.ExpirationDate, 
                SCOR.Score_A, 
                lc.ClientShortName, 
                --CONVERT(DATE, act.ActivityCreatedDate, 101) AS Activity_Date,
                --CASE
                --    WHEN act.ActivityCreatedDate IS NULL
                --    THEN 0
                --    ELSE 1
                --END AS Activity_Flag, 
                --act.ActivityOutcome, 
                --act.careactivitytypename, 
                --CONVERT(DATE, app.AppointmentCreatedDate, 101) AS Appointment_date,
                --CASE
                --    WHEN app.AppointmentCreatedDate IS NULL
                --    THEN 0
                --    ELSE 1
                --END AS Appointment_Flag, 
                --app.AppointmentStatusName,
                CASE
                    WHEN tzip.[zone] IS NULL
                    THEN 'Other'
                    ELSE tzip.[zone]
                END AS [Zone]
         FROM [ACECAREDW].[adw].[QM_ResultByMember_History] QM
              JOIN ACECAREDW.lst.LIST_QM_Mapping LQM ON LQM.QM = QM.[QmMsrId]
              LEFT JOIN [ACECAREDW].[dbo].[UHC_MembersByPCP] MP ON QM.ClientMemberKey = MP.UHC_SUBSCRIBER_ID
                                                                   AND YEAR(QM.[QMDate]) = YEAR(MP.[A_LAST_UPDATE_DATE])
                                                                   AND MONTH(QM.[QMDate]) = MONTH(MP.[A_LAST_UPDATE_DATE])
                                                                   AND LoadType <> 'S'
              LEFT JOIN ACECAREDW.dbo.ALT_MAPPING_TABLES AMT ON amt.SOURCE_VALUE = mp.subgrp_id
              LEFT JOIN [ACECAREDW].[lst].[lstCareOpToPlan] CP ON QM.[QmMsrId] = CP.[MeasureID]
                                                                  AND cp.CsPlan = amt.destination_value
              LEFT JOIN [ACECAREDW].[lst].[lstScoringSystem] SCOR ON SCOR.MeasureID = QM.[QmMsrId]
                                                                     AND SCOR.ClientKey = '1'
                                                                     AND YEAR(SCOR.ExpirationDate) = YEAR(QM.QMDate)
              LEFT JOIN acecaredw.lst.List_Client lc ON lc.ClientKey = qm.ClientKey
              LEFT JOIN [ACecaredw_test].dbo.[tmp_ZIPCode_Zones] tzip ON tzip.zipcodes = mp.member_home_zip
			  JOIN acecaredw.dbo.vw_activemembers am on am.MEMBER_ID = qm.ClientMemberKey -- need to add this to remove members who are wrongly pulled into PCOR with plans in MMP named as Starplus
              --LEFT JOIN dbo.tmp_Ahs_PatientActivities act ON act.clientmemberkey = qm.clientmemberkey
              --LEFT JOIN dbo.tmp_Ahs_PatientAppointments app ON app.ClientMemberKey = qm.ClientMemberKey

         --WHERE YEAR(QM.[QMDate]) = 2019  
     ) A;

--where a.qmmsrid like '%W34%'
