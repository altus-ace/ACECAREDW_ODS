

-- =============================================
-- Author:		Bing Yu
-- Create date: 09/08/2020
-- Description:	Insert 
-- ============================================
CREATE PROCEDURE [adi].[ImportAmerigroupProdrGroupSummary]
    @OriginalFileName  varchar(100)  ,
	@SrcFileName  varchar(100)  ,
	@LoadDate varchar(10) ,
	--@CreatedDate  
	@DataDate varchar(10) ,  
	@FileDate varchar(10) , 
	@CreatedBy  varchar(50)  ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy  varchar(50)  ,
    @ProviderGroup varchar(20) ,
	@MeasurementYear varchar(20) ,
	@DateAsOf varchar(12)  ,
	@Measure varchar(50) ,
	@Sub_Measure varchar(50) ,
	@Focus_Measure varchar(20) ,
	@Compliant int  ,
	@Non_Compliant int  ,
	@Eligible_Population int  ,
	@RATE varchar(10) ,
	@NCQA_QC_Target50thPercentile varchar(10) ,
	@MembersTarget_50th varchar(20) 
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--DECLARE @DATE VARCHAR(8) , @YEAR VARCHAR(4), @MONTH VARCHAR(2), @DAY VARCHAR(2)	
	--SET @DATE =  SUBSTRING(@SrcFileName, (CHARINDEX('.',@SrcFileName)-8),8)
	--SET @YEAR = SUBSTRING(@DATE, 5,4)
	--SET @MONTH = SUBSTRING(@DATE, 1,2)
	--SET @DAY = SUBSTRING(@DATE, 3,2)
	EXEC [ACDW_CLMS_AMGTX_MA].[adi].[ImportAmerigroupProdrGroupSummary]
	 @OriginalFileName    ,
	@SrcFileName    ,
	@LoadDate  ,
	--@CreatedDate  
	@DataDate  ,  
	@FileDate  , 
	@CreatedBy    ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy    ,
    @ProviderGroup  ,
	@MeasurementYear  ,
	@DateAsOf   ,
	@Measure  ,
	@Sub_Measure  ,
	@Focus_Measure  ,
	@Compliant   ,
	@Non_Compliant  ,
	@Eligible_Population ,
	@RATE  ,
	@NCQA_QC_Target50thPercentile  ,
	@MembersTarget_50th  

  
END




