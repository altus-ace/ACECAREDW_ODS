



CREATE VIEW [abo].[vw_Exp_ACEMemberRosterForGHH]

AS/* Purpose: Gets all Active members with MPI/Ace ID for Export to 3rd parties 
			 Used by GHH Export file creation ETL: Ghh-Exp-ActiveMembers.dtsx
     History: GK created 11/14/2019
			 GK: 10/16/2020: removed conversion and trim from ace_id 
			 Brit: 12/03/2020: Added the am.MEMBER_POD_DESC column from the vw_activeMembers to enable filtering for GHH Export downstream
			 GK: Removed ClientKey and ClientMemberKey: cause duplicates if member in multiple healthplans

			 */             
    SELECT DISTINCT 
            am.Ace_ID									   AS AceID			 -- Ace MRN
          , RTRIM(LTRIM(ISNULL(AM.MEMBER_LAST_NAME, '')))		 AS LAST_NAME		 -- name limit 50 char
		, RTRIM(LTRIM(ISNULL(AM.MEMBER_FIRST_NAME,'')))		 AS FIRST_NAME		 -- name limit 50 char
          , RTRIM(LTRIM(ISNULL(AM.MEMBER_MI, '')))				 AS MIDDLE_NAME	 -- name limit 50 char
		, CASE WHEN (RTRIM(LTRIM(am.Gender)) = 'M') THEN 'M'
			  WHEN (RTRIM(LTRIM(am.Gender)) = 'F') THEN 'F'
			  ELSE 'U' END 					 AS GENDER		 -- Gender Limit 1 char
          , CONVERT(VARCHAR(8), am.DATE_OF_BIRTH, 112)  AS DATE_OF_BIRTH	 -- DOB 8 Char
		, ''									 AS SSN
		, RTRIM(LTRIM(ISNULL(am.MEMBER_HOME_ADDRESS,'')))		 AS MEMBER_HOME_ADDRESS
          , RTRIM(LTRIM(ISNULL(am.MEMBER_HOME_ADDRESS2,'')))	 AS MEMBER_HOME_ADDRESS2
          , RTRIM(LTRIM(ISNULL(am.MEMBER_HOME_CITY,'')))		 AS MEMBER_HOME_CITY
          , CASE WHEN ISNULL(am.MEMBER_HOME_STATE,'') = '' THEN ''
		    WHEN [State].StateAbreviation IS NULL THEN ''
			 ELSE [State].StateAbreviation END		 AS MEMBER_HOME_STATE		
          , ISNULL(SUBSTRING(am.MEMBER_HOME_ZIP_C, 1,5), '')					 AS MEMBER_HOME_ZIP
		  --, ISNULL(am.MEMBER_HOME_ZIP_C, '')					 AS MEMBER_HOME_ZIP
		, ISNULL([adw].[AceCleanPhoneNumber](am.Member_Home_Phone),'')		 AS Member_Home_Phone
		, CONVERT(VARCHAR(8), DATEADD(DAY, -45, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()) , 1)),112) MinEligDate
		, CONVERT(VARCHAR(8), DATEADD(MONTH, 6, DATEADD(Day, -1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()) , 1))),112) MinExpDate				
		, am.MEMBER_POD_DESC    
     FROM dbo.vw_ActiveMembers AS AM
	   LEFT JOIN lst.lstState [State] ON AM.MEMBER_HOME_STATE = [State].StateAbreviation
	   ;



