
 create view vw_CO_Active_by_TIN
 as
  select *,  SUM(bb.#closed) OVER( partition by bb.year, bb.TIN  ORDER BY bb.month) as #closedsum,  bb.op_co_curr+ SUM(bb.#closed) OVER( partition by bb.year, bb.TIN ORDER BY bb.month) as Den,  
  cast(SUM(bb.#closed) OVER( partition by bb.year , bb.TIN ORDER BY bb.month) as float)/(bb.op_co_curr+ SUM(bb.#closed) OVER( partition by bb.year, bb.TIN ORDER BY bb.month))*100 as perc_Num_Den
  from
  (
  select  aa.month, aa.year, aa.TIN , case when aa.month = 1 then 0 else aa.#closed end as #closed, aa.op_co_curr

   from 
  (


 select distinct a.month ,a.year,a.TIN--, month(dateadd(month,-1,a.date)) as lmonth , year(dateadd(month,-1,a.date)) as lyear
 ,
 (

 select count(*) as  #closed from 
(select * from vw_distinct_CO_filter_act_member x where x.month = month(dateadd(month,-1,a.date))  and x.year = year(dateadd(month,-1,a.date))
and x.memberID in ( select distinct subscriber_id from vw_membership_all_for_INF z
 where z.mbr_mth =a.month and z.mbr_year =a.year  and z.subscriber_id = x.memberID and z.pcp_practice_tin = x.TIN  ))xx
  
   left join (
   select * from vw_distinct_CO_filter_act_member o
 where o.month =a.month and o.year = a.year)y on xx.memberId = y.memberId and xx.measure_desc = y.measure_desc and xx.sub_meas = y.sub_meas
where (y.memberId is null or  y.measure_desc is null or y.sub_meas is null) and xx.TIN = a.TIN

 
 ) as #closed
 --(select count(*) from vw_distinct_CO_filter_act_member b 
 --where b.month = month(dateadd(month,-1,a.date)) and b.year = year(dateadd(month,-1,a.date))) as last_month,
 ,
 (select count(*) from vw_distinct_CO_filter_act_member b 
 where b.month = a.month and b.year = a.year and b.TIN = a.TIN ) as op_co_curr
   from  vw_distinct_CO_filter_act_member a 



   )aa
   
   )bb




