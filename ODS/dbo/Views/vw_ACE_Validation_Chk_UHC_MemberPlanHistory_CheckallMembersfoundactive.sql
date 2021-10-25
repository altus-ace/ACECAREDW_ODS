CREATE VIEW [dbo].[vw_ACE_Validation_Chk_UHC_MemberPlanHistory_CheckallMembersfoundactive]
AS      
     SELECT *
     FROM (SELECT p.[UHC_SUBSCRIBER_ID], mp.Client_Member_ID, [A_LAST_UPDATE_DATE]
		  FROM [ACECAREDW].[dbo].[UHC_MembersByPCP] p
			 LEFT JOIN (SELECT mp.Client_Member_ID, CONVERT(DATE, mp.stopDate, 101) AS stopdate, mp.Benefit_plan, mp.a_created_date					   
					   FROM adw.[A_ALT_MemberPlanHistory] mp
					   WHERE planHistoryStatus = 1
						  AND stopDate = '12-31-2099'
					 ) AS mp ON CONVERT(INT, mp.Client_Member_ID) = CONVERT(INT, p.UHC_SUBSCRIBER_ID)
					 /* changed to reflect latest load not current date, more correct from perspective of data) */
		  WHERE MONTH(p.[A_LAST_UPDATE_DATE]) =  (select MONTH(max(a_last_update_date)) from dbo.Uhc_membersbyPcp m )--MONTH(GETDATE())
               AND YEAR(p.[A_LAST_UPDATE_DATE]) = (select YEAR(max(a_last_update_date)) from dbo.Uhc_membersbyPcp m ) -- YEAR(GETDATE())
               AND LoadType = 's'
		  ) AS c
     WHERE c.Client_Member_ID IS NULL;
