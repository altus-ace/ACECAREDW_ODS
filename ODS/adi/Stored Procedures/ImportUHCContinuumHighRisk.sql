-- =============================================
-- Author:		Bing Yu
-- Create date: 01/21/2020
-- Description:	Insert UHC Continuum HighRisk to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportUHCContinuumHighRisk]
    
	@HotspotFlag char(1) ,
	@PSUFlag char(1),
	@NewMember char(1) ,
	@UHC_SUBSCRIBER_ID varchar(20),
	@MEDICAID_ID varchar(15) ,
	@MEMBER_LAST_NAME varchar(50) ,
	@MEMBER_FIRST_NAME varchar(50),
	@DATE_OF_BIRTH varchar(10),
	@IPRO_ADMIT_RISK_SCORE varchar(10),
	@UHC_UNIQUE_SYSTEM_ID varchar(20),
	@MEMBER_ADDRESS varchar(50),
	@MEMBER_CITY varchar(50),
	@MEMBER_STATE varchar(50),
	@MEMBER_COUNTY varchar(50),
	@MEMBER_ZIP varchar(12) ,
	@MEMBER_PHONE varchar(20) ,
	@LINE_OF_BUSINESS varchar(20),
	@PLAN_CODE varchar(20) ,
	@PLAN_DESC varchar(500),
	@REGION_CODE varchar(20) ,
	@REGION_DESC varchar(500) ,
	@PCP_NAME varchar(20),
	@PCP_ADDRESS varchar(100),
	@PCP_CITY varchar(50),
	@PCP_STATE varchar(20),
	@PCP_COUNTY varchar(50),
	@PCP_ZIP varchar(12) ,
	@PCP_PRACTICE_TIN varchar(20) ,
	@PCP_PRACTICE_NAME varchar(50),
	@PRIMARY_RISK_FACTOR varchar(20) ,
	@TOTAL_COSTS_LAST_12_MOS varchar(10),
	@COUNT_OPEN_CARE_OPPS varchar(5),
	@INP_COSTS_LAST_12_MOS varchar(10),
	@ER_COSTS_LAST_12_MOS varchar(10),
	@OUTP_COSTS_LAST_12_MOS varchar(10),
	@HARMACY_COSTS_LAST_12_MOS varchar(10),
	@PRIMARY_CARE_COSTS_LAST_12_MOS varchar(10),
	@BEHAVIORAL_COSTS_LAST_12_MOS varchar(10),
	@OTHER_OFFICE_COSTS_LAST_12_MOS varchar(10),
	@INP_ADMITS_LAST_12_MOS varchar(10),
	@LAST_INP_DISCHARGE varchar(12) ,
	@POST_DISCHARGE_FUP_VISIT varchar(12),
	@INP_FUP_WITHIN_7_DAYS varchar(5),
	@ER_VISITS_LAST_12_MOS varchar(5),
	@LAST_ER_VISIT varchar(12),
	@POST_ER_FUP_VISIT varchar(10),
	@ER_FUP_WITHIN_7_DAYS varchar(5)  ,
	@LAST_PCP_VISIT varchar(12),
	@LAST_PCP_PRACTICE_SEEN varchar(20),
	@LAST_BH_VISIT varchar(12),
	@LAST_BH_PRACTICE_SEEN varchar(20),
	@MEMBER_MONTH_COUNT varchar(5),
	@FILE_GENERATION_DATE varchar(12),
    @REPORT_MONTH varchar(6),
	--[LoadDate] [date] NOT NULL,
	@DataDate varchar(12),
	@SrcFileName varchar(100),
	--[CreatedDate] ,
	@CreatedBy varchar(50) ,
	--[LastUpdatedDate] [datetime] NOT NULL,
	@LastUpdatedBy [varchar](50)
	
	
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
    IF @UHC_SUBSCRIBER_ID <> ''
	BEGIN
    -- Insert statements 
	INSERT INTO adi.UHCContinuumHighRisk
	(
	[HotspotFlag],
	[PSUFlag] ,
	[NewMember] ,
	[UHC_SUBSCRIBER_ID] ,
	[MEDICAID_ID] ,
	[MEMBER_LAST_NAME] ,
	[MEMBER_FIRST_NAME],
	[DATE_OF_BIRTH] ,
	[IPRO_ADMIT_RISK_SCORE] ,
	[UHC_UNIQUE_SYSTEM_ID] ,
	[MEMBER_ADDRESS] ,
	[MEMBER_CITY] ,
	[MEMBER_STATE] ,
	[MEMBER_COUNTY] ,
	[MEMBER_ZIP] ,
	[MEMBER_PHONE] ,
	[LINE_OF_BUSINESS] ,
	[PLAN_CODE] ,
	[PLAN_DESC] ,
	[REGION_CODE] ,
	[REGION_DESC] ,
	[PCP_NAME] ,
	[PCP_ADDRESS] ,
	[PCP_CITY] ,
	[PCP_STATE] ,
	[PCP_COUNTY] ,
	[PCP_ZIP] ,
	[PCP_PRACTICE_TIN] ,
	[PCP_PRACTICE_NAME] ,
	[PRIMARY_RISK_FACTOR] ,
	[TOTAL_COSTS_LAST_12_MOS] ,
	[COUNT_OPEN_CARE_OPPS] ,
	[INP_COSTS_LAST_12_MOS] ,
	[ER_COSTS_LAST_12_MOS] ,
	[OUTP_COSTS_LAST_12_MOS] ,
	[PHARMACY_COSTS_LAST_12_MOS] ,
	[PRIMARY_CARE_COSTS_LAST_12_MOS] ,
	[BEHAVIORAL_COSTS_LAST_12_MOS] ,
	[OTHER_OFFICE_COSTS_LAST_12_MOS] ,
	[INP_ADMITS_LAST_12_MOS] ,
	[LAST_INP_DISCHARGE] ,
	[POST_DISCHARGE_FUP_VISIT] ,
	[INP_FUP_WITHIN_7_DAYS] ,
	[ER_VISITS_LAST_12_MOS] ,
	[LAST_ER_VISIT] ,
	[POST_ER_FUP_VISIT] ,
	[ER_FUP_WITHIN_7_DAYS] ,
	[LAST_PCP_VISIT] ,
	[LAST_PCP_PRACTICE_SEEN] ,
	[LAST_BH_VISIT] ,
	[LAST_BH_PRACTICE_SEEN] ,
	[MEMBER_MONTH_COUNT] ,
	[FILE_GENERATION_DATE] ,
	[REPORT_MONTH] ,
	[LoadDate] ,
	[DataDate] ,
	[SrcFileName] ,
	[CreatedDate] ,
	[CreatedBy] ,
	[LastUpdatedDate] ,
	[LastUpdatedBy]
 )
		
 VALUES   (
    @HotspotFlag ,
	@PSUFlag ,
	@NewMember ,
	CASE WHEN @UHC_SUBSCRIBER_ID = ''
	THEN NULL
	ELSE 
	CONVERT(numeric(15,0), @UHC_SUBSCRIBER_ID) 
	END,
	CASE WHEN @MEDICAID_ID = ''
	THEN NULL
	ELSE 
	CONVERT(numeric(15,0), @MEDICAID_ID) 
	END,
	@MEMBER_LAST_NAME ,
	@MEMBER_FIRST_NAME ,
	@DATE_OF_BIRTH ,
	@IPRO_ADMIT_RISK_SCORE ,
	@UHC_UNIQUE_SYSTEM_ID ,
	@MEMBER_ADDRESS ,
	@MEMBER_CITY ,
	@MEMBER_STATE ,
	@MEMBER_COUNTY ,
	@MEMBER_ZIP ,
	@MEMBER_PHONE ,
	@LINE_OF_BUSINESS ,
	@PLAN_CODE ,
	@PLAN_DESC ,
	@REGION_CODE  ,
	@REGION_DESC ,
	@PCP_NAME ,
	@PCP_ADDRESS ,
	@PCP_CITY ,
	@PCP_STATE ,
	@PCP_COUNTY ,
	@PCP_ZIP  ,
	@PCP_PRACTICE_TIN  ,
	@PCP_PRACTICE_NAME ,
	@PRIMARY_RISK_FACTOR  ,
	convert(money, REPLACE(@TOTAL_COSTS_LAST_12_MOS , ',','')),
--	@TOTAL_COSTS_LAST_12_MOS ,
	@COUNT_OPEN_CARE_OPPS ,
	convert(money, REPLACE(@INP_COSTS_LAST_12_MOS, ',','')),
    convert(money, REPLACE(@ER_COSTS_LAST_12_MOS , ',','')),
	convert(money, REPLACE(@OUTP_COSTS_LAST_12_MOS , ',','')),
	convert(money, REPLACE(@HARMACY_COSTS_LAST_12_MOS , ',','')),
	convert(money, REPLACE(@PRIMARY_CARE_COSTS_LAST_12_MOS , ',','')),
	convert(money, REPLACE(	@BEHAVIORAL_COSTS_LAST_12_MOS , ',','')),
	convert(money, REPLACE(@OTHER_OFFICE_COSTS_LAST_12_MOS , ',','')),
	@INP_ADMITS_LAST_12_MOS,
	CONVERT(date,@LAST_INP_DISCHARGE) ,
	CONVERT(date,@POST_DISCHARGE_FUP_VISIT ),
	@INP_FUP_WITHIN_7_DAYS,
	CONVERT(int, @ER_VISITS_LAST_12_MOS) ,
	CONVERT(date, @LAST_ER_VISIT) ,
	CONVERT(DATE, @POST_ER_FUP_VISIT) ,
	@ER_FUP_WITHIN_7_DAYS,
	CONVERT(DATE, @LAST_PCP_VISIT) ,
	@LAST_PCP_PRACTICE_SEEN ,
	CONVERT(DATE, @LAST_BH_VISIT) ,
	@LAST_BH_PRACTICE_SEEN ,
	CONVERT(smallint, @MEMBER_MONTH_COUNT) ,
	CONVERT(DATE, @FILE_GENERATION_DATE)  ,
    @REPORT_MONTH ,
	GETDATE(),
	--[LoadDate] [date] NOT NULL,
	@DataDate ,
	@SrcFileName ,
	GETDATE(),
	--[CreatedDate] ,
	@CreatedBy,
	GETDATE(),
	--[LastUpdatedDate] [datetime] NOT NULL,
	@LastUpdatedBy 
   
    )
    END
END



--