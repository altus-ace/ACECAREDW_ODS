






CREATE VIEW [dbo].[zz_vw_UHC_ActiveMembers_01]
AS
     SELECT
            umPCP.UHC_SUBSCRIBER_ID AS MEMBER_ID
          , umPCP.MEMBER_FIRST_NAME
          , umPCP.MEMBER_MI
          , umPCP.MEMBER_LAST_NAME
          , umPCP.UHC_SUBSCRIBER_ID
          , umPCP.PLAN_ID
          , umPCP.PRODUCT_CODE
          , umPCP.SUBGRP_ID
          , umPCP.SUBGRP_NAME
          , umPCP.MEDICAID_ID
          , umPCP.AGE
          , umPCP.DATE_OF_BIRTH
          , umPCP.GENDER
          , umPCP.LANG_CODE
		,umPCP.[ETHNICITY_DESC] AS ETHNICITY
		,'' AS RACE
          , umPCP.MEMBER_HOME_ADDRESS
          , umPCP.MEMBER_HOME_ADDRESS2
          , umPCP.MEMBER_HOME_CITY
          , umPCP.MEMBER_HOME_STATE
          , LEFT(umPCP.MEMBER_HOME_ZIP, 5) AS MEMBER_HOME_ZIP_C
          , umPCP.MEMBER_HOME_PHONE
          , umPCP.MEMBER_MAIL_ADDRESS
          , umPCP.MEMBER_MAIL_ADDRESS2
          , umPCP.MEMBER_MAIL_CITY
          , umPCP.MEMBER_MAIL_STATE
          , LEFT(umPCP.MEMBER_MAIL_ZIP, 5) AS MEMBER_MAIL_ZIP_C
          , umPCP.MEMBER_MAIL_PHONE
          , umPCP.MEMBER_COUNTY
          , umPCP.MEMBER_BUS_PHONE
          , umPCP.MEMBER_ORG_EFF_DATE
          , umPCP.MEMBER_CONT_EFF_DATE
          , umPCP.MEMBER_CUR_EFF_DATE
          , umPCP.MEMBER_CUR_TERM_DATE
          , umPCP.PCP_UHC_ID
          , umPCP.PCP_FIRST_NAME
          , umPCP.PCP_LAST_NAME
          , umPCP.PCP_NPI
          , umPCP.PCP_PHONE
          , umPCP.PCP_FAX
          , umPCP.PCP_ADDRESS
          , umPCP.PCP_ADDRESS2
          , umPCP.PCP_CITY
          , umPCP.PCP_STATE
          , LEFT(umPCP.PCP_ZIP, 5) AS PCP_ZIP_C
          , umPCP.PCP_EFFECTIVE_DATE
          , umPCP.PCP_TERM_DATE
          , umPCP.PCP_PRACTICE_TIN
          , umPCP.PCP_GROUP_ID
          , umPCP.PCP_PRACTICE_NAME
          , umPCP.AUTO_ASSIGN
          , umPCP.MEMBER_STATUS
          , umPCP.MEMBER_TERM_DATE
          , try_convert(Numeric(10,2),uM_1.IPRO_ADMIT_RISK_SCORE) as IPRO_ADMIT_RISK_SCORE
          , dbo.sv_CalcRiskCategory(CONVERT(NUMERIC(10, 4), uM_1.IPRO_ADMIT_RISK_SCORE)) AS RISK_CATEGORY_C
          , uM_1.LINE_OF_BUSINESS
          , uM_1.PLAN_CODE
          , uM_1.PLAN_DESC
          , uM_1.PRIMARY_RISK_FACTOR
		,try_convert(numeric(14,2) ,replace( replace(uM_1.TOTAL_COSTS_LAST_12_MOS,'$',''),',','')) as TOTAL_COSTS_LAST_12_MOS
   		,try_convert(numeric(5),uM_1.COUNT_OPEN_CARE_OPPS) as COUNT_OPEN_CARE_OPPS
		,try_convert(numeric(14,2) ,replace( replace(uM_1.INP_COSTS_LAST_12_MOS,'$',''),',','')) as INP_COSTS_LAST_12_MOS		
		,try_convert(numeric(14,2) ,replace( replace(uM_1.ER_COSTS_LAST_12_MOS,'$',''),',','')) as ER_COSTS_LAST_12_MOS
 		,try_convert(numeric(14,2) ,replace( replace(uM_1.OUTP_COSTS_LAST_12_MOS,'$',''),',','')) as OUTP_COSTS_LAST_12_MOS
 		,try_convert(numeric(14,2) ,replace( replace(uM_1.PHARMACY_COSTS_LAST_12_MOS,'$',''),',','')) as PHARMACY_COSTS_LAST_12_MOS
		,try_convert(numeric(14,2) ,replace( replace(uM_1.PRIMARY_CARE_COSTS_LAST_12_MOS,'$',''),',','')) as PRIMARY_CARE_COSTS_LAST_12_MOS    
		,try_convert(numeric(14,2) ,replace( replace(uM_1.BEHAVIORAL_COSTS_LAST_12_MOS,'$',''),',','')) as BEHAVIORAL_COSTS_LAST_12_MOS
		,try_convert(numeric(14,2) ,replace(replace(uM_1.OTHER_OFFICE_COSTS_LAST_12_MOS,'$',''),',','')) as OTHER_OFFICE_COSTS_LAST_12_MOS 
		,try_convert(numeric(5),uM_1.INP_ADMITS_LAST_12_MOS) as INP_ADMITS_LAST_12_MOS  
          , uM_1.LAST_INP_DISCHARGE
          , uM_1.POST_DISCHARGE_FUP_VISIT
          , uM_1.INP_FUP_WITHIN_7_DAYS
		,try_convert(numeric(5),uM_1.ER_VISITS_LAST_12_MOS) as ER_VISITS_LAST_12_MOS    
          , uM_1.LAST_ER_VISIT
          , uM_1.POST_ER_FUP_VISIT
          , uM_1.ER_FUP_WITHIN_7_DAYS
          , uM_1.LAST_PCP_VISIT
          , uM_1.LAST_PCP_PRACTICE_SEEN
          , uM_1.LAST_BH_VISIT 
          , uM_1.LAST_BH_PRACTICE_SEEN
          , uM_1.MEMBER_MONTH_COUNT
          , umPCP.URN AS ACE_MemberByPCP_URN
          , uM_1.URN AS ACE_Membership_URN
          , CASE
                WHEN A.Pod IS NULL
                THEN 6
                ELSE A.Pod
            END AS MEMBER_POD_C
          , CASE
                WHEN A.Quadrant IS NULL
                THEN 'NOT DEFINED'
                ELSE A.Quadrant
            END AS MEMBER_POD_DESC
          , CASE
                WHEN B.Pod IS NULL
                THEN 6
                ELSE B.Pod
            END AS PCP_POD_C
          , CASE
                WHEN B.Quadrant IS NULL
                THEN 'NOT DEFINED'
                ELSE B.Quadrant
            END AS PCP_POD_DESC
          , uM_1.PCP_NAME
          , uM_1.UHC_UNIQUE_SYSTEM_ID
          , umPCP.MEDICARE_ID
          , umPCP.RESP_LAST_NAME
          , umPCP.RESP_FIRST_NAME
          , umPCP.RESP_ADDRESS
          , umPCP.RESP_ADDRESS2
          , umPCP.RESP_CITY
          , umPCP.RESP_STATE
          , umPCP.RESP_ZIP
          , umPCP.RESP_PHONE
		, DATEDIFF(mm, CONVERT(DATE, umPCP.DATE_OF_BIRTH, 101), GETDATE()) AS CurMonthsOld
		, DATEDIFF(yy, CONVERT(DATE, umPCP.DATE_OF_BIRTH, 101), GETDATE()) AS CurYearsOld
     FROM
     (
         SELECT
                URN
              , MEMBER_FIRST_NAME
              , MEMBER_MI
              , MEMBER_LAST_NAME
              , UHC_SUBSCRIBER_ID
              , CLASS
              , PLAN_ID
              , PRODUCT_CODE
              , SUBGRP_ID
              , SUBGRP_NAME
              , MEDICARE_ID
              , MEDICAID_ID
              , AGE
              , DATE_OF_BIRTH
              , GENDER
              , RELATIONSHIP_CODE
              , LANG_CODE
		    ,[ETHNICITY_DESC]
              , MEMBER_HOME_ADDRESS
              , MEMBER_HOME_ADDRESS2
              , MEMBER_HOME_CITY
              , MEMBER_HOME_STATE
              , MEMBER_HOME_ZIP
              , MEMBER_HOME_PHONE
              , MEMBER_MAIL_ADDRESS
              , MEMBER_MAIL_ADDRESS2
              , MEMBER_MAIL_CITY
              , MEMBER_MAIL_STATE
              , MEMBER_MAIL_ZIP
              , MEMBER_MAIL_PHONE
              , MEMBER_COUNTY_CODE
              , MEMBER_COUNTY
              , MEMBER_BUS_PHONE
              , DUAL_COV_FLAG
              , MEMBER_ORG_EFF_DATE
              , MEMBER_CONT_EFF_DATE
              , MEMBER_CUR_EFF_DATE
              , MEMBER_CUR_TERM_DATE
              , CLASS_PLAN_ID
              , RESP_LAST_NAME
              , RESP_FIRST_NAME
              , RESP_ADDRESS
              , RESP_ADDRESS2
              , RESP_CITY
              , RESP_STATE
              , RESP_ZIP
              , RESP_PHONE
              , BROKER_ID
              , PCP_UHC_ID
              , PCP_FIRST_NAME
              , PCP_LAST_NAME
              , PCP_MPIN
              , PCP_NPI
              , PCP_PROV_TYPE_ID
              , PCP_PROV_TYPE
              , PCP_INDICATOR
              , CMG
              , PCP_PHONE
              , PCP_FAX
              , PCP_ADDRESS
              , PCP_ADDRESS2
              , PCP_CITY
              , PCP_STATE
              , PCP_ZIP
              , PCP_COUNTY
              , PCP_EFFECTIVE_DATE
              , PCP_TERM_DATE
              , PCP_PRACTICE_TIN
              , PCP_GROUP_ID
              , PCP_PRACTICE_NAME
              , IND_PRACT_ID
              , IND_PRACT_NAME
              , RECERT_DATE
              , ETHNICITY
              , AUTO_ASSIGN
              , ASAP_ID
              , FEW_ID
              , LST_HRA_DATE
              , NXT_HRA_DATE
              , HRA_ID
              , A_LAST_UPDATE_DATE
              , A_LAST_UPDATE_BY
              , A_LAST_UPDATE_FLAG
              , MEMBER_STATUS
              , MEMBER_TERM_DATE
         FROM dbo.UHC_MembersByPCP AS mpcp
         WHERE (A_LAST_UPDATE_FLAG IN ('Y', 'L') 
		  AND mpcp.LoadType = 'P') /* last load was a secondary, this needs to be reviewed and cleaned up 1/29 */
     ) AS umPCP
     LEFT OUTER JOIN
     (
         SELECT
              um.URN
              , um.UHC_SUBSCRIBER_ID
		    , um.IPRO_ADMIT_RISK_SCORE
		    , um.LINE_OF_BUSINESS
		    , um.PLAN_CODE
		    , um.PLAN_DESC
		    , um.PRIMARY_RISK_FACTOR
		    , um.TOTAL_COSTS_LAST_12_MOS
		    , um.COUNT_OPEN_CARE_OPPS
		    , um.INP_COSTS_LAST_12_MOS
		    , um.ER_COSTS_LAST_12_MOS
		    , um.OUTP_COSTS_LAST_12_MOS
		    , um.PHARMACY_COSTS_LAST_12_MOS
		    , um.PRIMARY_CARE_COSTS_LAST_12_MOS
		    , um.BEHAVIORAL_COSTS_LAST_12_MOS
		    , um.OTHER_OFFICE_COSTS_LAST_12_MOS
		    , um.INP_ADMITS_LAST_12_MOS
		    , um.LAST_INP_DISCHARGE
		    , um.POST_DISCHARGE_FUP_VISIT
		    , um.INP_FUP_WITHIN_7_DAYS
		    , um.ER_VISITS_LAST_12_MOS
		    , um.LAST_ER_VISIT
		    , um.POST_ER_FUP_VISIT
		    , um.ER_FUP_WITHIN_7_DAYS
		    , um.LAST_PCP_VISIT
		    , um.LAST_PCP_PRACTICE_SEEN
		    , um.LAST_BH_VISIT
		    , um.LAST_BH_PRACTICE_SEEN
		    , um.MEMBER_MONTH_COUNT		    
		    , um.URN AS ACE_Membership_URN
		    , um.PCP_NAME
		    , um.UHC_UNIQUE_SYSTEM_ID
         FROM dbo.UHC_Membership AS um
         WHERE(A_LAST_UPDATE_FLAG = 'Y')
     ) AS uM_1 ON umPCP.UHC_SUBSCRIBER_ID = uM_1.UHC_SUBSCRIBER_ID
     LEFT OUTER JOIN dbo.LIST_ZIPCODES AS A ON LEFT(umPCP.MEMBER_HOME_ZIP, 5) = A.ZipCode
     LEFT OUTER JOIN dbo.LIST_ZIPCODES AS B ON LEFT(umPCP.PCP_ZIP, 5) = B.ZipCode;


