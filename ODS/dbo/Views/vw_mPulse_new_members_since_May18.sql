CREATE view [dbo].[vw_mPulse_new_members_since_May18]
as
select distinct member_id 
FROM [ACECAREDW].[dbo].[vw_UHC_ActiveMembers]