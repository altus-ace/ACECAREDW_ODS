



CREATE view [dbo].[monthly_lob_membership_trend_report_HQ]
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
  FROM [ACECAREDW].[dbo].[vw_monthly_membership_trend_by_product_HQ]
 -- where month(date) = month(getdate()) and year(date) = year(getdate())
 )z
 )z
 where row_num = 1 ) a


   join 
		( 
			select p.product_code as PRODUCT_CODE,s.line_of_business AS LOB,MAX(p.A_LAST_UPDATE_DATE) AS LAST_UPDATE_DT
				from uhc_membersbyPCP p
				inner join alt_mapping_tables a on a.source_value=p.subgrp_id
				INNER join  (select line_of_business,plan_code,plan_desc,MAX(A_LAST_UPDATE_DATE) AS A_LAST_UPDATE_DATE, COUNT(plan_code) AS CNT from uhc_membership
								GROUP BY line_of_business,plan_code,plan_desc,A_LAST_UPDATE_DATE 
								HAVING CONVERT(VARCHAR(4),YEAR(MAX(A_LAST_UPDATE_DATE))) = CONVERT(VARCHAR(4),YEAR(GETDATE())) 
								AND CONVERT(VARCHAR(2), MONTH(MAX(A_LAST_UPDATE_DATE))) = CASE WHEN MONTH(MAX(A_LAST_UPDATE_DATE)) < MONTH(GETDATE()) 
																							   THEN CONVERT(VARCHAR(2),(MONTH(GETDATE())-1))
																							   WHEN MONTH(MAX(A_LAST_UPDATE_DATE)) = MONTH(GETDATE()) 
																							   THEN CONVERT(VARCHAR(2),MONTH(GETDATE())) END 
								) s on s.plan_Code= a.source_value 
				 --CONVERT(VARCHAR(4),YEAR(MAX(p.A_LAST_UPDATE_DATE))) = CONVERT(VARCHAR(4),YEAR(GETDATE())) AND CONVERT(VARCHAR(2), MONTH(MAX(p.A_LAST_UPDATE_DATE))) = CONVERT(VARCHAR(4),MONTH(GETDATE()))
				GROUP BY p.product_code,s.line_of_business
				HAVING CONVERT(VARCHAR(4),YEAR(MAX(p.A_LAST_UPDATE_DATE))) = CONVERT(VARCHAR(4),YEAR(GETDATE())) 
				AND CONVERT(VARCHAR(2), MONTH(MAX(p.A_LAST_UPDATE_DATE))) = CASE WHEN MONTH(MAX(P.A_LAST_UPDATE_DATE)) < MONTH(GETDATE()) 
																				THEN CONVERT(VARCHAR(2),(MONTH(GETDATE())-1))
																		   WHEN MONTH(MAX(P.A_LAST_UPDATE_DATE)) = MONTH(GETDATE()) 
																				THEN CONVERT(VARCHAR(2),MONTH(GETDATE())) END 

		 ) b
	on a.product = b.product_code 

	--SELECT MAX(A_LAST_UPDATE_DATE) AS LAST_UPDATE_DT FROM uhc_membership WHERE line_of_business LIKE '%TX CHIP%'
	--select distinct line_of_business,plan_code,plan_desc from uhc_membership
	--select line_of_business,plan_code,plan_desc, COUNT(plan_code) AS CNT from uhc_membership GROUP BY line_of_business,plan_code,plan_desc
--select line_of_business,plan_code,plan_desc,[A_LAST_UPDATE_DATE], rank() over (partition by line_of_business,plan_code,plan_desc order by [A_LAST_UPDATE_DATE] desc)  as rank
--from (select distinct line_of_business,plan_code,plan_desc,[A_LAST_UPDATE_DATE] from uhc_membership) a

--select distinct p.product_code as PRODUCT_CODE,s.line_of_business AS LOB
--from uhc_membersbyPCP

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
  left join 
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


