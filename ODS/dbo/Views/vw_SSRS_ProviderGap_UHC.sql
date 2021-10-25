






CREATE VIEW [dbo].[vw_SSRS_ProviderGap_UHC]
AS
    -- OBJECTIVE: Gets care gaps for a provider for the Current month (active members only, with current PCP etc)
     SELECT src.[ClientMemberKey],
           /* CASE [QmMsrId] 
                WHEN 'UHC_AAP'	 THEN 'Adults Access to Preventive Services'
              ELSE 'O'
            END AS [QmMsr_Tb_Desc] */
		  src.QM_DESC AS [QmMsr_Tb_Desc], 		  
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
            src.[Zone],
		  src.ClientKey
     FROM(SELECT 
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
                END AS [Zone]		 --- Select distinct qmmsrid	 
	   FROM [adw].[QM_ResultByMember_History]  QM 
	       JOIN dbo.vw_ActiveMembers ActiveMembers 
	   	   ON QM.ClientMemberKey = ActiveMembers.MEMBER_ID AND ActiveMembers.clientKey = 1
	       JOIN lst.List_Client Client ON Client.ClientKey = qm.ClientKey
	       JOIN ACEMasterData.lst.LIST_QM_Mapping LQM 
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
	       JOIN ACEMasterData.[lst].[lstCareOpToPlan] CareOpToPlan --where active = 'Y' and clientkey = 1 order by measureID, csPlan
	   	   ON QM.[QmMsrId] = CareOpToPlan.[MeasureID] 
	   		  --AND CareOpToPlan.CsPlan = lstPlnMap.TargetValue
	   		  --AND CareOpToPlan.ACTIVE = 'Y' Joshi ask to remove it to eliminate error
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
	   WHERE NOT src.QmMsrId IN ('UHC_FUH_30_0617','UHC_FUH_30_1864','UHC_FUH_7_0617','UHC_FUH_7_1864', 'UHC_URI') -- explicitly suppressed from Provider Gap Report 
		  
--where a.qmmsrid like '%W34%'
