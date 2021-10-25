/****** Script for SelectTopNRows command from SSMS  ******/

CREATE FUNCTION [dbo].[tvf_AH_MemberActivities](@Activity_year int)
RETURNS TABLE
AS
     RETURN
(
SELECT Distinct  r.Member_id
      ,case when r.[Activity_year] is null then '' else r.[Activity_year] end as [Activity_year]
      ,r.TotalActivities
	 ,r.TotalAppointments
  FROM [ACECAREDW].[dbo].[vw_AH_ActivitesApptBymember] r
 where r.[Activity_year]=@Activity_year
 );