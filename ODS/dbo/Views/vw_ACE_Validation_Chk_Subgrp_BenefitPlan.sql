
CREATE VIEW [dbo].[vw_ACE_Validation_Chk_Subgrp_BenefitPlan]
AS
(
Select * from (
SELECT a.Benefit_Plan, Client_Member_ID, COUNT(A_ALT_MemberPlanHistory_ID) As CountPlans, min(a.startDate)  mStart, DATEDIFF(day, min(a.stopDate), max(startdate)) dDif
FROM adw.A_ALT_MemberPlanHistory a
GROUP BY a.Benefit_Plan, Client_Member_ID
HAVING COUNT(A_ALT_MemberPlanHistory_ID) > 1 
--order by dDif asc, mStart Asc
) as s where s.dDif=1
)

