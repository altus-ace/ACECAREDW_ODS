
CREATE FUNCTION [dbo].[tvf_RP_TOC4_ErSummary] (
	@StartDate DATE
	,@EndDate DATE )
RETURNS TABLE 
AS RETURN
(
select distinct
	 convert(int,UHC_Subscriber_ID) as Mbr_ID
	, Member_first_name as MBR_First_Name	
	, Member_Last_name as MBR_Last_Name
	, convert(date,Date_of_Birth) as DOB
	, convert(numeric(5,2),ltrim(rtrim(IPRO_ADMIT_RISK_SCORE))) as Risk_Score
	, ltrim(rtrim([PCP_PRACTICE_NAME])) as Practice_Name
	, convert(date,ltrim(rtrim([LAST_ER_VISIT]))) as Last_ER_Visit
	, convert(int,ltrim(rtrim(ER_visits_last_12_Mos))) as Total_ER_visits_12_Mths
	, convert(date,ltrim(rtrim([POST_ER_FUP_VISIT]))) as ER_FollowUp_visit
	, ltrim(rtrim(PRIMARY_RISK_FACTOR)) as Primary_Risk 
	, convert(int,ltrim(rtrim([COUNT_OPEN_CARE_OPPS]))) as Open_Care_Opps
	, ltrim(rtrim([ER_COSTS_LAST_12_MOS])) as ER_Cost_last_12_Mos
	, @EndDate AS DateRun
	, @StartDate AS DateStarts 
 from dbo.vw_UHC_ActiveMembers

 where convert(int,ER_visits_last_12_Mos) >= 3
 and convert(datetime, ltrim(rtrim(LAST_ER_VISIT)))  >= @StartDate
 
)
