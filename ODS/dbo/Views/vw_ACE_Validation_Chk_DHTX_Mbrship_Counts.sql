
CREATE VIEW [dbo].[vw_ACE_Validation_Chk_DHTX_Mbrship_Counts]
AS
select distinct devoted_member_id from acdw_clms_dhtx.[adi].[DHTX_MembershipEnrollment] a
join acecaredw.[dbo].[vw_Devoted_ProviderRoster] b on b.NPI = a.PCP_NPI
where filedate = '2020-02-05' --(select max(filedate) from acdw_clms_dhtx.[adi].[DHTX_MembershipEnrollment])
and a.Coverage_End_Date is null
and a.Coverage_Effective_Date <= getdate()
and isnull(PCP_End_Date,'12/31/2099') >= getdate()
and PCP_Effective_Date <= getdate()
except 
select distinct MEMBER_ID from vw_ActiveMembers a where a.clientkey = 11;
