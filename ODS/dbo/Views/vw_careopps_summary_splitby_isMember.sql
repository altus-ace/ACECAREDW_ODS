/****** Script for SelectTopNRows command from SSMS  ******/
create view vw_careopps_summary_splitby_isMember
as
select a.update_month, a.ace_member, sum(total) as total
from 
(
SELECT  [MemberID]
      ,[update_month]
      ,[NameFirst]
      ,[NameLast]
      ,[DOB]
      ,[TIN_Num]
      ,[ProviderID]
      ,[Provider_NPI]
      ,[Prov_Last_Name]
      ,[Prov_First_Name]
      ,[ACE_MEMBER]
      ,[AWC(Default)]
      ,case when [CDC1 HbA1c<8%] = 999 then 1 else 0 end as [CDC1 HbA1c<8%]
      ,[PPC Postpartum Care]
      ,[PPC Prenatal Care]
      ,[WC3456(Default)]
      ,[BCS(Default)]
      ,[CCS2(Default)]
      ,[FUH 7-Day Follow-Up]
	  ,[AWC(Default)]
      +case when [CDC1 HbA1c<8%] = 999 then 1 else 0 end
      +[PPC Postpartum Care]
      +[PPC Prenatal Care]
      +[WC3456(Default)]
      +[BCS(Default)]
      +[CCS2(Default)]
      +[FUH 7-Day Follow-Up] as total

  FROM [ACECAREDW].[dbo].[vw_current_UHC_CareOpps]
  )a
   group by update_month, ace_member