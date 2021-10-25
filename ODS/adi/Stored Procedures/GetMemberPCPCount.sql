
CREATE PROCEDURE [adi].[GetMemberPCPCount]
  @RowCount INT output
AS 
BEGIN 

 SELECT @RowCount = Count(*) 
 FROM [ACECAREDW].[dbo].[vw_AH_MemberPCP]
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
