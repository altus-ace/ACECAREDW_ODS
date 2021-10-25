-- =============================================
-- Author:		Bing
-- Create date: 01/14/2020
-- Description:	Export Avtive Members for GHH 
-- =============================================
CREATE PROCEDURE [adi].[ExportGHHActiveMembers]
   
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    	       
    -- Insert statements for procedure here

 SELECT MbrRoster.AceID, 
       MbrRoster.LAST_NAME, 
       MbrRoster.FIRST_NAME, 
       MbrRoster.MIDDLE_NAME, 
       MbrRoster.GENDER, 
       MbrRoster.DATE_OF_BIRTH, 
       MbrRoster.SSN, 
       MbrRoster.MEMBER_HOME_ADDRESS, 
       MbrRoster.MEMBER_HOME_ADDRESS2, 
       MbrRoster.MEMBER_HOME_CITY, 
       MbrRoster.MEMBER_HOME_STATE, 
       MbrRoster.MEMBER_HOME_ZIP, 
       MbrRoster.Member_Home_Phone, 
       MbrRoster.MinEligDate, 
       MbrRoster.MinExpDate, 
       MbrRoster.ClientMemberKey, 
       MbrRoster.clientKey
FROM abl.vw_GHH_MemberRoster MbrRoster

END