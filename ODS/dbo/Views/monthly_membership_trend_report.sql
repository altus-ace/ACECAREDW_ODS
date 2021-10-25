CREATE VIEW [dbo].[monthly_membership_trend_report]
AS
     SELECT a.[Date], 
            a.[Current_Members], 
            a.[Existing_Members], 
            a.[New_Members], 
            a.[Termed_Members], 
            LAG(a.[Current_Members], 1) OVER(
            ORDER BY a.[Date]) AS [Last_Month], 
            a.[Current_Members] - LAG(a.[Current_Members], 1) OVER(
            ORDER BY a.[Date]) AS [Month_Differences], 
            b.auto_count, 
            b.self_count
     FROM
     (
         SELECT [Date], 
                [currentmonth] AS Current_Members, 
                [exist_memb] AS Existing_Members, 
                [new_memb] AS New_Members, 
                [term_memb] AS Termed_Members, 
                [lastmonth] AS Last_Month, 
                [currentmonth] - [lastmonth] AS Month_Differences
         FROM
         (
             SELECT *, 
                    ROW_NUMBER() OVER(PARTITION BY MONTH(date), 
                                                   YEAR(date)
                    ORDER BY date) AS row_num
             FROM
             (
                 SELECT [Date], 
                        [currentmonth], 
                        [exist_memb], 
                        [new_memb], 
                        [lastmonth], 
                        [term_memb], 
                        [exist_memb2]
                 FROM [dbo].[monthly_membership_trend]
             ) z
         ) z
         WHERE row_num = 1
     ) a
     JOIN

     /****** Script for SelectTopNRows command from SSMS  ******/

     (
         SELECT a.A_LAST_UPDATE_DATE, 
                a.self_count, 
                b.auto_count
         FROM
         (
             SELECT A_LAST_UPDATE_DATE, 
                    COUNT(DISTINCT [UHC_SUBSCRIBER_ID]) self_count
             FROM [dbo].[UHC_MembersByPCP]
             WHERE [AUTO_ASSIGN] = 'self'
             GROUP BY A_LAST_UPDATE_DATE
             HAVING A_LAST_UPDATE_DATE NOT IN('2017-07-24')
         ) a
         JOIN
         (
             SELECT A_LAST_UPDATE_DATE, 
                    COUNT(DISTINCT [UHC_SUBSCRIBER_ID]) auto_count
             FROM [dbo].[UHC_MembersByPCP]
             WHERE [AUTO_ASSIGN] = 'auto'
             GROUP BY A_LAST_UPDATE_DATE
             HAVING A_LAST_UPDATE_DATE NOT IN('2017-07-24')
         ) b ON a.A_LAST_UPDATE_DATE = b.A_LAST_UPDATE_DATE
     ) b ON a.Date = b.A_LAST_UPDATE_DATE;
