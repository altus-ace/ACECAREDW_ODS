
CREATE VIEW [dbo].[vw_TB_PracticeActivities_01]
AS
     SELECT 'UHG' as Client_id,
	pp.Product_code as LOB,
	CONVERT(INT, pp.UHC_SUBSCRIBER_ID) AS SubscriberId,
            pp.MemberName as [Name],
		  pp.Date_of_Birth as [Date of Birth],
		pp.Gender,
		pp.Medicaid_id
      ,pp.[MEMBER_HOME_PHONE]
      ,pp.[MEMBER_MAIL_PHONE]
	 ,pp.[RESP_LAST_NAME]
      ,pp.[RESP_FIRST_NAME]
      ,pp.[RESP_ADDRESS]
      ,pp.[RESP_ADDRESS2]
      ,pp.[RESP_CITY]
      ,pp.[RESP_STATE]
      ,pp.[RESP_ZIP]
      ,pp.[RESP_PHONE]
            ,pp.PracticeName,
            CONVERT(INT, pp.PracticeTin) AS PracticeTin,
            pp.PcpNpi,
            pp.PCPLastName,
            pp.POD,
            act.id AS ACT_ID,
            act.Activity_type,
		  act.Performed,
            act.Month_year,
            act.Activity_Year,
            act.cnt,
            act.apptcnt
           -- act.progcnt
     FROM
(
    SELECT DISTINCT
           P.UHC_SUBSCRIBER_ID,
           concat(p.Member_First_name, ' ', p.Member_last_name) AS MemberName,
		p.Date_of_Birth,
		p.Gender,
		p.Medicaid_id,
		p.[MEMBER_HOME_ADDRESS]
      ,p.[MEMBER_HOME_ADDRESS2]
      ,p.[MEMBER_HOME_CITY]
      ,p.[MEMBER_HOME_STATE]
      ,p.[MEMBER_HOME_ZIP]
      ,p.[MEMBER_HOME_PHONE]
      ,p.[MEMBER_MAIL_ADDRESS]
      ,p.[MEMBER_MAIL_ADDRESS2]
      ,p.[MEMBER_MAIL_CITY]
      ,p.[MEMBER_MAIL_STATE]
      ,p.[MEMBER_MAIL_ZIP]
      ,p.[MEMBER_MAIL_PHONE]
	 ,p.[RESP_LAST_NAME]
      ,p.[RESP_FIRST_NAME]
      ,p.[RESP_ADDRESS]
      ,p.[RESP_ADDRESS2]
      ,p.[RESP_CITY]
      ,p.[RESP_STATE]
      ,p.[RESP_ZIP]
      ,p.[RESP_PHONE]
		,p.Product_code
          , CASE
               WHEN TA.NAME IS NULL
               THEN PCP_PRACTICE_NAME
               ELSE ta.name
           END AS PracticeName,
           P.PCP_PRACTICE_TIN AS PracticeTin,
           P.PCP_NPI AS PcpNpi,
           P.PCP_FIRST_NAME AS PCPFirstName,
           P.PCP_LAST_NAME AS PCPLastName,
           P.A_LAST_UPDATE_DATE,
           z.Quadrant__c AS POD,
           ROW_NUMBER() OVER(PARTITION BY P.UHC_SUBSCRIBER_ID ORDER BY P.A_LAST_UPDATE_DATE DESC) AS arn
    FROM ACECAREDW.DBO.UHC_membersbypcp P
  
         LEFT JOIN ACECAREDW.DBO.tmpSalesforce_Account TA ON CONVERT(INT, TA.[Tax_ID_Number__c]) = CONVERT(INT, P.PCP_PRACTICE_TIN)
         INNER JOIN ACECAREDW.dbo.tmpSalesforce_Account_Locations__c tlc ON tlc.Account_Name__c = TA.id
         INNER JOIN ACECAREDW.dbo.tmpSalesforce_Zip_Code__c z ON z.Id = tlc.Zip_Code__c
) AS pp
LEFT JOIN
(
    SELECT CLIENT_PATIENT_ID AS MEMBER_ID,
           id,
           Activity_type,
		 Performed,
           Month_Year,
           Activity_year,
           cnt,
           apptcnt,
           progcnt
    FROM
(
    SELECT DISTINCT
           pd.CLIENT_PATIENT_ID,
           pf.PATIENT_ID,
           concat('pf', CONVERT(VARCHAR, pf.patient_followup_id)) AS ID,
           CONVERT(DATE, pf.performed_date, 101) AS PERFORMED,
           concat(datename(Month, (Pf.performed_date)), ' ', CONVERT(VARCHAR, YEAR(pf.performed_date))) AS MONTH_YEAR,
           YEAR(pf.performed_date) AS Activity_year
           ,
--,case when sas.script_name is not null then sas.script_name else cat.care_activity_type_name end as 'Activity_type',
           CASE
               WHEN cat.care_activity_type_name IN('10CALL', '1CALL', '2CALL', '3CALL', '4CALL', '5CALL', '6CALL', '7CALL', '8CALL', '9CALL', 'I-CALL', 'NMC', 'RCALL')
               THEN 'CALLS'
               WHEN sas.SCRIPT_NAME IN('Health Risk Screening', 'Postpartum Screening', 'Prenatal Screening', 'Diabetic Script')
               THEN 'Screening'
               WHEN cat.CARE_ACTIVITY_TYPE_NAME IN('Assessment', 'TOC')
                    AND sas.SCRIPT_NAME IS NULL
               THEN 'Non Assessment'
               WHEN CAT.CARE_ACTIVITY_TYPE_NAME IN('TOC')
               THEN LTRIM(RTRIM(SAS.SCRIPT_NAME))
               ELSE LTRIM(RTRIM(cat.CARE_ACTIVITY_TYPE_NAME))
           END AS ACTIVITY_TYPE,
           1 AS cnt,
           0 AS apptcnt,
           0 AS Progcnt
    FROM AHS_ALTUS_PROD.dbo.patient_followup AS pf
         INNER JOIN AHS_ALTUS_PROD.dbo.care_activity_type AS cat ON pf.care_activity_type_id = cat.care_activity_type_id
                                                                    AND cat.deleted_on IS NULL
                                                                    AND cat.is_active = 1
         LEFT JOIN AHS_ALTUS_PROD.dbo.scpt_admin_script sas ON sas.Script_id = pf.script_id
         LEFT JOIN AHS_ALTUS_PROD.DBO.venue v ON v.venue_id = pf.venue_id
         LEFT OUTER JOIN AHS_ALTUS_PROD.dbo.activity_outcome AS ao ON pf.activity_outcome_id = ao.activity_outcome_id
                                                                      AND ao.deleted_on IS NULL
                                                                      AND ao.is_active = 1
         INNER JOIN AHS_ALTUS_PROD.DBO.patient_details pd ON pd.patient_id = pf.patient_id
    WHERE pf.performed_Date IS NOT NULL
          AND pd.CLIENT_PATIENT_ID NOT IN('ALT26860', 'ALT40110', 'ALT40111')
    UNION
    SELECT DISTINCT
           pd.client_patient_id,
           pf.PATIENT_ID,
           concat('Bh', CONVERT(VARCHAR, pf.PATIENT_FOLLOWUP_ID)) AS ID,
           CONVERT(DATE, pf.performed_date, 101) AS PERFORMED,
           concat(datename(Month, (Pf.performed_date)), ' ', CONVERT(VARCHAR, YEAR(pf.performed_date))) AS MONTH_YEAR,
           YEAR(pf.performed_date) AS Activity_year,
           CASE
               WHEN v.Venue_name IN('BH Referral Deblin', 'BH Referral NP Care Services Group')
               THEN 'BH Referral'
               ELSE NULL
           END AS ACTIVITY_TYPE,
           1 AS cnt,
           0 AS apptcnt,
           0 AS Progcnt
    FROM AHS_ALTUS_PROD.dbo.patient_followup AS pf
         INNER JOIN AHS_ALTUS_PROD.dbo.care_activity_type AS cat ON pf.care_activity_type_id = cat.care_activity_type_id
                                                                    AND cat.deleted_on IS NULL
                                                                    AND cat.is_active = 1
         LEFT JOIN AHS_ALTUS_PROD.dbo.scpt_admin_script sas ON sas.Script_id = pf.script_id
         LEFT JOIN AHS_ALTUS_PROD.DBO.venue v ON v.venue_id = pf.venue_id
         LEFT OUTER JOIN AHS_ALTUS_PROD.dbo.activity_outcome AS ao ON pf.activity_outcome_id = ao.activity_outcome_id
                                                                      AND ao.deleted_on IS NULL
                                                                      AND ao.is_active = 1
         INNER JOIN AHS_ALTUS_PROD.DBO.patient_details pd ON pd.patient_id = pf.patient_id
    WHERE pf.performed_Date IS NOT NULL
          AND v.Venue_name IN('BH Referral Deblin', 'BH Referral NP Care Services Group')
         AND pd.CLIENT_PATIENT_ID NOT IN('ALT26860', 'ALT40110', 'ALT40111')-- and pd.PATIENT_ID='143
    UNION
    SELECT apps.client_patient_id,
           apps.Patient_id AS PATIENT_ID,
           concat('apt', CONVERT(VARCHAR, APPOINTMENT_ID)) AS ID,
           CONVERT(DATE, apps.created_on, 101) AS performed,
           CONCAT(datename(Month, (apps.created_on)), ' ', CONVERT(VARCHAR, YEAR(apps.created_on))) AS month_year,
           YEAR(apps.created_on) AS Activity_year,
           CASE
               WHEN apps.APPOINTMENT_ID IS NOT NULL
               THEN 'Appointments'
           END AS ACTIVITY_type,
           1 AS CNT,
           1 AS apptcnt,
           0 AS progcnt
    FROM
(
    SELECT *,
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
           END AS AppDate
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
           app.CREATED_BY,
           app.APPOINTMENT_NOTES AS NOTE,
           ppd.PROVIDER_NAME AS Appointment_provider,
           ppd.CLINIC_NAME AS Appointment_Practice_Name,
           (LTRIM(RTRIM(csd3.FIRST_NAME))+' '+LTRIM(RTRIM(csd3.LAST_NAME))) AS Appt_SCH_by
    FROM AHS_ALTUS_PROD.dbo.appointment app
         INNER JOIN AHS_ALTUS_PROD.dbo.appointment_status aps ON app.appointment_status = aps.appointment_status_id
                                                                 AND aps.deleted_on IS NULL
                                                                 AND aps.is_active = 1
         LEFT JOIN AHS_ALTUS_PROD.DBO.APPOINTMENT_AUDIT_LOG AAL ON AAL.APPOINTMENT_ID = APP.APPOINTMENT_ID
                                                                   AND AAL.CREATED_ON = APP.UPDATED_ON
                                                                   AND AAL.APPOINTMENT_NOTE IS NOT NULL
                                                                   AND AAL.APPOINTMENT_NOTE <> ' '
         INNER JOIN AHS_ALTUS_PROD.dbo.CARE_STAFF_DETAILS AS csd3 ON csd3.MEMBER_ID = app.CREATED_BY
         INNER JOIN AHS_ALTUS_PROD.dbo.APPOINTMENT_PROVIDER_MAPPING AS apm ON apm.appointment_id = app.appointment_id
         JOIN AHS_ALTUS_PROD.DBO.PHYSICIAN_DEMOGRAPHY ppd ON ppd.physician_id = apm.provider_id
         JOIN AHS_ALTUS_PROD.DBO.patient_details pd ON pd.patient_id = app.patient_id
    WHERE app.deleted_on IS NULL
          AND app.is_active = 1
          AND aps.appointment_status_name IN('Scheduled', 'Confirmed', 'Completed', 'Retro', 'Appointment Update', 'Third Party Appointment')
         AND pd.CLIENT_PATIENT_ID NOT IN('ALT26860', 'ALT40110', 'ALT40111')
) AS AP
) AS apps --where apps.PATIENT_ID='14318'
/*    UNION
  SELECT DISTINCT
           pd.CLIENT_PATIENT_ID,
           pd.PATIENT_ID,
           concat('prog', CONVERT(VARCHAR, mbpr.mem_benf_prog_id)) AS ID,
           mbpr.START_DATE AS PERFORMED,
           concat(datename(month, mbpr.START_DATE), ' ', CONVERT(VARCHAR, YEAR(mbpr.START_DATE))) AS Month_Year,
           YEAR(mbpr.START_DATE) AS Activity_year
           ,
			--,bpr.PROGRAM_NAME as Activity_Type
           CASE
               WHEN bpr.PROGRAM_NAME IN('Transitions of Care- Inpatient', 'Transitions of Care- Inpatient-2')
               THEN 'Transitions of Care- Inpatient'
               WHEN bpr.PROGRAM_NAME IN('Transitions of Care-Emergency Room', 'Transitions of Care-Emergency Room-2')
               THEN 'Transitions of Care-Emergency Room'
               WHEN bpr.PROGRAM_NAME IN('Transitions of Care-Mental Health', 'Transitions of Care-Mental Health-2')
               THEN 'Transitions of Care-Mental Health'
               WHEN bpr.PROGRAM_NAME IN('High-Well Child visit 3rd-6th years')
               THEN 'C-Well Child visit 3rd-6th years'
               WHEN bpr.PROGRAM_NAME IN('Med-Well Child visit 3rd-6th years')
               THEN 'C-Well Child visit 3rd-6th years'
               WHEN bpr.PROGRAM_NAME IN('High-Adolescent Well Care visits')
               THEN 'C-Adolescent Well Care visits'
               WHEN bpr.PROGRAM_NAME IN('Med-Adolescent Well Care visits')
               THEN 'C-Adolescent Well Care visits'
               WHEN bpr.PROGRAM_NAME IN('Hard to Reach-CC')
               THEN 'HardtoReach'
               WHEN bpr.PROGRAM_NAME IN('Hard to Reach-ICT')
               THEN 'HardToReach'
               ELSE bpr.PROGRAM_NAME
           END AS Activity_Type,
           1 AS cnt,
           0 AS apptcnt,
           1 AS progcnt
    FROM Ahs_Altus_Prod.dbo.MEM_BENF_PLAN AS mbp
         INNER JOIN Ahs_Altus_Prod.dbo.LOB_BENF_PLAN AS lbp ON mbp.LOB_BEN_ID = lbp.LOB_BEN_ID
         INNER JOIN Ahs_Altus_Prod.dbo.BENEFIT_PLAN AS bpl ON lbp.BENEFIT_PLAN_ID = bpl.BENEFIT_PLAN_ID
         LEFT OUTER JOIN Ahs_Altus_Prod.dbo.MEM_BENF_PROG AS mbpr ON mbp.MEMBER_ID = mbpr.MEMBER_ID
         LEFT OUTER JOIN Ahs_Altus_Prod.dbo.BENF_PLAN_PROG AS bpp ON mbpr.BEN_PLAN_PROG_ID = bpp.BEN_PLAN_PROG_ID
         LEFT OUTER JOIN Ahs_Altus_Prod.dbo.BENEFIT_PROGRAM AS bpr ON bpp.BENEFIT_PROGRAM_ID = bpr.BENEFIT_PROGRAM_ID
         INNER JOIN Ahs_Altus_Prod.dbo.PATIENT_DETAILS AS pd ON mbp.MEMBER_ID = pd.PATIENT_ID
                                                                AND pd.DELETED_ON IS NULL
         INNER JOIN Ahs_Altus_Prod.dbo.PROGRAM_STATUS AS ps ON mbpr.PROGRAM_STATUS_ID = ps.PROGRAM_STATUS_ID
                                                               AND ps.DELETED_ON IS NULL
                                                               AND ps.IS_ACTIVE = 1
    WHERE(mbp.DELETED_ON IS NULL
          AND mbpr.deleted_on IS NULL
		   
/*Deleted the duplicate programs so need to add this condition to eliminate wrong program( Enrollment) 28*/
 
          AND PS.PROGRAM_STATUS_NAME <> 'ERROR'
          AND pd.CLIENT_PATIENT_ID NOT IN('ALT26860', 'ALT40110', 'ALT40111'))*/
) AS p

--Group by P.CLIENT_PATIENT_ID,p.Activity_year

) AS ACT ON ACT.MEMBER_ID = Pp.UHC_SUBSCRIBER_ID
     WHERE Pp.arn = 1; --and pp.UHC_SUBSCRIBER_ID='100416601'








