

create view vw_co_gap_vs_mbr_cnt
as
select A.month, B.count_mbr as MBR_count, A.Meas, A.count_memb as CO_CNT
from (
SELECT
      concat([Measure_Desc],' ', [Sub_Meas]) as Meas
      
      ,month([A_LAST_UPDATE_DATE]) as month	
	, count(distinct memberID) as count_memb
  FROM [ACECAREDW].[dbo].[UHC_CareOpps] 
  where year(a_last_update_date) = 2018 
  group by concat([Measure_Desc],' ', [Sub_Meas]) ,month([A_LAST_UPDATE_DATE]) ) A
  join (SELECT  month(date) as month , count(distinct [MEMBER_ID]) as count_mbr 
      
  FROM [ACECAREDW].[dbo].[vw_uhc_active_members_all_first_load]
  where year(date) = 2018
  group by month(date)) B on A.month = B.month
