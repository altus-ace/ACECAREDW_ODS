






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_MemberMonth] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
  SELECT DISTINCT UHC_SUBSCRIBER_ID as SUBSCRIBER
	,[PLAN_ID]
    ,[PRODUCT_CODE]
    ,[SUBGRP_ID]
	,[AUTO_ASSIGN]
  --,PCP_NPI
  --,PCP_LAST_NAME
  --,PCP_PRACTICE_TIN
  --,PCP_PRACTICE_NAME
  ,MONTH([A_LAST_UPDATE_DATE]) AS MBR_MTH ,YEAR([A_LAST_UPDATE_DATE]) AS MBR_YEAR
  FROM dbo.UHC_MembersByPCP a
  WHERE [LoadType] = 'P'
  AND A_LAST_UPDATE_DATE not in ('2017-07-24')
  ORDER BY UHC_SUBSCRIBER_ID, YEAR([A_LAST_UPDATE_DATE]), MONTH([A_LAST_UPDATE_DATE])
END







