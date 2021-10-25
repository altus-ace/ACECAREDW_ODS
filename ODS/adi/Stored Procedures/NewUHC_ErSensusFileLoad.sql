-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[NewUHC_ErSensusFileLoad](
   	@SrcFileName varchar(100),
	@RecordExist INT output
	 
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
	SET @RecordExist = (Select COUNT(*)
	FROM adi.NtfUhcErCensus 
	WHERE SrcFileName = @SrcFileName)
	 
--	IF @RecordExist =0
  --	BEGIN     
    -- Insert statements for procedure here


  ---END

END
