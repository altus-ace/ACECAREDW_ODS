create view monthly_membership_trend_by_practice_tin
as
select 
a.a_last_update_date,
a.pcp_practice_tin,
c.active_count,
lag(c.active_count,1,0) OVER (ORDER BY a.A_LAST_UPDATE_DATE) as active_count_lag1,
lag(c.active_count,2,0) OVER (ORDER BY a.A_LAST_UPDATE_DATE) as active_count_lag2,
c.active_count-lag(c.active_count,1,0) OVER (ORDER BY a.A_LAST_UPDATE_DATE) as act_diff_lag1, 
c.active_count-lag(c.active_count,2,0) OVER (ORDER BY a.A_LAST_UPDATE_DATE) as act_diff_lag2, 
a.newly_enrolled_count,
lag(a.newly_enrolled_count,1,0) OVER (ORDER BY a.A_LAST_UPDATE_DATE) as new_count_lag1,
d.existing_count,
lag(d.existing_count,1,0) OVER (ORDER BY a.A_LAST_UPDATE_DATE) as exist_count_lag1,
b.termed_count,
lag(b.termed_count,1,0) OVER (ORDER BY a.A_LAST_UPDATE_DATE) as term_count_lag1

from 
-- newly enrolled
(
SELECT e1.A_LAST_UPDATE_DATE
	,e1.pcp_practice_tin
	,count(distinct e1.UHC_SUBSCRIBER_ID) as newly_enrolled_count
FROM (SELECT  DENSE_RANK ( )OVER( ORDER BY A_LAST_UPDATE_DATE ASC)  as date_order 
		, pcp_practice_tin
		, UHC_SUBSCRIBER_ID
		, A_LAST_UPDATE_DATE		
		FROM            dbo.UHC_MembersByPCP) e1
	left join (SELECT  DENSE_RANK ( )OVER( ORDER BY A_LAST_UPDATE_DATE ASC)  as date_order 
		, pcp_practice_tin
		, UHC_SUBSCRIBER_ID
		, A_LAST_UPDATE_DATE		
		FROM  dbo.UHC_MembersByPCP
		)  e2 on e1.date_order = e2.date_order+1
								  and e1.UHC_SUBSCRIBER_ID = e2.UHC_SUBSCRIBER_ID
where e2.UHC_SUBSCRIBER_ID is null 
group by e1.A_LAST_UPDATE_DATE
	,e1.pcp_practice_tin

)a
join  
--termed
(
SELECT e2.A_LAST_UPDATE_DATE

,e2.pcp_practice_tin
,count(distinct e2.UHC_SUBSCRIBER_ID) as termed_count
FROM (SELECT  DENSE_RANK ( )OVER( ORDER BY A_LAST_UPDATE_DATE ASC)  as date_order 
		, pcp_practice_tin
		, UHC_SUBSCRIBER_ID
		, A_LAST_UPDATE_DATE		
		FROM            dbo.UHC_MembersByPCP) e1
	right join (SELECT  DENSE_RANK ( )OVER( ORDER BY A_LAST_UPDATE_DATE ASC)  as date_order 
		, pcp_practice_tin
		, UHC_SUBSCRIBER_ID
		, A_LAST_UPDATE_DATE		
				FROM dbo.UHC_MembersByPCP)  e2 
		on e1.date_order = e2.date_order+1
	and e1.UHC_SUBSCRIBER_ID = e2.UHC_SUBSCRIBER_ID
WHERE e1.UHC_SUBSCRIBER_ID is null
group by e2.A_LAST_UPDATE_DATE
--,e2.pcp_practice_tin, e2.pcp_group_id, e2.pcp_practice_name
,e2.pcp_practice_tin
) b

on a.A_LAST_UPDATE_DATE =b.A_LAST_UPDATE_DATE
and a.pcp_practice_tin = b.pcp_practice_tin

--active member
join 
(
SELECT e1.A_LAST_UPDATE_DATE,e1.pcp_practice_tin
,count(distinct e1.UHC_SUBSCRIBER_ID) as active_count
FROM (SELECT  DENSE_RANK ( )OVER( ORDER BY A_LAST_UPDATE_DATE ASC)  as date_order 
		, pcp_practice_tin
		, UHC_SUBSCRIBER_ID
		, A_LAST_UPDATE_DATE		
		FROM            dbo.UHC_MembersByPCP) e1
group by e1.A_LAST_UPDATE_DATE,e1.pcp_practice_tin
)c
on a.A_LAST_UPDATE_DATE =c.A_LAST_UPDATE_DATE
and a.pcp_practice_tin = c.pcp_practice_tin
--continuing member
left join 
(
SELECT e1.A_LAST_UPDATE_DATE,e1.pcp_practice_tin
,count(distinct e1.UHC_SUBSCRIBER_ID) as existing_count
FROM (SELECT  DENSE_RANK ( )OVER( ORDER BY A_LAST_UPDATE_DATE ASC)  as date_order 
		, pcp_practice_tin
		, UHC_SUBSCRIBER_ID
		, A_LAST_UPDATE_DATE		
		FROM            dbo.UHC_MembersByPCP) e1
right join (SELECT  DENSE_RANK ( )OVER( ORDER BY A_LAST_UPDATE_DATE ASC)  as date_order 
		, pcp_practice_tin
		, UHC_SUBSCRIBER_ID
		, A_LAST_UPDATE_DATE		
		FROM            dbo.UHC_MembersByPCP)  e2 
on e1.date_order = e2.date_order+1
and e1.UHC_SUBSCRIBER_ID = e2.UHC_SUBSCRIBER_ID
group by e1.A_LAST_UPDATE_DATE,e1.pcp_practice_tin
)d
on 
 a.A_LAST_UPDATE_DATE =d.A_LAST_UPDATE_DATE
and a.pcp_practice_tin = d.pcp_practice_tin


