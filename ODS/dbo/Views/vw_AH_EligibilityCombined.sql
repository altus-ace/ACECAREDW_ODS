
CREATE VIEW [dbo].[vw_AH_EligibilityCombined] AS 
SELECT [MEMBER_ID]
      ,[LOB]
      ,[BENEFIT PLAN]
      ,[INTERNAL/EXTERNAL INDICATOR]
      ,[START_DATE]
      ,[END_DATE]
FROM [dbo].[vw_AH_Eligibility]
UNION ALL
SELECT [MEMBER_ID]
      ,[LOB]
      ,[BENEFIT PLAN]
      ,[INTERNAL/EXTERNAL INDICATOR]
      ,[START_DATE]
      ,[END_DATE]
FROM   [dbo].[vw_AH_MSSP_Eligibility]
