
/*********************************************************************************************************
Created by : MI / DL
Create Date : 2017
Description : 
		


Modification:
 user        date        comment


******************************************************************/
CREATE view  [dbo].[monthly_membership_trend]
as     
select e2date as Date 
,currentmonth
,exist_memb
,new_memb 
, lag(currentmonth,2,0) OVER ( ORDER BY e2date) as lastmonth
,exist_memb- lag(currentmonth,2,0) OVER (ORDER BY e2date) as term_memb
, exist_memb as exist_memb2
from 
(
select  e2date, count(distinct e2member) as currentmonth, count(distinct e1member) as exist_memb, count(distinct e2member)-count(distinct e1member) as new_memb
from 
(SELECT 

e1.date_order as e1ord,
e1.UHC_SUBSCRIBER_ID as e1member,
e1.A_LAST_UPDATE_DATE as e1date,
e2.date_order as e2ord,

e2.UHC_SUBSCRIBER_ID as e2member,
e2.A_LAST_UPDATE_DATE as e2date



FROM (SELECT  DENSE_RANK ( )OVER( ORDER BY A_LAST_UPDATE_DATE ASC)  as date_order 
		
		, UHC_SUBSCRIBER_ID
		, A_LAST_UPDATE_DATE		
		FROM            dbo.UHC_MembersByPCP
		where  A_LAST_UPDATE_DATE not in ( '2017-07-24')) e1
 right join (SELECT  DENSE_RANK ( )OVER(ORDER BY A_LAST_UPDATE_DATE ASC)  as date_order 
	
		, UHC_SUBSCRIBER_ID
		, A_LAST_UPDATE_DATE		
		FROM            dbo.UHC_MembersByPCP
		where  A_LAST_UPDATE_DATE not in ( '2017-07-24'))  e2 
on e1.date_order = e2.date_order-2
and e1.UHC_SUBSCRIBER_ID = e2.UHC_SUBSCRIBER_ID

) a 
group by  e2date
)a
