


CREATE VIEW dbo.vw_Exp_8x8CRM_CallCenter

AS

SELECT [MembersIDNumber]
      ,[Customers.First_name]
      ,[Customers.Last_name]
      ,[Customers.Email]
      ,[Customers.Alternative]
      ,[Customers.Voice]
      ,[DateOfBirth]
      ,[PrimaryAddress]
      ,[MemberHomeCity]
      ,[MemberHomeState]
      ,[MEMBERHOMEZIP]
      ,[Secondary Address]
      ,[Secondary City]
      ,[Scondary State]
      ,[Secondary Zip]
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
  