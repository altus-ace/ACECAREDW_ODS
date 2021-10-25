


-- =============================================
-- Author:		Joshi/Bing Yu
-- Create date: 04/29/2021
-- Description:	Insert 
-- ============================================
CREATE PROCEDURE [adi].[ImportAmerigroup_Monthly_CodeSets]
   @OriginalFileName [varchar](100),
	@SrcFileName [varchar](100), 
	@LoadDate [varchar](10), 
	--@CreatedDate [date], 
	@DataDate [varchar](10), 
	@FileDate [varchar](10), 
	@CreatedBy [varchar](50),
	--@[LastUpdatedDate] [datetime],
	@LastUpdatedBy [varchar](50),
	@CodeSet [varchar](40),
	@CodeValue [varchar](100),
	@CodeValueName [varchar](1000),
	@SystemRecordCode [varchar](10)
 
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	EXEC [ACDW_CLMS_AMGTX_MA].[adi].[ImportAmerigroup_Monthly_CodeSets]
	  @OriginalFileName ,
	@SrcFileName , 
	@LoadDate , 
	--@CreatedDate [date], 
	@DataDate  ,
	@FileDate  ,
	@CreatedBy,
	--@[LastUpdatedDate] [datetime],
	@LastUpdatedBy ,
	@CodeSet ,
	@CodeValue ,
	@CodeValueName ,
	@SystemRecordCode 

END

