CREATE VIEW [dbo].[vw_AH_UHC_MI_IProInterface]
AS
SELECT DISTINCT
       mbr.SUBSCRIBER_ID AS MEMBER_ID,
       'UHC' AS [CLIENT_ID],
       mbr.MEMBER_FIRST_NAME AS [MEMBER_FIRST_NAME],
       mbr.MEMBER_LAST_NAME AS [MEMBER_LAST_NAME],
       mbr.DATE_OF_BIRTH AS DATE_OF_BIRTH,
       mbr.GENDER AS GENDER,
       'N/A' AS RISK_CATEGORY_C,
       'N/A' AS RISK_TYPE,
       '' AS RISK_SCORE,
       '01/01/2018' AS GC_START_DATE,
       '12/31/2018' AS GC_END_DATE
FROM adi.MbrUhcMicroIncentives mbr
    INNER JOIN
    (
        SELECT i.SUBSCRIBER_ID
        FROM adi.MbrUhcMicroIncentives i
            JOIN
            (
                SELECT loadDates.loadDate
                FROM
                (
                    SELECT src.loadDate,
                           ROW_NUMBER() OVER (PARTITION BY src.loadDate ORDER BY src.loadDate DESC) AS aRn
                    FROM
                    (
                        SELECT I.loadDate
                        FROM adi.MbrUhcMicroIncentives I
                        GROUP BY I.loadDate
                    ) src
                ) AS loadDates
                WHERE loadDates.aRn = 1
            ) AS ld
                ON i.loadDate = ld.loadDate
            JOIN
            (
                (SELECT i.SUBSCRIBER_ID AS UHC_SUBSCRIBER_ID
                 FROM adi.MbrUhcMicroIncentives i)
                EXCEPT
                (SELECT am.UHC_SUBSCRIBER_ID
                 FROM ACECAREDW.dbo.UHC_MembersByPCP am
                 WHERE A_LAST_UPDATE_FLAG = 'Y')
            ) AS AM
                ON i.SUBSCRIBER_ID = AM.UHC_SUBSCRIBER_ID
    ) AS s
        ON s.SUBSCRIBER_ID = mbr.SUBSCRIBER_ID;

