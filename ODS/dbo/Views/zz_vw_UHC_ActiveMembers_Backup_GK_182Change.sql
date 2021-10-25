CREATE VIEW [dbo].[zz_vw_UHC_ActiveMembers_Backup_GK_182Change]
AS
     SELECT umPCP.UHC_SUBSCRIBER_ID AS MEMBER_ID,
            umPCP.MEMBER_FIRST_NAME,
            umPCP.MEMBER_MI,
            umPCP.MEMBER_LAST_NAME,
            umPCP.UHC_SUBSCRIBER_ID,
		  umPCP.Ace_ID, 
            umPCP.PLAN_ID,
            umPCP.PRODUCT_CODE,
            umPCP.SUBGRP_ID,
            umPCP.SUBGRP_NAME,
            umPCP.MEDICAID_ID,
            umPCP.AGE,
            umPCP.DATE_OF_BIRTH,
            umPCP.GENDER,
            umPCP.LANG_CODE,
            umPCP.ETHNICITY_DESC AS ETHNICITY,
            '' AS RACE,
            umPCP.MEMBER_HOME_ADDRESS,
            umPCP.MEMBER_HOME_ADDRESS2,
            umPCP.MEMBER_HOME_CITY,
            umPCP.MEMBER_HOME_STATE,
            LEFT(umPCP.MEMBER_HOME_ZIP, 5) AS MEMBER_HOME_ZIP_C,
            umPCP.MEMBER_HOME_PHONE,
            umPCP.MEMBER_MAIL_ADDRESS,
            umPCP.MEMBER_MAIL_ADDRESS2,
            umPCP.MEMBER_MAIL_CITY,
            umPCP.MEMBER_MAIL_STATE,
            LEFT(umPCP.MEMBER_MAIL_ZIP, 5) AS MEMBER_MAIL_ZIP_C,
            umPCP.MEMBER_MAIL_PHONE,
            umPCP.MEMBER_COUNTY,
            umPCP.MEMBER_BUS_PHONE,
            umPCP.MEMBER_ORG_EFF_DATE,
            umPCP.MEMBER_CONT_EFF_DATE,
            umPCP.MEMBER_CUR_EFF_DATE,
            umPCP.MEMBER_CUR_TERM_DATE,
            umPCP.PCP_UHC_ID,
            umPCP.PCP_FIRST_NAME,
            umPCP.PCP_LAST_NAME,
            umPCP.PCP_NPI,
		  umPCP.PCP_AccountType ,
            umPCP.PCP_PHONE,
            umPCP.PCP_FAX,
            umPCP.PCP_ADDRESS,
            umPCP.PCP_ADDRESS2,
            umPCP.PCP_CITY,
            umPCP.PCP_STATE,
            LEFT(umPCP.PCP_ZIP, 5) AS PCP_ZIP_C,
            umPCP.PCP_EFFECTIVE_DATE,
            umPCP.PCP_TERM_DATE,
            umPCP.PCP_PRACTICE_TIN,
            umPCP.PCP_GROUP_ID,
            umPCP.PCP_PRACTICE_NAME,
            umPCP.AUTO_ASSIGN,
            umPCP.MEMBER_STATUS,
            umPCP.MEMBER_TERM_DATE,
            uM_1.IPRO_ADMIT_RISK_SCORE,
            um_1.RISK_CATEGORY_C,
            uM_1.LINE_OF_BUSINESS,
            uM_1.PLAN_CODE,
            uM_1.PLAN_DESC,
            uM_1.PRIMARY_RISK_FACTOR,
            uM_1.TOTAL_COSTS_LAST_12_MOS,
            uM_1.COUNT_OPEN_CARE_OPPS,
            uM_1.INP_COSTS_LAST_12_MOS,
            uM_1.ER_COSTS_LAST_12_MOS,
            uM_1.OUTP_COSTS_LAST_12_MOS,
            uM_1.PHARMACY_COSTS_LAST_12_MOS,
            uM_1.PRIMARY_CARE_COSTS_LAST_12_MOS,
            uM_1.BEHAVIORAL_COSTS_LAST_12_MOS,
            uM_1.OTHER_OFFICE_COSTS_LAST_12_MOS,
            uM_1.INP_ADMITS_LAST_12_MOS,
            uM_1.LAST_INP_DISCHARGE,
            uM_1.POST_DISCHARGE_FUP_VISIT,
            uM_1.INP_FUP_WITHIN_7_DAYS,
            uM_1.ER_VISITS_LAST_12_MOS,
            uM_1.LAST_ER_VISIT,
            uM_1.POST_ER_FUP_VISIT,
            uM_1.ER_FUP_WITHIN_7_DAYS,
            uM_1.LAST_PCP_VISIT,
            uM_1.LAST_PCP_PRACTICE_SEEN,
            uM_1.LAST_BH_VISIT,
            uM_1.LAST_BH_PRACTICE_SEEN,
            uM_1.MEMBER_MONTH_COUNT,
            umPCP.URN AS ACE_MemberByPCP_URN,
            uM_1.URN AS ACE_Membership_URN,
            CASE
                WHEN A.Pod IS NULL
                THEN 6
                ELSE A.Pod
            END AS MEMBER_POD_C,
            CASE
                WHEN A.Quadrant IS NULL
                THEN 'NOT DEFINED'
                ELSE A.Quadrant
            END AS MEMBER_POD_DESC,
            CASE
                WHEN B.Pod IS NULL
                THEN 6
                ELSE B.Pod
            END AS PCP_POD_C,
            CASE
                WHEN B.Quadrant IS NULL
                THEN 'NOT DEFINED'
                ELSE B.Quadrant
            END AS PCP_POD_DESC,
            umPCP.PCP_LAST_NAME + ', ' + umPCP.PCP_FIRST_NAME AS PCP_NAME,
            uM_1.UHC_UNIQUE_SYSTEM_ID,
            umPCP.MEDICARE_ID,
            umPCP.RESP_LAST_NAME,
            umPCP.RESP_FIRST_NAME,
            umPCP.RESP_ADDRESS,
            umPCP.RESP_ADDRESS2,
            umPCP.RESP_CITY,
            umPCP.RESP_STATE,
            umPCP.RESP_ZIP,
            umPCP.RESP_PHONE,
            umPCP.MEMBER_EMAIL,
            DATEDIFF(mm, CONVERT(DATE, CONVERT(DATETIME, umPCP.DATE_OF_BIRTH, 101), 101), GETDATE()) AS CurMonthsOld,
            DATEDIFF(yy, CONVERT(DATE, CONVERT(DATETIME, umPCP.DATE_OF_BIRTH, 101), 101), GETDATE()) AS CurYearsOld		  
		  , umPcp.AhsPlanCode
		  , umPcp.AhsPlanName
     FROM
(
    SELECT mpcp.URN,
           mpcp.MEMBER_FIRST_NAME,
           mpcp.MEMBER_MI,
           mpcp.MEMBER_LAST_NAME,
           mpcp.UHC_SUBSCRIBER_ID,
		 AceMrn.A_MSTR_MRN AS Ace_ID,
           mpcp.CLASS,
           mpcp.PLAN_ID,
           mpcp.PRODUCT_CODE,
           mpcp.SUBGRP_ID,
           mpcp.SUBGRP_NAME,
           mpcp.MEDICARE_ID,
           mpcp.MEDICAID_ID,
           mpcp.AGE,
           mpcp.DATE_OF_BIRTH,
           mpcp.GENDER,
           mpcp.RELATIONSHIP_CODE,
           mpcp.LANG_CODE,
           mpcp.ETHNICITY_DESC,
           mpcp.MEMBER_HOME_ADDRESS,
           mpcp.MEMBER_HOME_ADDRESS2,
           mpcp.MEMBER_HOME_CITY,
           mpcp.MEMBER_HOME_STATE,
           mpcp.MEMBER_HOME_ZIP,
           mpcp.MEMBER_HOME_PHONE,
           mpcp.MEMBER_MAIL_ADDRESS,
           mpcp.MEMBER_MAIL_ADDRESS2,
           mpcp.MEMBER_MAIL_CITY,
           mpcp.MEMBER_MAIL_STATE,
           mpcp.MEMBER_MAIL_ZIP,
           mpcp.MEMBER_MAIL_PHONE,
           mpcp.MEMBER_COUNTY_CODE,
           mpcp.MEMBER_COUNTY,
           mpcp.MEMBER_BUS_PHONE,
           mpcp.DUAL_COV_FLAG,
           mpcp.MEMBER_ORG_EFF_DATE,
           mpcp.MEMBER_CONT_EFF_DATE,
           mpcp.MEMBER_CUR_EFF_DATE,
           mpcp.MEMBER_CUR_TERM_DATE,
           mpcp.CLASS_PLAN_ID,
           mpcp.RESP_LAST_NAME,
           mpcp.RESP_FIRST_NAME,
           mpcp.RESP_ADDRESS,
           mpcp.RESP_ADDRESS2,
           mpcp.RESP_CITY,
           mpcp.RESP_STATE,
           mpcp.RESP_ZIP,
           mpcp.RESP_PHONE,
           mpcp.BROKER_ID,
           mpcp.PCP_UHC_ID,
           mpcp.PCP_FIRST_NAME,
           mpcp.PCP_LAST_NAME,
           mpcp.PCP_MPIN,
           mpcp.PCP_NPI,
		 contractedTins.AccountType AS PCP_AccountType,
           mpcp.PCP_PROV_TYPE_ID,
           mpcp.PCP_PROV_TYPE,
           mpcp.PCP_INDICATOR,
           mpcp.CMG,
           mpcp.PCP_PHONE,
           mpcp.PCP_FAX,
           mpcp.PCP_ADDRESS,
           mpcp.PCP_ADDRESS2,
           mpcp.PCP_CITY,
           mpcp.PCP_STATE,
           mpcp.PCP_ZIP,
           mpcp.PCP_COUNTY,
           mpcp.PCP_EFFECTIVE_DATE,
           mpcp.PCP_TERM_DATE,
           mpcp.PCP_PRACTICE_TIN,
           mpcp.PCP_GROUP_ID,
           RTRIM(LTRIM(mpcp.PCP_PRACTICE_NAME)) AS PCP_PRACTICE_NAME,
           mpcp.IND_PRACT_ID,
           mpcp.IND_PRACT_NAME,
           mpcp.RECERT_DATE,
           mpcp.ETHNICITY,
           mpcp.AUTO_ASSIGN,
           mpcp.ASAP_ID,
           mpcp.FEW_ID,
           mpcp.LST_HRA_DATE,
           mpcp.NXT_HRA_DATE,
           mpcp.HRA_ID,
           mpcp.MEMBER_EMAIL,
           mpcp.A_LAST_UPDATE_DATE,
           mpcp.A_LAST_UPDATE_BY,
           mpcp.A_LAST_UPDATE_FLAG,
           mpcp.MEMBER_STATUS,
           mpcp.MEMBER_TERM_DATE
		 , AhsPlanHist.Benefit_Plan as AhsPlanName
		 , '' as AhsPlanCode
		 
    FROM dbo.UHC_MembersByPCP AS mpcp
	   JOIN adw.A_Mbr_Members AceMRN ON mpcp.UHC_SUBSCRIBER_ID = aceMRN.Client_Member_ID
		  and AceMrn.Active = 1	   	   
	   JOIN adw.A_ALT_MemberPlanHistory AhsPlanHist  -- 29923
		  ON mpcp.UHC_SUBSCRIBER_ID = AhsPlanHist.Client_Member_ID
	   		 AND GETDATE() BETWEEN AhsPlanHist.StartDate and AhsPlanHist.stopDate
			 AND AhsPlanHist.planHistoryStatus = 1			 
	   /* GK: 8/14/2019: added: to filter for contracted TINS */
	   JOIN (SELECT pr.CalcClientKey, pr.TIN , '' as AccountType
			 FROM dbo.vw_AllClient_ProviderRoster pr
			 WHERE pr.HealthPlan = 'UHC'
				AND pr.ProviderType in ('PCP')
				AND GETDATE() BETWEEN pr.EffectiveDate and pr.ExpirationDate
				/* this logic forces the comparison on an INT which allows for non-zero padded varchar values to be equated to padded values */			 				
			 GROUP BY pr.CalcCLientKey, pr.TIN/*, pr.AccountType*/) contractedTins 
			 ON try_convert(int, mpcp.PCP_Practice_TIN) = try_convert(int, contractedTins.TIN)  			
				and 1 /* clientkey */ = contractedTins.CalcClientKey 
    --WHERE(mpcp.A_LAST_UPDATE_FLAG IN('L'))	   
    WHERE(mpcp.A_LAST_UPDATE_FLAG IN('Y'))	   
	   AND (mpcp.LoadType = 'P' ) 
) AS umPCP
LEFT OUTER JOIN
(
    SELECT URN,
           UHC_SUBSCRIBER_ID,
		 IPRO_ADMIT_RISK_SCORE,
           dbo.sv_CalcRiskCategory_V2(IPRO_ADMIT_RISK_SCORE) AS RISK_CATEGORY_C ,
           LINE_OF_BUSINESS,
           PLAN_CODE,
           PLAN_DESC,
           PRIMARY_RISK_FACTOR,
           TOTAL_COSTS_LAST_12_MOS,
           COUNT_OPEN_CARE_OPPS,
           INP_COSTS_LAST_12_MOS,
           ER_COSTS_LAST_12_MOS,
           OUTP_COSTS_LAST_12_MOS,
           PHARMACY_COSTS_LAST_12_MOS,
           PRIMARY_CARE_COSTS_LAST_12_MOS,
           BEHAVIORAL_COSTS_LAST_12_MOS,
           OTHER_OFFICE_COSTS_LAST_12_MOS,
           INP_ADMITS_LAST_12_MOS,
           LAST_INP_DISCHARGE,
           POST_DISCHARGE_FUP_VISIT,
           INP_FUP_WITHIN_7_DAYS,
           ER_VISITS_LAST_12_MOS,
           LAST_ER_VISIT,
           POST_ER_FUP_VISIT,
           ER_FUP_WITHIN_7_DAYS,
           LAST_PCP_VISIT,
           LAST_PCP_PRACTICE_SEEN,
           LAST_BH_VISIT,
           LAST_BH_PRACTICE_SEEN,
           MEMBER_MONTH_COUNT,
           URN AS ACE_Membership_URN,
--           PCP_NAME,
           UHC_UNIQUE_SYSTEM_ID
    FROM dbo.UHC_Membership AS um
    WHERE(A_LAST_UPDATE_FLAG = 'Y')
) AS uM_1 ON umPCP.UHC_SUBSCRIBER_ID = uM_1.UHC_SUBSCRIBER_ID
LEFT OUTER JOIN dbo.LIST_ZIPCODES AS A ON LEFT(umPCP.MEMBER_HOME_ZIP, 5) = A.ZipCode
LEFT OUTER JOIN dbo.LIST_ZIPCODES AS B ON LEFT(umPCP.PCP_ZIP, 5) = B.ZipCode



