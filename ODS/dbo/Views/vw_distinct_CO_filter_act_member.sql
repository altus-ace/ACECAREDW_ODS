CREATE view [dbo].[vw_distinct_CO_filter_act_member] 
as
SELECT a.* ,b.PCP_PRACTICE_TIN as TIN, b.PCP_NPI as NPI
  FROM (select distinct measure_desc, sub_meas, memberID, month(a_last_update_date) as month, year(a_last_update_date) as year, a_last_update_date as date from [ACECAREDW].[dbo].[UHC_CareOpps]) a
  join vw_membership_all_for_INF b on a.memberID = b.[SUBSCRIBER_ID] and a.month = b.[MBR_MTH] and a.year = b.[MBR_YEAR]

