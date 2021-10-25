
CREATE VIEW [dbo].[vw_RP_HighRiskCohorts_IPVISITS]
AS
/* Report identifies the members in High risk cohort program with Inpatient visits from 10/1/18 onwards */
SELECT [SUBSCRIBER_ID]
      --,[CLAIM_NUMBER]
      --,[CATEGORY_OF_SVC]
      --,[PAT_CONTROL_NO]
      ,[ICD_PRIM_DIAG]
--	   ,ccs.[ICD-10-CM_CODE_DESCRIPTION]
      ,[PRIMARY_SVC_DATE]
      ,[SVC_TO_DATE]
	  ,DATEDIFF(day,PRIMARY_SVC_DATE,SVC_To_DATE) as LOS
      --,[CLAIM_THRU_DATE]
      --,[POST_DATE]
      --,[CHECK_DATE]
      --,[CHECK_NUMBER]
      --,[DATE_RECEIVED]
      --,[ADJUD_DATE]
      ,[SVC_PROV_ID]
      ,[SVC_PROV_FULL_NAME]
      ,[SVC_PROV_NPI]
      ,[PROV_SPEC]
      ,[PROV_TYPE]
      --,[PROVIDER_PAR_STAT]
      --,[ATT_PROV_ID]
      ,[ATT_PROV_FULL_NAME]
      ,[ATT_PROV_NPI]
      --,[REF_PROV_ID]
      --,[REF_PROV_FULL_NAME]
      ,[VENDOR_ID]
      ,[VEND_FULL_NAME]
      ----,[IRS_TAX_ID]
      --,[DRG_CODE]
      --,[BILL_TYPE]
      --,[ADMISSION_DATE]
      --,[AUTH_NUMBER]
      --,[ADMIT_SOURCE_CODE]
      --,[ADMIT_HOUR]
      --,[DISCHARGE_HOUR]
      --,[PATIENT_STATUS]
      --,[CLAIM_STATUS]
      --,[PROCESSING_STATUS]
      --,[CLAIM_TYPE]
      ,[TOTAL_BILLED_AMT]
      --,[A_CREATED_DATE]
      --,[A_CREATED_BY]
      --,[A_LST_UPDATED_DATE]
      --,[A_LST_UPDATED_BY]
	 
FROM [ACECAREDW_TEST].[dbo].[Claims_Headers] claims
inner join [ACECAREDW].[dbo].[UHC_MembersByPCP] mbrs on claims.subscriber_id = mbrs.UHC_SUBSCRIBER_ID
left join [ACECAREDW_TEST].[dbo].[ICDCCS] CCS on ccs.[ICD-10-CM_CODE] = claims.ICD_PRIM_DIAG
  where mbrs.SUBGRP_ID in (
'TX99',
'1001',
'1002',
'1003',
'0603',
'0601',
'0602',
'0600',
'0606',
'0604',
'0605')
and mbrs.A_LAST_UPDATE_DATE >= '2018-10-11'
  and claims.primary_svc_date >= '2018-10-01'
  and claims.category_of_svc = 'INPATIENT'
