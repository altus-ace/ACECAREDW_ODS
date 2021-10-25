

CREATE VIEW [adw].[vw_Exp_AH_Eligibility]
AS 
    SELECT e.MEMBER_ID, 
       e.LOB, 
       e.[BENEFIT PLAN], 
       e.[INTERNAL/EXTERNAL INDICATOR], 
       e.START_DATE, 
       e.END_DATE
FROM dbo.vw_AH_EligibilityCombined e;
