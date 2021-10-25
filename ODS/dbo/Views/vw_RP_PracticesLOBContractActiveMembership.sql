




/****** Script for SelectTopNRows command from SSMS  ******/
  CREATE VIEW [dbo].[vw_RP_PracticesLOBContractActiveMembership]
  as

  SELECT DISTINCT P.[TAX_ID]
      ,P.[PRACTICE_NAME]
      ,CASE WHEN P.UHC ='X' THEN CONVERT(NVARCHAR(50),AM.UHC) ELSE 'NO' END AS UHC 
	  ,CASE WHEN P.UHC ='X' THEN AM.UHC ELSE 0 END AS UHC1 
     ,CASE WHEN P.WEllcare ='X' THEN CONVERT(NVARCHAR(50),[WellCare MA]) ELSE 'NO' END AS WELLCARE
	,CASE WHEN P.WEllcare ='X' THEN [WellCare MA] ELSE 0 END AS WELLCARE1
     ,CASE WHEN P.AETNA ='X' THEN CONVERT(NVARCHAR(50),AM.[AETNA MA]) ELSE 'NO' END AS [AETNA MEDICARE]
	,CASE WHEN P.AETNA ='X' THEN AM.[AETNA MA] ELSE 0 END AS AETNA1 
 --     ,'' AS [MOLINA]
      ,'' AS [IMPERIAL]
	 ,'' AS [AETNA COMM]
	 ,'' AS [CIGNA COMM]
     -- ,CASE WHEN P.[no contract] ='X' THEN CONVERT(NVARCHAR(50),P.[NO CONTRACT]) ELSE 'NO' END AS NO_CONTRACT
 FROM (select distinct c.TAX_ID,c.Practice_name,c.UHC,c.Aetna,s.WELLCARE from [dbo].[vw_RP_ProviderReferenceTool] c
 left join (select  distinct tax_id,Practice_name,Wellcare from [dbo].[vw_RP_ProviderReferenceTool] where WELLCARE='X' ) s on s.TAX_ID= c.TAX_ID ) P 
 LEFT JOIN (
SELECT DISTINCT [TIN]
      ,[PRACTICE_NAME]
      ,[ACE_CONTACT]
      ,[POD]
      ,[UHC]
      ,[WellCare MA]
      ,[AETNA MA]
      --,[MOLINA]
      ,[CIGNA]
  FROM [ACECAREDW].[dbo].[vw_RP_LOBPracticeActiveMembership] ) AS AM ON convert(int,AM.TIN)=convert(int,P.TAX_ID)
 



