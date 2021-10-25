


CREATE VIEW [dbo].[vw_SSRS_ProviderGap_UHC_Old2]
AS
    -- OBJECTIVE: Gets care gaps for a provider for the Current month (active members only, with current PCP etc)
     SELECT src.[ClientMemberKey],
            CASE
                WHEN [QmMsrId] = 'UHC_AAP'
                THEN 'Adults Access to Preventive Services'
                WHEN [QmMsrId] = 'UHC_ADD_CM'
                THEN 'FU for Children on  ADHD Medication - C'
                WHEN [QmMsrId] = 'UHC_ADD_I'
                THEN 'FU for Children on ADHD Medication - I'
                WHEN [QmMsrId] = 'UHC_AWC'
                THEN 'AWC:Adolescent Well-Care Visits'
                WHEN [QmMsrId] = 'UHC_BCS'
                THEN 'BCS:Breast Cancer Screening'
                WHEN [QmMsrId] = 'UHC_CAP'
                THEN 'Children and Adolescents Access to PCP'
                WHEN [QmMsrId] = 'UHC_CBP'
                THEN 'CBP:Controlling High BP'
                WHEN [QmMsrId] = 'UHC_CCS'
                THEN 'CCS:Cervical Cancer Screening'
                WHEN [QmMsrId] = 'UHC_CDC_G_9'
                THEN 'CDC: *HbA1c Poor Control (>9.0%)'
                WHEN [QmMsrId] = 'UHC_CDC_HB'
                THEN 'CDC: HbA1c (HbA1c) Testing'
                WHEN [QmMsrId] = 'UHC_CDC_L_8'
                THEN 'CDC: HbA1c control (<8.0%)'
                WHEN [QmMsrId] = 'UHC_CHL'
                THEN 'Chlamydia Screening in Women'
                WHEN [QmMsrId] = 'UHC_CIS'
                THEN 'CIS:  Childhood Immunization Status - Combination 10'
                WHEN [QmMsrId] = 'UHC_COA_MR'
                THEN 'Care for Older Adults -MR'         
                WHEN [QmMsrId] = 'UHC_MPM_A'
                THEN 'Patients on Persistent Medications - ARBs'
                WHEN [QmMsrId] = 'UHC_MPM_D'
                THEN 'Patients on Persistent Medications - Diuretics'
                WHEN [QmMsrId] = 'UHC_PPC_POST'
                THEN 'Postpartum Care'
                WHEN [QmMsrId] = 'UHC_PPC_PRE'
                THEN 'Timeliness of Prenatal Care'
                WHEN [QmMsrId] = 'UHC_SSD'
                THEN 'SSD: Diabetic Screening if Schizophrenia or Bipolar and Using Antipsychotic Medications'
                WHEN [QmMsrId] = 'UHC_W15'
                THEN 'W15: Well-Child Visits in the First 15 Months of Life - Six or more well-child visits'
                WHEN [QmMsrId] = 'UHC_W34'
                THEN 'W34: Well-Child Visits 3rd,4th,5th and 6th Years of Life'
                WHEN [QmMsrId] = 'UHC_WCC_BMI'
                THEN 'WCC BMI Percentile'
                WHEN [QmMsrId] = 'UHC_WCC_CN'
                THEN 'WCC: Weight Assessment & Counseling For Children/Adolescents  - Counseling for NUTRITION'
                WHEN [QmMsrId] = 'UHC_WCC_PA'
                THEN 'WCC Counseling for Physical Activity'
                WHEN [QmMsrId] = 'UHC_MRP'
                THEN 'MRP-Medication Reconciliation Post-Discharge'
                WHEN [QmMsrId] = 'UHC_ADM_RE'
                THEN 'ADM: Readmissions'
                WHEN [QmMsrId] = 'UHC_CIS_C2'
                THEN 'IMA: Immunizations for Adolescents - Combination 2'
                WHEN [QmMsrId] = 'UHC_SAA'
                THEN 'SAA-Adherence to Antipsychotic Medications for Individuals With Schizophrenia'      
			 ELSE 'O'
            END AS [QmMsr_Tb_Desc], 
            src.[QmMsrId], 
            src.[QMDate], 
            src.LOB, 
            src.QM_DESC AS MeasureDesc,
            CASE
                WHEN src.[QmCntCat] = 'DEN'
                THEN 1
                ELSE 0
            END AS MbrDEN,
            CASE
                WHEN src.[QmCntCat] = 'NUM'
                THEN 1
                ELSE 0
            END AS MbrNUM,
            CASE
                WHEN src.[QmCntCat] = 'COP'
                THEN 1
                ELSE 0
            END AS MbrCOP, 
            src.[AGE], 
            src.[PCP_PRACTICE_TIN], 
            src.[PCP_PRACTICE_NAME], 		  
		  src.DATE_OF_BIRTH,
		  src.GENDER,
		  src.MEMBER_HOME_PHONE,		   
		  src.PCP_NAME, 
		  src.NPI,
		  src.[PCP_PHONE], 		  
		  src.[MEMBER NAME],
            src.NPI AS PCP_NPI,             
            CASE
                WHEN src.MeasureID IS NULL
                THEN 'Not Contracted'
                ELSE 'Contracted'
            END AS 'Contract?',
            CASE
                WHEN src.ClientMemberKey IS NULL
                THEN 'NOT ACE_MBR'
                ELSE 'ACE MBR'
            END AS 'ACE MBR?', 
            YEAR(src.ExpirationDate) AS ExpirationYear, 
            src.Score_A / 100 AS Target, 
            src.clientshortname AS Client, 
            src.[Zone]
     FROM(SELECT DISTINCT 
                QM.[ClientMemberKey], 
                QM.clientkey, 
                QM.[QmMsrId], 
                --QM.[QmCntCat], 
			 CASE WHEN (QM.QmMsrId = 'UHC_CDC_G_9' AND qm.QmCntCat = 'NUM') THEN 'COP'
						WHEN (QM.QmMsrId = 'UHC_CDC_G_9' AND qm.QmCntCat = 'COP') THEN 'NUM'
						ELSE qm.QmCntCat END qmCntCat,
                QM.[QMDate],
                CASE
                    WHEN lstPlnMap.TargetValue IN('MMP', 'MMP NF', 'MMP  NF', 'MMP Waiver')
                    THEN 'MMP'
                    WHEN lstPlnMap.TargetVALUE IN('STARKIDS', 'STARKIDS IDD')
                    THEN 'STARKIDS'
                    WHEN lstPlnMap.TargetVALUE IN('STARPLUS IDD', 'STARPLUS NHC', 'STARPLUS NHR', 'TX-STAR+PLUS', 'TX STAR+PLUS 111', 'TX STAR+PLUS 120', 'TX STAR+PLUS 123', 'TX STAR+PLUS 901')
                    THEN 'STARPLUS'
                    WHEN lstPlnMap.TargetVALUE IN('TX-CHIP', 'TX-CHIP Pregnant Women')
                    THEN 'TX-CHIP'
                    WHEN lstPlnMap.TargetVALUE IN('TX-STAR', 'TX-STAR Pregnant Women')
                    THEN 'TX-STAR'
                END AS LOB, 
                LQM.QM, 
                LQM.QM_DESC, 
                ActiveMembers.[AGE],
			 ActiveMembers.DATE_OF_BIRTH,
			 ActiveMembers.GENDER,
			 ActiveMembers.MEMBER_HOME_PHONE,
                ActiveMembers.[PCP_PRACTICE_TIN], 
                ActiveMembers.[PCP_PRACTICE_NAME], 
			 ActiveMembers.PCP_NAME, 
                ActiveMembers.NPI,
                ActiveMembers.[PCP_PHONE],                 
			 ActiveMembers.MEMBER_LAST_NAME	+ ', ' + ActiveMembers.MEMBER_FIRST_NAME AS 'MEMBER NAME',
                CareOpToPlan.MeasureID,                 
                lstScore.ExpirationDate, 
                lstScore.Score_A,
                Client.ClientShortName,			 			 
                CASE
                    WHEN tzip.[zone] IS NULL
                    THEN 'Other'
                    ELSE tzip.[zone]
                END AS [Zone]			 
	   FROM [adw].[QM_ResultByMember_History]  QM 
	       JOIN dbo.vw_ActiveMembers ActiveMembers 
	   	   ON QM.ClientMemberKey = ActiveMembers.MEMBER_ID AND ActiveMembers.clientKey = 1
	       JOIN lst.List_Client Client ON Client.ClientKey = qm.ClientKey
	       JOIN lst.LIST_QM_Mapping LQM 
	   	   ON LQM.QM = QM.[QmMsrId]
	   		  AND QM.QMDate BETWEEN LQM.EffectiveDate AND LQM.ExpirationDate
	       /*JOIN [dbo].[UHC_MembersByPCP] MP -- Join member directly to get the mbrSubGrpID for the qmDate
	   	   ON QM.ClientMemberKey = MP.UHC_SUBSCRIBER_ID  
	   		AND YEAR(QM.[QMDate]) = YEAR(MP.[A_LAST_UPDATE_DATE])
	             AND MONTH(QM.[QMDate]) = MONTH(MP.[A_LAST_UPDATE_DATE])
	   		AND LoadType = 'P'*/ -- REmoved as we are doing only active member for the current month
	       --ACECAREDW.lst.ALT_MAPPING_TABLES AMT ON amt.SOURCE_VALUE = mp.subgrp_id
	       JOIN (SELECT LstPlanMapping.lstPlanMappingKey, lstPlanMapping.SourceValue, lstPlanMapping.TargetValue, lstPlanMapping.EffectiveDate, lstPlanMapping.ExpirationDate
	   			 FROM lst.lstPlanMapping LstPlanMapping
	   			 WHERE LstPlanMapping.TargetSystem = 'CS_AHS' AND LstPlanMapping.ClientKey = 1 ) lstPlnMap 
	   		ON ActiveMembers.SUBGRP_ID = lstPlnMap.sourceValue AND QM.QMDate BETWEEN lstPlnMap.EffectiveDate and lstPlnMap.ExpirationDate
	       JOIN[lst].[lstCareOpToPlan] CareOpToPlan --where active = 'Y' and clientkey = 1 order by measureID, csPlan
	   	   ON QM.[QmMsrId] = CareOpToPlan.[MeasureID] 
	   		  AND CareOpToPlan.CsPlan = lstPlnMap.TargetValue
	   		  AND CareOpToPlan.ACTIVE = 'Y'
	   		  AND qm.QMDate BETWEEN CareOpToPlan.EffectiveDate and CareOpToPlan.ExpirationDate
	   		  AND QM.ClientKey = CareOpToPlan.ClientKey     
	       LEFT JOIN (SELECT DISTINCT lstScore.MeasureID, lstScore.ExpirationDate, lstScore.EffectiveDate, lstScore.Score_A--, lstScore.lstScoringSystemKey
	   				, ROW_NUMBER() OVER (PARTITION BY lstScore.MeasureID ORDER BY lstScore.CreatedDate DESC) aRowNum
	   			 FROM [lst].[lstScoringSystem] lstScore 
	   			 WHERE lstScore.ClientKey = 1) lstScore
	   	   ON lstScore.MeasureID = QM.[QmMsrId] AND lstScore.aRowNum = 1 
	   		  --AND YEAR(SCOR.ExpirationDate) = YEAR(QM.QMDate)
	   		  AND DATEADD(year, -1, QM.qmDate) BETWEEN lstScore.EffectiveDate and lstScore.ExpirationDate
	       LEFT JOIN [ACecaredw_test].dbo.[tmp_ZIPCode_Zones] tzip 
	   	   ON tzip.zipcodes = ActiveMembers.MEMBER_HOME_ZIP_C
	   	       
	       --LEFT JOIN dbo.tmp_Ahs_PatientActivities act ON act.clientmemberkey = qm.clientmemberkey
	       --LEFT JOIN dbo.tmp_Ahs_PatientAppointments app ON app.ClientMemberKey = qm.ClientMemberKey
	   WHERE QM.ClientKey = 1 
	       AND LQM.ACTIVE = 'Y'
	       /* get care ops for this Year only */
	       --AND qm.QMDate > DateFromParts(Year(getdate()), 1, 1) 
		  AND qm.QMDate  = (SELECT MAX(Qm.QMDate) AS MaxQmDate FROM adw.QM_ResultByMember_History QM WHERE qm.ClientKey = 1)
	   )  SRC

--where a.qmmsrid like '%W34%'
