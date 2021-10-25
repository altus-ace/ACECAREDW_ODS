-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[LoadFileExistIACDW_CLMS_DHTX](
    @RecordsExist char(1) output,
   	@SrcFileName varchar(100),
	@TableName VARCHAR(100) 
	
	 
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
	EXEC [ACDW_CLMS_DHTX].[adi].[LoadFileExist]
	@RecordsExist output,
	@SrcFileName,
	@TableName   

END






