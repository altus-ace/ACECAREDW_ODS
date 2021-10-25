CREATE FUNCTION [dbo].[tvf_ACE_RP_Active_PracticeActivityStats]
(@reportPeriodStartDate DATE, 
 @reportPeriodStopDate  DATE, 
 @name                  VARCHAR(MAX)
)
RETURNS TABLE
AS
     RETURN
(
    SELECT DISTINCT 
           LTRIM(RTRIM(PracticeName)) AS PracticeName, 
           PracticeTin, 
           COUNT(DISTINCT UHC_SUBSCRIBER_ID) AS TotalMembers, 
           COUNT(DISTINCT client_patient_id) AS TotalMembersTouchedforActivites, 
           SUM([CALLS]) AS [#Calls], 
           SUM([Assessment]) AS [Assessment], 
           SUM([BH Referral]) AS [BH Referral], 
           SUM([ER Assessment]) AS [ER Assessment], 
           SUM([Follow Up]) AS [Follow Up], 
           SUM([Health Risk Assessment]) AS [Health Risk Assessment], 
           SUM([Health Risk Screening]) AS [Health Risk Screening], 
           SUM([Inpatient Post Discharge]) AS [Inpatient Post Discharge], 
           SUM([MDB]) AS [MDB], 
           SUM([Member Mailing]) AS [Member Mailing], 
           SUM([Member Outreach]) AS [Member Outreach], 
           SUM([Mental Health Inpatient Discharge]) AS [Mental Health Inpatient Discharge], 
           SUM([Non Assessment]) AS [Non Assessment], 
           SUM([Post Discharge Follow Up]) AS [Post Discharge Follow Up], 
           SUM([Psychosocial Issues]) AS [Psychosocial Issues], 
           SUM([Re-Pod]) AS [Re-Pod], 
           SUM([Schedule Appointment]) AS [Schedule Appointment], 
           SUM([Screening]) AS [Screening], 
           SUM([Transportation]) AS [Transportation]
    FROM
    (
        SELECT DISTINCT 
               P.UHC_SUBSCRIBER_ID,
               CASE
                   WHEN P.PCP_PRACTICE_TIN = '752894111'
                   THEN 'Topcare Medical Group Inc'
                   WHEN P.PCP_PRACTICE_TIN = '300491632'
                   THEN 'Topcare Medical Group Inc'
                   ELSE TA.Name
               END AS PracticeName, 
               P.PCP_PRACTICE_TIN AS PracticeTin, 
               P.PCP_NPI, 
               P.PCP_FIRST_NAME, 
               P.PCP_LAST_NAME, 
               r.Client_patient_id, 
               r.Patient_id, 
               r.Performed, 
               r.ACTIVITY_PERFORMED_MONTH, 
               r.ACTIVITY_PERFORMED_YEAR, 
               r.[CALLS], 
               r.[Assessment], 
               r.[BH Referral], 
               r.[ER Assessment], 
               r.[Follow Up], 
               r.[Health Risk Assessment], 
               r.[Health Risk Screening], 
               r.[Inpatient Post Discharge], 
               r.[MDB], 
               r.[Member Mailing], 
               r.[Member Outreach], 
               r.[Mental Health Inpatient Discharge], 
               r.[Non Assessment], 
               r.[Post Discharge Follow Up], 
               r.[Psychosocial Issues], 
               r.[Re-Pod], 
               r.[Schedule Appointment], 
               r.[Screening], 
               r.[Transportation]
        FROM ACECAREDW.DBO.vw_UHC_activeMembers P
             LEFT JOIN ACECAREDW.DBO.tmpSalesforce_Account TA ON CONVERT(INT, TA.[Tax_ID_Number__c]) = CONVERT(INT, P.PCP_PRACTICE_TIN)
             LEFT JOIN
        (
            SELECT DISTINCT 
                   Client_patient_id, 
                   Patient_id, 
                   Performed, 
                   ACTIVITY_PERFORMED_MONTH, 
                   ACTIVITY_PERFORMED_YEAR, 
                   [CALLS], 
                   [Assessment], 
                   [BH Referral], 
                   [ER Assessment], 
                   [Follow Up], 
                   [Health Risk Assessment], 
                   [Health Risk Screening], 
                   [Inpatient Post Discharge], 
                   [MDB], 
                   [Member Mailing], 
                   [Member Outreach], 
                   [Mental Health Inpatient Discharge], 
                   [Non Assessment], 
                   [Post Discharge Follow Up], 
                   [Psychosocial Issues], 
                   [Re-Pod], 
                   [Schedule Appointment], 
                   [Screening], 
                   [Transportation]
            FROM ahs_altus_prod.dbo.[vw_ACE_RP_PivotActivity]
            WHERE performed BETWEEN @reportPeriodStartDate AND @reportPeriodStopDate
        ) AS r ON r.Client_patient_id = p.UHC_SUBSCRIBER_ID
        --where TA.NAME=@name

    ) AS t
   WHERE t.PracticeName = @name
    GROUP BY t.PracticeName, 
             t.PracticeTIN
);
