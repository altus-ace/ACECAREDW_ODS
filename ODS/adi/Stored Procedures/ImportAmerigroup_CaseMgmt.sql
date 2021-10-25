


-- =============================================
-- Author:		Bing Yu
-- Create date: 09/08/2020
-- Description:	Insert 
-- ============================================
CREATE PROCEDURE [adi].[ImportAmerigroup_CaseMgmt]
    @OriginalFileName  varchar(100)  ,
	@SrcFileName  varchar(100)  ,
	@LoadDate varchar(10) ,
	--@CreatedDate  
	@DataDate varchar(10) ,  
	@FileDate varchar(10) , 
	@CreatedBy  varchar(50)  ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy  varchar(50)  ,
    @MCID_MASTER_CONSUMER_ID  bigint ,
	@HLTH_PGM_ID  varchar(15) ,
	@HLTH_PGM_NM  varchar(150) ,
	@HLTH_PGM_BGN_DT  varchar(10)  ,
	@HLTH_PGM_END_DT  VARCHAR(10)  ,
	@HLTH_PGM_STTS_CD  varchar(10) ,
	@RFRNC_NBR  varchar(25) ,
	@MEMBER_KEY  varchar(32) ,
	@PG_ID  varchar(32) ,
	@PG_NAME  varchar(100) ,
	@PGM_STTS_RSN_CD  varchar(10) ,
	@PGM_CASE_CLSFCTN_CD  varchar(10) ,
	@PGM_CASE_TYPE_CD  varchar(15) 
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	EXEC [ACDW_CLMS_AMGTX_MA].[adi].[ImportAmerigroup_CaseMgmt]
	  @OriginalFileName   ,
	@SrcFileName    ,
	@LoadDate  ,
	--@CreatedDate  
	@DataDate  ,  
	@FileDate , 
	@CreatedBy    ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy   ,
    @MCID_MASTER_CONSUMER_ID   ,
	@HLTH_PGM_ID  ,
	@HLTH_PGM_NM   ,
	@HLTH_PGM_BGN_DT  ,
	@HLTH_PGM_END_DT   ,
	@HLTH_PGM_STTS_CD   ,
	@RFRNC_NBR   ,
	@MEMBER_KEY   ,
	@PG_ID   ,
	@PG_NAME   ,
	@PGM_STTS_RSN_CD   ,
	@PGM_CASE_CLSFCTN_CD   ,
	@PGM_CASE_TYPE_CD  
END




