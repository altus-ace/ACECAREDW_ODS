-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [lst].[ImportCPT](
    	
	@CreatedBy varchar(50),
	--[LastUpdated] [datetime] NOT NULL,
	@LastUpdatedBy varchar(50),
	@SrcFileName varchar(50) ,
	@CPT_CODE varchar(20),
	@CPT_DESC varchar(100) ,
	@CPT_VER int ,
	@ACTIVE char(1),
	@EffectiveDate varchar(12),
	@ExpirationDate varchar(12)
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
 EXEC [AceMasterData].[lst].[ImportCPT] 
     @CreatedBy ,
	--[LastUpdated] [datetime] NOT NULL,
	@LastUpdatedBy ,
	@SrcFileName ,
	@CPT_CODE ,
	@CPT_DESC ,
	@CPT_VER ,
	@ACTIVE ,
	@EffectiveDate ,
	@ExpirationDate 
   
 END


