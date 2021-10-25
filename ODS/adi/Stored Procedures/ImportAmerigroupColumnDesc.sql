

-- =============================================
-- Author:		Bing Yu
-- Create date: 09/08/2020
-- Description:	Insert 
-- ============================================
CREATE PROCEDURE [adi].[ImportAmerigroupColumnDesc]
    @OriginalFileName  varchar(100)  ,
	@SrcFileName  varchar(100)  ,
	@LoadDate varchar(10) ,
	--@CreatedDate  
	@DataDate varchar(10) ,  
	@FileDate varchar(10) , 
	@CreatedBy  varchar(50)  ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy  varchar(50)  ,
    @ColumnName [varchar](50) ,
	@Description [varchar](500) 
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
     EXEC [ACDW_CLMS_AMGTX_MA].[adi].[ImportAmerigroupColumnDesc]
	   @OriginalFileName   ,
	@SrcFileName   ,
	@LoadDate  ,
	--@CreatedDate  
	@DataDate  ,  
	@FileDate , 
	@CreatedBy    ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy    ,
    @ColumnName ,
	@Description 

END




