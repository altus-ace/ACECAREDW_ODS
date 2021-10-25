





--use ACECAREDW

--USE AHS_ALTUS_PROD



CREATE VIEW [dbo].[vw_AH_Mpluse_Appointments_old_01]
As
Select *from (
                 sELECT Appointment_id,CLIENT_PATIENT_ID as Member_id,
			  			  case when APPOINTMENT_STATUS_NAME IN ('Completed','Scheduled','Confirmed','Retro','Rescheduled') then 'Scheduled'
						  Else APPOINTMENT_STATUS_NAME end 
 as Appt_Status,
			  CREATED_ON as Created_on,
			  CASE
                            WHEN aP.APPOINTMENT_STATUS_ID NOT IN(9, 10,11)
                            THEN ap.APPOINTMENT_DATE
                            WHEN ISNULL(NULLIF(LTRIM(RTRIM(AP.appointment_noteS)), ''), '') = ''
                                 AND ap.APPOINTMENT_STATUS_ID IN(9, 10,11)
                            THEN ap.APPOINTMENT_DATE
                            WHEN(TRY_CONVERT( DATE, ISNULL(NULLIF(LTRIM(RTRIM(ap.appointment_noteS)), ''), '')) IS NULL)
                                AND ap.APPOINTMENT_STATUS_ID IN(9, 10,11)
                            THEN ap.APPOINTMENT_DATE
                            ELSE TRY_CONVERT(DATE, ISNULL(NULLIF(LTRIM(RTRIM(ap.appointment_noteS)), ''), ''))
                        END AS ApptDate, Provider_NPI,provider_name,Practice_Name,Practice_Tin FROM (
    SELECT
                        app.patient_id
				    ,pd.client_patient_id
				   , aps.appointment_status_id
                      , aps.appointment_status_name
                      , app.APPOINTMENT_ID
				  ,app.created_on
                      , app.appointment_date
				  ,  APP.APPOINTMENT_NOTES AS APPOINTMENT_NOTES
                      , app.APPOINTMENT_NOTES AS NOTE
				  ,rtrim(ltrim(pin2.INDEX_VALUE)) as Provider_NPI
				 ,rtrim(ltrim(ppd.PROVIDER_NAME)) as Provider_name
				  ,rtrim(ltrim(ppd.CLINIC_NAME)) as Practice_Name
				  ,rtrim(ltrim(pin.Index_value)) as Practice_Tin
                 FROM ahs_altus_prod.dbo.appointment app
                      INNER JOIN ahs_altus_prod.dbo.appointment_status aps ON app.appointment_status = aps.appointment_status_id
                                                               AND aps.deleted_on IS NULL
                                                               AND aps.is_active = 1
					Inner Join ahs_altus_prod.dbo.APPOINTMENT_PROVIDER_MAPPING as apm on apm.appointment_id=app.appointment_id
			join ahs_altus_prod.dbo.PHYSICIAN_DEMOGRAPHY ppd on ppd.physician_id= apm.provider_id
			inner join ahs_altus_prod.dbo.PROVIDER_INDEX pin on pin.provider_id=apm.Provider_id and pin.index_name='TAX_ID' and pin.is_active=1
			inner join ahs_altus_prod.dbo.PROVIDER_INDEX pin2 on pin2.provider_id=apm.Provider_id and pin2.index_name='NPI' and pin2.IS_ACTIVE=1
			join ahs_altus_prod.dbo.patient_details pd on pd.patient_id = app.patient_id
			                 WHERE app.deleted_on IS NULL
                       AND app.is_active = 1
                      AND aps.appointment_status_name not IN('Third Party Appointment','Requested','Pending','Missed')
				 and pd.CLIENT_PATIENT_ID not in ('ALT26860','ALT40110','ALT40111') ) AS AP
            ) p 

		
union
Select *from (
                 sELECT Appointment_id,CLIENT_PATIENT_ID as Member_id,
			  			  case when APPOINTMENT_STATUS_NAME IN ('Completed','Scheduled','Confirmed','Retro','Rescheduled') then 'Scheduled'
						  Else APPOINTMENT_STATUS_NAME end  as Appt_Status,
			  CREATED_ON as Created_on,
			  CASE
                            WHEN aP.APPOINTMENT_STATUS_ID NOT IN(9, 10,11)
                            THEN ap.APPOINTMENT_DATE
                            WHEN ISNULL(NULLIF(LTRIM(RTRIM(AP.appointment_noteS)), ''), '') = ''
                                 AND ap.APPOINTMENT_STATUS_ID IN(9, 10,11)
                            THEN ap.APPOINTMENT_DATE
                            WHEN(TRY_CONVERT( DATE, ISNULL(NULLIF(LTRIM(RTRIM(ap.appointment_noteS)), ''), '')) IS NULL)
                                AND ap.APPOINTMENT_STATUS_ID IN(9, 10,11)
                            THEN ap.APPOINTMENT_DATE
                            ELSE TRY_CONVERT(DATE, ISNULL(NULLIF(LTRIM(RTRIM(ap.appointment_noteS)), ''), ''))
                        END AS ApptDate, Provider_NPI,provider_name,Practice_Name,Practice_Tin FROM (
    SELECT
                        app.patient_id
				    ,pd.client_patient_id
				   , aal.appointment_status as appointment_status_id
				   ,AAL.AUDIT_ID
				  -- ,AAL.APPOINTMENT_ID as al
                      , aps.appointment_status_name
                      , app.APPOINTMENT_ID
				  ,AAl.created_on
                      , AAL.APPOINTMENT_DATETIME as APPOINTMENT_DATE
				  
                      , aal.APPOINTMENT_NOTE AS appointment_noteS
				  ,rtrim(ltrim(pin2.INDEX_VALUE)) as Provider_NPI
				 ,rtrim(ltrim(ppd.PROVIDER_NAME)) as Provider_name
				  ,rtrim(ltrim(ppd.CLINIC_NAME)) as Practice_Name
				  ,rtrim(ltrim(pin.Index_value)) as Practice_Tin
                 FROM ahs_altus_prod.dbo.appointment app
			  inner JOIN ahs_altus_prod.DBO.APPOINTMENT_AUDIT_LOG AAL ON AAL.APPOINTMENT_ID=APP.APPOINTMENT_ID
												    AND AAL.CREATED_ON=APP.UPDATED_ON
												    --AND AAL.APPOINTMENT_NOTE IS NOT NULL
												    --AND AAL.APPOINTMENT_NOTE <>' '
                      INNER JOIN ahs_altus_prod.dbo.appointment_status aps ON aal.appointment_status = aps.appointment_status_id
                                                               AND aps.deleted_on IS NULL
                                                               AND aps.is_active = 1
				 
					Inner Join ahs_altus_prod.dbo.APPOINTMENT_PROVIDER_MAPPING as apm on apm.appointment_id=app.appointment_id
			join ahs_altus_prod.dbo.PHYSICIAN_DEMOGRAPHY ppd on ppd.physician_id= apm.provider_id
			inner join ahs_altus_prod.dbo.PROVIDER_INDEX pin on pin.provider_id=apm.Provider_id and pin.index_name='TAX_ID' and pin.is_active=1
			inner join ahs_altus_prod.dbo.PROVIDER_INDEX pin2 on pin2.provider_id=apm.Provider_id and pin2.index_name='NPI' and pin2.IS_ACTIVE=1
			join ahs_altus_prod.dbo.patient_details pd on pd.patient_id = app.patient_id
			                 WHERE app.deleted_on IS NULL
                       AND app.is_active = 1
                      AND aps.appointment_status_name not IN('Third Party Appointment','Requested','Pending','Missed')
				 and pd.CLIENT_PATIENT_ID not in ('ALT26860','ALT40110','ALT40111') ) AS AP
            ) p 

		




