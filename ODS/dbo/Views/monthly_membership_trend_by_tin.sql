CREATE view monthly_membership_trend_by_tin
as
select  a.e2date as Date
,a.e2prac as Practice_TIN
,c.Name as Practice_Name
,a.currentmonth
, case when month(a.e2date)- lag(month(a.e2date),1,0) OVER (Partition by a.e2prac ORDER BY a.e2date)=1
	then a.exist_memb else b.exist_memb end as exist_memb_month_or_last_recorded
, case when month(a.e2date)- lag(month(a.e2date),1,0) OVER (Partition by a.e2prac ORDER BY a.e2date)=1
	then a.new_memb else b.new_memb end as new_memb_month_or_last_recorded
--, month(a.e2date)- lag(month(a.e2date),1,0) OVER (Partition by a.e2prac ORDER BY a.e2date) as monthdiff
, case when month(a.e2date)- lag(month(a.e2date),1,0) OVER (Partition by a.e2prac ORDER BY a.e2date)=1
	then lag(a.currentmonth,2,0) OVER (Partition by a.e2prac ORDER BY a.e2date) 
	else lag(a.currentmonth,1,0) OVER (Partition by a.e2prac ORDER BY a.e2date) end as lastmonth_or_last_recorded
, case when month(a.e2date)- lag(month(a.e2date),1,0) OVER (Partition by a.e2prac ORDER BY a.e2date)=1
	then a.exist_memb- lag(a.currentmonth,2,0) OVER (Partition by a.e2prac ORDER BY a.e2date) 
	else b.exist_memb- lag(a.currentmonth,1,0) OVER (Partition by a.e2prac ORDER BY a.e2date) 
	end as term_memb_month_or_last_recorded


--a.exist_memb- lag(a.currentmonth,2,0) OVER (Partition by a.e2prac ORDER BY a.e2date) as term_memb
, case when month(a.e2date)- lag(month(a.e2date),1,0) OVER (Partition by a.e2prac ORDER BY a.e2date)=1
	then a.exist_memb else b.exist_memb end as exist_memb_month_or_last_recorded2

from 
(
select  e2date,e2prac, count(distinct e2member) as currentmonth, count(distinct e1member) as exist_memb, count(distinct e2member)-count(distinct e1member) as new_memb
from 
(SELECT 

e1.date_order as e1ord,
e1.pcp_practice_tin as e1prod,
e1.UHC_SUBSCRIBER_ID as e1member,
e1.A_LAST_UPDATE_DATE as e1date,
e2.date_order as e2ord,
e2.pcp_practice_tin as e2prac,
e2.UHC_SUBSCRIBER_ID as e2member,
e2.A_LAST_UPDATE_DATE as e2date
                                                                                         

FROM (SELECT  DENSE_RANK ( )OVER(Partition by pcp_practice_tin ORDER BY A_LAST_UPDATE_DATE ASC)  as date_order 
		, pcp_practice_tin
		, UHC_SUBSCRIBER_ID
		, A_LAST_UPDATE_DATE		
		FROM            dbo.UHC_MembersByPCP
		where  A_LAST_UPDATE_DATE not in ( '2017-07-24')) e1
 right join (SELECT  DENSE_RANK ( )OVER(Partition by pcp_practice_tin ORDER BY A_LAST_UPDATE_DATE ASC)  as date_order 
		, pcp_practice_tin
		, UHC_SUBSCRIBER_ID
		, A_LAST_UPDATE_DATE		
		FROM            dbo.UHC_MembersByPCP
		where  A_LAST_UPDATE_DATE not in ( '2017-07-24'))  e2 
on e1.date_order = e2.date_order-2
and e1.UHC_SUBSCRIBER_ID = e2.UHC_SUBSCRIBER_ID
and e1.pcp_practice_tin = e2.pcp_practice_tin
) a 
group by  e2date,e2prac
)a
join  
(
select  e2date,e2prac, count(distinct e2member) as currentmonth, count(distinct e1member) as exist_memb, count(distinct e2member)-count(distinct e1member) as new_memb
from 
(SELECT 

e1.date_order as e1ord,
e1.pcp_practice_tin as e1prod,
e1.UHC_SUBSCRIBER_ID as e1member,
e1.A_LAST_UPDATE_DATE as e1date,
e2.date_order as e2ord,
e2.pcp_practice_tin as e2prac,
e2.UHC_SUBSCRIBER_ID as e2member,
e2.A_LAST_UPDATE_DATE as e2date
                                                                                         

FROM (SELECT  DENSE_RANK ( )OVER(Partition by pcp_practice_tin ORDER BY A_LAST_UPDATE_DATE ASC)  as date_order 
		, pcp_practice_tin
		, UHC_SUBSCRIBER_ID
		, A_LAST_UPDATE_DATE		
		FROM            dbo.UHC_MembersByPCP
		where  A_LAST_UPDATE_DATE not in ( '2017-07-24')) e1
 right join (SELECT  DENSE_RANK ( )OVER(Partition by pcp_practice_tin ORDER BY A_LAST_UPDATE_DATE ASC)  as date_order 
		, pcp_practice_tin
		, UHC_SUBSCRIBER_ID
		, A_LAST_UPDATE_DATE		
		FROM            dbo.UHC_MembersByPCP
		where  A_LAST_UPDATE_DATE not in ( '2017-07-24'))  e2 
on e1.date_order = e2.date_order-1
and e1.UHC_SUBSCRIBER_ID = e2.UHC_SUBSCRIBER_ID
and e1.pcp_practice_tin = e2.pcp_practice_tin
) a 
group by  e2date,e2prac
)b
on a.e2date = b.e2date
and a.e2prac = b.e2prac
join 
(
select distinct a.pcp_practice_tin, b.Name
from  dbo.UHC_MembersByPCP a
join tmpSalesforce_Account b on CONVERT(INT,a.pcp_practice_tin) = CONVERT(INT,b.[Tax_ID_Number__c])
)c
on a.e2prac = c.pcp_practice_tin

