-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [lst].[ImportlstNtfConfigClient](
   
    @SrcFileName varchar(100),
	@CreatedBy varchar(50),
	@LastUpdatedBy varchar(50) ,
	@ClientKey varchar(5) ,
	@NtfType varchar(10),
	@NtfFollupDays varchar(5),
	@NtfFollupUpAnchorDate varchar(10)
   
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
	EXEC [AceMasterData].[lst].[ImportlstNtfConfigClient]
	@SrcFileName ,
	@CreatedBy ,
	@LastUpdatedBy ,
	@ClientKey ,
	@NtfType ,
	@NtfFollupDays ,
	@NtfFollupUpAnchorDate 
	
   END


