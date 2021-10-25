
CREATE view [dbo].[vw_AH_ACECAREDW_Activity]
As
SELECT  Distinct
'AHS' As [Source_name],l.lob_name as LOB,
pd.CLIENT_PATIENT_ID as Member_id
, convert(date,pf.performed_date,101) AS PERFORMED_Date
,csd.first_name+csd.Last_name as Perfromed_By
,RTRIM(LTRIM(cat.care_activity_type_name)) AS ACTIVITY_TYPE
, case when cat.care_activity_type_name in ('10CALL','1CALL','2CALL','3CALL','4CALL','5CALL',
'6CALL',
'7CALL',
'8CALL',
'9CALL',
'I-CALL' ,'NMC','RCALL') then 'CALLS' 
 when sas.SCRIPT_NAME in ('Health Risk Screening','Postpartum Screening','Prenatal Screening','Diabetic Script') then 'Screening'
 when cat.CARE_ACTIVITY_TYPE_NAME in ('Assessment','TOC') and sas.SCRIPT_NAME is null then 'Non Assessment'
 WHEN CAT.CARE_ACTIVITY_TYPE_NAME IN ('TOC') THEN LTRIM(RTRIM(SAS.SCRIPT_NAME))
else ltrim(rtrim(cat.CARE_ACTIVITY_TYPE_NAME)) end As Activity_Category
FROM ahs_altus_prod.dbo.patient_followup AS pf
INNER JOIN ahs_altus_prod.dbo.care_activity_type AS cat ON pf.care_activity_type_id = cat.care_activity_type_id
AND cat.deleted_on IS NULL
AND cat.is_active = 1
left Join ahs_altus_prod.dbo.scpt_admin_script sas on sas.Script_id=pf.script_id
left join ahs_altus_prod.dbo.venue v on v.venue_id=pf.venue_id
LEFT OUTER JOIN ahs_altus_prod.dbo.activity_outcome AS ao ON pf.activity_outcome_id = ao.activity_outcome_id
inner join ahs_altus_prod.dbo.care_staff_details csd on csd.member_id=pf.performed_by

AND ao.deleted_on IS NULL
AND ao.is_active = 1
inner join ahs_altus_prod.dbo.patient_details pd on pd.patient_id=pf.patient_id

Inner join  ahs_altus_prod.dbo.MEM_BENF_PLAN mbp on mbp.member_id=pd.patient_id
inner join ahs_altus_prod.dbo.LOB_BENF_PLAN lbp on lbp.lob_ben_id=mbp.lob_ben_id
inner join ahs_altus_prod.dbo.LOB l on l.LOB_ID=lbp.Lob_id
where pf.performed_Date is not null
and cat.CARE_ACTIVITY_TYPE_NAME not in ('Scheduled Appointemnt','1','Appointment Reminder','Case Conference','Case Management-Follow Up',
'Review Care Plan','Schedule Appointment') and pd.CLIENT_PATIENT_ID not in ('ALT26860','ALT40110','ALT40111') 
--order by pd.CLIENT_PATIENT_ID*
union
SELECT  Distinct
'AHS' As [Source_name],l.LOB_name as LOB,
pd.client_patient_id  AS Member_id 
, convert(date,pf.performed_date,101) AS PERFORMED_date
,csd.first_name+csd.Last_name as Perfromed_By
,RTRIM(LTRIM(v.VENUE_NAME)) as Activity_type
, case 
 when v.Venue_name in ('BH Referral Deblin','BH Referral NP Care Services Group') then 'BH Referral'
else null end As ACTIVITY_Category
FROM ahs_altus_prod.dbo.patient_followup AS pf
INNER JOIN ahs_altus_prod.dbo.care_activity_type AS cat ON pf.care_activity_type_id = cat.care_activity_type_id
AND cat.deleted_on IS NULL
AND cat.is_active = 1
left Join ahs_altus_prod.dbo.scpt_admin_script sas on sas.Script_id=pf.script_id
left join ahs_altus_prod.dbo.venue v on v.venue_id=pf.venue_id
LEFT OUTER JOIN ahs_altus_prod.dbo.activity_outcome AS ao ON pf.activity_outcome_id = ao.activity_outcome_id
AND ao.deleted_on IS NULL
AND ao.is_active = 1

inner join ahs_altus_prod.dbo.patient_details pd on pd.patient_id=pf.patient_id

Inner join  ahs_altus_prod.dbo.MEM_BENF_PLAN mbp on mbp.member_id=pd.patient_id
inner join ahs_altus_prod.dbo.LOB_BENF_PLAN lbp on lbp.lob_ben_id=mbp.lob_ben_id
inner join ahs_altus_prod.dbo.LOB l on l.LOB_ID=lbp.Lob_id
inner join ahs_altus_prod.dbo.care_staff_details csd on csd.member_id=pf.performed_by
where pf.performed_Date is not null
and v.Venue_name in ('BH Referral Deblin','BH Referral NP Care Services Group')
and pd.CLIENT_PATIENT_ID not in ('ALT26860','ALT40110','ALT40111')
union
SELECT 'AHS' as Source_name,LOB,
			  apps.client_patient_id as Member_id
			   , convert(date,apps.created_on,101) as performed_date
			   ,Appt_SCH_by as Performed_by
			   , case when apps.APPOINTMENT_ID is not null then 'Appointment '+ apps.appointment_status_name end as ACTIVITY_type
			   ,'Appointment' as  Activity_Category
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
				    ,l.lob_name As LOB
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
                 FROM ahs_altus_prod.dbo.appointment app
                      INNER JOIN ahs_altus_prod.dbo.appointment_status aps ON app.appointment_status = aps.appointment_status_id
                                                               AND aps.deleted_on IS NULL
                                                               AND aps.is_active = 1
				 LEFT JOIN ahs_altus_prod.DBO.APPOINTMENT_AUDIT_LOG AAL ON AAL.APPOINTMENT_ID=APP.APPOINTMENT_ID
												    AND AAL.CREATED_ON=APP.UPDATED_ON
												    AND AAL.APPOINTMENT_NOTE IS NOT NULL
												    AND AAL.APPOINTMENT_NOTE <>' '
				INNER JOIN ahs_altus_prod.dbo.CARE_STAFF_DETAILS AS csd3 ON csd3.MEMBER_ID = app.CREATED_BY
					Inner Join ahs_altus_prod.dbo.APPOINTMENT_PROVIDER_MAPPING as apm on apm.appointment_id=app.appointment_id
			join ahs_altus_prod.dbo.PHYSICIAN_DEMOGRAPHY ppd on ppd.physician_id= apm.provider_id
			

			join ahs_altus_prod.dbo.patient_details pd on pd.patient_id = app.patient_id
			Inner join  ahs_altus_prod.dbo.MEM_BENF_PLAN mbp on mbp.member_id=pd.patient_id
inner join ahs_altus_prod.dbo.LOB_BENF_PLAN lbp on lbp.lob_ben_id=mbp.lob_ben_id
inner join ahs_altus_prod.dbo.LOB l on l.LOB_ID=lbp.Lob_id
			                 WHERE app.deleted_on IS NULL
                       AND app.is_active = 1
                       AND aps.appointment_status_name IN('Scheduled', 'Confirmed', 'Completed', 'Retro', 'Appointment Update','Third Party Appointment')
				 and pd.CLIENT_PATIENT_ID not in ('ALT26860','ALT40110','ALT40111') ) as ap) as apps
