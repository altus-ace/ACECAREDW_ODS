


CREATE VIEW [dbo].[vw_care_op_distr_list]
AS
     SELECT DISTINCT 
            [member_id]
            ,
            --,NameFirst
            --,NameLast 
            concat(NameLast, ', ', NameFirst) AS Member_Name, 
            DOB, 
            GENDER, 
            Member_Phone, 
            MEDICAID_ID, 
            TIN_Num, 
            TIN_Name, 
            Prov_Last_Name, 
            Prov_First_Name, 
            concat(prov_last_name, ', ', prov_first_name) AS Provider_Name, 
            DESTINATION_VALUE AS [PLAN], 
            [A_LAST_UPDATE_DATE], 
            [UHC_AWC] AS [Adolescent Well-Care Visits], 
            [UHC_BCS] AS [Breast Cancer Screening], 
            [UHC_CCS] AS [Cervical Cancer Screening], 
            [UHC_CDC_HB] AS [Comprehensive Diabetes Care - HbA1c Testing], 
            [UHC_CDC_G_9] AS [Comprehensive Diabetes Care - HbA1c Poor Control (>9.0%)], 
            [UHC_W15] AS [Well-Child Visits in the First 15 Months of Life - Six or more well-child visits], 
            [UHC_W34] AS [Well-Child Visits in the Third, Fourth, Fifth and Sixth Years of Life], 
            [UHC_WCC_BMI] AS [Weight Assessment and Counseling for Nutrition and Physical Activity for Children/Adolescents - BMI Percentile], 
            [UHC_WCC_CN] AS [Weight Assessment and Counseling for Nutrition and Physical Activity for Children/Adolescents - Counseling for Nutrition], 
            [UHC_WCC_PA] AS [Weight Assessment and Counseling for Nutrition and Physical Activity for Children/Adolescents - Counseling for Physical Activity], 
            [UHC_SSD] AS [Diabetes Screening for People With Schizophrenia or Bipolar Disorder Who Are Using Antipsychotic Medications], 
            [UHC_SAA] as [Adherence to Antipsychotic Medications for Individuals with Schizopherenia],
			[UHC_COA_MR] AS [Care of Older Adults - Medication Review],
            CASE
                WHEN LEN(TIN_Num) = 8
                THEN concat('0', TIN_Num)
                ELSE TIN_Num
            END AS [Membership_TIN],
            CASE
                WHEN TIN_Num = '752894111'
                THEN UPPER('Topcare Medical PA')
                ELSE TIN_Name
            END AS Membership_Practice_Name, 
            [UHC_AWC] + [UHC_BCS] + [UHC_CCS] + [UHC_CDC_G_9] + [UHC_W15] + [UHC_W34] + [UHC_WCC_BMI] + [UHC_WCC_CN] + [UHC_WCC_PA] + [UHC_SSD] +[UHC_SAA]+ [UHC_COA_MR] + [UHC_CDC_HB] + [UHC_MPM_A] + [UHC_MPM_D] AS [Total], 
            [UHC_ADD_CM], 
            [UHC_ADD_I], 
            [UHC_CAP], 
            [UHC_CBP], 
            [UHC_CDC_L_8], 
            [UHC_CIS], 
            [UHC_FUH_30_0617], 
            [UHC_FUH_30_1864], 
            [UHC_FUH_30_G_65], 
            [UHC_FUH_7_0617], 
            [UHC_FUH_7_1864], 
            [UHC_FUH_7_G_65], 
            [UHC_MPM_A] AS [Annual Monitoring for Patients on Persistent Medications - ACE Inhibitors or ARBs], 
            [UHC_MPM_D] AS [Annual Monitoring for Patients on Persistent Medications - Diuretics], 
            [UHC_PPC_POST], 
            [UHC_PPC_PRE], 
			[UHC_SAA],
            [UHC_URI]
     FROM
     (
         SELECT DISTINCT 
                [QmMsrID], 
                [QM_DESC], 
                [Member_ID], 
                b.MEMBER_FIRST_NAME AS [NameFirst], 
                b.MEMBER_LAST_NAME AS [NameLast], 
                b.DESTINATION_VALUE, 
                b.MEDICAID_ID, 
                CONVERT(DATE, b.DATE_OF_BIRTH, 101) AS DOB, 
                [Gender],
                CASE
                    WHEN b.MEMBER_HOME_PHONE = ''
                    THEN ''
                    ELSE SUBSTRING('(' + b.MEMBER_HOME_PHONE, 1, 4) + ')' + SUBSTRING(b.MEMBER_HOME_PHONE, 4, 3) + '-' + SUBSTRING(b.MEMBER_HOME_PHONE, 7, 4)
                END AS [Member_Phone], 
                b.PCP_PRACTICE_TIN AS [TIN_Num], 
                d.[PRACTICE NAME] AS [TIN_Name], 
                b.PCP_LAST_NAME AS [Prov_Last_Name], 
                b.PCP_FIRST_NAME AS [Prov_First_Name], 
                [QMDate] AS [A_LAST_UPDATE_DATE]
         FROM
         (
             SELECT *
             FROM acecaredw.[adw].[QM_ResultByMember_History]
             WHERE CASE
                       WHEN qmmsrid = 'UHC_CDC_G_9'
                            AND qmcntcat = 'NUM'
                       THEN 'COP'
                       WHEN qmmsrid = 'UHC_CDC_G_9'
                            AND qmcntcat = 'COP'
                       THEN 'NUM'
                       ELSE qmcntcat
                   END = 'COP'
                   AND qmdate =
             (
                 SELECT MAX(qmdate)
                 FROM acecaredw.[adw].[QM_ResultByMember_History]
             )
         ) a
         JOIN
         (
             SELECT a.*, 
                    b.*
             FROM [vw_UHC_ActiveMembers] a
                  LEFT JOIN
             (
                 SELECT DISTINCT 
                        SOURCE_VALUE, 
                        MeasureID, 
                        destination_value
                 FROM [ACECAREDW].[lst].[lstCareOpToPlan] a
                      LEFT JOIN
                 (
                     SELECT source_value,
                            DESTINATION_VALUE
                     FROM [ACECAREDW].[dbo].[ALT_MAPPING_TABLES]
					 where SOURCE <> 'UHC_MI'
                 ) b ON a.CsPlan = b.DESTINATION_VALUE
                 WHERE measureID NOT IN('unkn_UHC') 
             ) b ON a.SUBGRP_ID = b.SOURCE_VALUE
         ) b ON a.clientMemberKey = b.member_id
                AND a.QmMsrId = b.MeasureID
         JOIN [ACECAREDW].[lst].[LIST_QM_Mapping] c ON a.QmMsrId = c.qm
         LEFT JOIN
         (
             SELECT DISTINCT 
                    [Tax id], 
                    [PRACTICE NAME]
             FROM [ACECAREDW].[dbo].[vw_NetworkRoster]
         ) d ON CONVERT(INT, b.PCP_PRACTICE_TIN) = CONVERT(INT, d.[TAX ID])
         WHERE d.[PRACTICE NAME] NOT IN('TOPCARE MEDICAL GROUP INC DALLAS') and ClientKey = 1
     ) zz PIVOT(COUNT(qm_desc) FOR [qmMsrID] IN([UHC_ADD_CM], 
                                                [UHC_ADD_I], 
                                                [UHC_AWC], 
                                                [UHC_BCS], 
                                                [UHC_CAP], 
                                                [UHC_CBP], 
                                                [UHC_CCS], 
                                                [UHC_CDC_G_9], 
                                                [UHC_CDC_HB], 
                                                [UHC_CDC_L_8], 
                                                [UHC_CIS], 
                                                [UHC_COA_MR], 
                                                [UHC_FUH_30_0617], 
                                                [UHC_FUH_30_1864], 
                                                [UHC_FUH_30_G_65], 
                                                [UHC_FUH_7_0617], 
                                                [UHC_FUH_7_1864], 
                                                [UHC_FUH_7_G_65], 
                                                UHC_MPM_A, 
                                                UHC_MPM_D, 
                                                [UHC_PPC_POST], 
                                                [UHC_PPC_PRE], 
												[UHC_SAA],
                                                [UHC_SSD],
												[UHC_URI], 
                                                [UHC_W15], 
                                                [UHC_W34], 
                                                [UHC_WCC_BMI], 
                                                [UHC_WCC_CN], 
                                                [UHC_WCC_PA])) AS pvt
 ;
