
/*********************************************************************************************************
Created by : TS
Create Date : 06-02-2020
Description : To calculate all Term and New Members for MCOs
		


Modification:
 user        date        comment


******************************************************************/
CREATE VIEW [dbo].[vw_Dashboard_All_MCOS_Termed_New_mbrs_Calc]
as
SELECT 
k.Date,
k.e2Clientkey,
k.currentmonth,
k.exist_memb,
k.new_memb,
k.lastmonth,
k.term_memb,
k.exist_memb2
FROM(
/************* for Client =9 *************/
SELECT e2date AS Date, 
       a.e2Clientkey, 
       currentmonth, 
       exist_memb, 
       new_memb, 
       LAG(currentmonth, 2, 0) OVER(
       ORDER BY e2date, 
                e2clientkey) AS lastmonth, 
       exist_memb - LAG(currentmonth, 2, 0) OVER(
       ORDER BY e2date, 
                e2clientkey) AS term_memb, 
       exist_memb AS exist_memb2
FROM
(
    SELECT e2date, 
           e2Clientkey, 
           COUNT(DISTINCT e2member) AS currentmonth, 
           COUNT(DISTINCT e1member) AS exist_memb, 
           COUNT(DISTINCT e2member) - COUNT(DISTINCT e1member) AS new_memb
    FROM
    (
        SELECT e1.date_order AS e1ord, 
               e1.ClientMemberKey AS e1member, 
               e1.CLientKey AS e1Clientkey, 
               e1.MemberMonth AS e1date, 
               e2.date_order AS e2ord, 
               e2.clientkey AS e2Clientkey, 
               e2.ClientMemberKey AS e2member, 
               e2.MemberMonth AS e2date
        FROM
        (
            SELECT DENSE_RANK() OVER(
                   ORDER BY membermonth ASC) AS date_order, 
                   ClientMemberKey, 
                   MemberMonth, 
                   CLientKey
            FROM acecaredw.[dbo].[TmpAllMemberMonths]
			where CLientKey= 9
        ) e1
        RIGHT JOIN
        (
            SELECT DENSE_RANK() OVER(
                   ORDER BY membermonth ASC) AS date_order, 
                   ClientMemberKey, 
                   MemberMonth, 
                   CLientKey
            FROM acecaredw.[dbo].[TmpAllMemberMonths]
			where CLientKey= 9
        ) e2 ON e1.date_order = e2.date_order - 2
                AND e1.ClientMemberKey = e2.ClientMemberKey
                AND e1.CLientKey = e2.CLientKey
    ) a
    GROUP BY a.e2date, 
             a.e2Clientkey
) a
union all
/************* for Client =2 *************/
SELECT e2date AS Date, 
       a.e2Clientkey, 
       currentmonth, 
       exist_memb, 
       new_memb, 
       LAG(currentmonth, 2, 0) OVER(
       ORDER BY e2date, 
                e2clientkey) AS lastmonth, 
       exist_memb - LAG(currentmonth, 2, 0) OVER(
       ORDER BY e2date, 
                e2clientkey) AS term_memb, 
       exist_memb AS exist_memb2
FROM
(
    SELECT e2date, 
           e2Clientkey, 
           COUNT(DISTINCT e2member) AS currentmonth, 
           COUNT(DISTINCT e1member) AS exist_memb, 
           COUNT(DISTINCT e2member) - COUNT(DISTINCT e1member) AS new_memb
    FROM
    (
        SELECT e1.date_order AS e1ord, 
               e1.ClientMemberKey AS e1member, 
               e1.CLientKey AS e1Clientkey, 
               e1.MemberMonth AS e1date, 
               e2.date_order AS e2ord, 
               e2.clientkey AS e2Clientkey, 
               e2.ClientMemberKey AS e2member, 
               e2.MemberMonth AS e2date
        FROM
        (
            SELECT DENSE_RANK() OVER(
                   ORDER BY membermonth ASC) AS date_order, 
                   ClientMemberKey, 
                   MemberMonth, 
                   CLientKey
            FROM acecaredw.[dbo].[TmpAllMemberMonths]
			where CLientKey= 2
        ) e1
        RIGHT JOIN
        (
            SELECT DENSE_RANK() OVER(
                   ORDER BY membermonth ASC) AS date_order, 
                   ClientMemberKey, 
                   MemberMonth, 
                   CLientKey
            FROM acecaredw.[dbo].[TmpAllMemberMonths]
			where CLientKey= 2
        ) e2 ON e1.date_order = e2.date_order - 2
                AND e1.ClientMemberKey = e2.ClientMemberKey
                AND e1.CLientKey = e2.CLientKey
    ) a
    GROUP BY a.e2date, 
             a.e2Clientkey
) a
union all
/************* for Client =3 *************/
SELECT e2date AS Date, 
       a.e2Clientkey, 
       currentmonth, 
       exist_memb, 
       new_memb, 
       LAG(currentmonth, 2, 0) OVER(
       ORDER BY e2date, 
                e2clientkey) AS lastmonth, 
       exist_memb - LAG(currentmonth, 2, 0) OVER(
       ORDER BY e2date, 
                e2clientkey) AS term_memb, 
       exist_memb AS exist_memb2
FROM
(
    SELECT e2date, 
           e2Clientkey, 
           COUNT(DISTINCT e2member) AS currentmonth, 
           COUNT(DISTINCT e1member) AS exist_memb, 
           COUNT(DISTINCT e2member) - COUNT(DISTINCT e1member) AS new_memb
    FROM
    (
        SELECT e1.date_order AS e1ord, 
               e1.ClientMemberKey AS e1member, 
               e1.CLientKey AS e1Clientkey, 
               e1.MemberMonth AS e1date, 
               e2.date_order AS e2ord, 
               e2.clientkey AS e2Clientkey, 
               e2.ClientMemberKey AS e2member, 
               e2.MemberMonth AS e2date
        FROM
        (
            SELECT DENSE_RANK() OVER(
                   ORDER BY membermonth ASC) AS date_order, 
                   ClientMemberKey, 
                   MemberMonth, 
                   CLientKey
            FROM acecaredw.[dbo].[TmpAllMemberMonths]
			where CLientKey= 3
        ) e1
        RIGHT JOIN
        (
            SELECT DENSE_RANK() OVER(
                   ORDER BY membermonth ASC) AS date_order, 
                   ClientMemberKey, 
                   MemberMonth, 
                   CLientKey
            FROM acecaredw.[dbo].[TmpAllMemberMonths]
			where CLientKey= 3
        ) e2 ON e1.date_order = e2.date_order - 2
                AND e1.ClientMemberKey = e2.ClientMemberKey
                AND e1.CLientKey = e2.CLientKey
    ) a
    GROUP BY a.e2date, 
             a.e2Clientkey
) a
union all
/************* for Client =1
Exclude these date 2018-12-04(for CPP,CPI & MICRO INCENTIVES)
AND 2017-07-24  *************/
SELECT e2date AS Date, 
       a.e2Clientkey, 
       currentmonth, 
       exist_memb, 
       new_memb, 
       LAG(currentmonth, 2, 0) OVER(
       ORDER BY e2date, 
                e2clientkey) AS lastmonth, 
       exist_memb - LAG(currentmonth, 2, 0) OVER(
       ORDER BY e2date, 
                e2clientkey) AS term_memb, 
       exist_memb AS exist_memb2
FROM
(
    SELECT e2date, 
           e2Clientkey, 
           COUNT(DISTINCT e2member) AS currentmonth, 
           COUNT(DISTINCT e1member) AS exist_memb, 
           COUNT(DISTINCT e2member) - COUNT(DISTINCT e1member) AS new_memb
    FROM
    (
        SELECT e1.date_order AS e1ord, 
               e1.ClientMemberKey AS e1member, 
               e1.CLientKey AS e1Clientkey, 
               e1.MemberMonth AS e1date, 
               e2.date_order AS e2ord, 
               e2.clientkey AS e2Clientkey, 
               e2.ClientMemberKey AS e2member, 
               e2.MemberMonth AS e2date
        FROM
        (
            SELECT DENSE_RANK() OVER(
                   ORDER BY membermonth ASC) AS date_order, 
                   ClientMemberKey, 
                   MemberMonth, 
                   CLientKey
            FROM acecaredw.[dbo].[TmpAllMemberMonths]
			where CLientKey= 1
			AND MemberMonth NOT IN ('2017-07-24', '2018-12-4')
        ) e1
        RIGHT JOIN
        (
            SELECT DENSE_RANK() OVER(
                   ORDER BY membermonth ASC) AS date_order, 
                   ClientMemberKey, 
                   MemberMonth, 
                   CLientKey
            FROM acecaredw.[dbo].[TmpAllMemberMonths]
			where CLientKey= 1
			AND MemberMonth NOT IN ('2017-07-24', '2018-12-4')
        ) e2 ON e1.date_order = e2.date_order - 2
                AND e1.ClientMemberKey = e2.ClientMemberKey
                AND e1.CLientKey = e2.CLientKey
    ) a
    GROUP BY a.e2date, 
             a.e2Clientkey
) a
)k    ----order by k.Date asc;
