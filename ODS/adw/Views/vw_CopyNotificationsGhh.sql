


CREATE VIEW [adw].[vw_CopyNotificationsGhh]
AS
SELECT        [NotificationID]
      ,[Status]
      ,[AceID]
      ,[AlternateFacilityMRN]
      ,[AceClientMemberID]
      ,[EmrID]
      ,[NotificationType]
      ,[EventType]
      ,[PatientClass]
      ,[AdmissionType]
      ,[AdmitDateTime]
      ,[DischargeDateTime]
      ,[DischargedLocation]
      ,[DischargeDisposition]
      ,[ChiefComplaint]
      ,[DiagnosisDescription]
      ,[DiagnosisCodingMethod]
      ,[DiagnosisCode]
      ,[DiagnosisDateTime]
      ,[DiagnosisType]
      ,[AdmitSource]
      ,[AdmitHospital]
      ,[MessageDateTime]
      ,[AttendingDoctor]
      ,[ReferringDoctor]
      ,[ConsultingDoctor]
      ,[AdmittingDoctor]
      ,[PatientVisitID]
      ,[NewBornBabyIndicator]
      ,[ReadmissionIndicator]
      ,[DataDate]
      ,[CreatedDate]
      ,[CreatedBy]
FROM          [ACE-SDV-DB02].[Ace_CP01].[dbo].[vw_GetGHHNotification] 
--ON            Notifi.AceClientMemberId != CM.Client_Member_ID
--WHERE        (Notifi.CreatedDate > CONVERT(datetime, '2019-06-01'))








