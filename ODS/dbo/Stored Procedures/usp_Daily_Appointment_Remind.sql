

--USE [ACECAREDW]
--go

CREATE PROCEDURE [dbo].[usp_Daily_Appointment_Remind]
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
	  , A.practice_name
	  , '. This is a reminder that you are scheduled for an appointment on '
	  ,CAST(A.APPTDATE AS DATE), ' @ ', CONVERT(VARCHAR(15)
	  , CAST(A.apptdate AS TIME), 100) 
	  , ' . Call 832-835-5200 '
	  , ' to cancel or reschedule your appointment. Text STOP to cancel texts."') AS TEXT_MSG 
--,  DATENAME(dw,getdate()) as day_of_send

FROM  [ACECAREDW].[dbo].[vw_AH_Mpluse_Appointments] A WITH (NOLOCK)
inner JOIN
(
    SELECT 
           ClientMemberKey,Ace_ID_Mrn,phoneNumber
    FROM [AceCareDw].[adi].[MPulsePhoneScrubbed] WITH (NOLOCK)
    WHERE carrier_type = 'Mobile'
) B ON A.Member_id = B.ClientMemberKey
inner join ACECAREDW.[dbo].vw_ActiveMembers d WITH (NOLOCK) on d.MEMBER_ID=A.member_id
WHERE A.Practice_tin IN('760649747','311756818','260233069','202319157','461559030','201719874','200462905','760622208','731727721','471104790','760604846',
'760604667',
'760598582',
'760537608',
'432109907',
'431960127',
'760675781',
'020647102',
'472271803',
'412073608')

AND (
(convert(date,A.apptdate) = CASE WHEN DATEPART("DW",GETDATE()) <> 6 THEN convert(date,DATEADD(day,2, GETDATE()))
									 ELSE convert(date,DATEADD(day, 2, GETDATE())) END)
OR
(convert(date,A.apptdate) = CASE WHEN DATEPART("DW",GETDATE()) <> 6 THEN convert(date,DATEADD(day,2, GETDATE()))
									 ELSE convert(date,DATEADD(day, 3, GETDATE())) END)
OR (convert(date,A.apptdate) = CASE WHEN DATEPART("DW",GETDATE()) <> 6 THEN convert(date,DATEADD(day,2, GETDATE()))
									 ELSE convert(date,DATEADD(day, 4, GETDATE())) END)
)
and  A.appt_status in ('Scheduled', 'Confirmed', 'Completed', 'Retro', 'Appointment Update','Third Party Appointment','ReScheduled')
and CONVERT(VARCHAR(15), CAST(A.apptdate AS TIME), 100) <> '12:00AM'

END 
