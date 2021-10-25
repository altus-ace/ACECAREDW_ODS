



/*
Purpose: Export of our Members for all HIEs. Required to have 1 AceID for 
BRIT: 
**/

CREATE VIEW [abl].[vw_ACEMaster_MembershipRoster]
 ---SELECT * FROM [abl].[vw_Master_MembershipRoster]
AS				

    SELECT			MRN
					,LAST_NAME
					,FIRST_NAME
					,MIDDLE_NAME
					,GENDER
					,DATE_OF_BIRTH
					,MEMBER_HOME_ADDRESS
					,MEMBER_HOME_ADDRESS2
					,MEMBER_HOME_CITY
					,MEMBER_HOME_STATE
					,MEMBER_HOME_ZIP5
					,MemberPrimaryPhone
					,MinEligDate
					,MinExpDate
					,MEMBER_POD_DESC
					,MEDICAID_ID
					,MEDICARE_ID
					,RwCnt
					,RaceCode
					,DriversLicenseNumber
					,DriversLicenseState
					,SSN9
					,SSN4
					,Ordering_Account_Number
					,zip4
					,Country
					,CellPhone
					,HomePhone
					,EmailAddress
					,PayerName
					,PayerGroupNumber
					,MemberID
					,SubscriberID
					,UniqueRequestID
					,RecordIndicator
					
	FROM			( 
    SELECT  
					DISTINCT am.Ace_ID			AS UniqueRequestID			 
					, (RTRIM(LTRIM(ISNULL(AM.MEMBER_LAST_NAME, ''))))			 AS LAST_NAME		 
					, (RTRIM(LTRIM(ISNULL(AM.MEMBER_FIRST_NAME,''))))		     AS FIRST_NAME		 
					, (RTRIM(LTRIM(ISNULL(AM.MEMBER_MI, ''))))				 AS MIDDLE_NAME	 
					, CASE WHEN (RTRIM(LTRIM(am.Gender)) = 'M') THEN 'M'
						WHEN (RTRIM(LTRIM(am.Gender)) = 'F') THEN 'F'
						ELSE 'U' 
					  END 													 AS GENDER		
					, CONVERT(VARCHAR(8), am.DATE_OF_BIRTH, 112)			 AS DATE_OF_BIRTH	 
					, ''													 AS SSN9
					, (RTRIM(LTRIM(ISNULL(am.MEMBER_HOME_ADDRESS,''))))		 AS MEMBER_HOME_ADDRESS
					, (RTRIM(LTRIM(ISNULL(am.MEMBER_HOME_ADDRESS2,''))))	     AS MEMBER_HOME_ADDRESS2
					, (RTRIM(LTRIM(ISNULL(am.MEMBER_HOME_CITY,''))))			 AS MEMBER_HOME_CITY
					, CASE WHEN ISNULL(am.MEMBER_HOME_STATE,'') = '' THEN ''
						WHEN [State].StateAbreviation IS NULL THEN ''
						ELSE [State].StateAbreviation 
						END													 AS MEMBER_HOME_STATE		
					, ISNULL(SUBSTRING(am.MEMBER_HOME_ZIP_C, 1,5), '')		 AS MEMBER_HOME_ZIP5
						--, ISNULL(am.MEMBER_HOME_ZIP_C, '')					 AS MEMBER_HOME_ZIP
					, ISNULL([adw].[AceCleanPhoneNumber](am.Member_Home_Phone),'')		 AS MemberPrimaryPhone
					, CONVERT(VARCHAR(8), DATEADD(DAY, -45, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()) , 1)),112) MinEligDate
					, CONVERT(VARCHAR(8), DATEADD(MONTH, 6, DATEADD(Day, -1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()) , 1))),112) MinExpDate				
					, am.MEMBER_POD_DESC
					, ISNULL(am. MEDICAID_ID,'')							 AS MEDICAID_ID
					, ISNULL(am.MEDICARE_ID ,'')							 AS MEDICARE_ID	
					, ROW_NUMBER() OVER (PARTITION BY Ace_ID ORDER BY MEDICAID_ID DESC, MEDICARE_ID DESC) RwCnt
					, ISNULL(am. RACE,'')									 AS RaceCode
					, ''													 AS DriversLicenseNumber
					, ''													 AS DriversLicenseState
					, ''													 AS SSN4
					, ''													 AS Ordering_Account_Number
					, ''													 AS zip4
					, ''													 AS Country
					, ''													 AS CellPhone
					, ''													 AS HomePhone
					, ''													 AS EmailAddress
					, CLIENT												 AS PayerName
					, ''													 AS PayerGroupNumber
					, MEMBER_ID													 AS MemberID
					, CLIENT_SUBSCRIBER_ID							 AS SubscriberID
					, ''													 AS MRN
					, 'N'													 AS RecordIndicator -- N -NEW, M - Modify/Update, D -Delete
     FROM			dbo.vw_ActiveMembers AS am
	 LEFT JOIN		lst.lstState [State] 
	 ON				am.MEMBER_HOME_STATE = [State].StateAbreviation 
					)drv   
	 WHERE			RwCnt = 1
	 ;


