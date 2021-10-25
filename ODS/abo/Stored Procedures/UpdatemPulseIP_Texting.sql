-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [abo].[UpdatemPulseIP_Texting]
@Member_ID varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @RowCount INT = 0
	SET @RowCount = (Select COUNT(*)
--distinct CLIENT as Client
--,ltrim(rtrim(CLIENT_SUBSCRIBER_ID)) as MemberID
--, ltrim(rtrim(MEMBER_FIRST_NAME)) as MemberFirstName
--,ltrim(rtrim(MEMBER_LAST_NAME)) as MemberLastName
--,ltrim(rtrim(convert(date,DATE_OF_BIRTH))) as DOB
--,b.phonenumber
--,'Emergency Room' as Discharge_Flag
--,'English' as Language

from vw_ActiveMembers A

inner JOIN
(
/* 
     SELECT
           ClientMemberKey,Ace_ID_Mrn,phoneNumber
    FROM [AceCareDw].[adi].[MPulsePhoneScrubbed]
    WHERE carrier_type = 'Mobile'
*/
select * from (
SELECT   ClientMemberKey,Ace_ID_Mrn,phoneNumber ,
row_number() over (partition by  clientmemberkey order by loaddate desc) as arn
    FROM [AceCareDw].[adi].[MPulsePhoneScrubbed]           
              WHERE carrier_type = 'Mobile'
              ) as x where x.arn = 1
              --AND  LoadDate =(SELECT MAX(LoadDate) FROM [AceCareDw].[adi].[MPulsePhoneScrubbed])
) B ON A.CLIENT_SUBSCRIBER_ID = B.ClientMemberKey

where a.CLIENT_SUBSCRIBER_ID = @Member_ID and a.subgrp_id in (
'0060'
,'0064'
,'0301'
,'0302'
,'0311'
,'0601'
,'310'
,'601'
,'604'
,'605'
,'606'
,'62'
,'64'
,'65'
,'67'
,'68'
,'D001'
,'0062'
,'0066'
,'0068'
,'0309'
,'0602'
,'0606'
,'120'
,'302'
,'304'
,'5'
,'60'
,'600'
,'603'
,'61'
,'D002'
,'0020'
,'0063'
,'0065'
,'0067'
,'0600'
,'20'
,'3'
,'301'
,'303'
,'309'
,'63'
,'0003'
,'0005'
,'0303'
,'0304'
,'0310'
,'0603'
,'0604'
,'0605'
,'311'
,'602'
,'66'
,'D000'
))

	--SELECT COUNT(*)
	--FROM [adi].[tempmPulse_ER_Texting]
	--WHERE [PatientCardID] = 
	IF @RowCount > 0
	BEGIN
	UPDATE [adi].[tempmPulse_IP_Texting]
		SET [Text] = 'Text'
		WHERE [MEMEBR_ID] = @Member_ID
	END
	ELSE 
	BEGIN
		UPDATE [adi].[tempmPulse_IP_Texting]
		SET [Text] = 'No Text'
		WHERE [MEMEBR_ID] = @Member_ID
	END

	---, @PatientCardID varchar(50)
	--SELECT @PatientCardID = [PatientCardID]
	--FROM [adi].[tempmPulse_ER_Texting]
	--EXEC [ACECAREDW].[abo].[UpdatemPulseER_Texting] @PatientCardID




--update [adi].[tempmPulse_ER_Texting]
--SET 
--WHERE [PatientCardID] =''
END