

-- =============================================
-- Author:		Bing Yu
-- Create date: 09/08/2020
-- Description:	Insert 
-- ============================================
CREATE PROCEDURE [adi].[ImportAmerigroup_CodeSets]
    @OriginalFileName  varchar(100)  ,
	@SrcFileName  varchar(100)  ,
	@LoadDate varchar(10) ,
	--@CreatedDate  
	@DataDate varchar(10) ,  
	@FileDate varchar(10) , 
	@CreatedBy  varchar(50)  ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy  varchar(50)  ,
	@CodeSet  varchar(40) ,
	@CodeValue  varchar(100) ,
	@CodeValueName  varchar(1000) ,
	@SystemRecordCode  varchar(10) ,
	@ProductSystemRecordCode  char(10) 
 
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	EXEC [ACDW_CLMS_AMGTX_MA].[adi].[ImportAmerigroup_CodeSets]
	  @OriginalFileName    ,
	@SrcFileName    ,
	@LoadDate  ,
	--@CreatedDate  
	@DataDate ,  
	@FileDate  , 
	@CreatedBy   ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy    ,
	@CodeSet  ,
	@CodeValue   ,
	@CodeValueName   ,
	@SystemRecordCode   ,
	@ProductSystemRecordCode  

END




