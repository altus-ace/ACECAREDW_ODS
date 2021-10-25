CREATE VIEW [dbo].[vw.AH_EligibilityCombined] AS 
SELECT *
FROM [dbo].[vw_AH_Eligibility]
UNION ALL
SELECT *
FROM   [dbo].[vw_AH_MSSP_Eligibility]