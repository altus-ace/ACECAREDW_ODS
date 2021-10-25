
create view vw_member_trend_start_assignment_report 
as
select a.UHC_SUBSCRIBER_ID,a.MBR_MTH,a.MBR_YEAR,a.Starting_Assignment_Date , b.AUTO_ASSIGN, b.PCP_NPI,b.PCP_PRACTICE_NAME,b.PCP_PRACTICE_TIN
from 
(SELECT UHC_SUBSCRIBER_ID,MONTH(A_LAST_UPDATE_DATE) AS MBR_MTH, YEAR(A_LAST_UPDATE_DATE) AS MBR_YEAR, min(A_LAST_UPDATE_DATE) AS Starting_Assignment_Date
FROM            dbo.UHC_MembersByPCP
group by UHC_SUBSCRIBER_ID, MONTH(A_LAST_UPDATE_DATE), YEAR(A_LAST_UPDATE_DATE) )a
join UHC_MembersByPCP b on a.UHC_SUBSCRIBER_ID =b.UHC_SUBSCRIBER_ID
and a.Starting_Assignment_Date = b.A_LAST_UPDATE_DATE