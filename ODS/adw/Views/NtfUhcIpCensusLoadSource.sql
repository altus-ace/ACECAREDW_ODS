
CREATE VIEW [adw].[NtfUhcIpCensusLoadSource]
-- src query for load of CC P12 
AS
SELECT 'TOC2' AS Prog_ID,
       CONVERT(DATE, GETDATE(), 101) AS CreateDate,
       SYSTEM_USER AS CreateBy,
       CONVERT(DATE, GETDATE(), 101) AS AssignDate,
       'N/A' AS AssignTo,
       'N/A' AS ProgMemStatus,
       'N/A' AS ProgMemNote,
       'N/A' AS ApptStatus,
       '1/1/1900' AS ApptDate,
       src.PatientIdentifier AS Member_ID,
       0 AS HRA,
       '1/1/1900' AS HRAComp,
       src.AdmissionDate AS EffAdmDate,
       src.DischargeDate AS ConDiscDate,
       -1 AS LOS,
       '1/1/1900' AS FollowUpVisDate,
       src.hospitalName AdmHosp,
       src.PrimaryDiagnosisDesc AS Diagnosis_Desc,
       src.PrimaryCarePhysicianName AS AssignedPcp,
       src.LoadDate AS DateAppeared,
       DATEADD(DAY, src.FollowUpDays, src.LoadDate) AS ReCalcFollowUp,
       src.CreatedDate AS lst_Update_date,
       src.CreatedBy AS lst_Update_by,
       0 AS Exported,
       '01/01/1980' AS exportedDate,
       src.PrimaryDiagnosisCode,
       src.DispositionDesc AS DiscDisp
	 
FROM  
(
    SELECT Ntf.PatientIdentifier,
           Ntf.AdmissionDate,
           Ntf.DischargeDate,
           Ntf.DispositionDesc,
           --, Ntf.LengthOfStay    
		 Ntf.hospitalName,
           Ntf.PrimaryCarePhysicianName,
           Ntf.AdmissionDateReported,
           Ntf.DateDcReported,
           Ntf.PrimaryDiagnosisCode,
           Ntf.PrimaryDiagnosisDesc,
           Ntf.LoadDate,
           Ntf.DataDate,
           c.FollowUpDays,
           Ntf.SrcFileName,
           Ntf.CreatedDate,
           Ntf.CreatedBy    
    
    FROM adi.NtfUhcIpCensus Ntf
        JOIN
        (
            SELECT c.IpDischargeFollupIntervalInDays AS FollowUpDays
            FROM lst.List_Client c
            WHERE c.ClientKey = 1
        ) c
            ON 1 = 1
    WHERE Ntf.AdmissionDateReported >= DATEADD(DAY, -7, '12/03/2018')	   
	   AND Ntf.LoadDate = CONVERT(DATE, GETDATE())    
	 /* proposed: ticket # 1753 add this filter, to remove all null discharge dates from downstream data 
	 AND ISNULL(Ntf.DischargeDate, '01/01/1900') <> '01/01/1900'
	 */
) src
    JOIN
    (SELECT MEMBER_ID FROM dbo.vw_UHC_ActiveMembers 
  /*  used by a mass load of intial members in nov 2018 remove code
     UNION
    SELECT DISTINCT UHC_SUBSCRIBER_ID FROM dbo.UHC_MembersByPCP
    WHERE  SUBGRP_ID  IN ('TX99','1001','1002','1003','0603','0601','0602','0600','0606','0604','0605')
    */
    ) AM
        ON src.PatientIdentifier = RTRIM(LTRIM(AM.MEMBER_ID)
	   )
