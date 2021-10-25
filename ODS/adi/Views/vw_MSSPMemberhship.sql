



CREATE VIEW [adi].[vw_MSSPMemberhship]

AS
/* Purpose: Gets all Active members with MPI/Ace ID for Export to 3rd parties 
			 Used by GHH Export file creation ETL: Ghh-Exp-ActiveMembers.dtsx
     History: GK created 11/14/2019

			 */  
			 
			 
    SELECT DISTINCT 
	fctMbr.Ace_ID AS AceID,
	fctMbr.[LastName] AS LAST_NAME,
	fctMbr.[FirstName] AS FIRST_NAME,
	fctMbr.[MiddleName] AS MIDDLE_NAME,
	fctMbr.[Gender] AS GENDER,
	fctMbr.[DOB] AS DATE_OF_BIRTH,
	''	AS SSN ,
	fctMbr.[MemberHomeAddress] AS MEMBER_HOME_ADDRESS,
	fctMbr.[MemberMailingAddress1] AS MEMBER_HOME_ADDRESS2,
	fctMbr.[MemberMailingCity] AS MEMBER_HOME_CITY,
	fctMbr.[MemberMailingState] AS MEMBER_HOME_STATE,
	fctMbr.[MemberHomeZip] AS MEMBER_HOME_ZIP,
	'' AS Member_Home_Phone,
	CONVERT(VARCHAR(8), DATEADD(DAY, -45, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()) , 1)),112) MinEligDate, 
    CONVERT(VARCHAR(8), DATEADD(MONTH, 6, DATEADD(Day, -1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()) , 1))),112) MinExpDate,
	fctMbr.[ClientMemberKey] AS ClientMemberKey	,
	fctMbr.ClientKey   

	FROM [ACDW_CLMS_SHCN_MSSP].[adi].[tmp_MemberListValidation] tmpMbr INNER JOIN [ACDW_CLMS_SHCN_MSSP].[adw].[vw_Dashboard_Membership] fctMbr
	ON tmpMbr.[MBI_ID] = fctMbr.[MBI]

	
				           
  --  SELECT DISTINCT 
  --          RTRIM(LTRIM(ISNULL(am.Ace_ID, '')))				 AS AceID			 -- Ace MRN
  --        , RTRIM(LTRIM(ISNULL(AM.MEMBER_LAST_NAME, '')))		 AS LAST_NAME		 -- name limit 50 char
		--, RTRIM(LTRIM(ISNULL(AM.MEMBER_FIRST_NAME,'')))		 AS FIRST_NAME		 -- name limit 50 char
  --        , RTRIM(LTRIM(ISNULL(AM.MEMBER_MI, '')))				 AS MIDDLE_NAME	 -- name limit 50 char
		--, CASE WHEN (RTRIM(LTRIM(am.Gender)) = 'M') THEN 'M'
		--	  WHEN (RTRIM(LTRIM(am.Gender)) = 'F') THEN 'F'
		--	  ELSE 'U' END 					 AS GENDER		 -- Gender Limit 1 char
  --        , CONVERT(VARCHAR(8), am.DATE_OF_BIRTH, 112)  AS DATE_OF_BIRTH	 -- DOB 8 Char
		--, ''									 AS SSN
		--, RTRIM(LTRIM(ISNULL(am.MEMBER_HOME_ADDRESS,'')))		 AS MEMBER_HOME_ADDRESS
  --        , RTRIM(LTRIM(ISNULL(am.MEMBER_HOME_ADDRESS2,'')))	 AS MEMBER_HOME_ADDRESS2
  --        , RTRIM(LTRIM(ISNULL(am.MEMBER_HOME_CITY,'')))		 AS MEMBER_HOME_CITY
  --        , CASE WHEN ISNULL(am.MEMBER_HOME_STATE,'') = '' THEN ''
		--    WHEN [State].StateAbreviation IS NULL THEN ''
		--	 ELSE [State].StateAbreviation END		 AS MEMBER_HOME_STATE		
  --        , ISNULL(am.MEMBER_HOME_ZIP_C, '')					 AS MEMBER_HOME_ZIP
		--, ISNULL([adw].[AceCleanPhoneNumber](am.Member_Home_Phone),'')		 AS Member_Home_Phone
		--, CONVERT(VARCHAR(8), DATEADD(DAY, -45, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()) , 1)),112) MinEligDate
		--, CONVERT(VARCHAR(8), DATEADD(MONTH, 6, DATEADD(Day, -1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()) , 1))),112) MinExpDate
		--, RTRIM(LTRIM(am.MEMBER_ID))				 AS ClientMemberKey	
		--, am.clientKey    
  --   FROM dbo.vw_ActiveMembers AS AM
	 --  LEFT JOIN lst.lstState [State] ON AM.MEMBER_HOME_STATE = [State].StateAbreviation
	




