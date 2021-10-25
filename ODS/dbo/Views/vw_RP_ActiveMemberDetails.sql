

 
 CREATE VIEW [dbo].[vw_RP_ActiveMemberDetails]
 as
 SELECT DISTINCT
           CLIENT_PATIENT_ID AS MEMBER_ID,
		 LOB_NAME AS CLIENT,
		 MEMBER_NAME,
		 RISK_SCORE,
		enrolled as MAY_PROG_ENROLLED,
		progenrolled6months as PROG_ENROLLED_6MONTHS,
           [1-2018],
           [2-2018],
           [3-2018],
           [4-2018],
           [5-2018],
           [6-2018],
           [7-2018]
    FROM
(
    SELECT DISTINCT
           pd.client_patient_id,
		 L.LOB_NAME,
           pd.PATIENT_ID,
         CONCAT( pd.FIRST_NAME,' ',pd.LAST_NAME) AS MEMBER_NAME,
           a.ACTIVITY_PERFORMED_MONTH,
           a.id,
           PR.RISK_SCORE,
           CASE
               WHEN prog.CLIENT_PATIENT_ID IS NOT NULL
               THEN 1
               ELSE 0
           END AS enrolled,
		  CASE
               WHEN prog1.CLIENT_PATIENT_ID is not NULL
               THEN 1
               ELSE 0
           END AS progenrolled6months
    FROM [Ahs_Altus_Prod].[dbo].[MEM_BENF_PLAN] mbp
    INNER JOIN [Ahs_Altus_Prod].[dbo].LOB_BENF_PLAN LP ON LP.LOB_BEN_ID=MBP.LOB_BEN_ID
    INNER JOIN [Ahs_Altus_Prod].[dbo].LOB L ON L.LOB_ID=LP.LOB_ID
         INNER JOIN [Ahs_Altus_Prod].[dbo].PATIENT_DETAILS pd ON mbp.member_id = pd.patient_id
                                                                 AND mbp.end_date = '2099-12-31'
         LEFT JOIN [Ahs_Altus_Prod].[dbo].vw_ACE_ALT_PE prog ON prog.CLIENT_PATIENT_ID = pd.CLIENT_PATIENT_ID
                                         AND MONTH(prog.START_DATE) = 5
                                         AND YEAR(prog.start_date) = 2018
	   LEFT JOIN [Ahs_Altus_Prod].[dbo].[PATIENT_RISK] pr on pr.patient_id=MBP.MEMBER_ID and pr.Risk_type_id=10 and year(pr.updated_on)=2018 AND mbp.end_date = '2099-12-31'
	   LEFT JOIN [Ahs_Altus_Prod].[dbo].vw_ACE_ALT_PE prog1 ON prog1.CLIENT_PATIENT_ID = pd.CLIENT_PATIENT_ID
                                         AND MONTH(prog1.START_DATE) between 1 and 5
                                         AND YEAR(prog1.start_date) = 2018
         LEFT JOIN
(
    SELECT DISTINCT
           pf.PATIENT_ID,
           pf.patient_followup_id AS ID,
           CONVERT(DATE, pf.performed_date, 101) AS PERFORMED,
           concat(MONTH(Pf.performed_date), '-', YEAR(pf.performed_date)) AS ACTIVITY_PERFORMED_MONTH,
           cat.care_activity_type_name AS ACTIVITY_TYPE
    FROM [Ahs_Altus_Prod].[dbo].patient_followup AS pf
         INNER JOIN [Ahs_Altus_Prod].[dbo].care_activity_type AS cat ON pf.care_activity_type_id = cat.care_activity_type_id
                                                     AND cat.deleted_on IS NULL
                                                     AND cat.is_active = 1
         LEFT JOIN [Ahs_Altus_Prod].[dbo].scpt_admin_script sas ON sas.Script_id = pf.script_id
         LEFT JOIN [Ahs_Altus_Prod].[dbo].venue v ON v.venue_id = pf.venue_id
         LEFT OUTER JOIN [Ahs_Altus_Prod].[dbo].activity_outcome AS ao ON pf.activity_outcome_id = ao.activity_outcome_id
                                                       AND ao.deleted_on IS NULL
                                                       AND ao.is_active = 1
         INNER JOIN [Ahs_Altus_Prod].[dbo].[MEM_BENF_PLAN] mbp1 ON mbp1.MEMBER_ID = pf.PATIENT_ID
                                                                   AND mbp1.END_DATE = '12-31-2099'
    WHERE pf.performed_Date IS NOT NULL
          AND pf.performed_date >= '01/01/2018'
          AND cat.CARE_ACTIVITY_TYPE_NAME NOT IN('Scheduled Appointemnt', '1', 'Appointment Reminder', 'Case Conference', 'Case Management-Follow Up', 'LexisNexis', 'Review Care Plan', 'Schedule Appointment')-- and pd.CLIENT_PATIENT_ID not like 'ALT%' 
) AS a ON a.patient_id = mbp.MEMBER_ID
    WHERE mbp.end_date = '12-31-2099'
    
     --and pd.CLIENT_PATIENT_ID='115872403'
  
) AS p PIVOT(COUNT(ID) FOR p.Activity_performed_month IN([1-2018],
                                                         [2-2018],
                                                         [3-2018],
                                                         [4-2018],
                                                         [5-2018],
                                                         [6-2018],
                                                         [7-2018])) pvt

