CREATE FUNCTION [dbo].[tvf_ACE_RP_PracticeActivityStats](@reportPeriodStartDate DATE
                                            , @reportPeriodStopDate  DATE, @name varchar)
RETURNS TABLE
AS
     RETURN
(
select 
 [pcp_practice_name]
        ,sum([CALLS]) as CALLS
      ,Sum([Assessment]) As Assessment
      ,Sum([BH Referral]) [BH Referral]
      ,Sum([ER Assessment])[ER Assessment]
      ,Sum([Follow Up])[Follow Up]
      ,Sum([Health Risk Assessment])[Health Risk Assessment]
      ,Sum([Health Risk Screening])[Health Risk Screening]
      ,Sum([Inpatient Post Discharge])[Inpatient Post Discharge]
      ,Sum([MDB])[MDB]
      ,Sum([Member Mailing])[Member Mailing]
      ,Sum([Member Outreach])[Member Outreach]
      ,Sum([Mental Health Inpatient Discharge])[Mental Health Inpatient Discharge]
      ,Sum([Non Assessment])[Non Assessment]
      ,Sum([Post Discharge Follow Up])[Post Discharge Follow Up]
      ,Sum([Psychosocial Issues])[Psychosocial Issues]
      ,Sum([Re-Pod])[Re-Pod]
      ,Sum([Screening])[Screening]
      ,Sum([Transportation])[Transportation]
	 from (
Select *     
	  from 
	  ahs_altus_prod.dbo.[vw_ACE_RP_PivotActivity] r
	  where
	  r.performed between @reportPeriodStartDate and @reportPeriodStopDate
	  and r.pcp_practice_name =@name) as s  Group by [pcp_practice_name]
	  )
	 