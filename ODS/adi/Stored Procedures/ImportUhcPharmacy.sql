-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert UHC Pharmacy file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportUhcPharmacy]
    @SrcFileName varchar(100),
	@OriginalFileName varchar(100),
	@LoadDate varchar(100),
	--[date],
	@DataDate varchar(10),
	--date] NOT NULL,
	--[CreatedDate] [datetime] NOT NULL,
	@CreatedBy varchar(50) ,
	@LastUpdatedDate varchar(50), 
	--[datetime],
	@LastUpdatedBy varchar(50),
	@MEMBER_LAST_NAME varchar(50),
	@MEMBER_FIRST_NAME varchar(50),
	@DATE_OF_BIRTH varchar(10),
	--[date] NULL,
    @NDC_CODE varchar(50),
	@MEDICATION_NAME varchar(50),
	@DAYS_SUPPLY varchar(5),
	--int,
	@PRESCRIBE_DATE varchar(10),
	--[date] NULL,
	@PRESCRIPTION_NUMBER varchar(50), 
	--[numeric](20, 0) NULL,
	@PRESCRIBING_PROVIDER varchar(50),
	@PRESCRIBING_PROVIDER_PRACTICE varchar(100),
	@PRESCRIBING_PROVIDER_PHONE varchar(20),
	@FILL_DATE varchar(10), 
	--[date] NULL,
	@FILL_PHARMACY varchar(50),
	@IPRO_ADMIT_RISK_SCORE VARCHAR(10), 
	--[decimal](5, 2) NULL,
	@UHC_SUBSCRIBER_ID varchar(50),
	@UHC_UNIQUE_SYSTEM_ID varchar(50),
	@MEMBER_ADDRESS varchar(100) ,
	@MEMBER_CITY varchar(50),
	@MEMBER_STATE varchar(20),
	@MEMBER_COUNTY varchar(50),
	@MEMBER_ZIP varchar(10),
	@MEMBER_PHONE varchar(20),
	@PCP_NAME varchar(50),
	@PCP_ADDRESS varchar(100),
	@PCP_CITY varchar(20),
	@PCP_STATE varchar(20) ,
	@PCP_COUNTY varchar(50),
	@PCP_ZIP varchar(10),
	@PCP_PRACTICE_TIN varchar(20),
	@PCP_PRACTICE_NAME varchar(50) ,
	@LINE_OF_BUSINESS_DESC varchar(200),
	@PLAN_CODE varchar(20),
	@PLAN_DESC varchar(200) ,
	@FILE_GENERATION_DATE VARCHAR(10)
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
	 
--	IF @@ROWCOUNT = 0
	BEGIN
    -- Insert statements 
	INSERT INTO adi.UhcPharmacy
	(
	[SrcFileName],
	[OriginalFileName] ,
	[LoadDate] ,
	[DataDate] ,
	[CreatedDate] ,
	[CreatedBy] ,
	[LastUpdatedDate] ,
	[LastUpdatedBy] ,
	[MEMBER_LAST_NAME] ,
	[MEMBER_FIRST_NAME] ,
	[DATE_OF_BIRTH],
	[NDC_CODE],
	[MEDICATION_NAME] ,
	[DAYS_SUPPLY] ,
	[PRESCRIBE_DATE],
	[PRESCRIPTION_NUMBER] ,
	[PRESCRIBING_PROVIDER] ,
	[PRESCRIBING_PROVIDER_PRACTICE] ,
	[PRESCRIBING_PROVIDER_PHONE] ,
	[FILL_DATE],
	[FILL_PHARMACY],
	[IPRO_ADMIT_RISK_SCORE],
	[UHC_SUBSCRIBER_ID] ,
	[UHC_UNIQUE_SYSTEM_ID] ,
	[MEMBER_ADDRESS],
	[MEMBER_CITY] ,
	[MEMBER_STATE] ,
	[MEMBER_COUNTY] ,
	[MEMBER_ZIP] ,
	[MEMBER_PHONE] ,
	[PCP_NAME] ,
	[PCP_ADDRESS] ,
	[PCP_CITY] ,
	[PCP_STATE] ,
	[PCP_COUNTY] ,
	[PCP_ZIP] ,
	[PCP_PRACTICE_TIN] ,
	[PCP_PRACTICE_NAME] ,
	[LINE_OF_BUSINESS_DESC] ,
	[PLAN_CODE] ,
	[PLAN_DESC] ,
	[FILE_GENERATION_DATE] 
   
    )
		
 VALUES   (
    
    @SrcFileName,
	@OriginalFileName,
	GETDATE(),
	CASE WHEN @DataDate = '' 
	THEN NULL 
	ELSE CONVERT(date, @DataDate)
	END, 
	GETDATE(),
	@CreatedBy,
	GETDATE(),
	@LastUpdatedBy ,
	@MEMBER_LAST_NAME ,
	@MEMBER_FIRST_NAME ,
	CASE WHEN 	@DATE_OF_BIRTH  = '' 
	THEN NULL 
	ELSE CONVERT(date, 	@DATE_OF_BIRTH )
	END, 
	@NDC_CODE,
	@MEDICATION_NAME ,
	@DAYS_SUPPLY,
	CASE WHEN @PRESCRIBE_DATE  = '' 
	THEN NULL 
	ELSE CONVERT(date, @PRESCRIBE_DATE)
	END, 
	CASE WHEN @PRESCRIPTION_NUMBER  = '' 
	THEN NULL 
	ELSE CONVERT(numeric(20, 0), @PRESCRIPTION_NUMBER)
	END,
	@PRESCRIBING_PROVIDER ,
	@PRESCRIBING_PROVIDER_PRACTICE,
	@PRESCRIBING_PROVIDER_PHONE , 
	CASE WHEN @FILL_DATE  = '' 
	THEN NULL 
	ELSE CONVERT(date, @FILL_DATE)
	END,  
	@FILL_PHARMACY,
	CASE WHEN @IPRO_ADMIT_RISK_SCORE  = '' 
	THEN NULL 
	ELSE CONVERT(decimal(5,2), @IPRO_ADMIT_RISK_SCORE)
	END,
	@UHC_SUBSCRIBER_ID ,
	@UHC_UNIQUE_SYSTEM_ID ,
	@MEMBER_ADDRESS ,
	@MEMBER_CITY ,
	@MEMBER_STATE ,
	@MEMBER_COUNTY ,
	@MEMBER_ZIP ,
	@MEMBER_PHONE ,
	@PCP_NAME ,
	@PCP_ADDRESS,
	@PCP_CITY ,
	@PCP_STATE ,
	@PCP_COUNTY ,
	@PCP_ZIP ,
	@PCP_PRACTICE_TIN ,
	@PCP_PRACTICE_NAME ,
	@LINE_OF_BUSINESS_DESC ,
	@PLAN_CODE,
	@PLAN_DESC ,
	CASE WHEN @FILE_GENERATION_DATE   = '' 
	THEN NULL 
	ELSE CONVERT(date, @FILE_GENERATION_DATE)
	END
    )
    END
END



