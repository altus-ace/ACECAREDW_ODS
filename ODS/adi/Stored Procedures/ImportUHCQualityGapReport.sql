-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportUHCQualityGapReport](
    
	@SrcFileName [varchar](100),
	@OriginalFileName [varchar](100),
	--[LoadDate] [date] NOT NULL,
	@DataDate  varchar(20),
    --[CreatedDate] [datetime] NOT NULL,
	@CreatedBy [varchar](50),
	--[LastUpdatedDate] [datetime] NOT NULL,
	@LastUpdatedBy [varchar](50),
    @ProductSugroup varchar(50) ,
    @MemberId varchar(50) ,
    @MedicaidId varchar(50),
    @Lastname varchar(50),
    @Firstname varchar(50),
    @Gender varchar(10),
    @DOB varchar(10),
    @Telephone varchar(50),
    @MeasureId varchar(50),
    @MeasureDescription varchar(50),
    @SubmeasureId varchar(50),
    @SubmeasureDescription varchar(500),
    @ComplianceDate varchar(10),
    @COMPLIANCE varchar(50) ,
    @LOB varchar(50),
    @ProviderTINName varchar(50),
    @ProviderMedicaidId varchar(50),
    @ProviderLastname varchar(50),
    @ProviderFirstname varchar(50) ,
    @ProviderAddress1 varchar(50),
    @ProviderAddress2 varchar(50) ,
    @ProviderCity varchar(50),
    @ProviderCounty varchar(50),
    @ProviderState varchar(50) ,
    @ProviderZipcode varchar(20) ,
    @ProviderTelephone varchar(50),
    @ProviderLastVisit varchar(50) ,
    @ProviderTIN varchar(20),
    @ProviderNPI varchar(50),
    @ProviderMPIN varchar(50),
    @ProviderId varchar(50),
	@ReviewSet varchar(50)

)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
 INSERT INTO [adi].[UHCQualityGapReport]
   (
   	SrcFileName ,
	OriginalFileName ,
	[LoadDate] ,
	[DataDate] ,
    [CreatedDate] ,
	[CreatedBy] ,
	[LastUpdatedDate] ,
	[LastUpdatedBy] ,
    [ProductSugroup] ,
    MemberId ,
    MedicaidId ,
    Lastname ,
    Firstname ,
    Gender ,
    DOB ,
    Telephone ,
    MeasureId ,
    MeasureDescription ,
    SubmeasureId ,
    SubmeasureDescription ,
    ComplianceDate ,
    COMPLIANCE ,
    LOB ,
    ProviderTINName ,
    ProviderMedicaidId ,
    ProviderLastname ,
    ProviderFirstname ,
    ProviderAddress1 ,
    ProviderAddress2 ,
    ProviderCity ,
    ProviderCounty ,
    ProviderState ,
    ProviderZipcode ,
    ProviderTelephone ,
    ProviderLastVisit ,
    ProviderTIN ,
    ProviderNPI ,
    ProviderMPIN ,
    ProviderId,
	ReviewSet 
	)
     VALUES
   (
    
	@SrcFileName,
	@OriginalFileName ,
	GETDATE(),
	--[LoadDate] [date] NOT NULL,
	@DataDate ,
    GETDATE(),
	--[CreatedDate] [datetime] NOT NULL,
	@CreatedBy ,
	GETDATE(),
	--[LastUpdatedDate] [datetime] NOT NULL,
	@LastUpdatedBy ,
    @ProductSugroup ,
    @MemberId ,
    @MedicaidId ,
    @Lastname ,
    @Firstname ,
    @Gender ,
	CASE WHEN @DOB = ''
	THEN NULL
	ELSE CONVERT(DATE, @DOB)
	END,
    @Telephone ,
    @MeasureId ,
    @MeasureDescription ,
    @SubmeasureId ,
    @SubmeasureDescription ,
	CASE WHEN     @ComplianceDate = ''
	THEN NULL
	ELSE CONVERT(DATE,     @ComplianceDate)
	END,
    @COMPLIANCE ,
    @LOB ,
    @ProviderTINName ,
    @ProviderMedicaidId ,
    @ProviderLastname ,
    @ProviderFirstname ,
    @ProviderAddress1 ,
    @ProviderAddress2  ,
    @ProviderCity ,
    @ProviderCounty ,
    @ProviderState  ,
    @ProviderZipcode ,
    @ProviderTelephone ,
    @ProviderLastVisit ,
    @ProviderTIN ,
    @ProviderNPI ,
    @ProviderMPIN ,
    @ProviderId ,
	@ReviewSet 
	
   );
END


 