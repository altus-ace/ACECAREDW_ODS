
CREATE VIEW [dbo].[vw_AH_UHC_MI_MemberPCP]
AS
     SELECT DISTINCT
		  mbr.SUBSCRIBER_ID as MEMBER_ID,
            'UHC' AS [CLIENT_ID],
		  null as [MEMBER_PCP],
            'PCP' AS [PROVIDER_RELATIONSHIP_TYPE],
            'UHC' [LOB],
            RTRIM(CONVERT(VARCHAR(10),CONVERT(DATE, '01/01/2018'))) AS [PCP_EFFECTIVE_DATE],
            '2099-12-31' AS [PCP_TERM_DATE],
            'A' AS [MEMBER_PCP_ADDITIONAL_INFORMATION_1]
     FROM adi.MbrUhcMicroIncentives mbr
    inner JOIN (SELECT i.SUBSCRIBER_ID
FROM adi.MbrUhcMicroIncentives I
    JOIN (SELECT loadDates.loadDate
                FROM (SELECT src.loadDate , ROW_NUMBER() OVER (PARTITION BY src.LoadDate ORDER BY src.LoadDATE DESC) as aRn
                           FROM (  SELECT I.loadDate     
                                      FROM adi.MbrUhcMicroIncentives I
                                     GROUP BY I.loadDate) src
                               ) AS loadDates
                     WHERE loadDates.aRn = 1) as ld ON I.loadDate = ld.loadDate
    JOIN (( SELECT i.Subscriber_ID AS UHC_SUBSCRIBER_ID FROM adi.MbrUhcMicroIncentives i) 
                      EXCEPT
                (SELECT am.UHC_SUBSCRIBER_ID FROM ACECAREDW.dbo.UHC_MembersByPCP am WHERE A_LAST_UPDATE_FLAG = 'Y')) AS AM ON I.SUBSCRIBER_ID = am.UHC_SUBSCRIBER_ID


			 ) as
			  s on s.SUBSCRIBER_ID=mbr.SUBSCRIBER_ID

