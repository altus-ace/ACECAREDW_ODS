CREATE VIEW [dbo].[GHH_all_client_data] 
AS
SELECT DISTINCT --This view grabs the GHH notifications for all client dated back for the previous day
       'GHH' AS [Source], 
       ntf.CreatedDate,
       CASE
           WHEN CAST(AceIdToCMK.ClientKeyID AS VARCHAR) = 1
           THEN 'UHC'
           WHEN CAST(AceIdToCMK.ClientKeyID AS VARCHAR) = 2
           THEN 'WLC'
           WHEN CAST(AceIdToCMK.ClientKeyID AS VARCHAR) = 3
           THEN 'Aetna MA'
           WHEN CAST(AceIdToCMK.ClientKeyID AS VARCHAR) = 9
           THEN 'Aetna COM'
           ELSE CAST(AceIdToCMK.ClientKeyID AS VARCHAR)
       END AS ClientName,
       -- e.CLIENT,
       CASE
           WHEN ActiveMember.MEMBER_LAST_NAME IS NULL
           THEN 'Not Active'
           ELSE(ActiveMember.MEMBER_LAST_NAME + ',' + ActiveMember.MEMBER_FIRST_NAME)
       END AS PatientName, 
       ActiveMember.MEMBER_ID AS MemberId, 
         --ntf.aceID AS MemberId, 
       ntf.admithospital AS HospitalName, 
       CONVERT(DATE, ntf.admitdatetime, 101) AS AdmissionDate, 
       CONVERT(DATE, ntf.dischargedatetime, 101) AS DischargeDate, 
       CONVERT(DATE, LEFT(ntf.messagedatetime, 8), 101) AS NotificationDate, 
       ntf.attendingdoctor AS AttendingPhysicianName, 
       ntf.ReferringDoctor AS ReferringPhysicianName, 
       ntf.ConsultingDoctor, 
       ntf.AdmittingDoctor, 
       ntf.DiagnosisCode AS PrimaryDiagnosisCode, 
       ntf.DiagnosisDescription AS PrimaryDiagnosisDesc, 
       ntf.PatientClass, 
       ntf.AdmissionType, 
       ntf.DischargedLocation, 
       ntf.DischargeDisposition, 
       ntf.ChiefComplaint, 
       ntf.DiagnosisCode, 
       ntf.DiagnosisDescription, 
       ntf.DiagnosisCodingMethod
FROM adi.NTFGHHNotifications Ntf
     JOIN AceMPI.adw.MPI_ClientMemberAssociationHistoryODS AceIdToCMK ON ntf.aceid = AceIdToCMK.MstrMrnKey
     LEFT JOIN [dbo].[vw_ActiveMembers] ActiveMember ON ActiveMember.Ace_ID = ntf.aceid
WHERE 
--cast(ntf.DischargeDateTime as date)> DATEADD(dd, -2, cast(GETDATE() as date))
convert(date, ntf.DischargeDateTime) BETWEEN DATEADD(dd,-2,GETDATE()) AND DATEADD(dd,-1,GETDATE())
--ORDER BY ntf.CreatedDate DESC

