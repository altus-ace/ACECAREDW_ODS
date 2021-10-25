CREATE view vw_mpulse_daily_appt_reminders
as 
 select
Z.Appointment_id,--
Z.member_id  as CLIENT_PATIENT_ID,--
Z.CLIENT as CLIENT_ID,--
Z.mbrMrn as ACE_ID,--
Z.mbrFName as FIRST_NAME,--
Z.mbrLName as LAST_NAME,--
Z.appt_status as APPT_STAT,--
convert(date,cast(Z.APPTDATE as date) ,101) as APPT_DATE,--
CONVERT(varchar(15),CAST(Z.apptdate AS TIME),100) as APPTTIME,--
Z.phoneNumber as PHONE,--
CONCAT('Hi this is ACE, we work with your doctor at ', Z.practice_name,'. You are scheduled for an appointment on [',cast(convert(date,cast(Z.APPTDATE as date) ,101) as date),' @ ',CONVERT(varchar(15),CAST(Z.apptdate AS TIME),100),'] . Call ',ZZ.PHONE,' to cancel or reschedule your appointment. Text STOP to cancel texts.') as TEXT_MSG
 --
 from 
  (
select  A.Appointment_id,A.Appt_Status,A.ApptDate,A.Practice_Name,A.Member_id, C.phoneNumber,c.mbrFName,c.mbrLName,c.mbrMrn,c.CLIENT
 from (
 select * from (
 select *,dense_rank() over (partition by appointment_id order by created_on desc) as rank ,
  case when  DATENAME(dw,getdate()) = 'Monday' then dateadd(day, -3, getdate()) else dateadd(day,-1,getdate()) end as take_appt_day from [ACECAREDW].[dbo].[vw_AH_Mpluse_Appointments]
) A where rank = 1 and Appt_status <> 'Cancelled'
 --where CONVERT(DATE,CREATED_ON,101) =CONVERT(DATE,case when  DATENAME(dw,getdate()) = 'Monday' then dateadd(day, -3, getdate()) else dateadd(day,-1,getdate()) end,101)
 )A
 join ACECAREDW.dbo.vw_UHC_ActiveMembers B on A.MEMBER_ID = B.MEMBER_ID
 join (SELECT 1 as CLIENT ,* FROM [AceCareDw_Qa].[adw].[mbrPhoneMobileValidation2]  where carrier_type = 'Mobile') C on A.Member_id = C.ClientMemberKey
 where 
  convert(date,A.apptdate,101) >= convert(date, Getdate(),101)
  and A.member_id not in (select distinct member_id from [ACECAREDW].[dbo].vw_do_not_text_list)
  and  A.practice_name like '%calvary%'
  )Z
  join  [ACECAREDW].[dbo].[Phone_Scrub_Client_Phone] ZZ on Z.CLIENT = ZZ.id

