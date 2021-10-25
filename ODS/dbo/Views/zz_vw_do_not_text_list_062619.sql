
/****** Script for SelectTopNRows command from SSMS  ******/



CREATE view [dbo].[zz_vw_do_not_text_list_062619]
as
  SELECT distinct  [MEMBER_ID]
    
      ,[PCP_NPI]
 
      ,[PCP_PRACTICE_TIN]
 
  FROM [ACECAREDW].[dbo].[vw_UHC_ActiveMembers] 
  where 
  PCP_PRACTICE_TIN  in (select distinct PCP_PRACTICE_TIN FROM [AceCareDw_Qa].[adw].[PrvTinDoNotText])
or
  [PCP_NPI]  in (SELECT distinct PCP_NPI  FROM [AceCareDw_Qa].[adw].[prvDoNotText])
or
  MEMBER_ID in (SELECT distinct [ClientMemberKey] FROM [AceCareDw_Qa].[adw].[mbrDoNotText])
  --or 
 -- MEMBER_ID in (SELECT distinct [Client_patient_id]  FROM [ACECAREDW].[dbo].[vw_AH_Mpluse_MembersDonotCall])
