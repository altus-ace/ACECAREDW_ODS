/****** Script for SelectTopNRows command from SSMS  ******/
CREATE view vw_careopp_maps
as 
SELECT [MEMBER_ID]
      ,[MEMBER_FIRST_NAME]
      ,[MEMBER_MI]
      ,[MEMBER_LAST_NAME]
      ,[PLAN_ID]
      ,[PRODUCT_CODE]
      ,[SUBGRP_ID]
      ,[SUBGRP_NAME]
      ,[MEDICAID_ID]
      ,[AGE]
      ,[DATE_OF_BIRTH]
      ,[MEMBER_HOME_ADDRESS]
      ,[MEMBER_HOME_ADDRESS2]
      ,[MEMBER_HOME_CITY]
      ,[MEMBER_HOME_STATE]
      ,[MEMBER_HOME_ZIP_C]
	  ,[AUTO_ASSIGN]
	  , PCP_FIRST_NAME
	  ,PCP_LAST_NAME
	  ,a.PCP_PRACTICE_TIN
	  ,TIN_Name
	  ,b.[Breast Cancer Screening (Default)]
	  ,b.[Cervical Cancer Screening (Medicaid/Marketplace) (Default)]
  FROM [ACECAREDW].[dbo].[vw_UHC_ActiveMembers]a
  join [ACECAREDW].[dbo].[vw_care_op_distr_list]b on a.UHC_SUBSCRIBER_ID = b.MemberID 
  where a.PCP_PRACTICE_tin = 760009637 and (b.[Breast Cancer Screening (Default)] >=1 or b.[Cervical Cancer Screening (Medicaid/Marketplace) (Default)] >=1)