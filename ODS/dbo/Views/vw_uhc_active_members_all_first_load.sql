

CREATE view [dbo].[vw_uhc_active_members_all_first_load]
as
select * from (
select
a.[MEMBER_ID],

LINE_OF_BUSINESS,
IPRO_ADMIT_RISK_SCORE,
PCP_PRACTICE_TIN,
PRIMARY_RISK_FACTOR,
                                                                                                                                                                                                                     

CAST(STR(YEAR(a.a_last_update_date) ) + '-' + STR(MONTH(a.a_last_update_date) ) + '-01' AS DATE) as date

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
	   ) AS b ON a.a_last_update_date = b.load_date
) a --where date = '2018-04-01'
