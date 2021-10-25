CREATE view VW_APPT_REMINDERS_2DAYS
as
Select p.member_id as CLIENT_PATIENT_ID , Z.ClientKey as CLIENT_ID,Z.mbrMrn as ACE_ID, Z.mbrFName as FIRST_NAME,Z.mbrLName as LAST_NAME
 ,p.appt_status as APPT_STAT, cast(p.APPTDATE as date) as APPTDATE,
  CONVERT(varchar(15),CAST(p.apptdate AS TIME),100) as APPTTIME , 8322489388 as PHONE

,CONCAT('Hi this is ACE, we work with your doctor at ', p.practice_name,'. You are scheduled for an appointment on [',cast(p.APPTDATE as date),' @ ',CONVERT(varchar(15),CAST(p.apptdate AS TIME),100),'] . Call ',AA.PHONE,' to cancel or reschedule your appointment. Text STOP to cancel texts.') as TEXT_MSG 



from vw_AH_Mpluse_Appointments p 
			 join 
	   VW_PHONE_SCRUB_VALID_MOBILE Z  on p.member_ID = Z.ClientMemberKey

join 
[Phone_Scrub_Client_Phone] AA on AA.client_id = Z.CLIENTKey

join (
SELECT distinct Member_id 
  FROM [ACECAREDW].[dbo].[vw_UHC_ActiveMembers]) BB on p.Member_id = BB.MEMBER_ID