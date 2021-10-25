





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Top10_RiskScore] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
  SELECT TOP 10 PERCENT [MEMBER_ID]   
      ,IIF([LAST_PCP_VISIT] = ' ',0,IIF(LAST_PCP_VISIT IS NULL, 0,1)) AS HAS_PCP_VISIT_LST_12MOS
	  ,IPRO_ADMIT_RISK_SCORE
	  ,RISK_CATEGORY_C
  FROM [ACECAREDW].[dbo].[vw_UHC_ActiveMembers] t
  --GROUP BY MEMBER_ID
  
  ORDER BY HAS_PCP_VISIT_LST_12MOS ASC
	  ,CASE RISK_CATEGORY_C
	   WHEN 'HIGH' THEN 1
	   WHEN 'MED' THEN 2
	   WHEN 'LOW' THEN 3
	   ELSE 5
	   END
	  ,IPRO_ADMIT_RISK_SCORE DESC
END






