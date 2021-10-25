








CREATE view [dbo].[vw_ActiveMembers]
AS
/* version history: 
    12/02/2019: GK Added a MbrMember.ClientKey <> 1 clause for rollout of mbr Model 
	2021-02-03: Brit 
    */
SELECT distinct --t.mbrMemberKey,
       t.CLIENT, t.clientKey,
       t.MEMBER_ID,
       t.MEMBER_FIRST_NAME,
       t.MEMBER_MI,
       t.MEMBER_LAST_NAME,
       t.CLIENT_SUBSCRIBER_ID,
	  t.Ace_ID,
       t.PLAN_ID,
       t.PRODUCT_CODE,
       t.SUBGRP_ID,
       t.SUBGRP_NAME,
       t.MEDICAID_ID,
       t.AGE,
       t.DATE_OF_BIRTH,
       t.GENDER,
       t.LANG_CODE,
       t.ETHNICITY,
       t.RACE,
       t.MEMBER_HOME_ADDRESS,
       t.MEMBER_HOME_ADDRESS2,
       t.MEMBER_HOME_CITY,
       t.MEMBER_HOME_STATE,
       t.MEMBER_HOME_ZIP_C,
       t.MEMBER_HOME_PHONE,
       t.MEMBER_MAIL_ADDRESS,
       t.MEMBER_MAIL_ADDRESS2,
       t.MEMBER_MAIL_CITY,
       t.MEMBER_MAIL_STATE,
       t.MEMBER_MAIL_ZIP_C,
       t.MEMBER_MAIL_PHONE,
       t.MEMBER_COUNTY,
       t.MEMBER_BUS_PHONE,
       t.MEMBER_ORG_EFF_DATE,
       t.MEMBER_CONT_EFF_DATE,
       t.MEMBER_CUR_EFF_DATE,
       t.MEMBER_CUR_TERM_DATE,
       t.PCP_CLIENT_ID,
       t.PCP_FIRST_NAME,
       t.PCP_LAST_NAME,
       t.NPI,
	  t.PCP_AccountType,
       t.PCP_PHONE,
       t.PCP_FAX,
       t.PCP_ADDRESS,
       t.PCP_ADDRESS2,
       t.PCP_CITY,
       t.PCP_STATE,
       t.PCP_ZIP_C,
       t.PCP_EFFECTIVE_DATE,
       t.PCP_TERM_DATE,
       t.PCP_PRACTICE_TIN,
       t.PCP_GROUP_ID,
       RTRIM(LTRIM(t.PCP_PRACTICE_NAME)) AS PCP_PRACTICE_NAME,
       t.AUTO_ASSIGN,
       t.MEMBER_STATUS,
       t.MEMBER_TERM_DATE,
       t.ClientRiskScore AS IPRO_ADMIT_RISK_SCORE,
       t.RISK_CATEGORY_C,
       t.LINE_OF_BUSINESS,
       t.PLAN_CODE,
       t.PLAN_DESC,
       t.PRIMARY_RISK_FACTOR,
       t.TOTAL_COSTS_LAST_12_MOS,
       t.COUNT_OPEN_CARE_OPPS,
       t.INP_COSTS_LAST_12_MOS,
       t.ER_COSTS_LAST_12_MOS,
       t.OUTP_COSTS_LAST_12_MOS,
       t.PHARMACY_COSTS_LAST_12_MOS,
       t.PRIMARY_CARE_COSTS_LAST_12_MOS,
       t.BEHAVIORAL_COSTS_LAST_12_MOS,
       t.OTHER_OFFICE_COSTS_LAST_12_MOS,
       t.INP_ADMITS_LAST_12_MOS,
       t.LAST_INP_DISCHARGE,
       t.POST_DISCHARGE_FUP_VISIT,
       t.INP_FUP_WITHIN_7_DAYS,
       t.ER_VISITS_LAST_12_MOS,
       t.LAST_ER_VISIT,
       t.POST_ER_FUP_VISIT,
       t.ER_FUP_WITHIN_7_DAYS,
       t.LAST_PCP_VISIT,
       t.LAST_PCP_PRACTICE_SEEN,
       t.LAST_BH_VISIT,
       t.LAST_BH_PRACTICE_SEEN,
       t.MEMBER_MONTH_COUNT,
       t.MEMBER_POD_C,
       t.MEMBER_POD_DESC,
       t.PCP_POD_C,
       t.PCP_POD_DESC,
       t.PCP_NAME,
       t.CLIENT_UNIQUE_SYSTEM_ID,
       t.MEDICARE_ID,
       t.RESP_LAST_NAME,
       t.RESP_FIRST_NAME,
       t.RESP_ADDRESS,
       t.RESP_ADDRESS2,
       t.RESP_CITY,
       t.RESP_STATE,
       t.RESP_ZIP,
       t.RESP_PHONE,
	  t.AhsPlanCode,
	  t.AhsPlanName,
	  t.CurMonthsOld, 
	  t.CurYearsOld,
	  t.LoadDate
	  , TRY_CONVERT(VARCHAR(12), t.ClientRiskScore  ) AS ClientRiskScore /*Brit added column for tmpAllMemberMonth Table*/	--- SELECT *  
FROM [dbo].[tvf_Activemembers](GETDATE()) t
    WHERE t.ClientKey <> 1

/* get UHC MEMBERS from UHC tables */
union all
SELECT 'UHC' as CLIENT, 
	  1 as Clientkey,
	  mPCP.UHC_SUBSCRIBER_ID AS MEMBER_ID,
       mPCP.MEMBER_FIRST_NAME,
       mPCP.MEMBER_MI,
       mPCP.MEMBER_LAST_NAME,
       mPCP.UHC_SUBSCRIBER_ID,
	  AceMRN.A_MSTR_MRN AS  Ace_ID, 
       mPCP.PLAN_ID,
       mPCP.PRODUCT_CODE,
       mPCP.SUBGRP_ID,
       mPCP.SUBGRP_NAME,
       mPCP.MEDICAID_ID,
       mPCP.AGE,
       mPCP.DATE_OF_BIRTH,
       mPCP.GENDER,
       mPCP.LANG_CODE,
       mPCP.ETHNICITY_DESC AS ETHNICITY,
       '' AS RACE,
       mPCP.MEMBER_HOME_ADDRESS,
       mPCP.MEMBER_HOME_ADDRESS2,
       mPCP.MEMBER_HOME_CITY,
       mPCP.MEMBER_HOME_STATE,
       LEFT(mPCP.MEMBER_HOME_ZIP, 5) AS MEMBER_HOME_ZIP_C,
       mPCP.MEMBER_HOME_PHONE,
       mPCP.MEMBER_MAIL_ADDRESS,
       mPCP.MEMBER_MAIL_ADDRESS2,
       mPCP.MEMBER_MAIL_CITY,
       mPCP.MEMBER_MAIL_STATE,
       LEFT(mPCP.MEMBER_MAIL_ZIP, 5) AS MEMBER_MAIL_ZIP_C,
       mPCP.MEMBER_MAIL_PHONE,
       mPCP.MEMBER_COUNTY,
       mPCP.MEMBER_BUS_PHONE,
       mPCP.MEMBER_ORG_EFF_DATE,
       mPCP.MEMBER_CONT_EFF_DATE,
       mPCP.MEMBER_CUR_EFF_DATE,
       mPCP.MEMBER_CUR_TERM_DATE,
       mPCP.PCP_UHC_ID,
       mPCP.PCP_FIRST_NAME,
       mPCP.PCP_LAST_NAME,
       mPCP.PCP_NPI,
	  contractedTins.AccountType as PCP_AccountType ,
       mPCP.PCP_PHONE,
       mPCP.PCP_FAX,
       mPCP.PCP_ADDRESS,
       mPCP.PCP_ADDRESS2,
       mPCP.PCP_CITY,
       mPCP.PCP_STATE,
       LEFT(mPCP.PCP_ZIP, 5) AS PCP_ZIP_C,
       mPCP.PCP_EFFECTIVE_DATE,
       mPCP.PCP_TERM_DATE,
       mPCP.PCP_PRACTICE_TIN,
       mPCP.PCP_GROUP_ID,
       --[adi].[udf_ConvertToCamelCase](mPCP.PCP_PRACTICE_NAME) PCP_PRACTICE_NAME, --Brit added function to transform Column
	  CASE WHEN (PracticeGroupName.AttribTINName is null) THEN [adi].[udf_ConvertToCamelCase](mPCP.PCP_PRACTICE_NAME) 
		  else PracticeGroupName.AttribTINName END AS PCP_PRACTICE_NAME,
       mPCP.AUTO_ASSIGN,
       mPCP.MEMBER_STATUS,
       mPCP.MEMBER_TERM_DATE,
       '' as IPRO_ADMIT_RISK_SCORE,--uM_1.IPRO_ADMIT_RISK_SCORE,
       '' as RISK_CATEGORY_C,--um_1.RISK_CATEGORY_C,
       '' as LINE_OF_BUSINESS,--uM_1.LINE_OF_BUSINESS,
       '' as PLAN_CODE,--uM_1.PLAN_CODE,
       '' as PLAN_DESC,--uM_1.PLAN_DESC,
       '' as PRIMARY_RISK_FACTOR,--uM_1.PRIMARY_RISK_FACTOR,
       '' as TOTAL_COSTS_LAST_12_MOS,--uM_1.TOTAL_COSTS_LAST_12_MOS,
       '' as COUNT_OPEN_CARE_OPPS,--uM_1.COUNT_OPEN_CARE_OPPS,
       '' as INP_COSTS_LAST_12_MOS,--uM_1.INP_COSTS_LAST_12_MOS,
       '' as ER_COSTS_LAST_12_MOS,--uM_1.ER_COSTS_LAST_12_MOS,
       '' as OUTP_COSTS_LAST_12_MOS,--uM_1.OUTP_COSTS_LAST_12_MOS,
       '' as PHARMACY_COSTS_LAST_12_MOS,--uM_1.PHARMACY_COSTS_LAST_12_MOS,
       '' as PRIMARY_CARE_COSTS_LAST_12_MOS,--uM_1.PRIMARY_CARE_COSTS_LAST_12_MOS,
       '' as BEHAVIORAL_COSTS_LAST_12_MOS,--uM_1.BEHAVIORAL_COSTS_LAST_12_MOS,
       '' as OTHER_OFFICE_COSTS_LAST_12_MOS,--uM_1.OTHER_OFFICE_COSTS_LAST_12_MOS,
       '' as INP_ADMITS_LAST_12_MOS,--uM_1.INP_ADMITS_LAST_12_MOS,
       '' as LAST_INP_DISCHARGE,--uM_1.LAST_INP_DISCHARGE,
       '' as POST_DISCHARGE_FUP_VISIT,--uM_1.POST_DISCHARGE_FUP_VISIT,
       '' as INP_FUP_WITHIN_7_DAYS,--uM_1.INP_FUP_WITHIN_7_DAYS,
       '' as ER_VISITS_LAST_12_MOS,--uM_1.ER_VISITS_LAST_12_MOS,
       '' as LAST_ER_VISIT,--uM_1.LAST_ER_VISIT,
       '' as POST_ER_FUP_VISIT,--uM_1.POST_ER_FUP_VISIT,
       '' as ER_FUP_WITHIN_7_DAYS,--uM_1.ER_FUP_WITHIN_7_DAYS,
       '' as LAST_PCP_VISIT,--uM_1.LAST_PCP_VISIT,
       '' as LAST_PCP_PRACTICE_SEEN,--uM_1.LAST_PCP_PRACTICE_SEEN,
       '' as LAST_BH_VISIT,--uM_1.LAST_BH_VISIT,
       '' as LAST_BH_PRACTICE_SEEN,--uM_1.LAST_BH_PRACTICE_SEEN,
       '' as MEMBER_MONTH_COUNT,--uM_1.MEMBER_MONTH_COUNT,
       --mPCP.URN AS ACE_MemberByPCP_URN,
       CASE WHEN A.Pod IS NULL THEN 6 ELSE A.Pod  END AS MEMBER_POD_C,
       CASE WHEN A.Quadrant IS NULL THEN 'NOT DEFINED' ELSE A.Quadrant END AS MEMBER_POD_DESC,
       CASE WHEN B.Pod IS NULL THEN 6 ELSE B.Pod END AS PCP_POD_C,
       CASE WHEN B.Quadrant IS NULL THEN 'NOT DEFINED' ELSE B.Quadrant END AS PCP_POD_DESC,
       mpcp.PCP_LAST_NAME + ', ' + mpcp.PCP_FIRST_NAME AS PCP_NAME,
       '' UHC_UNIQUE_SYSTEM_ID,--uM_1.UHC_UNIQUE_SYSTEM_ID,
       mpcp.MEDICARE_ID,
       mpcp.RESP_LAST_NAME,
       mpcp.RESP_FIRST_NAME,
       mpcp.RESP_ADDRESS,
       mpcp.RESP_ADDRESS2,
       mpcp.RESP_CITY,
       mpcp.RESP_STATE,
       mpcp.RESP_ZIP,
       mpcp.RESP_PHONE
    , '' as AhsPlanCode    
    ,  AhsPlanHist.Benefit_Plan as AhsPlanName    
    , DATEDIFF(mm, CONVERT(DATE, CONVERT(DATETIME, mpcp.DATE_OF_BIRTH, 101), 101), GETDATE()) AS CurMonthsOld
    ,DATEDIFF(yy, CONVERT(DATE, CONVERT(DATETIME, mpcp.DATE_OF_BIRTH, 101), 101), GETDATE()) AS CurYearsOld
    , mpcp.A_LAST_UPDATE_DATE as LoadDate -----  -- Brit- 2021-02-03 : Added Column  SELECT distinct uhc_subscriber_id 
	, TRY_CONVERT(VARCHAR(12), ClientRiskScore  ) AS ClientRiskScore  /*Brit added column for tmpAllMemberMonth Table*/
FROM dbo.UHC_MembersByPCP AS mpcp  /*Change Date: 2021-08-25. Brit: Made all below joins a left join and added the condition Result = 'Passed'*/
    LEFT JOIN adw.A_Mbr_Members AceMRN 
		  ON mpcp.UHC_SUBSCRIBER_ID = aceMRN.Client_Member_ID 
		  and AceMrn.Active = 1	   	   
	  LEFT JOIN adw.A_ALT_MemberPlanHistory AhsPlanHist  -- 29923
		  ON mpcp.UHC_SUBSCRIBER_ID = AhsPlanHist.Client_Member_ID
	   		 AND GETDATE() BETWEEN AhsPlanHist.StartDate and AhsPlanHist.stopDate
			 AND AhsPlanHist.planHistoryStatus = 1			 
	  LEFT JOIN (SELECT pr.ClientKey, pr.AttribTIN TIN, pr.AccountType as AccountType
			 FROM adw.tvf_AllClient_ProviderRoster(1,  (select MAX(mpcp.A_LAST_UPDATE_DATE) FROM dbo.UHC_MembersByPCP Mpcp), 1) pr			 
				/* this logic forces the comparison on an INT which allows for non-zero padded varchar values to be equated to padded values */			 				
			 GROUP BY pr.CLientKey, pr.AttribTIN, pr.AccountType) contractedTins 
			 ON try_convert(int, mpcp.PCP_Practice_TIN) = try_convert(int, contractedTins.TIN)  					   /* add practice Name from provider roster for UHC PCP */
	   LEFT JOIN (SELECT pr.ClientKey, pr.AttribTIN, pr.AttribTINName, NPI
					FROM adw.tvf_AllClient_ProviderRoster(1, GETDATE(), 1) pr
			 GROUP BY pr.CLientKey, pr.AttribTIN, pr.AttribTINName, pr.NPI)  PracticeGroupName
			 ON try_convert(int, mpcp.PCP_Practice_TIN) = try_convert(int, PracticeGroupName.AttribTIN)  			
				and 1  = contractedTins.ClientKey 
				AND mpcp.PCP_NPI = PracticeGroupName.NPI
    
    LEFT OUTER JOIN dbo.LIST_ZIPCODES AS A ON LEFT(mPCP.MEMBER_HOME_ZIP, 5) = A.ZipCode
    LEFT OUTER JOIN dbo.LIST_ZIPCODES AS B ON LEFT(mPCP.PCP_ZIP, 5) = B.ZipCode
	WHERE(mpcp.A_LAST_UPDATE_FLAG IN('Y'))	   AND (mpcp.LoadType = 'P' ) 	
	AND mpcp.Result = 'Passed'   


