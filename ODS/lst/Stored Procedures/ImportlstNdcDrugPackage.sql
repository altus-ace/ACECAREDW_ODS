-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [lst].[ImportlstNdcDrugPackage](
    --[CreatedDate] [datetime] NOT NULL,
	@CreatedBy [varchar](50) ,
	--[LastUpdated] [datetime] NOT NULL,
	@LastUpdatedBy [varchar](50) ,
	@SrcFileName [varchar](50) ,
	@PRODUCTID [varchar](50) ,
	@PRODUCTNDC [varchar](15) ,
	@NDCPACKAGECODE [varchar](20) ,
	@NdcPackageCode_Clean varchar(20),
	@PACKAGEDESCRIPTION [varchar](1000) ,
    @STARTMARKETINGDATE varchar(10),
	@ENDMARKETINGDATE varchar(10),
	@NDC_EXCLUDE_FLAG varchar(10),
	@SAMPLE_PACKAGE varchar(10),
	@EffectiveDate vARCHAR(10),
	@ExpirationDate VARCHAR(10)
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    EXEC [AceMasterData].[lst].[ImportlstNdcDrugPackage]
	@CreatedBy ,
	--[LastUpdated] [datetime] NOT NULL,
	@LastUpdatedBy ,
	@SrcFileName  ,
	@PRODUCTID  ,
	@PRODUCTNDC ,
	@NDCPACKAGECODE ,
	@NdcPackageCode_Clean,
	@PACKAGEDESCRIPTION ,
    @STARTMARKETINGDATE ,
	@ENDMARKETINGDATE ,
	@NDC_EXCLUDE_FLAG ,
	@SAMPLE_PACKAGE ,
	@EffectiveDate ,
	@ExpirationDate 
END

