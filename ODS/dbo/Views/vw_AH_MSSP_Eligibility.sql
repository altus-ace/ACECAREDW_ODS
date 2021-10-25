


CREATE VIEW [dbo].[vw_AH_MSSP_Eligibility]

AS

SELECT   [MEMBER_ID],
         [LOB],
         [BENEFIT PLAN],
         [INTERNAL/EXTERNAL INDICATOR],
         [START_DATE],
         [END_DATE]
FROM [ACDW_CLMS_SHCN_MSSP].[dbo].[vw_Exp_AH_Eligibility]
