

CREATE VIEW [abo].[vw_Exp_AetneMAClaimMember]
AS 
SELECT 
     MbrKey
     ,[CreateDate]  

      ,[CreateBy]
      ,[DwDate]
      ,[DwKey]
      ,[ClientKey]
      ,[PatientID]
      ,[AltPatientID]
      ,[MemberFirstName]
      ,[MemberMiddleInitial]
      ,[MemberLastName]
      ,[MemberBirthDate]
      ,[MemberGender]
      ,[MemberAddressLine1]
      ,[MemberAddressLine2]
      ,[MemberCity]
      ,[MemberState]
      ,[MemberZip]
  FROM [ACECAREDW_TEST].[adi].[vw_Exp_AetnaMAClaimMember]     

