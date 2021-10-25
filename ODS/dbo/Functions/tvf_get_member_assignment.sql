create function tvf_get_member_assignment
(	@anchor_mth int, @compare_mth int
)
RETURNS TABLE 
As
RETURN
(	


select c.AUTO_ASSIGN, count(c.UHC_SUBSCRIBER_ID) as CNT
from 
(
select c.UHC_SUBSCRIBER_ID,   auto_assign, MONTH(A_LAST_UPDATE_DATE) as month_of
from 
(
select distinct a.UHC_SUBSCRIBER_ID--,a.MBR_MTH,a.MBR_YEAR,a.Starting_Assignment_Date , b.AUTO_ASSIGN, b.PCP_NPI,b.PCP_PRACTICE_NAME,b.PCP_PRACTICE_TIN
from 
(SELECT UHC_SUBSCRIBER_ID,MONTH(A_LAST_UPDATE_DATE) AS MBR_MTH, YEAR(A_LAST_UPDATE_DATE) AS MBR_YEAR, min(A_LAST_UPDATE_DATE) AS Starting_Assignment_Date
FROM            dbo.UHC_MembersByPCP
group by UHC_SUBSCRIBER_ID, MONTH(A_LAST_UPDATE_DATE), YEAR(A_LAST_UPDATE_DATE) )a
join UHC_MembersByPCP b on a.UHC_SUBSCRIBER_ID =b.UHC_SUBSCRIBER_ID
and a.Starting_Assignment_Date = b.A_LAST_UPDATE_DATE
where a.MBR_MTH = @anchor_mth
except 
select distinct a.UHC_SUBSCRIBER_ID--,a.MBR_MTH,a.MBR_YEAR,a.Starting_Assignment_Date , b.AUTO_ASSIGN, b.PCP_NPI,b.PCP_PRACTICE_NAME,b.PCP_PRACTICE_TIN
from 
(SELECT UHC_SUBSCRIBER_ID,MONTH(A_LAST_UPDATE_DATE) AS MBR_MTH, YEAR(A_LAST_UPDATE_DATE) AS MBR_YEAR, min(A_LAST_UPDATE_DATE) AS Starting_Assignment_Date
FROM            dbo.UHC_MembersByPCP
group by UHC_SUBSCRIBER_ID, MONTH(A_LAST_UPDATE_DATE), YEAR(A_LAST_UPDATE_DATE) )a
join UHC_MembersByPCP b on a.UHC_SUBSCRIBER_ID =b.UHC_SUBSCRIBER_ID
and a.Starting_Assignment_Date = b.A_LAST_UPDATE_DATE
where a.MBR_MTH = @compare_mth
)c
join UHC_MembersByPCP b on c.UHC_SUBSCRIBER_ID =b.UHC_SUBSCRIBER_ID
where MONTH(A_LAST_UPDATE_DATE) = @anchor_mth
group by c.UHC_SUBSCRIBER_ID,  auto_assign, MONTH(A_LAST_UPDATE_DATE)
)  c
group by c.AUTO_ASSIGN

)