
CREATE view [dbo].[vw_membership_all]
as
select
a.*,
CONVERT(varchar(12)       ,a.[MEMBER_ID])as  [M_Registration_ID],
CONVERT(varchar(5)     , c.A_IS_Client_ID)as [CLIENT_ID],
CONVERT(varchar(50)     , a.[MEMBER_FIRST_NAME])as [M_First_Name],
CONVERT(varchar(50)     , a.[MEMBER_LAST_NAME])as [M_Last_Name],
YEAR(a.a_last_update_date) as [MBR_YEAR],
MONTH(a.a_last_update_date) as [MBR_MTH],
CONVERT(datetime     , CONVERT(DATE, GETDATE(), 101))as [LOAD_DATE],
CONVERT(varchar(50)     , SYSTEM_USER )as [LOAD_USER]



FROM [ACECAREDW].[dbo].[vw_UHC_ActiveMembers_ALL] AS a
     JOIN [ACECAREDW].[adw].[A_LIST_Clients] c ON 1 = c.A_Client_ID
     JOIN(SELECT
		   aaa.[LOAD_KEY]
		  , aaa.[LOAD_DATE]
		  FROM
		  (SELECT
			   aa.[LOAD_KEY]
			 , aa.[LOAD_DATE]
			 , ROW_NUMBER() OVER(PARTITION BY MONTH(load_date),year(load_date) ORDER BY load_date ASC) AS rank
		  FROM [ACECAREDW].[ast].[A_vw_UHC_Get_MemberLoadDates] AS aa
		  ) AS aaa
		  WHERE aaa.rank = 1
	   ) AS b ON a.a_last_update_date = b.load_date;
