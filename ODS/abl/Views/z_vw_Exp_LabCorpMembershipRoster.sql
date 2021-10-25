

/*
Purpose: Export of our Members for Labcorp. Required to have 1 AceID for 
BRIT: 

BY: Format DATE_OF_BRTH AS YYYY-MM-DD PER LabCorp's requirement. DON't REMOVE IT !!!
**/

CREATE VIEW [abl].[z_vw_Exp_LabCorpMembershipRoster]

AS				

    SELECT			
					UniqueRequestID
					,MemberID
					,SubscriberID
					,FIRST_NAME
					,MIDDLE_NAME
					,LAST_NAME
					,CONVERT(VARCHAR(10), CONVERT(DATE,DATE_OF_BIRTH), 126) AS DATE_OF_BIRTH
					,GENDER
					,RaceCode
					,DriversLicenseNumber
					,DriversLicenseState
					,SSN9
					,SSN4
					,MRN
					,Ordering_Account_Number
					,MEMBER_HOME_ADDRESS
					,MEMBER_HOME_ADDRESS2
					,MEMBER_HOME_CITY
					,MEMBER_HOME_STATE
					,MEMBER_HOME_ZIP5
					,zip4
					,Country
					,MemberPrimaryPhone
					,CellPhone
					,HomePhone
					,EmailAddress
					,PayerName
					,PayerGroupNumber
					,RecordIndicator					
	FROM			[abl].[vw_Master_MembershipRoster];


