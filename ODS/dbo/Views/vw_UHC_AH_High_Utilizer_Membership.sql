

CREATE VIEW [dbo].[vw_UHC_AH_High_Utilizer_Membership]
AS

SELECT [Member First Name]
      ,[Member Last Name]
      ,[ ID]
      ,left([Program Start Date], 11) As [Program Start Date]
      ,left([Program End Date], 11) As [Program End Date]
      ,[Program Name]
      ,[Program Status]
      ,[Internal Care Team],
       CASE
           WHEN HUM.[ ID] IN(SELECT Member_ID
                             FROM vw_ActiveMembers)
           THEN 'Active'
           ELSE 'Not Active'
       END AS [MemberActive?],
       CASE
           WHEN HUM.[ ID] IN(SELECT AM.MEMBER_ID
                             FROM vw_ActiveMembers AM
                                  JOIN Ahs_Altus_Prod.[dbo].[vw_ACE_Get_PM] GP ON AM.MEMBER_ID = GP.MEMBER_ID
                             WHERE lob = 'UHC'
                                   AND PROGRAM_STATUS_NAME IN('active', 'HTR-ICT')
                                  AND PROGRAM_START_DATE >= '2019-05-19 00:00:00.000'
                                  AND PROGRAM_START_DATE <= '2019-12-31 00:00:00.000')
           THEN 'Active'
           ELSE 'Not Active'
       END AS [ProgramActive?]
FROM tmp_UHC_AH_High_Utilizer_Membership HUM

