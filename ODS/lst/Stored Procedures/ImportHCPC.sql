-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [lst].[ImportHCPC](
   --[CreatedDate] [datetime] NOT NULL,
	@CreatedBy varchar(50) ,
	--[LastUpdated] [datetime] NOT NU,
	@LastUpdatedBy varchar(50),
	@SrcFileName varchar(50) ,
    @HCPC_MOD varchar(20),
	@ACTION_CD varchar(20),
	@SHORT_DESC varchar(50),
	@LONG_DESC varchar(8000),
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
 
 EXEC [AceMasterData].[lst].[ImportHCPC]
      --[CreatedDate] [datetime] NOT NULL,
	@CreatedBy ,
	--[LastUpdated] [datetime] NOT NU,
	@LastUpdatedBy ,
	@SrcFileName ,
    @HCPC_MOD ,
	@ACTION_CD ,
	@SHORT_DESC ,
	@LONG_DESC ,
	@ACTIVE ,
	@EffectiveDate ,
	@ExpirationDate 	
   
   END


