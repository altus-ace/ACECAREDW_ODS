

CREATE PROCEDURE [lst].[ImportListDischargeDisposition](
 
	
 -- 	[CreatedDate] [datetime] NOT NULL,
	--[CreatedBy] [varchar](50) NOT NULL,
	--[LastUpdated] [datetime] NOT NULL,
	--[LastUpdatedBy] [varchar](50) NOT NULL,
	--[SrcFileName] [varchar](50) NULL,
	--[lstDischDispositionKey] [int] IDENTITY(1,1) NOT NULL,
	@DataDate varchar(12),
	@Disch_Disp_Code varchar(12),
	@Disch_Disp_CodeValue varchar(100),
	@Disch_Disp_Description varchar(1000),
	@Field varchar(50),
	@Version varchar(50) ,
	@ACTIVE char(1),
	@EffectiveDate  varchar(12),
	@ExpirationDate varchar(12),
	
	--@EffectiveDate varchar(20) ,
--	@ExpirationDate varchar(20) ,
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
    
	  
	--DECLARE @RecordExist INT
	--SET @RecordExist = (Select COUNT(*)
	--FROM adi.NtfUhcErCensus 
	--WHERE SrcFileName = @SrcFileName)
	 
--	IF @RecordExist =0
	

    -- Insert statements for procedure here
--IF(LEN(@PcpID) > 0)
-- BEGIN

EXEC [DEV_ACECAREDW].[lst].[ImportListDischargeDisposition]
    @DataDate ,
	@Disch_Disp_Code ,
	@Disch_Disp_CodeValue ,
	@Disch_Disp_Description ,
	@Field ,
	@Version ,
	@ACTIVE ,
	@EffectiveDate  ,
	@ExpirationDate ,
	
	--@EffectiveDate varchar(20) ,
--	@ExpirationDate varchar(20) ,
--	@CreatedDate datetime2(7),
	@CreatedBy ,
--	@LastUpdatedDate datetime2(7) ,
	@LastUpdatedBy  ,
	@SrcFileName  

 END


