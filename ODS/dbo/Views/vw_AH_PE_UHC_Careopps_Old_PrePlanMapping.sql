

CREATE VIEW [dbo].[vw_AH_PE_UHC_Careopps_Old_PrePlanMapping]
AS
(
    SELECT
           RTRIM(ss.CLIENT_ID) AS CLIENT_ID
         , Convert(NVARCHAR(1000) ,SS.PROGRAM_NAME) AS PROGRAM_NAME
         , convert(nvarchar,RTRIM(ss.MEMBER_ID)) AS MEMBER_ID
         , SS.ENROLL_DATE
         , SS.CREATE_DATE
         , SS.ENROLL_END_DATE
         , convert(nvarchar,RTRIM(SS.PROGRAM_STATUS)) AS PROGRAM_STATUS
         , REASON_DESCRIPTION AS REASON_DESCRIPTION
         , REFERAL_TYPE AS REFERAL_TYPE
    FROM
    (
        SELECT DISTINCT
               S.SOURCE AS CLIENT_ID
             , C.MEMBERID AS MEMBER_ID
             , C.DOB
             , DATEADD(YEAR, DATEDIFF(YEAR, c.DOB, GETDATE()), c.DOB) AS CUR_YEAR_DOB
             , DATEDIFF(DAY, DATEADD(YEAR, DATEDIFF(YEAR, c.DOB, GETDATE()), c.DOB), GETDATE()) AS DAYSCOUNT
             , CASE
                   WHEN s.Criteria IS NULL
                   THEN LTRIM(RTRIM(S.DESTINATION_PROGRAM_NAME))
                   WHEN s.Criteria = 'high'
                        AND (DATEDIFF(DAY, DATEADD(YEAR, DATEDIFF(YEAR, c.DOB, GETDATE()), c.DOB), GETDATE())) <= 60
                   THEN LTRIM(RTRIM(S.DESTINATION_PROGRAM_NAME))
                   WHEN s.Criteria = 'Med'
                        AND (DATEDIFF(DAY, DATEADD(YEAR, DATEDIFF(YEAR, c.DOB, GETDATE()), c.DOB), GETDATE())) > 60
                   THEN LTRIM(RTRIM(s.Destination_program_name))
               END AS Program_name
           , dateadd(day, -1*day(CONVERT(DATE, C.A_last_update_date, 101))+1,CONVERT(DATE,C.A_last_update_date, 101)) AS ENROLL_DATE
            -- ,CONVERT(DATE, C.A_last_update_date, 101) as ENROLL_DATE
		   , CONVERT(DATE, C.A_last_update_date, 101) AS CREATE_DATE
		   /* EDIT: Changed Enroll_End_Date Per Business Need that it ends on last day of currrent year RA/GK*/
             , CONVERT(DATE, '12/31/' + convert(VARCHAR(4),YEar(GETDATE())), 101) AS ENROLL_END_DATE 
             , 'ACTIVE' AS PROGRAM_STATUS
             , 'Enrolled in a Program' AS REASON_DESCRIPTION
		   /*changing the referal type to UHC CareOpps instead of External- change request received form Dee and ICT*/
             , 'UHC CareOpps' AS REFERAL_TYPE
        FROM uhc_careopps c
             INNER JOIN (SELECT *
					   FROM dbo.ACE_MAP_CAREOPPS_PROGRAMS
					   WHERE is_active=1
				    ) AS s ON s.SOURCE_MEASURE_NAME = c.Measure_Desc
                  AND c.Sub_Meas = s.SOURCE_SUB_MEASURE_NAME
                  AND s.SOURCE = 'UHC'
                  AND S.DESTINATION = 'ALTRUISTA'
		  INNER JOIN vw_UHC_ActiveMembers am ON c.MemberID = am.UHC_SUBSCRIBER_ID
        WHERE C.A_last_update_FLAG = 'Y'
    ) ss
    WHERE ss.Program_name IS not NULL
    --order by ss.MEMBER_ID
   union
    SELECT distinct [Client_id]
      ,[PROGRAM_NAME]
      ,[MEMBER_ID]
      ,[ENROLL_DATE]
      ,[CREATE_DATE]
      ,[ENROLL_END_DATE]
      ,[PROGRAM_STATUS]
      ,[REASON_DESCRIPTION]
      ,[REFERAL_TYPE]
  FROM [ACECAREDW].[dbo].[vw_AH_PE_WLC_Careopps]

 

UNION
SELECT DISTINCT [CLIENT_ID]
      ,[PROGRAM_NAME]
      ,[MEMBER_ID]
      ,[ENROLL_DATE]
      ,[CREATE_DATE]
      ,[ENROLL_END_DATE]
      ,[PROGRAM_STATUS]
      ,[REASON_DESCRIPTION]
      ,[REFERAL_TYPE]
  FROM [ACECAREDW].[dbo].[vw_AH_PE_AET_Careopps]

  );




