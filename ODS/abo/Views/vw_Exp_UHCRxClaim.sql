﻿

CREATE VIEW [abo].[vw_Exp_UHCRxClaim]
AS 
SELECT
       [RXClaimKey]
	   ,[CreateDate]
      ,[CreateBy]
      ,[DwDate]
      ,[DwKey]
      ,[ClientKey]
      ,[ExtractID]
      ,[ClaimStatusCode]
      ,[ProviderNPI]
      ,[ServiceDate]
      ,[PatientID]
      ,[ClaimID]
      ,[NDCCode]
      ,[RxID]
      ,[FillDate]
      ,[NumberofServiceS]
      ,[NumberofScriptsDispensed]
      ,[DaysSupply]
      ,[PaidDate]
      ,[BrandGenericIndicator]
      ,[AdjustmentSequenceNumber]
      ,[ClaimLineNumber]
      ,[TherapeuticClassCode]
      ,[ProviderLastName]
      ,[ProviderPhoneNumber]
      ,[ProviderTIN]
      ,[PracticeName]
      ,[ProviderFirstName]
      ,[ProviderStreetAddress1]
      ,[ProviderCity]
      ,[ProviderState]
      ,[ProviderZipCode]
      ,[DrugFormulation]
      ,[AWPAmount]
  FROM [ACECAREDW_TEST].[adi].[vw_Exp_UHCRxClaim]

