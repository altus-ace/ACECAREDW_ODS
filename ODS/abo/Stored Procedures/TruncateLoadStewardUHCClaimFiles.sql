-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [abo].[TruncateLoadStewardUHCClaimFiles]
   



	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE	@ClientKey int
    SET @ClientKey = 1

EXEC	[ACDW_CLMS_UHC].[adi].[sp_TruncateAndLoadStewardClaimFiles] @ClientKey
    
END




