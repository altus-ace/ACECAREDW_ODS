CREATE VIEW dbo.vw_AHR_EFFECTIVE1
AS 

SELECT 
	   [Context]
      ,[TIN_Num]
      ,[TIN_Name]
      ,[Measure_Desc]
      ,[MemberID]
      ,[UniversalMemberId]
      ,[MedicaidID]
      ,[Gender]
      ,[Provider_NPI]
      ,Latest_Shown_on_CareOPP
	  ,CLIENT_PATIENT_ID
	  ,Latest_AppDate
	  ,CASE WHEN CLIENT_PATIENT_ID IS NULL THEN 0
			WHEN Latest_Shown_on_CareOPP < DATEADD(D,90,Latest_AppDate) THEN 1
			WHEN (Latest_Shown_on_CareOPP > DATEADD(D,90,Latest_AppDate) 
					AND Latest_Shown_on_CareOPP <> (SELECT MAX([A_LAST_UPDATE_DATE]) FROM [ACECAREDW].[dbo].[UHC_CareOpps])) THEN 2
			WHEN Latest_Shown_on_CareOPP = (SELECT MAX([A_LAST_UPDATE_DATE]) FROM [ACECAREDW].[dbo].[UHC_CareOpps]) THEN 0
			ELSE '' END AS GAP_CLOSE_TAG
FROM 
(
SELECT DISTINCT
      [Context]
      ,[TIN_Num]
      ,[TIN_Name]
      ,[Measure_Desc]
      ,[MemberID]
      ,[UniversalMemberId]
      ,[MedicaidID]
      ,[Gender]
      ,[Provider_NPI]
      ,MAX(CONVERT(VARCHAR(11),[A_LAST_UPDATE_DATE])) AS Latest_Shown_on_CareOPP
	  ,B.CLIENT_PATIENT_ID
	  ,MAX(B.AppDate) AS Latest_AppDate
  FROM [ACECAREDW].[dbo].[UHC_CareOpps]  CO
   --(SELECT * FROM [ACECAREDW].[dbo].[UHC_CareOpps]   where TIN_Num IN ('202319157','262617385'))
 LEFT JOIN (
  SELECT DISTINCT 
CLIENT_PATIENT_ID
,AppDate
 FROM (
 SELECT *,CASE
                            WHEN aP.APPOINTMENT_STATUS_ID NOT IN(9, 10,11)
                            THEN ap.APPOINTMENT_DATE
                            WHEN ISNULL(NULLIF(LTRIM(RTRIM(AP.appointment_noteS)), ''), '') = ''
                                 AND ap.APPOINTMENT_STATUS_ID IN(9, 10,11)
                            THEN ap.APPOINTMENT_DATE
                            WHEN(TRY_CONVERT( DATE, ISNULL(NULLIF(LTRIM(RTRIM(ap.appointment_noteS)), ''), '')) IS NULL)
                                AND ap.APPOINTMENT_STATUS_ID IN(9, 10,11)
                            THEN ap.APPOINTMENT_DATE
                            ELSE TRY_CONVERT(DATE, ISNULL(NULLIF(LTRIM(RTRIM(ap.appointment_noteS)), ''), ''))
                        END AS AppDate
FROM (SELECT
app.patient_id
,pd.client_patient_id
,aps.appointment_status_id
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
FROM (SELECT * FROM AHS_ALTUS_PROD.dbo.appointment WHERE deleted_on IS NULL AND is_active = 1) app
INNER JOIN AHS_ALTUS_PROD.dbo.appointment_status aps ON app.appointment_status = aps.appointment_status_id
                                                               AND aps.deleted_on IS NULL
                                                               AND aps.is_active = 1
                       AND aps.appointment_status_name IN('Scheduled', 'Confirmed', 'Completed', 'Retro', 'Appointment Update','Third Party Appointment')
LEFT JOIN AHS_ALTUS_PROD.DBO.APPOINTMENT_AUDIT_LOG AAL ON AAL.APPOINTMENT_ID=APP.APPOINTMENT_ID
												    AND AAL.CREATED_ON=APP.UPDATED_ON
												    AND AAL.APPOINTMENT_NOTE IS NOT NULL
												    AND AAL.APPOINTMENT_NOTE <>' '
INNER JOIN AHS_ALTUS_PROD.dbo.CARE_STAFF_DETAILS AS csd3 ON csd3.MEMBER_ID = app.CREATED_BY
Inner Join AHS_ALTUS_PROD.dbo.APPOINTMENT_PROVIDER_MAPPING as apm on apm.appointment_id=app.appointment_id
join AHS_ALTUS_PROD.DBO.PHYSICIAN_DEMOGRAPHY ppd on ppd.physician_id= apm.provider_id
join AHS_ALTUS_PROD.DBO.patient_details pd on pd.patient_id = app.patient_id  and pd.CLIENT_PATIENT_ID not in ('ALT26860','ALT40110','ALT40111') 
) AP
)A 
WHERE YEAR(A.AppDate) =2018
group by CLIENT_PATIENT_ID,AppDate

  ) B ON CO.MemberID = B.CLIENT_PATIENT_ID
  GROUP BY MemberID,[Context]
      ,[TIN_Num]
      ,[TIN_Name]
      ,[Measure_Desc]
      ,[UniversalMemberId]
      ,[MedicaidID]
      ,[Gender]
      ,[Provider_NPI]
	  ,B.CLIENT_PATIENT_ID
 ) C

