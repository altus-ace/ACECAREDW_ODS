
CREATE PROCEDURE [adi].[CopyGHHNotification]

AS 
BEGIN 

INSERT INTO [adi].[NtfGhhNotifications] (
                                    [DataDate],
                                    [SrcFileName],
									[CreatedDate],
									[CreatedBy],
									[LastUpdatedDate],
									[LastUpdatedBy],
									[NotificationID],
									[AceID],
									[AlternateFacilityMRN],
									[AceClientMemberID],
									[EmrID],
									[NotificationType],
									[EventType],
									[PatientClass],
									[AdmissionType],
									[AdmitDateTime],
									[DischargeDateTime],
									[DischargedLocation],
									[DischargeDisposition],
									[ChiefComplaint],
									[DiagnosisDescription],
									[DiagnosisCodingMethod],
									[DiagnosisCode],
									[DiagnosisDateTime],
									[DiagnosisType],
									[AdmitSource],
									[AdmitHospital],
									[MessageDateTime],
									[AttendingDoctor],
									[ReferringDoctor],
									[ConsultingDoctor],
									[AdmittingDoctor],
									[PatientVisitID],
									[NewBornBabyIndicator],
									[ReadmissionIndicator],
									[Status]
									)
SELECT [DataDate], 
        'DB02.Ace_CP01.athIB.Notifications',
        GETDATE(),
		'BoomiDbUser',
		GETDATE(),
		'BoomiDbUser',
		NotificationID,
        AceID,
		AlternateFacilityMRN,
		AceClientMemberID,
		EmrID,
		NotificationType,
		EventType,
		PatientClass,
		AdmissionType,
		AdmitDateTime,
		DischargeDateTime,
		DischargedLocation,
		DischargeDisposition,
		ChiefComplaint, 
		DiagnosisDescription,
		DiagnosisCodingMethod,
		DiagnosisCode,
		DiagnosisDateTime,
		DiagnosisType,
		AdmitSource,
		AdmitHospital,
		MessageDateTime,
		AttendingDoctor,
		ReferringDoctor,
		ConsultingDoctor,
		AdmittingDoctor,
		PatientVisitID,
		NewBornBabyIndicator,
		ReadmissionIndicator,
		[Status]

FROM [ACECAREDW].[adw].[vw_CopyNotificationsGhh]

EXEC [ACE-SDV-DB02].[Ace_CP01].[athIB].[GetGHHNotifications]

--SELECT CN.DataDate
--INTO  [adi.NtfNotificationsGhh].DataDate
--FROM  [adw].[vw_CopyNotificationsGhh] CN
 

END


--INSERT INTO adi.NtfNotificationsGhh([DataDate],[AceID])
--SELECT [DataDate], [AceID]
--FROM [ACECAREDW].[adw].[vw_CopyNotificationsGhh]

--Msg 208, Level 16, State 1, Procedure CopyGHHNotification, Line 9
--Invalid object name 'ACE-SDV-DB02.Ace_CP01.athIB.Notifications'.

--SELECT column-names
--  INTO new-table-name
--  FROM table-name
-- WHERE EXISTS 
--      (SELECT column-name
 --        FROM table-name
 --       WHERE condition)


 -- [Ace_CP01].[athIB].[Notifications]
