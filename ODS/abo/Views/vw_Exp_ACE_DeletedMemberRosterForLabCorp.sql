



/*
Purpose: Export of our Members for Labcorp. Required to have 1 AceID for 
BRIT: 

BY: Format DATE_OF_BRTH AS YYYY-MM-DD
**/

CREATE VIEW [abo].[vw_Exp_ACE_DeletedMemberRosterForLabCorp]

AS				

SELECT 
    [First_Name]
      ,[Middle_Name]
      ,[Last_Name]
      ,[DOB]
      ,[Gender]
      ,[Race_code]
      ,[DriversLicenseNumber]
      ,[DriversLicenseState]
      ,[SSN9]
      ,[SSN4]
      ,[MRN]
      ,[Ordering_Account_Number]
      ,[Address_Line1]
      ,[Address_Line2]
      ,[city]
      ,[state]
      ,[zip5]
      ,[zip4]
      ,[country]
      ,[Primary_phone]
      ,[CellPhone]
      ,[Home_Phone]
      ,[Email_Address]
      ,[Payer_name]
      ,[Payor_group_Number]
      ,[Member_ID]
      ,[Subscriber_ID]
      ,[Unique_Request_ID]
      ,[Record_Indicator]
      ,[SendDate]

  FROM [ACECAREDW].[adi].[LabCorp_MemberSend]
  where Record_Indicator != 'D' AND  [Unique_Request_ID] not in (
  Select UniqueRequestID
    FROM [abo].[vw_Exp_ACEMemberRosterForLabCorp]
)

