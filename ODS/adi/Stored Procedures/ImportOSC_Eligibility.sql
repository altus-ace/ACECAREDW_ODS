-- =============================================
-- Author:		Bing Yu
-- Create date: 01/31/2020
-- Description:	Insert Membership file to DB
-- 
-- =============================================
CREATE PROCEDURE [adi].[ImportOSC_Eligibility]
 
	@SrcFileName varchar(100) ,
	@DataDate varchar(12),
	--@CreateDate  ,
	@CreateBy varchar(100) ,
	@OriginalFileName varchar(100) ,
	@LastUpdatedBy varchar(100),
	@LastUpdatedDate varchar(100),
	@PAYER_ID varchar(50),
    @MEMBER_ID varchar(50),
    @MBI varchar(50),
    @RELATIONSHIP_TO_SUBSCRIBER varchar(5),
    @LAST_NAME varchar(50),
    @FIRST_NAME varchar(50),
    @MIDDLE_NAME varchar(50),
    @DATE_OF_BIRTH varchar(12),
    @DATE_OF_DEATH varchar(12),
    @SEX char(1) ,
    @SSN varchar(12),
    @ADDRESS varchar(100),
    @CITY varchar(50),
    @STATE varchar(50),
    @ZIP_CODE varchar(20),
    @COUNTY_NAME varchar(50),
    @MEMBER_PHONE_NUMBER varchar(12),
    @MEMBER_EMAIL varchar(50),
    @SUBSCRIBER_ID varchar(30),
    @SUBSCRIBER_SSN varchar(12),
    @SUBSCRIBER_LAST_NAME varchar(50),
    @SUBSCRIBER_FIRST_NAME varchar(50),
    @SUBSCRIBER_DOB varchar(12),
    @SUBSCRIBER_SEX char(1),
    @LOW_INCOME_COPAY_CAT char(1),
    @DUAL_ELIGIBILITY_STATUS char(1),
    @COVERAGE_EFFECTIVE_DATE varchar(12),
    @COVERAGE_END_DATE varchar(12), 
    @PLAN_ID varchar(20),
    @PLAN_NAME varchar(50),
    @ATTRIBUTION_START_DATE varchar(12),
    @ATTRIBUTION_END_DATE varchar(12),
    @ATTRIBUTED_PCP_NPI varchar(50) 
         
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
	--DECLARE @FileNameDate varchar(100), @DateForFile DATE
	--SET @FileNameDate =  substring(@SrcFileName,charindex('.',@SrcFileName)+1,charindex('.',@SrcFileName)-1)
	--SET @DateForFile = CONVERT(DATE, SUBSTRING(@FileNameDate, 1, 8))
	--SET @DataDate = SUBSTRING(@FileNameDate, 1, 8)
	--SET @FileDate =  SUBSTRING(@FileNameDate, 1, 8)
	--SET @RecordExist = (SELECT COUNT(*) 
	--FROM adi.[CopWlcTxM]
	--WHERE SrcFileName = @SrcFileName)

 --   IF @RecordExist = 0
	--BEGIN
   -- IF (@Devoted_Member_ID != '' )

    -- Insert statements 

	 EXEC [ACDW_CLMS_OSC].[adi].[importOSCEligibility]
     @SrcFileName,
	 @DataDate,
	--@CreateDate  ,
	@CreateBy ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	@LastUpdatedDate ,
	@PAYER_ID ,
    @MEMBER_ID ,
    @MBI ,
    @RELATIONSHIP_TO_SUBSCRIBER ,
    @LAST_NAME ,
    @FIRST_NAME,
    @MIDDLE_NAME ,
    @DATE_OF_BIRTH ,
    @DATE_OF_DEATH ,
    @SEX  ,
    @SSN,
    @ADDRESS ,
    @CITY ,
    @STATE ,
    @ZIP_CODE ,
    @COUNTY_NAME ,
    @MEMBER_PHONE_NUMBER ,
    @MEMBER_EMAIL ,
    @SUBSCRIBER_ID,
    @SUBSCRIBER_SSN ,
    @SUBSCRIBER_LAST_NAME,
    @SUBSCRIBER_FIRST_NAME ,
    @SUBSCRIBER_DOB ,
    @SUBSCRIBER_SEX,
    @LOW_INCOME_COPAY_CAT ,
    @DUAL_ELIGIBILITY_STATUS ,
    @COVERAGE_EFFECTIVE_DATE ,
    @COVERAGE_END_DATE , 
    @PLAN_ID ,
    @PLAN_NAME ,
    @ATTRIBUTION_START_DATE ,
    @ATTRIBUTION_END_DATE ,
    @ATTRIBUTED_PCP_NPI
            
END
