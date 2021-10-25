



-- =============================================
-- Author:		Bing Yu
-- Create date: 09/08/2020
-- Description:	Insert 
-- ============================================
CREATE PROCEDURE [adi].[ImportAmerigroup_CLM_DIAG]
      @OriginalFileName  varchar(100)  ,
	@SrcFileName  varchar(100)  ,
	@LoadDate varchar(10) ,
	--@CreatedDate  
	@DataDate varchar(10) ,  
	@FileDate varchar(10) , 
	@CreatedBy  varchar(50)  ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy  varchar(50)  ,
   	@ClaimNbr  varchar(24) ,
	@ClaimAdjustmentNum  decimal(4, 0) ,
	@ClaimDispositionCode  varchar(5) ,
	@PG_ID  varchar(32) ,
	@PG_NAME  varchar(100) ,
	@CLM_ADJSTMNT_KEY  varchar(32) ,
	@LINE_Number varchar(6) ,
	@SEQUENCENUMBER  decimal(2, 0) ,
	@DIAG_CD  varchar(10) 
	
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	EXEC [ACDW_CLMS_AMGTX_MA].[adi].[ImportAmerigroup_CLM_DIAG]
	     @OriginalFileName   ,
	@SrcFileName  ,
	@LoadDate ,
	--@CreatedDate  
	@DataDate  ,  
	@FileDate  , 
	@CreatedBy    ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy    ,
   	@ClaimNbr  ,
	@ClaimAdjustmentNum  ,
	@ClaimDispositionCode  ,
	@PG_ID  ,
	@PG_NAME  ,
	@CLM_ADJSTMNT_KEY   ,
	@SEQUENCENUMBER   ,
	@LINE_Number,
	@DIAG_CD  
	


END




