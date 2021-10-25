
CREATE PROCEDURE [adi].[CopyGHHMembers]

AS 
BEGIN 

INSERT INTO [adi].[MbrGhhMember] (
    [DataDate] ,
	[SrcFileName] ,
	[CreatedDate] ,
	[CreatedBy] ,
	[LastUpdatedDate] ,
	[LastUpdatedBy] ,
	[AceID] ,
	[AceClientMemberId],
	[EmrID] ,
	[FirstName] ,
	[MiddleName] ,
	[LastName] ,
	[Gender] ,
	[DateOfBirth] ,
	[Medicaid_ID] ,
	[Medicare_ID] ,
	[SSN] ,
	[HomeAddress1] ,
	[HomeAddress2] ,
	[HomeCity] ,
	[HomeState] ,
	[HomeZip] ,
	[HomeZipPlus4] ,
	[HomePhone] ,
	[MobilePhone] ,
	[BusinessPhone] ,
	[PCP_Practice_TIN] ,
	[PCP_NPI] ,
	[Status] 
	)
									
SELECT [DataDate], 
        'DB02.Ace_CP01.athIB.Member',
        GETDATE(),
		'BoomiDbUser',
		GETDATE(),
		'BoomiDbUser',
		
        AceID,
        [AceClientMemberId],
		EmrID,
        [FirstName],
		[MiddleName] ,
	[LastName] ,
	[Gender] ,
	[DateOfBirth] ,
	[Medicaid_ID] ,
	[Medicare_ID] ,
	[SSN] ,
	[HomeAddress1] ,
	[HomeAddress2] ,
	[HomeCity] ,
	[HomeState] ,
	[HomeZip] ,
	[HomeZipPlus4] ,
	[HomePhone] ,
	[MobilePhone] ,
	[BusinessPhone] ,
	[PCP_Practice_TIN] ,
	[PCP_NPI] ,
	[Status] 
	
	

FROM [ACECAREDW].[adw].[vw_CopyMembersGhh]
where EmrID = 'GHHCOMMUNITY'

EXEC [ACE-SDV-DB02].[Ace_CP01].[athIB].[GetGHHMembers] 'GHHCOMMUNITY'

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
