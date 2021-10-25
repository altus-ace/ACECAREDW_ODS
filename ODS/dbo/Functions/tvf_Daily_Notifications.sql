CREATE FUNCTION [dbo].[tvf_Daily_Notifications](@FileDate DATE)
RETURNS TABLE
AS
     RETURN
(  
 --    declare @fileDate date = '2020/02/18'
    SELECT DISTINCT 
           b.NPI, 
           b.[Pcp_First_Name], 
           b.[Pcp_Last_Name], 
           [Member_First_Name], 
           [Member_Last_Name], 
           b.Member_Id, 
           b.CLIENT, 
           b.Subgrp_name
           ,
           --,'' [PatientCardID]
           --,''[MemberHealthPlanNumber] 
           b.Date_of_birth, 
           b.Gender, 
           b.lang_code
           ,
           --,[Address]
           --,[City]
           --,[State]
           --,[Zip]
           --,[ContactPhoneNumber]
           --,[AlternativePhoneNumber]
           --,[LOB]
           --,[ServiceDate] 
           a.ntfSource AS Notification_Source, 
           a.casetype, 
           a.[AdmitdateTime], 
           a.[ActualDischargeDate], 
           a.datadate AS [ServiceDateReported]
           ,
           --,[DayOfWeek]
           --,[ReOccuranceWithin30Days]
           --,[AvoidableERVisit]
           --,[LastIpVisitDate] 
           a.[DiagnosisCode], 
           a.[DiagnosisDesc]
           ,
           --,[AttendingPhysicianFirstName]
           --,[AttendingPhysicianLastName] 
           a.admitHospital [FacilityName]
           ,
           --,[FacilityState]
           --,[PcpNpi]
           --   ,[LoadDate]
           --,[DataDate]
           --,[SrcFileName]
           CASE
               WHEN c.phonenumber IS NOT NULL
               THEN 'No'
               WHEN b.subgrp_id IN('0060', '0064', '0100', '0114', '0301', '0302', '0311', '0601', '310', '601', '604', '605', '606', '62', '64', '65', '67', '68', 'D001', '0062', '0066', '0068', '0120', '0123', '0309', '0602', '0606', '0901', '120', '302', '304', '5', '60', '600', '603', '61', '901', 'D002', '0020', '0063', '0065', '0067', '0600', '100', '111', '123', '20', '3', '301', '303', '309', '63', '0003', '0005', '0111', '0115', '0121', '0303', '0304', '0310', '0603', '0604', '0605', '311', '602', '66', 'D000')
               THEN 'Yes'
               ELSE 'Yes'
           END AS [Text Sent?]
    FROM [ACECAREDW].[adw].[NtfNotification] a
         JOIN ACECAREDW.dbo.vw_ActiveMembers b ON b.MEMBER_ID = a.clientmemberkey
         LEFT JOIN
    (
        SELECT *
        FROM
        (
            SELECT ClientMemberKey, 
                   Ace_ID_Mrn, 
                   phoneNumber, 
                   ROW_NUMBER() OVER(PARTITION BY clientmemberkey
                   ORDER BY loaddate DESC) AS arn
            FROM [AceCareDw].[adi].[MPulsePhoneScrubbed]
            WHERE carrier_type = 'Mobile'
        ) AS x
        WHERE x.arn = 1
    ) C ON B.member_ID = C.ClientMemberKey
    WHERE CONVERT(DATE, a.exporteddate) = @FileDate
	and a.ntfpatienttype = 'IP'
	and Exported = 1
);
