CREATE view vw_consecutive_enrollment
as
select bin.UHC_SUBSCRIBER_ID, bin.consecutive_mth, case when bin.consecutive_mth = 1 then 'MTHS 0-1'
								 when  bin.consecutive_mth >1 and bin.consecutive_mth <=3 then 'MTHS 2-3'
								 
								 when  bin.consecutive_mth >3 and bin.consecutive_mth <=6 then 'MTHS 4-6'
								 
								 when  bin.consecutive_mth >6 and bin.consecutive_mth <=9 then 'MTHS 7-9'
								 when  bin.consecutive_mth >9 and bin.consecutive_mth <=12 then 'MTHS 10-12' end as bucket
from 
(
select  distinct a.UHC_SUBSCRIBER_ID, case when b.consecutive_months is null then MONTH(GETDATE()) else b.consecutive_months end as consecutive_mth
from vw_member_trend a
left join 
(
select a.UHC_SUBSCRIBER_ID, MONTH(GETDATE())-max(a.MBR_MTH) as consecutive_months
from
(select a.MBR_MTH,b.UHC_SUBSCRIBER_ID
from (select distinct mbr_mth from vw_member_trend)a,(select distinct [UHC_SUBSCRIBER_ID] from vw_member_trend)b
except
select MBR_MTH,UHC_SUBSCRIBER_ID
from vw_member_trend) a
group by a.UHC_SUBSCRIBER_ID
) b on a.UHC_SUBSCRIBER_ID = b.UHC_SUBSCRIBER_ID
inner join ACECAREDW.dbo.vw_UHC_ActiveMembers act on act.member_id = a.uhc_subscriber_id
) bin