




CREATE VIEW [adi].[vw_CopyNotificationsGhh]
AS
SELECT        Notifi.*
FROM          [ACE-SDV-DB02].[Ace_CP01].[dbo].[vw_GetNotification] Notifi 
--ON            Notifi.AceClientMemberId != CM.Client_Member_ID
--WHERE        (Notifi.CreatedDate > CONVERT(datetime, '2019-06-01'))




