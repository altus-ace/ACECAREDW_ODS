
create view vw_retention_data_set
as 
select 
  a.dates
, month(a.dates) as Month_of
, year(a.dates) as year_of
, a.subscriber_id
, datediff(month,date_start, dates)+1 as mbr_mths
, c.gender
, c.risk_score
, c.assign
, c.LOB
, c.time_from_ORG_EFF
, c.time_from_CONT_EFF
, c.Age
, c.PCP_PRACTICE_TIN
, case when b.dropped is null then 0 else 1 end as dropped
 from acecaredw.dbo.tmp_Mbr_mth a left join acecaredw_test.dbo.vw_mbr_drop b on a.subscriber_id = b.subscriber_id and a.dates = b.date
 left join acecaredw_test.dbo.vw_mbr_info c on a.subscriber_id = c.subscriber_id and a.dates = c.date

