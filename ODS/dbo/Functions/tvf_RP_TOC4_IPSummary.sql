



CREATE FUNCTION [dbo].[tvf_RP_TOC4_IPSummary] (
	@StartDate DATE
	,@EndDate DATE )
RETURNS TABLE 
AS RETURN
(
select distinct
	 convert(int,UHC_Subscriber_ID) as Mbr_ID
	, Member_first_name as MBR_First_Name	
	, Member_Last_name as MBR_Last_Name
	, convert(date,Date_of_Birth,101) as DOB
	, convert(numeric(5,2),ltrim(rtrim(IPRO_ADMIT_RISK_SCORE))) as Risk_Score
	, ltrim(rtrim([PCP_PRACTICE_NAME])) as Practice_Name
	, ltrim(rtrim([LAST_INP_DISCHARGE])) as Last_IP_Dis
	, convert(int,ltrim(rtrim(INP_ADMITS_LAST_12_MOS))) as Total_INP_ADMITS_12_Mths
	, ltrim(rtrim([INP_FUP_WITHIN_7_DAYS])) as INP_FollowUp_visit
	, ltrim(rtrim(PRIMARY_RISK_FACTOR)) as Primary_Risk 
	, convert(int,ltrim(rtrim([COUNT_OPEN_CARE_OPPS]))) as Open_Care_Opps
	, ltrim(rtrim([INP_COSTS_LAST_12_MOS])) as INP_Cost_last_12_Mos
	, @EndDate AS DateRun
	, @StartDate AS DateStarts 
 from dbo.vw_UHC_ActiveMembers


 where convert(int,INP_ADMITS_LAST_12_MOS) >= 3
 and ltrim(rtrim(LAST_INP_DISCHARGE))  >= @StartDate
 
)
