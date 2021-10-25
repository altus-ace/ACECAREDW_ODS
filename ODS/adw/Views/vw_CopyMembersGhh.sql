








CREATE VIEW [adw].[vw_CopyMembersGhh]
AS
SELECT        GHHMembers.*
FROM          [ACE-SDV-DB02].[Ace_CP01].[dbo].[vw_GetGHHMembers] GHHMembers
--ON            Notifi.AceClientMemberId != CM.Client_Member_ID
--WHERE        (Notifi.CreatedDate > CONVERT(datetime, '2019-06-01'))








