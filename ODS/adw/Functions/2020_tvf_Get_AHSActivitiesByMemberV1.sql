-- =============================================
-- Author:		Si Nguyen
-- Create date: 10/16/19
-- Description:	Get Activities by Member from Altruista

-- Modified: 04/23/21  Filter by CareActivityTypeName IS NOT NULL, remove MbrActivityKey
-- =============================================
CREATE FUNCTION [adw].[2020_tvf_Get_AHSActivitiesByMemberV1]
	(	
		@ClientKey			INT,
		@PastActivityMonth	INT
	)
RETURNS TABLE 
AS
RETURN 
(
	WITH CTE AS (
	SELECT DISTINCT
      APA.ClientMemberKey			as MemberID
		,Client.ClientKey
		,Client.ClientShortName
		,convert(DATE, APA.ActivityCreatedDate)	as ActDate
		,CONCAT(APA.CareActivityTypeName,'(',APA.ActivityOutcome,')')				as Activity
		,APA.ActivityOutcome	as ActivityOutcome
      ,APA.OutcomeNotes		as OutcomeNotes
    FROM dbo.tmp_AHS_PatientActivities APA
    JOIN lst.List_Client Client ON APA.lOB = Client.CS_Export_LobName
	 WHERE DATEDIFF(mm,APA.ActivityCreatedDate,GETDATE()) <= @PastActivityMonth
	 AND CareActivityTypeName IS NOT NULL
)
	SELECT t2.MemberID
		,(SELECT MIN(a.ActDate) FROM CTE a WHERE a.MemberID = t2.MemberID) as FirstActDate
		,(SELECT MAX(a.ActDate) FROM CTE a WHERE a.MemberID = t2.MemberID) as LastActDate
		,COUNT(*) as CntAct
		,ActType = RIGHT(STUFF(
             (SELECT ' -- ' + t1.Activity
              FROM CTE t1
              WHERE t1.MemberID = t2.MemberID
              FOR XML PATH (''))
             , 1, 1, ''),100) 
	FROM CTE t2
	GROUP BY t2.MemberID
)

/***
Usage:
SELECT * FROM [adw].[2020_tvf_Get_AHSActivitiesByMemberV1] (1,3)
ORDER BY CntAct
***/

