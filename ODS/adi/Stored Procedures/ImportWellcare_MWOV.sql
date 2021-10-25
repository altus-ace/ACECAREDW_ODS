
-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert Wellcare IPACLM Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportWellcare_MWOV]
    @IpaDisplayName [varchar](50) NULL,
	@VendorID [varchar](50) NULL,
	@VendorName [varchar](50) NULL,
	@TIN [varchar](50) NULL,
	@ProviderID [varchar](50) NULL,
	@ProName [varchar](50) NULL,
	@NPI [varchar](50) NULL,
	@Member [varchar](100) NULL,
	@DosYear varchar(10) NULL,
	@MbrCountUnique varchar(5),
	@NoVisitCount varchar(5),
	@NoVisitPercent varchar(10),
	@CountofHCCCountw_oNA varchar(5),
	@StdPreviouslyCapturedHCCs varchar(5),
	@StdRecapturedHCCs varchar(5),
	@StdRecaptureRate varchar(10),
	@AvgBaseScore varchar(5),
	@AvgDocumentedScore varchar(5),
	@AvgDroppedScore varchar(5),
	@AvgDroppedHCCScoreMax varchar(5),
	--@LoadDate [date] NOT NULL,
    @DataDate varchar(10),
	@srcFileName [varchar](100) ,
	--[CreatedDate] [datetime] NULL,
	@CreatedBy [varchar](50),
	@LastUpdatedBy [varchar](100) 
	--LastUpdatedDate] [datetime] NULL,    


            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC [ACDW_CLMS_WLC].[adi].[ImportWellcare_MWOV]
	 @IpaDisplayName ,
	@VendorID ,
	@VendorName ,
	@TIN ,
	@ProviderID ,
	@ProName ,
	@NPI ,
	@Member ,
	@DosYear ,
	@MbrCountUnique ,
	@NoVisitCount ,
	@NoVisitPercent ,
	@CountofHCCCountw_oNA ,
	@StdPreviouslyCapturedHCCs ,
	@StdRecapturedHCCs ,
	@StdRecaptureRate ,
	@AvgBaseScore ,
	@AvgDocumentedScore ,
	@AvgDroppedScore,
	@AvgDroppedHCCScoreMax ,
	--@LoadDate [date] NOT NULL,
    @DataDate ,
	@srcFileName ,
	--[CreatedDate] [datetime] NULL,
	@CreatedBy ,
	@LastUpdatedBy 
	--LastUpdatedDate] [datetime] NULL,  
    
END


