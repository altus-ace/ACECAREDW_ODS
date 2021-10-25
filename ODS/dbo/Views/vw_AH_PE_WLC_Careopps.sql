
CREATE VIEW [dbo].[vw_AH_PE_WLC_Careopps]
AS
     SELECT DISTINCT 
            'WellCare' AS Client_id, 
            map.DESTINATION_PROGRAM_NAME AS PROGRAM_NAME, 
            CO.subscriber AS MEMBER_ID, 
            CONVERT(VARCHAR(10), DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0), 120) AS ENROLL_DATE, 
		  CONVERT(DATE, CO.CreateDate, 101) AS CREATE_DATE, 
            CONVERT(DATE, '12/31/2019', 101) AS ENROLL_END_DATE, 
            CONVERT(NVARCHAR, RTRIM('ACTIVE')) AS PROGRAM_STATUS, 
            'Enrolled in a Program' AS REASON_DESCRIPTION, 
            'WLC CareOpps' AS REFERAL_TYPE    
     FROM
     (
         SELECT CASE
                    WHEN(PATINDEX('%-%', m.Subscriber) = 0)
                    THEN m.Subscriber
                    ELSE SUBSTRING(m.Subscriber, 0, PATINDEX('%-%', m.Subscriber))
                END AS Subscriber, 
                m.Measure,
                CASE
                    WHEN(ComplianceStatus NOT LIKE 'In%')
                    THEN m.ComplianceStatus
                    ELSE(CASE
                             WHEN(CONVERT(INT,
                                          CASE
                                              WHEN(m.ComplianceStatus = 'In-Play - 100%')
                                              THEN RIGHT(LEFT(RIGHT(m.ComplianceStatus, (LEN(m.ComplianceStatus) - 7)), 6), 3)
                                              WHEN(m.ComplianceStatus LIKE 'in%')
                                                  AND m.ComplianceStatus <> 'In-Play - 100%'
                                              THEN LEFT(RIGHT(LEFT(RIGHT(m.ComplianceStatus, (LEN(m.ComplianceStatus) - 7)), 6), 3), 2)
                                          END)) BETWEEN 80 AND 100
                             THEN 'Compliant'
                             ELSE 'Non-Compliant'
                         END)
                END AS ComplianceStatus, 
                m.ServiceStartDate AS EnrollDate, 
                m.ServiceEndDate, 
                m.ComplianceDetail, 
                m.CreateDate
         FROM adi.CopWlcTxM m
              JOIN
         (
             SELECT MAX(m.FileDate) MaxFileDate
             FROM adi.CopWlcTxM m
         ) AS LatestLoad ON m.FileDate = LatestLoad.MaxFileDate
     ) AS co
     INNER JOIN
     (
         SELECT DISTINCT 
                Member_id, 
                MEMBER_CUR_EFF_DATE
         FROM vw_ActiveMembers
         WHERE client = 'WLC'
     ) a ON CONVERT(INT, a.member_id) = CONVERT(INT, co.subscriber)
     INNER JOIN acecaredw.dbo.ACE_MAP_CAREOPPS_PROGRAMS map ON map.SOURCE_MEASURE_NAME = co.Measure
                                                               AND map.destination = 'Altruista'
                                                               AND MAP.is_active = 1
                                                               AND MAP.SOURCE = 'WellCare'
     WHERE co.ComplianceStatus = 'Non-Compliant'; 
-- and CO.A_LAST_UPDATE_FLAG='Y'  not needed as the select for Adi gets only the latest data load
--ORDER BY MEMBER_ID

