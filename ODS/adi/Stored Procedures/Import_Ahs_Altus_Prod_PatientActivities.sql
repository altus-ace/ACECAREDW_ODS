


-- =============================================
-- Author:		Bing Yu
-- Create date: 09/08/2020
-- Description:	Insert 
-- ============================================
CREATE PROCEDURE [adi].[Import_Ahs_Altus_Prod_PatientActivities]
              
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--EXEC [Ahs_Altus_Prod].[adi].[Get_PatientActivities]
INSERT INTO AceCareDw.dbo.tmp_Ahs_PatientActivities 
    (ClientMemberKey, CareActivityTypeName, ActivityOutcome, ActivityPerformedDate, ActivityCreatedDate, OutcomeNotes, VenueName, LOB,srcFileName, LoadDate, CreatedDate, CreatedBy)
    SELECT DISTINCT 
       PatientDetails.client_patient_id, 
       CareActivityType.care_activity_type_name, 
       ActivityOutcome.activity_outcome, 
       PatientFollowUp.performed_date, 
       PatientFollowUp.created_date, 
       PatientFollowUp.OUTCOME_NOTES, 
       Venue.VENUE_NAME,
	  LOB.LOB,
	  'Ahs_DailyRestore_ExportPatientActivities' srcFileName,
	  CONVERT(DATE, GETDATE())
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
			 and PatientFollowUp.Created_date BETWEEN LOB.start_date and LOB.end_date;
	
END




