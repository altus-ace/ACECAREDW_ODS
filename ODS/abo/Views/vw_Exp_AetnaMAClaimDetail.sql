





CREATE VIEW [abo].[vw_Exp_AetnaMAClaimDetail]
AS 
SELECT 
       [LLKey]
	   ,[CreateDate]
      , [CreateBy]
      ,[DwDate]
      ,[DwKey]
      ,[ClientKey]
      ,[ClaimRecordID]
      ,[ClaimTypeDSC]
      ,[ClaimID]
      ,[ClaimLinenumber]
      ,[ClaimLineStatusCode]
      ,[LLServicingProviderNPI]
      ,[LLServicingProviderFirstName]
      ,[LLServicingProviderMiddle]
      ,[LLServicingProviderLastName]
      ,[LLPrimaryDiagnosisCode]
      ,[LLDiagnosisCode2]
      ,[LLDiagnosisCode3]
      ,[LLDiagnosisCode4]
      ,[LLDiagnosisCode5]
      ,[LLDiagnosisCode6]
      ,[LLDiagnosisCode7]
      ,[LLDiagnosisCode8]
      ,[LLDiagnosisCode9]
      ,[LLDiagnosisCode10]
      ,[LLDiagnosisCode11]
      ,[LLDiagnosisCode12]
      ,[RevenueCode]
      ,[HCPCS_CPTCode]
      ,[HCPCS_CPTModifierCode1]
      ,[HCPCS_CPTModifierCode2]
      ,[LLBilledAmount]
      ,[LLPaidAmount]
      ,[ServiceQuantity]
      ,[LLDateService]
      ,[LLPaidDate]
FROM [ACECAREDW_TEST].[adi].[vw_Exp_AetnaMAClaimDetail]

