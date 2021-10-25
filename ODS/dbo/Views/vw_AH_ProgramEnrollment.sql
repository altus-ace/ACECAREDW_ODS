

CREATE VIEW [dbo].[vw_AH_ProgramEnrollment]
AS
SELECT [CS_Export_LobName] AS LOB,
       [Program_Name] AS ProgramName,
       [Enroll_date] AS EnrollDate,
       [Create_date] AS CreateDate,
       [MEMBER_ID] As MemberID,
	   [Enroll_END_DATE] AS EnrollEndDate,
       [Program_status] AS ProgramStatus,
       [REASON_DESCRIPTION] AS ReasonDescription,
	   [REFERAL_TYPE] AS ReferalType,
       [ClientKey]  
FROM [dbo].[vw_AH_WC_NewlyEnrolledProgram]
