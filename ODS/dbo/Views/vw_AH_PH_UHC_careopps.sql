






CREATE VIEW [dbo].[vw_AH_PH_UHC_careopps]
AS


   SELECT DISTINCT
            s.SOURCE AS CLIENT_ID,
            C.MEMBERID AS MEMBER_ID,
            concat(ltrim(rtrim(M.SOURCE_MEASURE_ID)),'-',ltrim(rtrim(M.SOURCE_MEASURE_NAME))) AS OPPURTUNITY,
            ltrim(rtrim(M.SOURCE_MEASURE_ID)) AS MEASURE_CODE,
            M.SOURCE AS MEASURE_CATEGORY,
            case when pr.PROGRAM_STATUS_NAME='ACTIVE' then 'Not Addressed'
		  when pr.PROGRAM_STATUS_NAME='In Progress' then 'In Progress'
		  when pr.PROGRAM_STATUS_NAME='CLOSE-PENDING CLAIMS' then 'Completed'
		  else 'Not Addressed' end AS 'STATUS', 
            c.a_last_update_date AS DATE_IDENTIFIED,
            YEAR(GETDATE()) AS MEASURE_VERSION
		 ---, pr.CLIENT_PATIENT_ID,
		--  pr.PROGRAM_STATUS_NAME,
		--  pr.PROGRAM_NAME
     FROM uhc_careopps c
          INNER JOIN
(
    SELECT *
    FROM ACE_MAP_CAREOPPS_PROGRAMS
            WHERE is_active=1
) AS s ON s.SOURCE_MEASURE_NAME = c.Measure_Desc
          AND c.Sub_Meas = s.SOURCE_SUB_MEASURE_NAME
          AND s.SOURCE = 'UHC'
          AND S.DESTINATION = 'ALTRUISTA'
          INNER JOIN vw_UHC_ActiveMembers am ON c.MemberID = am.UHC_SUBSCRIBER_ID
          INNER JOIN
(
    SELECT *
    FROM [ACE_MAP_PROGRAMS_HEDIS]
    WHERE [Source] = 'hedis'
          AND Destination = 'ALTRUISTA'
) AS M ON M.Destination_program_name = s.DESTINATION_PROGRAM_NAME
   
left join (

	Select CLIENT_PATIENT_ID,
	PROGRAM_NAME,START_DATE,end_date,PROGRAM_STATUS_NAME from Ahs_Altus_Prod.dbo.vw_ACE_ALT_PE
 where YEAR(start_date)=YEAR(getdate())) as  pr on pr.client_patient_id=c.MemberID
 and pr.PROGRAM_NAME=s.DESTINATION_PROGRAM_NAME
 
   WHERE C.A_last_update_FLAG = 'Y'







