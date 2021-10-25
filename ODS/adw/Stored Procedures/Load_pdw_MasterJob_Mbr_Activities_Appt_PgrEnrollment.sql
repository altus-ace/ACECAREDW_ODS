
CREATE PROCEDURE [adw].[Load_pdw_MasterJob_Mbr_Activities_Appt_PgrEnrollment]

AS



/*Process Mbr Activities*/
BEGIN
EXECUTE [adw].[Load_Pdw_MbrActivities_ToShcnMssp_FromAceCare];
END


/*Process Mbr Appointments*/
BEGIN
EXECUTE [adw].[Load_Pdw_MbrAppointments_ToShcnMssp_FromAceCare];
END


/*Process Mbr Program Enrollments*/
BEGIN
EXECUTE [adw].[Load_Pdw_MbrProgramEnrollments_ToShcnMssp_FromAceCare];
END


/*-- clean dbo ahs program exports*/
BEGIN
EXECUTE dbo.LoadAhsExportProgramEnrollment_CleanOldData  
END