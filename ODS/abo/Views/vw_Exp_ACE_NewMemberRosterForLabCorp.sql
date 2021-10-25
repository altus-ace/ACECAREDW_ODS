




/*
Purpose: Export of our Members for Labcorp. Required to have 1 AceID for 
BRIT: 

BY: Format DATE_OF_BRTH AS YYYY-MM-DD
**/

CREATE VIEW [abo].[vw_Exp_ACE_NewMemberRosterForLabCorp]

AS				
SELECT CellPhone, Country, DATE_OF_BIRTH, DriversLicenseNumber, DriversLicenseState, EmailAddress, FIRST_NAME, GENDER, HomePhone, LAST_NAME, MEMBER_HOME_ADDRESS, MEMBER_HOME_ADDRESS2, MEMBER_HOME_CITY, MEMBER_HOME_STATE, MEMBER_HOME_ZIP5, MIDDLE_NAME, MRN, MemberID, MemberPrimaryPhone, Ordering_Account_Number, PayerGroupNumber, PayerName, RaceCode, RecordIndicator, SSN4, SSN9, SubscriberID, UniqueRequestID, zip4 
FROM [abo].[vw_Exp_ACEMemberRosterForLabCorp]
WHERE UniqueRequestID not in 
(SELECT [Unique_Request_ID]FROM [adi].[LabCorp_MemberSend])

