




CREATE VIEW [adi].[vw_Ahs_PatientActivities]

AS
/*
ClientMemberKey, CareActivityTypeName, 
ActivityOutcome, ActivityPerformedDate, 
ActivityCreatedDate, OutcomeNotes, 
VenueName, LOB,srcFileName, LoadDate, 
CreatedDate, CreatedBy
			 */  
			 
 SELECT DISTINCT 
       PatientDetails.client_patient_id AS ClientMemberKey, 
       CareActivityType.care_activity_type_name AS CareActivityTypeName, 
       ActivityOutcome.activity_outcome AS ActivityOutcome, 
       PatientFollowUp.performed_date AS ActivityPerformedDate, 
       PatientFollowUp.created_date AS ActivityCreatedDate, 
       PatientFollowUp.OUTCOME_NOTES AS OutcomeNotes, 
       Venue.VENUE_NAME AS VenueName,
	  LOB.LOB AS LOB,
	  'Ahs_DailyRestore_ExportPatientActivities' AS srcFileName,
	  CONVERT(DATE, GETDATE()) AS LoadDate
	  , getdate() AS CreatedDate
	  , SYSTEM_USER AS CreatedBy
    FROM Ahs_Altus_Prod.dbo.patient_followup AS PatientFollowUp
     LEFT JOIN Ahs_Altus_Prod.dbo.care_activity_type AS CareActivityType ON PatientFollowUp.care_activity_type_id = CareActivityType.care_activity_type_id
     LEFT JOIN Ahs_Altus_Prod.dbo.care_staff_details AS CareStaffDetails ON CareStaffDetails.member_id = PatientFollowUp.PERFORMED_BY
     LEFT JOIN Ahs_Altus_Prod.dbo.activity_outcome AS ActivityOutcome ON PatientFollowUp.activity_outcome_id = ActivityOutcome.activity_outcome_id
     LEFT JOIN Ahs_Altus_Prod.dbo.patient_details AS PatientDetails ON PatientDetails.patient_id = PatientFollowUp.patient_id
	   AND NOT PatientDetails.client_patient_id like 'ALT%'
     LEFT JOIN Ahs_Altus_Prod.dbo.VENUE AS Venue ON Venue.VENUE_ID = PatientFollowUp.VENUE_ID
	 JOIN (SELECT DISTINCT pd.Patient_id, lob.LOB_NAME AS LOB , mbp.start_date , mbp.end_date
		  FROM ahs_altus_prod.dbo.MEM_BENF_PLAN AS mbp
			 INNER JOIN ahs_altus_prod.dbo.LOB_BENF_PLAN AS lbp ON mbp.LOB_BEN_ID = lbp.LOB_BEN_ID         
			 INNER JOIN ahs_altus_prod.dbo.LOB ON LOB.LOB_ID = lbp.LOB_ID
			 INNER JOIN ahs_altus_prod.dbo.PATIENT_DETAILS AS pd ON mbp.MEMBER_ID = pd.PATIENT_ID 
		  WHERE(mbp.DELETED_ON IS NULL)    
			 and NOT pd.Client_Patient_id like 'Alt%'
		  GROUP BY pd.PATIENT_ID, lob.lob_name, mbp.start_date, mbp.end_date) LOB
		  ON patientFollowUp.Patient_ID = LOB.Patient_ID
			 and PatientFollowUp.Created_date BETWEEN LOB.start_date and LOB.end_date

	
				           
  --  SELECT DISTINCT 
  --          RTRIM(LTRIM(ISNULL(am.Ace_ID, '')))				 AS AceID			 -- Ace MRN
  --        , RTRIM(LTRIM(ISNULL(AM.MEMBER_LAST_NAME, '')))		 AS LAST_NAME		 -- name limit 50 char
		--, RTRIM(LTRIM(ISNULL(AM.MEMBER_FIRST_NAME,'')))		 AS FIRST_NAME		 -- name limit 50 char
  --        , RTRIM(LTRIM(ISNULL(AM.MEMBER_MI, '')))				 AS MIDDLE_NAME	 -- name limit 50 char
		--, CASE WHEN (RTRIM(LTRIM(am.Gender)) = 'M') THEN 'M'
		--	  WHEN (RTRIM(LTRIM(am.Gender)) = 'F') THEN 'F'
		--	  ELSE 'U' END 					 AS GENDER		 -- Gender Limit 1 char
  --        , CONVERT(VARCHAR(8), am.DATE_OF_BIRTH, 112)  AS DATE_OF_BIRTH	 -- DOB 8 Char
		--, ''									 AS SSN
		--, RTRIM(LTRIM(ISNULL(am.MEMBER_HOME_ADDRESS,'')))		 AS MEMBER_HOME_ADDRESS
  --        , RTRIM(LTRIM(ISNULL(am.MEMBER_HOME_ADDRESS2,'')))	 AS MEMBER_HOME_ADDRESS2
  --        , RTRIM(LTRIM(ISNULL(am.MEMBER_HOME_CITY,'')))		 AS MEMBER_HOME_CITY
  --        , CASE WHEN ISNULL(am.MEMBER_HOME_STATE,'') = '' THEN ''
		--    WHEN [State].StateAbreviation IS NULL THEN ''
		--	 ELSE [State].StateAbreviation END		 AS MEMBER_HOME_STATE		
  --        , ISNULL(am.MEMBER_HOME_ZIP_C, '')					 AS MEMBER_HOME_ZIP
		--, ISNULL([adw].[AceCleanPhoneNumber](am.Member_Home_Phone),'')		 AS Member_Home_Phone
		--, CONVERT(VARCHAR(8), DATEADD(DAY, -45, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()) , 1)),112) MinEligDate
		--, CONVERT(VARCHAR(8), DATEADD(MONTH, 6, DATEADD(Day, -1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()) , 1))),112) MinExpDate
		--, RTRIM(LTRIM(am.MEMBER_ID))				 AS ClientMemberKey	
		--, am.clientKey    
  --   FROM dbo.vw_ActiveMembers AS AM
	 --  LEFT JOIN lst.lstState [State] ON AM.MEMBER_HOME_STATE = [State].StateAbreviation
	




