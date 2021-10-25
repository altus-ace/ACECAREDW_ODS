







-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Indiv_ICD] 
	-- Add the parameters for the stored procedure here
	 @Indiv_ICD varchar(100)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT DISTINCT a.SUBSCRIBER_ID
  FROM [ACECAREDW_TEST].[dbo].[Claims_Diags] a
  WHERE a.diagCode IN (@Indiv_ICD)
  GROUP BY a.SUBSCRIBER_ID;
END








