/*********************************************************************************************************
Created by : DL
Create Date : 2017
Description : 
		

Modification:
 user        date        comment


******************************************************************/

CREATE view [dbo].[monthly_lob_membership_trend_report]
as
select 
b.LOB
,a.Product
,a.Date
,a.currentmonth as Current_Month
,a.exist_memb as Existing_Member
,a.new_memb as New_Member	
,a.term_memb as Term_Member
,a.lastmonth as Last_Month
,a.currentmonth-lastmonth as Month_Differences
,c.auto_count
,c.self_count
from (
select * 
from 
(
select * ,RANK ( ) OVER (  order by date desc )  as row_num
from 
(
SELECT  [Date]
      ,[Product]
      ,[currentmonth]
      ,[exist_memb]
      ,[new_memb]
      ,[lastmonth]
      ,[term_memb]
      ,[exist_memb2]
  FROM [ACECAREDW].[dbo].[monthly_membership_trend_by_product]
 -- where month(date) = month(getdate()) and year(date) = year(getdate())
 )z
 )z
 where row_num = 1 ) a


   join 
 ( select distinct p.product_code as PRODUCT_CODE,s.line_of_business AS LOB
from uhc_membersbyPCP p
inner join alt_mapping_tables a on a.source_value=p.subgrp_id
INNER join  (select distinct line_of_business,plan_code,plan_desc from uhc_membership ) s on s.plan_Code= a.source_value) b
on a.product = b.product_code





join 
(

select a.A_LAST_UPDATE_DATE,a.PRODUCT_CODE,a.self_count,b.auto_count
from 
(
SELECT 
     
     A_LAST_UPDATE_DATE, 
     PRODUCT_CODE,

	count(distinct [UHC_SUBSCRIBER_ID]) self_count

  FROM [ACECAREDW].[dbo].[UHC_MembersByPCP]
  where  [AUTO_ASSIGN] = 'self'
  group by     A_LAST_UPDATE_DATE , PRODUCT_CODE
  having A_LAST_UPDATE_DATE not in ('2017-07-24')
  ) a 
  join 
  (
SELECT 
     
     A_LAST_UPDATE_DATE, 
       PRODUCT_CODE,

	count(distinct [UHC_SUBSCRIBER_ID]) auto_count

  FROM [ACECAREDW].[dbo].[UHC_MembersByPCP]
  where  [AUTO_ASSIGN] = 'auto'
  group by     A_LAST_UPDATE_DATE,  PRODUCT_CODE
  having A_LAST_UPDATE_DATE not in ('2017-07-24')
  ) b on a.A_LAST_UPDATE_DATE = b.A_LAST_UPDATE_DATE and a.PRODUCT_CODE = b.PRODUCT_CODE
  --  where month(a.A_LAST_UPDATE_DATE) = month(getdate()) and year(a.A_LAST_UPDATE_DATE) = year(getdate()) 

)c on a.Product = c.PRODUCT_CODE and a.date = c.A_LAST_UPDATE_DATE


