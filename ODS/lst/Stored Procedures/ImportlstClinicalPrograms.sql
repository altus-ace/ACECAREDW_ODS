-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [lst].[ImportlstClinicalPrograms](
    @SrcFileName varchar(100) ,
	@DataDate varchar(10) ,
	--@CreatedDate datetime ,
	@CreatedBy varchar(50) ,
	--@LastUpdatedDate datetime ,
	@LastUpdatedBy varchar(50) ,
	@EffectiveDate varchar(10) ,
	@ExpirationDate varchar(10) ,
	@ProgramName varchar(50) ,
	@ProgramDescription varchar(250) ,
	@ProgramDesc_Short varchar(100)

)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    EXEC [AceMasterData].lst.ImportlstClinicalPrograms
	 @SrcFileName  ,
	@DataDate  ,
	--@CreatedDate datetime ,
	@CreatedBy  ,
	--@LastUpdatedDate datetime ,
	@LastUpdatedBy  ,
	@EffectiveDate  ,
	@ExpirationDate  ,
	@ProgramName  ,
	@ProgramDescription  ,
	@ProgramDesc_Short 

	 
   END


