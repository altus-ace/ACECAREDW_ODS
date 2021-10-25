



CREATE view [dbo].[vw_AH_ActivitesApptBymember]
As
SELECT DISTINCT P.UHC_SUBSCRIBER_ID as Member_id,convert(int,act.Activity_year) as Activity_year ,ACT.[ACTIVITIES] as TotalActivities,TotalAppointments
 FROM ACECAREDW.DBO.UHC_membersbypcp P 
 		LEFT JOIN 

		
		(select CLIENT_PATIENT_ID AS MEMBER_ID,Activity_year
,SUM(cnt) as [ACTIVITIES] ,sum(apptCnt) as TotalAppointments from (
SELECT  Distinct
pd.CLIENT_PATIENT_ID,
	   pf.PATIENT_ID,
	   pf.patient_followup_id as ID
, convert(date,pf.performed_date,101) AS PERFORMED
, concat(Month(Pf.performed_date),'-',Year(pf.performed_date)) as MONTH_YEAR
,Year(pf.performed_date) as Activity_year
--,Year(pf.performed_date) as ACTIVITY_PERFORMED_YEAR
, case when cat.care_activity_type_name in ('10CALL','1CALL','2CALL','3CALL','4CALL','5CALL',
'6CALL',
'7CALL',
'8CALL',
'9CALL',
'I-CALL' ,'NMC','RCALL') then 'CALLS' 
 when sas.SCRIPT_NAME in ('Health Risk Screening','Postpartum Screening','Prenatal Screening','Diabetic Script') then 'Screening'
 when cat.CARE_ACTIVITY_TYPE_NAME='Assessment' and sas.SCRIPT_NAME is null then 'Non Assessment'
 WHEN CAT.CARE_ACTIVITY_TYPE_NAME IN ('TOC') THEN LTRIM(RTRIM(SAS.SCRIPT_NAME))
else ltrim(rtrim(cat.CARE_ACTIVITY_TYPE_NAME)) end As ACTIVITY_TYPE,
1 as cnt,
0 as apptcnt
FROM AHS_ALTUS_PROD.dbo.patient_followup AS pf
INNER JOIN AHS_ALTUS_PROD.dbo.care_activity_type AS cat ON pf.care_activity_type_id = cat.care_activity_type_id
AND cat.deleted_on IS NULL
AND cat.is_active = 1
left Join AHS_ALTUS_PROD.dbo.scpt_admin_script sas on sas.Script_id=pf.script_id
left join AHS_ALTUS_PROD.DBO.venue v on v.venue_id=pf.venue_id
LEFT OUTER JOIN AHS_ALTUS_PROD.dbo.activity_outcome AS ao ON pf.activity_outcome_id = ao.activity_outcome_id
AND ao.deleted_on IS NULL
AND ao.is_active = 1
inner join AHS_ALTUS_PROD.DBO.patient_details pd on pd.patient_id=pf.patient_id

where pf.performed_Date is not null
--and cat.CARE_ACTIVITY_TYPE_NAME not in ('Scheduled Appointemnt','1','Appointment Reminder','Case Conference','Case Management-Follow Up',
--'LexisNexis','Non Assessment','Research','Review Care Plan','Schedule Appointment') 
and pd.CLIENT_PATIENT_ID not in ('ALT26860','ALT40110','ALT40111')
--and pd.PATIENT_ID='14318'
union
SELECT  Distinct
pd.client_patient_id,
	   pf.PATIENT_ID
	   ,pf.PATIENT_FOLLOWUP_ID as ID
, convert(date,pf.performed_date,101) AS PERFORMED
, concat(Month(Pf.performed_date),'-',Year(pf.performed_date)) as MONTH_YEAR
,Year(pf.performed_date) as Activity_year
, case 
 when v.Venue_name in ('BH Referral Deblin','BH Referral NP Care Services Group') then 'BH Referral'
else null end As ACTIVITY_TYPE,
1 as cnt,
0 as apptcnt
FROM AHS_ALTUS_PROD.dbo.patient_followup AS pf
INNER JOIN AHS_ALTUS_PROD.dbo.care_activity_type AS cat ON pf.care_activity_type_id = cat.care_activity_type_id
AND cat.deleted_on IS NULL
AND cat.is_active = 1
left Join AHS_ALTUS_PROD.dbo.scpt_admin_script sas on sas.Script_id=pf.script_id
left join AHS_ALTUS_PROD.DBO.venue v on v.venue_id=pf.venue_id
LEFT OUTER JOIN AHS_ALTUS_PROD.dbo.activity_outcome AS ao ON pf.activity_outcome_id = ao.activity_outcome_id
AND ao.deleted_on IS NULL
AND ao.is_active = 1
inner join AHS_ALTUS_PROD.DBO.patient_details pd on pd.patient_id=pf.patient_id
where pf.performed_Date is not null
and v.Venue_name in ('BH Referral Deblin','BH Referral NP Care Services Group')
and pd.CLIENT_PATIENT_ID not in ('ALT26860','ALT40110','ALT40111')-- and pd.PATIENT_ID='14318'

UNION 
SELECT
                  apps.client_patient_id,
                  apps.Patient_id AS PATIENT_ID
			  
						   ,APPOINTMENT_ID AS ID
			   , convert(date,apps.created_on,101) as performed
			   ,CONCAT(Month(apps.created_on),'-',year(apps.created_on)) as month_year
			  ,year(apps.created_on) as Activity_year
			   , case when apps.APPOINTMENT_ID is not null then 'Appointments' end as ACTIVITY_type,
			   1 AS CNT,
			   1 as apptcnt
                         FROM
             (
                 sELECT *,CASE
                            WHEN aP.APPOINTMENT_STATUS_ID NOT IN(9, 10,11)
                            THEN ap.APPOINTMENT_DATE
                            WHEN ISNULL(NULLIF(LTRIM(RTRIM(AP.appointment_noteS)), ''), '') = ''
                                 AND ap.APPOINTMENT_STATUS_ID IN(9, 10,11)
                            THEN ap.APPOINTMENT_DATE
                            WHEN(TRY_CONVERT( DATE, ISNULL(NULLIF(LTRIM(RTRIM(ap.appointment_noteS)), ''), '')) IS NULL)
                                AND ap.APPOINTMENT_STATUS_ID IN(9, 10,11)
                            THEN ap.APPOINTMENT_DATE
                            ELSE TRY_CONVERT(DATE, ISNULL(NULLIF(LTRIM(RTRIM(ap.appointment_noteS)), ''), ''))
                        END AS AppDate FROM (
    SELECT
                        app.patient_id
				    ,pd.client_patient_id
				   , aps.appointment_status_id
                      , aps.appointment_status_name
                      , app.APPOINTMENT_ID
				  ,app.created_on
                      , app.appointment_date
				  , CASE WHEN AAL.CREATED_ON =APP.UPDATED_ON THEN AAL.APPOINTMENT_NOTE ELSE APP.APPOINTMENT_NOTES END AS APPOINTMENT_NOTES
                      , app.CREATED_BY
                      , app.APPOINTMENT_NOTES AS NOTE
				  ,ppd.PROVIDER_NAME as Appointment_provider
				  ,ppd.CLINIC_NAME as Appointment_Practice_Name
				  ,(LTRIM(RTRIM(csd3.FIRST_NAME))+' '+LTRIM(RTRIM(csd3.LAST_NAME))) as Appt_SCH_by
                 FROM AHS_ALTUS_PROD.dbo.appointment app
                      INNER JOIN AHS_ALTUS_PROD.dbo.appointment_status aps ON app.appointment_status = aps.appointment_status_id
                                                               AND aps.deleted_on IS NULL
                                                               AND aps.is_active = 1
				 LEFT JOIN AHS_ALTUS_PROD.DBO.APPOINTMENT_AUDIT_LOG AAL ON AAL.APPOINTMENT_ID=APP.APPOINTMENT_ID
												    AND AAL.CREATED_ON=APP.UPDATED_ON
												    AND AAL.APPOINTMENT_NOTE IS NOT NULL
												    AND AAL.APPOINTMENT_NOTE <>' '
				INNER JOIN AHS_ALTUS_PROD.dbo.CARE_STAFF_DETAILS AS csd3 ON csd3.MEMBER_ID = app.CREATED_BY
					Inner Join AHS_ALTUS_PROD.dbo.APPOINTMENT_PROVIDER_MAPPING as apm on apm.appointment_id=app.appointment_id
			join AHS_ALTUS_PROD.DBO.PHYSICIAN_DEMOGRAPHY ppd on ppd.physician_id= apm.provider_id
			join AHS_ALTUS_PROD.DBO.patient_details pd on pd.patient_id = app.patient_id
			                 WHERE app.deleted_on IS NULL
                       AND app.is_active = 1
                       AND aps.appointment_status_name IN('Scheduled', 'Confirmed', 'Completed', 'Retro', 'Appointment Update','Third Party Appointment')
				 and pd.CLIENT_PATIENT_ID not in ('ALT26860','ALT40110','ALT40111') ) AS AP
             ) AS apps --where apps.PATIENT_ID='14318'
) as p

Group by P.CLIENT_PATIENT_ID,p.Activity_year

) AS ACT ON ACT.MEMBER_ID=P.UHC_SUBSCRIBER_ID




