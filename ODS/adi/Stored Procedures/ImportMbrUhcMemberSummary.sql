-- =============================================
-- Author:		Bing Yu
-- Create date: 03/21/2019
-- Description:	Insert UHC Memebership info to UHC Memeber DB
-- =============================================
CREATE PROCEDURE [adi].[ImportMbrUhcMemberSummary]
( 
        @SrcFileName varchar(100) ,
		--[LoadDate] [date] NOT NULL,
		@DataDate varchar(12),
		--[CreatedDate] [datetime] NOT NULL,
		@CreatedBy varchar(50),
		--[LastUpdatedDate] [datetime] NOT NULL,
		@LastUpdatedBy varchar(50),
		@ACE_MBR_ID varchar(255),
		@MEDICAID_ID varchar(255),
		@MEMBER_LAST_NAME varchar(255),
		@MEMBER_FIRST_NAME varchar(255),
		@DATE_OF_BIRTH varchar(255),
		@IPRO_ADMIT_RISK_SCORE varchar(255),
		@UHC_SUBSCRIBER_ID varchar(255) ,
		@UHC_UNIQUE_SYSTEM_ID varchar(255) ,
		@MEMBER_ADDRESS varchar(255),
		@MEMBER_CITY varchar(255),
		@MEMBER_STATE varchar(255),
		@MEMBER_COUNTY varchar(255) ,
		@MEMBER_ZIP varchar(255),
		@MEMBER_PHONE varchar(255),
		@LINE_OF_BUSINESS varchar(255),
		@PLAN_CODE varchar(255) ,
		@PLAN_DESC varchar(255) ,
		@REGION_CODE varchar(255),
		@REGION_DESC varchar(255) ,
		@PCP_NAME varchar(255),
		@PCP_ADDRESS varchar(255),
		@PCP_CITY varchar(255),
		@PCP_STATE varchar(255),
		@PCP_COUNTY varchar(255),
		@PCP_ZIP varchar(255),
		@PCP_PRACTICE_TIN varchar(255),
		@PCP_PRACTICE_NAME varchar(255),
		@PRIMARY_RISK_FACTOR varchar(255) ,
		@TOTAL_COSTS_LAST_12_MOS varchar(255),
		@COUNT_OPEN_CARE_OPPS varchar(255),
		@INP_COSTS_LAST_12_MOS varchar(255),
		@ER_COSTS_LAST_12_MOS varchar(255),
		@OUTP_COSTS_LAST_12_MOS varchar(255),
		@PHARMACY_COSTS_LAST_12_MOS varchar(255),
		@PRIMARY_CARE_COSTS_LAST_12_MOS varchar(255) ,
		@BEHAVIORAL_COSTS_LAST_12_MOS varchar(255) ,
		@OTHER_OFFICE_COSTS_LAST_12_MOS varchar(255),
		@INP_ADMITS_LAST_12_MOS varchar(255) ,
		@LAST_INP_DISCHARGE varchar(255),
		@POST_DISCHARGE_FUP_VISIT varchar(255),
		@INP_FUP_WITHIN_7_DAYS varchar(255),
		@ER_VISITS_LAST_12_MOS varchar(255),
		@LAST_ER_VISIT varchar(255) ,
		@POST_ER_FUP_VISIT varchar(255),
		@ER_FUP_WITHIN_7_DAYS varchar(255),
		@LAST_PCP_VISIT varchar(255),
		@LAST_PCP_PRACTICE_SEEN varchar(255),
		@LAST_BH_VISIT varchar(255),
		@LAST_BH_PRACTICE_SEEN varchar(255) ,
		@MEMBER_MONTH_COUNT varchar(255) ,
		@FILE_GENERATION_DATE varchar(255),
		@REPORT_MONTH varchar(255)
)

   
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--	UPDATE UHCMember 
--	SET FirstName = @FirstName,
--	    LastName = @LastName

 --   WHERE SubscriberID = @SubscriberID
	 
--	IF @@ROWCOUNT = 0
	BEGIN
    -- Insert statements 
		INSERT INTO adi.MbrUhcMemberSummary
		(
		[SrcFileName] ,
		[LoadDate] ,
		[DataDate] ,
		[CreatedDate] ,
		[CreatedBy] ,
		[LastUpdatedDate] ,
		[LastUpdatedBy] ,
		[ACE_MBR_ID] ,
		[MEDICAID_ID] ,
		[MEMBER_LAST_NAME] ,
		[MEMBER_FIRST_NAME],
		[DATE_OF_BIRTH] ,
		[IPRO_ADMIT_RISK_SCORE] ,
		[UHC_SUBSCRIBER_ID] ,
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
		[PCP_ZIP],
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
		[BEHAVIORAL_COSTS_LAST_12_MOS],
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
		[REPORT_MONTH] 

											 														
		)
		VALUES (
		       
         @SrcFileName,
		 GETDATE(),
		--@DataDate,
		GETDATE(),
		--CONVERT(DATE, Substring(@SrcFileName, CHARINDEX('rt', @SrcFileName) + + 3, 7) + '-01'),
		GETDATE(),
		@CreatedBy ,
		GETDATE(),
		@LastUpdatedBy ,
		@ACE_MBR_ID ,
		@MEDICAID_ID ,
		@MEMBER_LAST_NAME ,
		@MEMBER_FIRST_NAME ,
		@DATE_OF_BIRTH ,
		@IPRO_ADMIT_RISK_SCORE ,
		@UHC_SUBSCRIBER_ID ,
		@UHC_UNIQUE_SYSTEM_ID ,
		@MEMBER_ADDRESS ,
		@MEMBER_CITY ,
		@MEMBER_STATE ,
		@MEMBER_COUNTY  ,
		@MEMBER_ZIP ,
		@MEMBER_PHONE ,
		@LINE_OF_BUSINESS ,
		@PLAN_CODE ,
		@PLAN_DESC ,
		@REGION_CODE ,
		@REGION_DESC ,
		@PCP_NAME ,
		@PCP_ADDRESS ,
		@PCP_CITY ,
		@PCP_STATE ,
		@PCP_COUNTY ,
		@PCP_ZIP ,
		@PCP_PRACTICE_TIN ,
		@PCP_PRACTICE_NAME ,
		@PRIMARY_RISK_FACTOR,
		@TOTAL_COSTS_LAST_12_MOS ,
		@COUNT_OPEN_CARE_OPPS ,
		@INP_COSTS_LAST_12_MOS ,
		@ER_COSTS_LAST_12_MOS ,
		@OUTP_COSTS_LAST_12_MOS ,
		@PHARMACY_COSTS_LAST_12_MOS ,
		@PRIMARY_CARE_COSTS_LAST_12_MOS ,
		@BEHAVIORAL_COSTS_LAST_12_MOS ,
		@OTHER_OFFICE_COSTS_LAST_12_MOS ,
		@INP_ADMITS_LAST_12_MOS ,
		@LAST_INP_DISCHARGE ,
		@POST_DISCHARGE_FUP_VISIT ,
		@INP_FUP_WITHIN_7_DAYS ,
		@ER_VISITS_LAST_12_MOS ,
		@LAST_ER_VISIT ,
		@POST_ER_FUP_VISIT ,
		@ER_FUP_WITHIN_7_DAYS ,
		@LAST_PCP_VISIT ,
		@LAST_PCP_PRACTICE_SEEN ,
		@LAST_BH_VISIT ,
		@LAST_BH_PRACTICE_SEEN  ,
		@MEMBER_MONTH_COUNT  ,
		@FILE_GENERATION_DATE ,
		@REPORT_MONTH
	
	) 

    END
END




