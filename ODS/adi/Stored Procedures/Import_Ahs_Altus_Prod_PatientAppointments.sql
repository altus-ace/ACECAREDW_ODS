


-- =============================================
-- Author:		Bing Yu
-- Create date: 09/08/2020
-- Description:	Insert 
-- ============================================
CREATE PROCEDURE [adi].[Import_Ahs_Altus_Prod_PatientAppointments]
              
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--	EXEC [Ahs_Altus_Prod].[adi].[Get_PatientAppointments]
INSERT INTO AceCaredw.dbo.tmp_Ahs_PatientAppointments (
    ClientMemberKey, AppointmentStatusName, AppointmentDate, AppointmentScheduledBy, AppointmentNote, AppointmentCreatedDate, LOB, srcFileName, LoadDate, CreatedDate, CreatedBy
    )
    SELECT DISTINCT 
	  PatientDetails.CLIENT_PATIENT_ID AS ClientMemberKey, 
       AppointmentStatus.appointment_status_name, 
       Appointments.appointment_date, 
       concat(LTRIM(RTRIM(CareStaffDetails.FIRST_NAME)), LTRIM(RTRIM(CareStaffDetails.LAST_NAME))) AS Appt_SCH_by, 
       Appointments.APPOINTMENT_NOTES AS NOTE, 
       Appointments.created_on,
	  LOB,
	  'Ahs_DailyRestore_ExportPatientAppointments' srcFileName,
	  CONVERT(DATE,GETDATE()) LoadDate
	  , getdate() AS CreatedDate
	  , SYSTEM_USER AS CreatedBy
    FROM Ahs_Altus_Prod.dbo.appointment Appointments
	   LEFT JOIN Ahs_Altus_Prod.dbo.appointment_status AppointmentStatus ON Appointments.appointment_status = AppointmentStatus.appointment_status_id      
	   LEFT JOIN Ahs_Altus_Prod.dbo.APPOINTMENT_AUDIT_LOG AppointmentAuditLog ON AppointmentAuditLog.APPOINTMENT_ID = Appointments.APPOINTMENT_ID      
	   LEFT JOIN Ahs_Altus_Prod.dbo.CARE_STAFF_DETAILS AS CareStaffDetails ON CareStaffDetails.MEMBER_ID = Appointments.CREATED_BY
	   LEFT JOIN Ahs_Altus_Prod.dbo.APPOINTMENT_PROVIDER_MAPPING AS AppointmentProviderMapping ON AppointmentProviderMapping.appointment_id = Appointments.appointment_id
	   LEFT JOIN Ahs_Altus_Prod.dbo.patient_details AS PatientDetails ON PatientDetails.patient_id = Appointments.patient_id
	   JOIN (SELECT DISTINCT pd.Patient_id, lob.LOB_NAME AS LOB , mbp.start_date , mbp.end_date
					   FROM ahs_altus_prod.dbo.MEM_BENF_PLAN AS mbp
		  				  INNER JOIN ahs_altus_prod.dbo.LOB_BENF_PLAN AS lbp ON mbp.LOB_BEN_ID = lbp.LOB_BEN_ID         
		  				  INNER JOIN ahs_altus_prod.dbo.LOB ON LOB.LOB_ID = lbp.LOB_ID
		  				  INNER JOIN ahs_altus_prod.dbo.PATIENT_DETAILS AS pd ON mbp.MEMBER_ID = pd.PATIENT_ID 
			 WHERE(mbp.DELETED_ON IS NULL)    
				and NOT pd.Client_Patient_id like 'Alt%'
			GROUP BY pd.PATIENT_ID, lob.lob_name, mbp.start_date, mbp.end_date) LOB
		  ON Appointments.Patient_id = LOB.Patient_id
			 AND appointments.CREATED_ON BETWEEN LOB.START_DATE AND LOB.END_DATE
	
END




