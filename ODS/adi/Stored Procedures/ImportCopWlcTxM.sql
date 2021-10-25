-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert Wellcare CareGaps file to DB
-- 
-- =============================================
CREATE PROCEDURE [adi].[ImportCopWlcTxM]
@ProviderID varchar(50), 
@ProviderName varchar(150),
@MemberName varchar(150),
@Subscriber varchar(50),
@DOB varchar(10),
@Phone varchar(50),
@STARTFlag varchar(50),
@MeasureID varchar(20),
@Measure varchar(100),
@ComplianceStatus varchar(50),
@ComplianceDetail varchar(100),
@LastKnownServiceDate varchar(20),
@ServiceStartDate varchar(20),
@ServiceEndDate varchar(20),
@ClaimsThruDate varchar(12),
@StarMeasureComplianceUpdatedThru  varchar(50),
@NPI varchar(50),
@NPIName varchar(150),
@MedicareID varchar(50),
@MedicaidID varchar(50),
@HPRFlag varchar(50),
@P4QFlag varchar(50),
@Category varchar(150),
@BaseValue varchar(100),
@SrcFileName varchar(100),
@FileDate varchar(12),
@DataDate varchar(20),
--@CreateDate datetime, 
@CreatedBy varchar(100), 
@OriginalFileName varchar(100)    
  
          
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--UPDATE adi.[stg_claims] 
	--SET FirstName = @FirstName,
	--    LastName = @LastName

 --   WHERE SUBSCRIBER_ID = @SUBSCRIBER_ID
--	and 
	--DECLARE @RecordExist INT
	--SET @RecordExist = (SELECT COUNT(*) 
	--FROM adi.[CopWlcTxM]
	--WHERE SrcFileName = @SrcFileName)

 --   IF @RecordExist = 0
	--BEGIN
    IF (LEN(@Subscriber) > 0)
	BEGIN
    -- Insert statements 
    INSERT INTO adi.[CopWlcTxM]
    (
	[ProviderID],
	[ProviderName],
	[MemberName] ,
	[Subscriber] ,
	[DOB] ,
	[Phone],
	[STARFlag],
	[MeasureID],
	[Measure],
	[ComplianceStatus] ,
	[ComplianceDetail],
	[LastKnownServiceDate],
	[ServiceStartDate] ,
	[ServiceEndDate],
	[ClaimsThruDate],
	[StarMeasureComplianceUpdatedThru ],
	[NPI],
	[NPIName],
	[MedicareID],
	[MedicaidID],
	[HPRFlag],
	[P4QFlag],
	[Category] ,
	[BaseValue],
	[SrcFileName],
	[FileDate],
	[DataDate], 
	[CreateDate],
	[CreateBy],
	[OriginalFileName] ,
	LoadDate
	)
		
 VALUES   (
     
@ProviderID, 
@ProviderName,
@MemberName,
@Subscriber,
CASE WHEN (@DOB = '')
THEN null
ELSE CONVERT(DATE, @DOB)
END,
@Phone,
@STARTFlag,
@MeasureID ,
@Measure,
@ComplianceStatus,
@ComplianceDetail,
CASE WHEN (@LastKnownServiceDate   = '')
THEN null
ELSE CONVERT(DATE, @LastKnownServiceDate)
END,
CASE WHEN (@ServiceStartDate   = '')
THEN null
ELSE CONVERT(DATE, @ServiceStartDate )
END,
CASE WHEN (@ServiceEndDate  = '')
THEN null
ELSE CONVERT(DATE, @ServiceEndDate )
END,
CASE WHEN (@ClaimsThruDate = '')
THEN null
ELSE CONVERT(DATE, @ClaimsThruDate)
END,
CASE WHEN (@StarMeasureComplianceUpdatedThru = '')
THEN null
ELSE CONVERT(DATE, @StarMeasureComplianceUpdatedThru)
END,
@NPI ,
@NPIName ,
@MedicareID ,
@MedicaidID ,
@HPRFlag ,
@P4QFlag ,
@Category ,
@BaseValue ,
@SrcFileName, 
GETDATE(),
GETDATE(),
--CONVERT(date, RIGHT( Substring(@SrcFileName,1, (PATINDEX('%.xlsx%', @SrcFileName)-1)), 8)),
--CONVERT(date, RIGHT( Substring(@SrcFileName,1, (PATINDEX('%.xlsx%', @SrcFileName)-1)), 8)),
--CASE WHEN (@FileDate = '')
--THEN null
--ELSE CONVERT(date, @FileDate)
--END,
--CASE WHEN (@DataDate = '')
--THEN null
--ELSE CONVERT(date, @DataDate)
--END,
GETDATE(), 
@CreatedBy, 
@OriginalFileName,
DATEADD(mm, DATEDIFF(mm,0, GETDATE()), 0)
)
END
END



