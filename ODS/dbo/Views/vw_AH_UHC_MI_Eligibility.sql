

CREATE VIEW [dbo].[vw_AH_UHC_MI_Eligibility]
AS
    SELECT DISTINCT
       mbr.SUBSCRIBER_ID AS [MEMBER_ID],
       'UHC' AS CLIENT_ID,
       'UHC' AS [LOB],
       p.DESTINATION_VALUE AS [BENEFIT PLAN],
       'E' AS [INTERNAL/EXTERNAL INDICATOR],
       RTRIM(CONVERT(VARCHAR(10), CONVERT(DATE, '10/01/2018'))) AS [START_DATE],
       '2018-12-31' AS [END_DATE]
FROM adi.MbrUhcMicroIncentives mbr
    INNER JOIN dbo.[ALT_MAPPING_TABLES] p
        ON p.SOURCE_VALUE = mbr.SGSG_ID
           AND p.SOURCE = 'UHC_MI'
           AND p.TYPE = 'PLAN CODE'
           AND p.DESTINATION = 'ALTRUISTA'
    JOIN
    (
        SELECT I.SUBSCRIBER_ID
        FROM adi.MbrUhcMicroIncentives I
            JOIN
            (
                SELECT loadDates.loadDate
                FROM
                (
                    SELECT src.loadDate,
                           ROW_NUMBER() OVER (PARTITION BY src.LoadDate ORDER BY src.LoadDATE DESC) AS aRn
                    FROM
                    (
                        SELECT I.loadDate
                        FROM adi.MbrUhcMicroIncentives I
                        GROUP BY I.loadDate
                    ) src
                ) AS loadDates
                WHERE loadDates.aRn = 1
            ) AS ld
                ON I.loadDate = ld.loadDate
            JOIN
            (
                (SELECT i.Subscriber_ID AS UHC_SUBSCRIBER_ID
                 FROM adi.MbrUhcMicroIncentives i)
                EXCEPT
                (SELECT am.UHC_SUBSCRIBER_ID
                 FROM ACECAREDW.dbo.UHC_MembersByPCP am
                 WHERE A_LAST_UPDATE_FLAG = 'Y')
            ) AS AM
                ON I.SUBSCRIBER_ID = AM.UHC_SUBSCRIBER_ID
    ) AS s
        ON s.SUBSCRIBER_ID = mbr.SUBSCRIBER_ID;

