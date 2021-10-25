
CREATE view [dbo].[vw_ACE_Validation_Chk_AET_multipleeligbilitylines]
as
select * from ( select m.clientmemberkey,mp.MbrMemberKey,mp.EffectiveDate,mp.ExpirationDate,mp.MbrCsSubPlan
,	row_Number() over(Partition by m.clientMemberkey  order by mp.ExpirationDate desc) as brn from adw.mbrCsPlanHistory mp
inner join adw.MbrMember m on m.mbrMemberKey=mp.MbrMemberKey and m.ClientKey=3
) x where x.brn>=2
and expirationdate > getdate()
--where GETDATE() between mp.EffectiveDate and mp.ExpirationDate
