
CREATE VIEW [dbo].[vw_AH_Mpluse_Appointments]
AS
    /* VERSION HISTORY
	   2/25/2021: GK added a filter to only get last 90 days of appointments (on appointment created date)
	   */
/*      SELECT *
     FROM
     (SELECT * FROM dbo.[tmp_Ahs_PatientAppointments] 
    */

     SELECT Appointment_id, 
            CLIENT_PATIENT_ID AS Member_id, 
            APPOINTMENT_STATUS_NAME AS Appt_Status, 
            CREATED_ON AS Created_on,
            CASE
                WHEN aP.APPOINTMENT_STATUS_ID NOT IN(9, 10, 11)
                THEN ap.APPOINTMENT_DATE
                WHEN ISNULL(NULLIF(LTRIM(RTRIM(AP.appointment_noteS)), ''), '') = ''
                     AND ap.APPOINTMENT_STATUS_ID IN(9, 10, 11)
                THEN ap.APPOINTMENT_DATE
                WHEN(TRY_CONVERT( DATE, ISNULL(NULLIF(LTRIM(RTRIM(ap.appointment_noteS)), ''), '')) IS NULL)
                    AND ap.APPOINTMENT_STATUS_ID IN(9, 10, 11)
                THEN ap.APPOINTMENT_DATE
                ELSE TRY_CONVERT(DATE, ISNULL(NULLIF(LTRIM(RTRIM(ap.appointment_noteS)), ''), ''))
            END AS ApptDate, 
            Provider_NPI, 
            provider_name, 
            Practice_Name, 
            Practice_Tin
     FROM
     (
         SELECT app.patient_id, 
                pd.client_patient_id, 
                aps.appointment_status_id, 
                aps.appointment_status_name, 
                app.APPOINTMENT_ID, 
                app.created_on, 
                app.appointment_date,
                CASE
                    WHEN AAL.CREATED_ON = APP.UPDATED_ON
                    THEN AAL.APPOINTMENT_NOTE
                    ELSE APP.APPOINTMENT_NOTES
                END AS APPOINTMENT_NOTES, 
                app.APPOINTMENT_NOTES AS NOTE, 
                RTRIM(LTRIM(pin2.INDEX_VALUE)) AS Provider_NPI, 
                RTRIM(LTRIM(ppd.PROVIDER_NAME)) AS Provider_name, 
                RTRIM(LTRIM(ppd.CLINIC_NAME)) AS Practice_Name,
                CASE
                    WHEN RTRIM(LTRIM(pin.Index_value)) = '43751219'
                    THEN '043751219'
                    ELSE RTRIM(LTRIM(pin.Index_value))
                END AS Practice_Tin
         FROM ahs_altus_prod.dbo.appointment app
              INNER JOIN ahs_altus_prod.dbo.appointment_status aps ON app.appointment_status = aps.appointment_status_id
                                                                      AND aps.deleted_on IS NULL
                                                                      AND aps.is_active = 1
              LEFT JOIN ahs_altus_prod.DBO.APPOINTMENT_AUDIT_LOG AAL ON AAL.APPOINTMENT_ID = APP.APPOINTMENT_ID
                                                                        AND AAL.CREATED_ON = APP.UPDATED_ON
                                                                        AND AAL.APPOINTMENT_NOTE IS NOT NULL
                                                                        AND AAL.APPOINTMENT_NOTE <> ' '
              INNER JOIN ahs_altus_prod.dbo.APPOINTMENT_PROVIDER_MAPPING AS apm ON apm.appointment_id = app.appointment_id
              JOIN ahs_altus_prod.dbo.PHYSICIAN_DEMOGRAPHY ppd ON ppd.physician_id = apm.provider_id
              INNER JOIN ahs_altus_prod.dbo.PROVIDER_INDEX pin ON pin.provider_id = apm.Provider_id
                                                                  AND pin.index_name = 'TAX_ID'
                                                                  AND pin.is_active = 1
              INNER JOIN ahs_altus_prod.dbo.PROVIDER_INDEX pin2 ON pin2.provider_id = apm.Provider_id
                                                                   AND pin2.index_name = 'NPI'
                                                                   AND pin2.IS_ACTIVE = 1
              JOIN ahs_altus_prod.dbo.patient_details pd ON pd.patient_id = app.patient_id
         WHERE app.deleted_on IS NULL
               AND app.is_active = 1
               AND aps.appointment_status_name IN('Scheduled', 'Confirmed', 'Completed', 'Retro', 'Appointment Update', 'Third Party Appointment', 'ReScheduled')
              AND pd.CLIENT_PATIENT_ID NOT IN('ALT26860', 'ALT40110', 'ALT40111')
		    AND app.CREATED_ON > DATEADD(day, -90, GETDATE())  -- ONLY GET THE LAST 90 days of records 
     ) AS AP

	 /** Business has stopped setting up appointments at St. Joseph's and we are commenting this part of the code out **/

     --UNION
     --SELECT APP.APPOINTMENT_ID, 
     --       PD.CLIENT_PATIENT_ID AS Member_id, 
     --       APS.APPOINTMENT_STATUS_NAME AS Appt_Status, 
     --       APP.CREATED_ON, 
     --       APP.APPOINTMENT_DATE AS ApptDate, 
     --       PDM.PROVIDER_TYPE_ID, 
     --       PDM.PROVIDER_NAME, 
     --       PDM.CLINIC_NAME AS PRACTICE_NAME, 
     --       PDM.HOSPITAL_NPI_NUMBER
     --FROM ahs_altus_prod.dbo.appointment APP
     --     JOIN Ahs_Altus_Prod.DBO.PATIENT_DETAILS PD ON PD.PATIENT_ID = APP.PATIENT_ID
     --     INNER JOIN ahs_altus_prod.dbo.appointment_status aps ON app.appointment_status = aps.appointment_status_id
     --                                                             AND aps.deleted_on IS NULL
     --                                                             AND aps.is_active = 1
     --     LEFT JOIN [Ahs_Altus_Prod].DBO.[APPOINTMENT_PROVIDER_MAPPING] APM ON APM.APPOINTMENT_ID = APP.APPOINTMENT_ID
     --     LEFT JOIN ahs_altus_prod.dbo.PHYSICIAN_DEMOGRAPHY PDM ON PDM.PHYSICIAN_ID = APM.PROVIDER_ID
     --WHERE APPOINTMENT_DATE >= GETDATE()
     --      AND pdm.PROVIDER_NAME = 'St. Joseph';

--    ) p;
