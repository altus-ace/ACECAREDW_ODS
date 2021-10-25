
CREATE view [dbo].[vw_membership_all_for_INF]
as
select
CONVERT(varchar(12)       ,a.[MEMBER_ID])as  [M_Registration_ID],
CONVERT(varchar(5)     , c.A_IS_Client_ID)as [CLIENT_ID],
CONVERT(varchar(50)     , a.[MEMBER_FIRST_NAME])as [M_First_Name],
CONVERT(varchar(50)     , a.[MEMBER_LAST_NAME])as [M_Last_Name],
CONVERT(varchar(50)     , a.[MEMBER_MI])as [M_Middle_Name],
CONVERT(char(1)     , a.[GENDER])as [M_Gender],
CONVERT(datetime     , a.[DATE_OF_BIRTH])as [M_Date_Of_Birth],
CONVERT(varchar(20)     , a.[MEMBER_MAIL_PHONE])as [M_Alternate_Number],
CONVERT(varchar(20)     , a.[MEMBER_HOME_PHONE])as [M_Mobile_Number],
CONVERT(varchar(150)     , a.[MEMBER_HOME_ADDRESS])as [M_Address_Line1_Res],
CONVERT(varchar(150)     , a.[MEMBER_HOME_ADDRESS2])as [M_Address_Line2_Res],
CONVERT(varchar(50)     , a.[MEMBER_HOME_CITY])as [M_City_Res],
CONVERT(varchar(30)     , a.[MEMBER_HOME_STATE])as [M_State_Res],
CONVERT(varchar(9)     , a.[MEMBER_HOME_ZIP_C])as [M_Zip_Code_Res],
CONVERT(varchar(150)     , a.[MEMBER_MAIL_ADDRESS])as [M_Address_Line1_Office],
CONVERT(varchar(150)     , a.[MEMBER_MAIL_ADDRESS2])as [M_Address_Line2_Office],
CONVERT(varchar(50)     , a.[MEMBER_MAIL_CITY])as [M_City_Office],
CONVERT(varchar(30)     , a.[MEMBER_MAIL_STATE])as [M_State_Office],
CONVERT(varchar(30)     , a.[MEMBER_COUNTY])as [M_County_Office],
CONVERT(varchar(9)     , a.[MEMBER_MAIL_ZIP_C])as [M_Zip_Code_Office],
CONVERT(varchar(12)     , a.[UHC_SUBSCRIBER_ID])as [SUBSCRIBER_ID],
CONVERT(varchar(50)     , a.[LINE_OF_BUSINESS])as [LINE_OF_BUSINESS],
CONVERT(varchar(15)     , a.[PLAN_CODE])as [PLAN_CODE],
CONVERT(varchar(30)     , a.[PLAN_DESC])as [PLAN_DESC],
CONVERT(varchar(15)     , a.[PLAN_ID])as [PLAN_ID],
CONVERT(varchar(30)     , a.[PRODUCT_CODE])as [PRODUCT_CODE],
CONVERT(varchar(15)     , a.[SUBGRP_ID])as [SUBGRP_ID],
CONVERT(varchar(100)     , a.[SUBGRP_NAME])as [SUBGRP_NAME],
CONVERT(varchar(15)     , a.[MEDICAID_ID])as [MEDICAID_ID],
CONVERT(varchar(15)     , a.[MEDICARE_ID])as [MEDICARE_ID],
CONVERT(varchar(10)     , a.[PCP_PRACTICE_TIN])as [PCP_PRACTICE_TIN],
CONVERT(varchar(10)     , a.[PCP_NPI])as [PCP_NPI],
CONVERT(varchar(35)     , a.[PCP_FIRST_NAME])as [PCP_FIRST_NAME],
CONVERT(varchar(35)     , a.[PCP_LAST_NAME])as [PCP_LAST_NAME],
CONVERT(varchar(20)     , a.[MEMBER_ORG_EFF_DATE])as [MEMBER_ORG_EFF_DATE],
CONVERT(varchar(20)     , a.[MEMBER_CONT_EFF_DATE])as [MEMBER_CONT_EFF_DATE],
CONVERT(varchar(20)     , a.[MEMBER_CUR_EFF_DATE])as [MEMBER_CUR_EFF_DATE],
CONVERT(varchar(20)     , a.[MEMBER_CUR_TERM_DATE])as [MEMBER_CUR_TERM_DATE],
CONVERT(varchar(10)     , a.[AUTO_ASSIGN])as [AUTO_ASSIGN],
CONVERT(varchar(5)     , a.[MEMBER_STATUS])as [MEMBER_STATUS],
CONVERT(varchar(20)     , a.[MEMBER_TERM_DATE])as [MEMBER_TERM_DATE],
CONVERT(varchar(20)     , a.[IPRO_ADMIT_RISK_SCORE])as [CLIENT_ADMIT_RISK_SCORE],
CONVERT(varchar(15)     , a.[RISK_CATEGORY_C])as [CLIENT_RISK_CATEGORY_C],
CONVERT(varchar(100)     , a.[PRIMARY_RISK_FACTOR])as [PRIMARY_RISK_FACTOR],
CONVERT(varchar(20)     , a.[TOTAL_COSTS_LAST_12_MOS])as [TOTAL_COSTS_LAST_12_MOS],
CONVERT(varchar(20)     , a.[COUNT_OPEN_CARE_OPPS])as [COUNT_OPEN_CARE_OPPS],
CONVERT(varchar(20)     , a.[INP_COSTS_LAST_12_MOS])as [INP_COSTS_LAST_12_MOS],
CONVERT(varchar(20)     , a.[ER_COSTS_LAST_12_MOS])as [ER_COSTS_LAST_12_MOS],
CONVERT(varchar(20)     , a.[OUTP_COSTS_LAST_12_MOS])as [OUTP_COSTS_LAST_12_MOS],
CONVERT(varchar(20)     , a.[PHARMACY_COSTS_LAST_12_MOS])as [PHARMACY_COSTS_LAST_12_MOS],
CONVERT(varchar(20)     , a.[PRIMARY_CARE_COSTS_LAST_12_MOS])as [PRIMARY_CARE_COSTS_LAST_12_MOS],
CONVERT(varchar(20)     , a.[BEHAVIORAL_COSTS_LAST_12_MOS])as [BEHAVIORAL_COSTS_LAST_12_MOS],
CONVERT(varchar(20)     , a.[OTHER_OFFICE_COSTS_LAST_12_MOS])as [OTHER_OFFICE_COSTS_LAST_12_MOS],
CONVERT(varchar(20)     , a.[INP_ADMITS_LAST_12_MOS])as [INP_ADMITS_LAST_12_MOS],
CONVERT(datetime     , a.[LAST_INP_DISCHARGE])as [LAST_INP_DISCHARGE],
CONVERT(varchar(20)     , a.[ER_VISITS_LAST_12_MOS])as [ER_VISITS_LAST_12_MOS],
CONVERT(datetime     , a.[LAST_ER_VISIT])as [LAST_ER_VISIT],
CONVERT(datetime     , a.[LAST_PCP_VISIT])as [LAST_PCP_VISIT],
CONVERT(varchar(100)     , a.[LAST_PCP_PRACTICE_SEEN])as [LAST_PCP_PRACTICE_SEEN],
CONVERT(datetime     , a.[LAST_BH_VISIT])as [LAST_BH_VISIT],
CONVERT(varchar(100)     , a.[LAST_BH_PRACTICE_SEEN])as [LAST_BH_PRACTICE_SEEN],
CONVERT(varchar(5)     , a.[MEMBER_POD_C])as [MEMBER_POD],
CONVERT(varchar(25)     , a.[MEMBER_POD_DESC])as [MEMBER_POD_DESC],

YEAR(a.a_last_update_date) as [MBR_YEAR],
MONTH(a.a_last_update_date) as [MBR_MTH],
CONVERT(datetime     , CONVERT(DATE, GETDATE(), 101))as [LOAD_DATE],
CONVERT(varchar(50)     , SYSTEM_USER )as [LOAD_USER]


FROM [ACECAREDW].[dbo].[vw_UHC_ActiveMembers_ALL] AS a
     JOIN [ACECAREDW].[adw].[A_LIST_Clients] c ON 1 = c.A_Client_ID
     JOIN(SELECT
		   aaa.[LOAD_KEY]
		  , aaa.[LOAD_DATE]
		  FROM
		  (SELECT
			   aa.[LOAD_KEY]
			 , aa.[LOAD_DATE]
			 , ROW_NUMBER() OVER(PARTITION BY MONTH(load_date),year(load_date) ORDER BY load_date ASC) AS rank
		  FROM [ACECAREDW].[ast].[A_vw_UHC_Get_MemberLoadDates] AS aa
		  ) AS aaa
		  WHERE aaa.rank = 1
	   ) AS b ON a.a_last_update_date = b.load_date;
