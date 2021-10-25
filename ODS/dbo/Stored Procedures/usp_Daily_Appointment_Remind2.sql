

--USE [ACECAREDW]
--go
/*********************************************************************************************************
Created by : Robert
Create Date : 2019
Description : 
		


Modification:
 user        date        comment
 RA        08/12/19		Change phone number  from 832-835-5200 to 832-835-5133
 RA		   11/18/2019   Added St Joseph appointments
 BY        12/05/2019   Changed date inside the message minus 2 to keep same as MSDATE
 GK		 01/21/2020   Altered date add code to get the message date to show correctly 2 days before appt.

******************************************************************/
CREATE PROCEDURE [dbo].[usp_Daily_Appointment_Remind2]
AS 

BEGIN
SELECT distinct 
--A.APPOINTMENT_ID,
              '1' as CAMPAIGN_ID,
       A.member_id AS ALTRUISTA_ID,
          'UHC' AS CLIENT_ID,
       B.Ace_ID_Mrn AS ACE_ID,
              d.member_first_name as FIRST_NAME,
              d.member_last_name as LAST_NAME,
	   DATEADD(DAY, -2, CAST(A.APPTDATE AS DATE)) AS MSGDATE,	    
       B.phoneNumber AS PHONE,
      -- A.Created_on AS CREATED_ON,
	 
       CONCAT('"Hi this is ACE, we work with your doctor at '
         , isnull(A.provider_name,A.practice_name)
         , '. This is a reminder that you are scheduled for an appointment on '
		 ,CAST(A.APPTDATE AS DATE)
		 , ' @ ', CONVERT(VARCHAR(15)		          
		 , CAST(A.apptdate AS TIME), 100) 
         , ' . Call 832-835-5133 '
         , ' to cancel or reschedule your appointment. Text STOP to cancel texts."') AS TEXT_MSG 
FROM  [ACECAREDW].[dbo].[vw_AH_Mpluse_Appointments] A 
inner JOIN
(
        SELECT *
    FROM
    (
        SELECT ClientMemberKey, 
               Ace_ID_Mrn, 
               phoneNumber, 
               ROW_NUMBER() OVER(PARTITION BY clientmemberkey
               ORDER BY loaddate DESC) AS arn
        FROM [AceCareDw].[adi].[MPulsePhoneScrubbed]
  --      WHERE carrier_type = 'Mobile'
    ) AS x
    WHERE x.arn = 1
) B ON A.Member_id = B.ClientMemberKey
inner join ACECAREDW.[dbo].vw_ActiveMembers d WITH (NOLOCK) on d.MEMBER_ID=A.member_id
WHERE 
(A.Practice_tin IN('760649747','311756818','260233069','202319157','461559030','201719874','200462905','760622208','731727721','471104790','760604846',
	   '760604667', '760598582','760537608','432109907','431960127','760675781','020647102','472271803','412073608')
    or a.Practice_Tin is null)
AND
 ((convert(date,A.apptdate) = CASE WHEN DATEPART("DW",GETDATE()) <> 6 THEN convert(date,DATEADD(day,2, GETDATE()))
	   ELSE convert(date,DATEADD(day, 2, GETDATE())) END)
OR (convert(date,A.apptdate) = CASE WHEN DATEPART("DW",getdate()) <> 6 THEN convert(date,DATEADD(day,2, GETDATE()))
	   ELSE convert(date,DATEADD(day, 3, getdate())) END)
OR (convert(date,A.apptdate) = CASE WHEN DATEPART("DW",GETDATE()) <> 6 THEN convert(date,DATEADD(day,2, GETDATE()))
	   ELSE convert(date,DATEADD(day, 4, GETDATE())) END))
and  A.appt_status in ('Scheduled', 'Confirmed', 'Completed', 'Retro', 'Appointment Update','Third Party Appointment','ReScheduled')
and CONVERT(VARCHAR(15), CAST(A.apptdate AS TIME), 100) <> '12:00AM'



END 

