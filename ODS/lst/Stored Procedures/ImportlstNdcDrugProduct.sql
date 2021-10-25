-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [lst].[ImportlstNdcDrugProduct](
    @srcFileName [varchar](100) ,
	@DataDate varchar(10) ,
	--[CreatedDate] [datetime] NOT NULL,
	@CreatedBy [varchar](50),
	--LastUpdatedDate] [datetime] NOT NULL,
	@LastUpdatedBy [varchar](50) ,
	@EffectiveDate varchar(10),
	@ExpirationDate varchar(10),
	@ProductID varchar(60) NULL,
	@ProductNDC [varchar](20) NULL,
	@ProductTypeName [varchar](50) NULL,
	@ProprietaryName [varchar](400) NULL,
	@ProprietaryNameSuffix [varchar](150) NULL,
	@NonProprietaryName [varchar](600) NULL,
	@DosageFormName [varchar](60) NULL,
	@RouteName [varchar](200) NULL,
	@StartMarketingDate varchar(10),
	@EndMarketingDate varchar(10),
	@MarketingCategoryName [varchar](50) NULL,
	@ApplicationNumber [varchar](20) NULL,
	@LabelerName [varchar](200) NULL,
	@SubstanceName [varchar](5000) NULL,
	@ActiveNumeratorStrength [varchar](1000) NULL,
	@ActiveIngredUnit [varchar](2500) NULL,
	@PharmClasses [varchar](5000) NULL,
	@DeaSchedule [varchar](10) NULL,
	@NdcExcludeFlag [char](1) NULL,
	@ListingRecordCertifiedThrough varchar(10),
	@Active char(1)
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    EXEC [AceMasterData].[lst].[ImportlstNdcDrugProduct]
	@srcFileName ,
	@DataDate  ,
	--[CreatedDate] [datetime] NOT NULL,
	@CreatedBy ,
	--LastUpdatedDate] [datetime] NOT NULL,
	@LastUpdatedBy  ,
	@EffectiveDate ,
	@ExpirationDate ,
	@ProductID ,
	@ProductNDC ,
	@ProductTypeName ,
	@ProprietaryName ,
	@ProprietaryNameSuffix ,
	@NonProprietaryName ,
	@DosageFormName ,
	@RouteName ,
	@StartMarketingDate ,
	@EndMarketingDate ,
	@MarketingCategoryName ,
	@ApplicationNumber ,
	@LabelerName ,
	@SubstanceName ,
	@ActiveNumeratorStrength ,
	@ActiveIngredUnit ,
	@PharmClasses ,
	@DeaSchedule ,
	@NdcExcludeFlag ,
	@ListingRecordCertifiedThrough,
	@Active

END

