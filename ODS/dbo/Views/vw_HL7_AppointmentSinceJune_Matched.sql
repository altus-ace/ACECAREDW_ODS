
CREATE VIEW [dbo].[vw_HL7_AppointmentSinceJune_Matched]
AS
SELECT       APP.*
FROM            [ACE-SDV-DB02].[Ace_CP01].[dbo].[vw_AppointmentSince_June] APP 
--INNER JOIN  
--WHERE        (CreatedDate > CONVERT(datetime, '2019-06-01')) AND APP.AceClientMemberID 




--SELECT *
--from [ACE-SDV-DB02].[Ace_CP01].[dbo].[vw_AppointmentSince_June]