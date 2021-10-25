-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportHEDISMeasure](
  
    @MEASURE_ID varchar(20),
	@MEASURE_NAME varchar(100),
	@VALUE_SET_NAME varchar(100),
	@VALUE_SET_OID varchar(100),
	@ACTIVE varchar(2) ,
	@EffectiveDate varchar(20) ,
	@ExpirationDate varchar(20) ,
--	@CreatedDate datetime2(7),
	@CreatedBy varchar(50) ,
--	@LastUpdatedDate datetime2(7) ,
	@LastUpdatedBy varchar(50) ,
	@SrcFileName varchar(50) 
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    

	EXEC [AceMasterData].[adi].[ImportHEDISMeasure]
    @MEASURE_ID ,
	@MEASURE_NAME ,
	@VALUE_SET_NAME ,
	@VALUE_SET_OID ,
	@ACTIVE ,
	@EffectiveDate ,
	@ExpirationDate,
--	@CreatedDate datetime2(7),
	@CreatedBy ,
--	@LastUpdatedDate datetime2(7) ,
	@LastUpdatedBy ,
	@SrcFileName  
	
END


