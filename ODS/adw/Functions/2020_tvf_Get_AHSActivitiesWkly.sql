
-- =============================================
-- Author:		Si Nguyen
-- Create date: 10/16/19
-- Description:	Get Activities by Member from Altruista
-- =============================================
CREATE FUNCTION [adw].[2020_tvf_Get_AHSActivitiesWkly]
	(	
		@StartDate			DATE,
		@EndDate			DATE
	)
RETURNS TABLE 
AS
RETURN 
(
WITH CTE AS (
SELECT
              APA.ClientMemberKey,
            Client.ClientKey,
				Client.ClientShortName,
            'AHS' ActivitySource,
              APA.CareActivityTypeName,
              APA.ActivityOutcome,
              APA.ActivityPerformedDate,
              APA.ActivityCreatedDate,
              APA.OutcomeNotes,
              APA.VenueName,              
              APA.srcFileName,
              APA.LoadDate             
    FROM dbo.tmp_AHS_PatientActivities APA
       JOIN lst.List_Client Client ON APA.lOB = Client.CS_Export_LobName
    WHERE APA.ShcnMsspLoadStatus = 0
       --AND Client.ClientKey = 16;
)

SELECT ClientKey, ClientShortName, DATEPART(ww,ActivityCreatedDate) as Wk
       ,DATEADD(dd, -(DATEPART(dw, ActivityCreatedDate)-1), ActivityCreatedDate) WkStart
       ,DATEADD(dd, 7-(DATEPART(dw, ActivityCreatedDate)), ActivityCreatedDate) WkEnd
       ,CareActivityTypeName
       ,count(*) as CntAct
FROM CTE -- .[mbrActivities]
WHERE ActivityCreatedDate BETWEEN @StartDate	AND @EndDate
GROUP BY ClientKey, ClientShortName, DATEPART(ww,ActivityCreatedDate)
       ,DATEADD(dd, -(DATEPART(dw, ActivityCreatedDate)-1), ActivityCreatedDate) 
       ,DATEADD(dd, 7-(DATEPART(dw, ActivityCreatedDate)), ActivityCreatedDate)
       ,CareActivityTypeName 
--ORDER BY DATEPART(ww,ActivityCreatedDate)
--       ,DATEADD(dd, -(DATEPART(dw, ActivityCreatedDate)-1), ActivityCreatedDate) 
--       ,DATEADD(dd, 7-(DATEPART(dw, ActivityCreatedDate)), ActivityCreatedDate)
--       ,CareActivityTypeName
)

/***
Usage:
SELECT * FROM [adw].[2020_tvf_Get_AHSActivitiesWkly] ('2020-06-01','2020-11-24')
ORDER BY ClientKey, Wk
***/


