
CREATE FUNCTION [dbo].[z_tvf_UHCSum](@BaselineDate DATE, @TargetDate DATE)
RETURNS TABLE
    /* Purpose: Get List of patients from a specific baseline date (end of year) 
	and compare to target date. Use this to identify churn
	1. churn bc of age in certain lob/plan 
	2. churn bc of lob
	3. calcAge < X = 0, 

	*/
AS
    RETURN
(   
--DECLARE @BaselineDate DATE = '12/10/2018'
SELECT m.UHC_SUBSCRIBER_ID as MemberID, RTRIM(m.LINE_OF_BUSINESS) as LOB, RTRIM(m.PLAN_DESC) as PlanDesc
	,m.DATE_OF_BIRTH as DOB
	,DATEDIFF(yy,m.DATE_OF_BIRTH,@BaselineDate) as CalcAge 
	,m.MEMBER_MONTH_COUNT as MemberMth
	,CASE WHEN CONVERT(INT,m.MEMBER_MONTH_COUNT) = 12 THEN 0 ELSE 1 END as Churn
	,1 as CntMbr
  	,A_LAST_UPDATE_DATE as LoadDate
	FROM dbo.Uhc_Membership m    
	WHERE m.A_LAST_UPDATE_DATE = @BaselineDate
UNION
SELECT m.UHC_SUBSCRIBER_ID as MemberID, RTRIM(m.LINE_OF_BUSINESS) as LOB, RTRIM(m.PLAN_DESC) as PlanDesc
	,m.DATE_OF_BIRTH as DOB
	,DATEDIFF(yy,m.DATE_OF_BIRTH,@TargetDate) as CalcAge 
	,m.MEMBER_MONTH_COUNT as MemberMth
	,CASE WHEN CONVERT(INT,m.MEMBER_MONTH_COUNT) = 12 THEN 0 ELSE 1 END as Churn
	,1 as CntMbr
  	,A_LAST_UPDATE_DATE as LoadDate
	FROM dbo.Uhc_Membership m    
	WHERE m.A_LAST_UPDATE_DATE = @TargetDate
)

/***
Usage:
SELECT * FROM [dbo].[z_tvf_UHCSum] ('12/10/2018','12/16/2019')	-- 12/13/17, 12/10/18, 12/16/19

SELECT DISTINCT LOB

FROM
	(SELECT * FROM [dbo].[z_tvf_UHCSum] ('12/10/2018','12/16/2019')) a	-- 12/13/17, 12/10/18, 12/16/19
WHERE LOB IN (
'TX CHIP'
'TX MMP'                                                                                           
'TX Star Kids                                                                                        
'TX Star Medicaid                                                                                    
'TX StarPlus LTC                                                                                     
GROUP BY LOB, Churn
***/


