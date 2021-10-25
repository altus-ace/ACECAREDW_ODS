CREATE View VW_DAILY_APPT_MPULSE
as
select Appointment_id,
CLIENT_PATIENT_ID,
CLIENT_ID,
ACE_ID,
FIRST_NAME,
LAST_NAME,
APPT_STAT,
APPTDATE,
APPTTIME,
PHONE,
TEXT_MSG--, take_appt_day
 from 
(
select * , case when day_of_send = 'Monday' then dateadd(day, -3, getdate()) else dateadd(day,-1,getdate()) end as take_appt_day
--,datename(dw,case when day_of_send = 'Monday' then dateadd(day, -3, getdate()) else dateadd(day,-1,getdate()) end ) as dayy

 from 
(
SELECT  
      A.Appointment_id,A.member_id as CLIENT_PATIENT_ID , B.CLIENT as CLIENT_ID,B.mbrMrn as ACE_ID,B.mbrFName as FIRST_NAME,B.mbrLName as LAST_NAME
 ,A.appt_status as APPT_STAT, cast(A.APPTDATE as date) as APPTDATE,
  CONVERT(varchar(15),CAST(A.apptdate AS TIME),100) as APPTTIME , B.phoneNumber as PHONE
  ,A.Created_on
,CONCAT('Hi this is ACE, we work with your doctor at ', A.practice_name,'. You are scheduled for an appointment on [',cast(A.APPTDATE as date),' @ ',CONVERT(varchar(15),CAST(A.apptdate AS TIME),100),'] . Call ',C.PHONE,' to cancel or reschedule your appointment. Text STOP to cancel texts.') as TEXT_MSG 
,  DATENAME(dw,getdate()) as day_of_send
  FROM [ACECAREDW].[dbo].[vw_AH_Mpluse_Appointments] A  join (SELECT 'UHG' as CLIENT ,*
      
  FROM [AceCareDw_Qa].[adw].[mbrPhoneMobileValidation2]
  where carrier_type = 'Mobile') B on A.Member_id = B.ClientMemberKey
  join [ACECAREDW].[dbo].[Phone_Scrub_Client_Phone] C on C.client_id = B.CLIENT
  where A.practice_name like '%calvary%'and 
  A.apptdate >= Getdate()
  and A.member_id not in (select distinct member_id from [ACECAREDW].[dbo].vw_do_not_text_list)

  )Z
  )ZZ
 WHERE CONVERT(DATE,CREATED_ON,101) =CONVERT(DATE,TAKE_APPT_DAY,101)
 