



CREATE VIEW [dbo].[vw_AH_Exp_8x8CRM_CallCenter]

AS

SELECT  [MembersIDNumber]
      ,[CustomersFirst_name]
      ,[CustomersLast_name]
      ,[CustomersEmail]
      ,[CustomersAlternative]
      ,[CustomersVoice]
      ,[DateOfBirth]
      ,[PrimaryAddress]
      ,[MemberHomeCity]
      ,[MemberHomeState]
      ,[MEMBERHOMEZIP]
      ,[SecondaryAddress]
      ,[SecondaryCity]
      ,[ScondaryState]
      ,[SecondaryZip]
      ,[gender]
      ,[PCPName]
      ,[PCPPhone]
      ,[MCO]
      ,[MCOEffectiveDate]
      ,[MCOProduct]
      ,[LineOfBusiness]
      ,[HEDISGap]
      ,[HedisDateRange]
      ,[HEDISStatus]
      ,[CurrentAge]
      ,[Language]
      ,[Comments]
      ,[AppointmentDate]
      ,[CaregiverName]
      ,[PatientidentifiedHighRisk]
  FROM [ACDW_CLMS_SHCN_MSSP].[dbo].[vw_Exp_8x8CRM_CallCenter]
  
