



CREATE VIEW [adw].[yy_vw_Dashboard_QM_UHC_Old_11112020]
AS
    /* Objective: get quality measure for a member by month for a client */
    SELECT S.ClientMemberKey, S.CareOpToPlan_Active, S.QmMsr_Tb_Desc, S.AHR_QM_DESC, S.QmMsrId, S.QMDate, 
       S.LOB, S.MeasureDesc, 
	  SUM(S.MbrDEN) AS MbrDEN, SUM(S.MbrNUM) AS MbrNUM, SUM(S.MbrCOP) AS MbrCOP, 
       S.AGE, S.PCP_PRACTICE_TIN, S.PCP_PRACTICE_NAME, S.PCP_NPI, S.PCP_PHONE, S.careOpToPlan_MeasureID, S.[Contract?], 
       S.[ACE MBR?], S.ExpirationYear, S.Target, S.Client, S.ProviderName
	  , s.IsMbrActive
	  
    FROM
    (
        SELECT [ClientMemberKey], 
               a.active CareOpToPlan_Active,
               CASE -- cleaned up to match the uhc 2020 measures 
                   WHEN [QmMsrId] = 'UHC_AWC'
                   THEN 'AWC :  Adolescent Well-Care Visits .'
                   WHEN [QmMsrId] = 'UHC_BCS'
                   THEN 'BCS :  Breast Cancer Screening.'
                   WHEN [QmMsrId] = 'UHC_CBP'
                   THEN 'CBP:Controlling High Blood Pressure'
                   WHEN [QmMsrId] = 'UHC_CCS'
                   THEN 'CCS:Cervical Cancer Screening'
                   WHEN [QmMsrId] = 'UHC_CDC'
                   THEN 'CDC:Comprehensive Diabetes Care: HbA1c Control ( < 8% )'
                   WHEN [QmMsrId] = 'UHC_CIS'
                   THEN 'Childhood Immunization Status'
                   WHEN [QmMsrId] = 'UHC_FUH_30'
                   THEN 'FUH:Follow Up After Hospitalization for Mental Illness:  30-Day Follow Up'
                   WHEN [QmMsrId] = 'UHC_FUH_7'
                   THEN 'FUH:Follow Up After Hospitalization for Mental Illness:  7-Day Follow Up'
                   WHEN [QmMsrId] = 'UHC_IMA'
                   THEN 'IMA:Immunizations For Adolescents (Combination 2)'
                   WHEN [QmMsrId] = 'UHC_PCR'
                   THEN 'PCR:Readmissions - less is better'
                   WHEN [QmMsrId] = 'UHC_SSD'
                   THEN 'SSD :  Diabetes Screening for People With Schizophrenia or Bipolar Disorder Who are Using Antipsychotic Medications'
                   WHEN [QmMsrId] = 'UHC_URI'
                   THEN 'URI: Appropriate Treatment for Children with Upper Respiratory Infection'
                   WHEN [QmMsrId] = 'UHC_W15'
                   THEN 'W15:Well Child Visits in the First 15 Months of Life: 6 or More'
                   WHEN [QmMsrId] = 'UHC_W34'
                   THEN 'W34:Well Child  Visits in the Third, Fourth, Fifth, and Sixth Year of Life'
                   WHEN [QmMsrId] = 'UHC_WCC'
                   THEN 'WCC: Weight Assessment and Counseling for Nutrition and Physical Activity for Children/Adolescents: Counseling for Nutrition'
                   ELSE 'O'
               END AS [QmMsr_Tb_Desc], 
               a.[AHR_QM_DESC], 
               [QmMsrId], 
               [QMDate], 
               A.LOB, 
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
               a.careOpToPlan_MeasureID,
               CASE
                   WHEN a.careOpToPlan_MeasureID IS NULL
                   THEN 'Not Contracted'
                   ELSE 'Contracted'
               END AS 'Contract?',
               CASE
                   WHEN UHC_SUBSCRIBER_ID IS NULL
                   THEN 'NOT ACE_MBR'
                   ELSE 'ACE MBR'
               END AS 'ACE MBR?', 
               YEAR(SCOR.ExpirationDate) AS ExpirationYear, 
               SCOR.Score_A / 100 AS Target, 
               a.clientshortname AS Client, 
               a.ProviderName
			, a.IsMbrActive
        FROM
        (
            SELECT DISTINCT 
                   QM.[ClientMemberKey], 
                   QM.[clientkey], 
                   QM.[QmMsrId] AS SourceQmMsrID, 
                   cp.ACTIVE,
                   CASE
                       WHEN(QM.[QmMsrId] LIKE 'UHC_FUH_30%')
                       THEN 'UHC_FUH_30'
                       WHEN(QM.[QmMsrId] LIKE 'UHC_FUH_7%')
                       THEN 'UHC_FUH_7'
                       ELSE QM.QmMsrId
                   END AS QmMsrID, 
                   QM.[QmCntCat], 
                   lqm.AHR_QM_DESC, 
                   QM.[QMDate], 
                   AceMap_csPlan.TargetValue AS AHS_LOB, 
                   Mp.SUBGRP_ID, 
                   AceMap_csPlan.SourceValue,
                   CASE
                       WHEN AceMap_csPlan.TargetValue IN('MMP', 'MMP NF', 'MMP  NF', 'MMP Waiver')
                       THEN 'MMP'
                       WHEN AceMap_csPlan.TargetValue IN('STARKIDS', 'STARKIDS IDD')
                       THEN 'STARKIDS'
                       WHEN AceMap_csPlan.TargetValue IN('STARPLUS IDD', 'STARPLUS NHC', 'STARPLUS NHR', 'TX-STAR+PLUS', 'TX STAR+PLUS 111', 'TX STAR+PLUS 120', 'TX STAR+PLUS 123', 'TX STAR+PLUS 901')
                       THEN 'STARPLUS'
                       WHEN AceMap_csPlan.TargetValue IN('TX-CHIP', 'TX-CHIP Pregnant Women')
                       THEN 'TX-CHIP'
                       WHEN AceMap_csPlan.TargetValue IN('TX-STAR', 'TX-STAR Pregnant Women')
                       THEN 'TX-STAR'
                   END AS LOB, 
                   LQM.QM, 
                   LQM.QM_DESC, 
                   MP.[AGE], 
                   MP.[PCP_PRACTICE_TIN], 
                --   MP.[PCP_PRACTICE_NAME], 
			 -- USE  ProviderRoster to clean UHC Tin Name, For the SHCN Permian Tin, use NPI to get Group name , all others justNPI
				CASE WHEN (mp.PCP_PRACTICE_TIN = '134334288') THEN PR_SHCN.GroupName 
										  ELSE pr.GroupName END AS PCP_PRACTICE_NAME,
                   MP.[PCP_NPI], 
                   MP.[PCP_PHONE], 
                   MP.UHC_SUBSCRIBER_ID, 
                   CP.MeasureID careOpToPlan_MeasureID, 
                   MP.LoadType,                    
                   lc.ClientShortName, 
                   mp.PCP_LAST_NAME + ', ' + mp.PCP_FIRST_NAME AS ProviderName,
			    CASE WHEN (am.CLIENT_SUBSCRIBER_ID IS NULL) THEN 'Inactive' ELSE 'Active' END AS IsMbrActive
            FROM [adw].[QM_ResultByMember_History] QM 
                 LEFT JOIN dbo.vw_activemembers am 
				ON am.MEMBER_ID = QM.ClientMemberKey -- need to add this to remove members who are wrongly pulled into PCOR with plans in MMP named as Starplus
				    AND am.clientKey = qm.ClientKey
                 JOIN lst.LIST_QM_Mapping LQM ON LQM.QM = QM.[QmMsrId]
                 LEFT JOIN [ACECAREDW].[dbo].[UHC_MembersByPCP] MP  ON QM.ClientMemberKey = MP.UHC_SUBSCRIBER_ID
                            AND YEAR(QM.[QMDate]) = YEAR(MP.[A_LAST_UPDATE_DATE])
                            AND MONTH(QM.[QMDate]) = MONTH(MP.[A_LAST_UPDATE_DATE])
                            AND LoadType <> 'S'
                 LEFT JOIN lst.lstPlanMapping AceMap_Plan ON Mp.SUBGRP_ID = AceMap_Plan.SourceValue
                            AND AceMap_Plan.TargetSystem = 'ACDW'
                            AND AceMap_Plan.ClientKey = 1
                 LEFT JOIN lst.lstPlanMapping AceMap_csPlan ON Mp.SUBGRP_ID = AceMap_csPlan.SourceValue
					   AND AceMap_csPlan.TargetSystem = 'CS_AHS'
					   AND AceMap_csPlan.ClientKey = 1
                 LEFT JOIN [ACECAREDW].[lst].[lstCareOpToPlan] CP ON QM.[QmMsrId] = CP.[MeasureID]
				     AND cp.CsPlan = AceMap_csPlan.TargetValue
					AND QM.QMDate between CP.EffectiveDate AND cp.ExpirationDate
                -- LEFT JOIN [ACECAREDW].[lst].[lstScoringSystem] SCOR ON SCOR.MeasureID = QM.[QmMsrId]
                --                                                        AND SCOR.ClientKey = '1'
                --                                                        AND YEAR(SCOR.ExpirationDate) = YEAR(QM.QMDate)
                 LEFT JOIN acecaredw.lst.List_Client lc ON lc.ClientKey = qm.ClientKey
			 -- JOIN TO ProviderRoster to clean UHC Tin Name, For the SHCN Permian Tin, use NPI to get Group name , all others justNPI
			  LEFT JOIN (SELECT pr.TIN, pr.GroupName 
						  FROM dbo.vw_AllClient_ProviderRoster PR 
						  WHERE pr.CalcClientKey = 1 AND pr.TIN <> '134334288'
						  GROUP BY pr.TIN, pr.GroupName) PR
				ON mp.PCP_PRACTICE_TIN	   = pr.TIN
			 LEFT JOIN (SELECT pr.TIN, pr.GroupName, pr.NPI
						  FROM dbo.vw_AllClient_ProviderRoster PR 
						  WHERE pr.CalcClientKey = 1 AND pr.TIN = '134334288'
						  GROUP BY pr.TIN, pr.GroupName, pr.Npi) PR_SHCN
				ON mp.PCP_PRACTICE_TIN	   = PR_SHCN.TIN 
				    AND mp.PCP_NPI = PR_SHCN.NPI
				    
            --  8/18/2020:GK Removed as Zones are not used in Dashboard              
            --   LEFT JOIN [ACecaredw_test].dbo.[tmp_ZIPCode_Zones] tzip ON tzip.zipcodes = mp.member_home_zip
            WHERE QM.ClientKey = 1
                  AND lqm.active = 'Y'			   
        ) A
	   LEFT JOIN [ACECAREDW].[lst].[lstScoringSystem] SCOR ON SCOR.MeasureID = a.[QmMsrId]
                                                                        AND SCOR.ClientKey = '1'
                                                                        AND YEAR(SCOR.ExpirationDate) = YEAR(a.QMDate)
														  AND SCOR.LOB = a.LOB
    ) S    
    	GROUP BY S.ClientMemberKey, S.CareOpToPlan_Active, S.QmMsr_Tb_Desc, S.AHR_QM_DESC, S.QmMsrId, S.QMDate, 
           S.LOB, S.MeasureDesc,  S.AGE, S.PCP_PRACTICE_TIN, S.PCP_PRACTICE_NAME, S.PCP_NPI, S.PCP_PHONE, S.careOpToPlan_MeasureID, S.[Contract?], 
           S.[ACE MBR?]
		 , S.ExpirationYear, S.Target
		 , S.Client, S.ProviderName	
		 , s.IsMbrActive
    	;
