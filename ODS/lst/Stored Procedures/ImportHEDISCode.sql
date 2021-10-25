


CREATE PROCEDURE [lst].[ImportHEDISCode](
    @VALUE_SET_NAME varchar(100) ,
	@VALUE_SET_OID varchar(100),
	@VALUE_SET_VER varchar(50) ,
	@VALUE_CODE varchar(50) ,
	@VALUE_CODE_WithoutDot varchar(50),
	@VALUE_CODE_NAME varchar(max) ,
	@VALUE_CODE_SYSTEM varchar(50) ,
	@CODE_SYSTEM_OID varchar(50) ,
	@CODE_SYSTEM_VER varchar(50) ,
	@A_LAST_UPDATE_DATE datetime ,
	@A_LAST_UPDATE_BY varchar(20) ,
	@A_LAST_UPDATE_FLAG varchar(1) ,
	@ACTIVE varchar(2) ,
	@EffectiveDate varchar(20) ,
	@ExpirationDate varchar(20) ,
--	@CreatedDate datetime2(7),
	@CreatedBy varchar(50) ,
--	@LastUpdatedDate datetime2(7) ,
	@LastUpdatedBy varchar(50) ,
	@SrcFileName varchar(100) 
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
	  
	--DECLARE @RecordExist INT
	--SET @RecordExist = (Select COUNT(*)
	--FROM adi.NtfUhcErCensus 
	--WHERE SrcFileName = @SrcFileName)
	 
--	IF @RecordExist =0
	

    -- Insert statements for procedure here
--IF(LEN(@PcpID) > 0)
-- BEGIN
  
  
EXEC [AceMasterData].[lst].[ImportHEDISCode]
    @VALUE_SET_NAME ,
	@VALUE_SET_OID ,
	@VALUE_SET_VER ,
	@VALUE_CODE ,
	@VALUE_CODE_WithoutDot,
	@VALUE_CODE_NAME  ,
	@VALUE_CODE_SYSTEM ,
	@CODE_SYSTEM_OID ,
	@CODE_SYSTEM_VER ,
	@A_LAST_UPDATE_DATE ,
	@A_LAST_UPDATE_BY ,
	@A_LAST_UPDATE_FLAG ,
	@ACTIVE  ,
	@EffectiveDate  ,
	@ExpirationDate ,
--	@CreatedDate datetime2(7),
	@CreatedBy  ,
--	@LastUpdatedDate datetime2(7) ,
	@LastUpdatedBy ,
	@SrcFileName  

   END


