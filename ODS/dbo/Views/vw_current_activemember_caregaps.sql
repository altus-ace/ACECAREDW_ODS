create view vw_current_activemember_caregaps as
SELECT  [MemberID]
      ,[update_month]
      ,[NameFirst]
      ,[NameLast]
      ,[DOB]
      ,[TIN_Num]
      ,[ProviderID]
      ,[Provider_NPI]
      ,[AWC(Default)]
      ,[CDC1 HbA1c<8%]
      ,[PPC Postpartum Care]
      ,[PPC Prenatal Care]
      ,[WC3456(Default)]
  FROM [ACECAREDW].[dbo].[vw_current_UHC_CareOpps] a
  join ACECAREDW.dbo.vw_UHC_ActiveMembers b on a.MemberID = b.member_id
  where update_month = month(getdate())