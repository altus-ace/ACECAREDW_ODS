


CREATE view [dbo].[vw_TB_PracticeActivities]
as
SELECT 'UHG' as Client_id
	  ,PP.LINE_OF_BUSINESS
	,CONVERT(INT, pp.UHC_SUBSCRIBER_ID) AS SUBSCRIBER_ID,
            pp.MemberName as [Name],
		  pp.Date_of_Birth as [Date of Birth],
		pp.Gender,
		pp.Medicaid_id
      ,pp.[MEMBER_HOME_PHONE]
      ,pp.[MEMBER_MAIL_PHONE]
	,PP.RISK_CATEGORY_C
	,PP.IPRO_ADMIT_RISK_SCORE
	,PP.PRIMARY_RISK_FACTOR
	,PP.LAST_PCP_VISIT
     ,pp.PracticeName,
      CONVERT(INT, pp.PracticeTin) AS PracticeTin,
      pp.PcpNpi,
      pp.PCPLastName,
      pp.POD,
	 pp.a_last_update_date,
      act.id AS ACT_ID,
            act.Activity_type,
		  act.Performed,
            act.Month_year,
            act.Activity_Year,
            act.cnt,
            act.apptcnt
           -- act.progcnt
     FROM
(   SELECT DISTINCT
       P.UHC_SUBSCRIBER_ID,
       concat(LTRIM(RTRIM(p.Member_First_name)), ' ', LTRIM(RTRIM(p.Member_last_name))) AS MEMBERNAME,
       p.Date_of_Birth,
       p.Gender,
       p.Medicaid_id,
       p.[MEMBER_HOME_PHONE],
       p.[MEMBER_MAIL_PHONE],
       P.LINE_OF_BUSINESS,
       P.RISK_CATEGORY_C,
       TRY_CONVERT( NUMERIC(10, 2), P.IPRO_ADMIT_RISK_SCORE) AS IPRO_ADMIT_RISK_SCORE,
       P.PRIMARY_RISK_FACTOR,
       P.LAST_PCP_VISIT,
       P.PCP_PRACTICE_TIN AS PracticeTin,
	  case when P.PCP_PRACTICE_NAME='' then P.PCP_LAST_NAME else P.PCP_PRACTICE_NAME end as PracticeName,
       P.PCP_NPI AS PcpNpi,
       P.PCP_FIRST_NAME AS PCPFirstName,
       P.PCP_LAST_NAME AS PCPLastName,
       P.A_LAST_UPDATE_DATE,
       p.MEMBER_POD_C AS POD,
       TA.[ACCOUNT TYPE] AS PRACTICETYPE,
       TA.NETWORK_CONTACT__c,
       P.AUTO_ASSIGN,
	  TA.[PRIMARY POD] AS PRACTICE_POD,
	 TA.[PRIMARY SPECIALTY],
	  TA.[PROVIDER TYPE],
       TRY_CONVERT( NUMERIC(14, 2), replace(replace(P.TOTAL_COSTS_LAST_12_MOS, '$', ''), ',', '')) AS TOTAL_COSTS_LAST_12_MOS,
       TRY_CONVERT( NUMERIC(5), P.COUNT_OPEN_CARE_OPPS) AS COUNT_OPEN_CARE_OPPS,
       TRY_CONVERT( NUMERIC(14, 2), replace(replace(P.INP_COSTS_LAST_12_MOS, '$', ''), ',', '')) AS INP_COSTS_LAST_12_MOS,
       TRY_CONVERT( NUMERIC(14, 2), replace(replace(P.ER_COSTS_LAST_12_MOS, '$', ''), ',', '')) AS ER_COSTS_LAST_12_MOS,
       TRY_CONVERT( NUMERIC(14, 2), replace(replace(P.OUTP_COSTS_LAST_12_MOS, '$', ''), ',', '')) AS OUTP_COSTS_LAST_12_MOS,
       TRY_CONVERT( NUMERIC(14, 2), replace(replace(P.PHARMACY_COSTS_LAST_12_MOS, '$', ''), ',', '')) AS PHARMACY_COSTS_LAST_12_MOS,
       TRY_CONVERT( NUMERIC(14, 2), replace(replace(P.PRIMARY_CARE_COSTS_LAST_12_MOS, '$', ''), ',', '')) AS PRIMARY_CARE_COSTS_LAST_12_MOS,
       TRY_CONVERT( NUMERIC(14, 2), replace(replace(P.BEHAVIORAL_COSTS_LAST_12_MOS, '$', ''), ',', '')) AS BEHAVIORAL_COSTS_LAST_12_MOS,
       TRY_CONVERT( NUMERIC(14, 2), replace(replace(P.OTHER_OFFICE_COSTS_LAST_12_MOS, '$', ''), ',', '')) AS OTHER_OFFICE_COSTS_LAST_12_MOS,
       TRY_CONVERT( NUMERIC(5), P.INP_ADMITS_LAST_12_MOS) AS INP_ADMITS_LAST_12_MOS
FROM ACECAREDW.DBO.vw_UHC_activeMembers_all P
     LEFT JOIN 
	(SELECT distinct [NPI]
      ,[PROVIDER TYPE]
      ,[LAST NAME]
      ,[FIRST NAME]
      ,[TAX ID]
      ,[PRIMARY SPECIALTY]
      ,[SECONDARY SPECIALTY]
      ,[PRACTICE NAME]
      ,[PRIMARY ADDRESS]
      ,[PRIMARY CITY]
      ,[PRIMARY STATE]
      ,[PRIMARY ZIPCODE]
      ,[PRIMARY POD]
      ,[PRIMARY ADDRESS PHONE#]
      ,[STATUS]
      ,[ACCOUNT TYPE]
      ,[NETWORK_CONTACT__c]
  FROM [ACECAREDW].[dbo].[vw_NetworkRoster]) as TA ON CONVERT(INT, TA.[TAX ID]) = CONVERT(INT, P.PCP_PRACTICE_TIN)
	AND 	 CONVERT(INT, TA.[NPI])=CONVERT(INT, P.PCP_NPI) 
	 
     JOIN
(
    SELECT aaa.[LOAD_KEY],
           aaa.[LOAD_DATE]
    FROM
(
    SELECT aa.[LOAD_KEY],
           aa.[LOAD_DATE],
           ROW_NUMBER() OVER(PARTITION BY MONTH(load_date),
                                          YEAR(load_date) ORDER BY load_date ASC) AS rank
    FROM [ACECAREDW].[ast].[A_vw_UHC_Get_MemberLoadDates] AS aa
) AS aaa
    WHERE aaa.rank = 1
) AS b ON p.a_last_update_date = b.load_date
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
) AS p


) AS ACT ON ACT.MEMBER_ID = Pp.UHC_SUBSCRIBER_ID AND month( ACT.PERFORMED)=month (pp.A_LAST_UPDATE_DATE) and year(act.performed)=year(pp.A_LAST_UPDATE_DATE)


