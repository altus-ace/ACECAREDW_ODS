-- =============================================
-- Author:		Bing Yu
-- Create date: 03/21/2019
-- Description:	Insert UHC Memebership info to UHC Memeber DB
-- =============================================
CREATE PROCEDURE [adi].[ImportmbrUhcMbrByPcp]
( 
    @mbrFName varchar(75),
	@mbrMName varchar(75),
	@mbrLName varchar(75),
	@UHC_SUBSCRIBER_ID varchar(50),
	@CLASS varchar(20),
	@PLAN_ID varchar(20),
	@PRODUCT_CODE varchar(20),
	@SUBGRP_ID varchar(20),
	@SUBGRP_NAME varchar(100),
	@MEDICARE_ID varchar(12),
	@MEDICAID_ID varchar(9),
	@AGE varchar(5),
	@DATE_OF_BIRTH varchar(12),
	@GENDER varchar(20),
	@RELATIONSHIP_CODE varchar(20),
	@LANG_CODE varchar(20),
	@MEMBER_HOME_ADDRESS varchar(100),
	@MEMBER_HOME_ADDRESS2 varchar(100) ,
	@MEMBER_HOME_CITY varchar(40),
	@MEMBER_HOME_STATE varchar(20),
	@MEMBER_HOME_ZIP varchar(15) ,
	@MEMBER_HOME_PHONE varchar(25) ,
	@MEMBER_MAIL_ADDRESS varchar(100),
	@MEMBER_MAIL_ADDRESS2 varchar(100),
	@MEMBER_MAIL_CITY varchar(40) ,
	@MEMBER_MAIL_STATE varchar(20),
	@MEMBER_MAIL_ZIP varchar(15),
	@MEMBER_MAIL_PHONE varchar(25),
	@MEMBER_COUNTY_CODE varchar(10) ,
	@MEMBER_COUNTY varchar(50) ,
	@MEMBER_BUS_PHONE varchar(25) ,
	@DUAL_COV_FLAG varchar(20),
	@MEMBER_ORG_EFF_DATE varchar(12),
	@MEMBER_CONT_EFF_DATE varchar(12),
	@MEMBER_CUR_EFF_DATE varchar(12),
	@MEMBER_CUR_TERM_DATE varchar(12),
	@CLASS_PLAN_ID varchar(20),
	@RESP_LAST_NAME varchar(75),
	@RESP_FIRST_NAME varchar(75) ,
	@RESP_ADDRESS varchar(100) ,
	@RESP_ADDRESS2 varchar(100) ,
	@RESP_CITY varchar(40),
	@RESP_STATE varchar(20) ,
	@RESP_ZIP varchar(15),
	@RESP_PHONE varchar(25),
	@BROKER_ID varchar(50) ,
	@PCP_UHC_ID varchar(50),
	@PCP_FIRST_NAME varchar(75),
	@PCP_LAST_NAME varchar(75),
	@PCP_MPIN varchar(50),
	@PCP_NPI varchar(10),
	@PCP_PROV_TYPE_ID varchar(20),
	@PCP_PROV_TYPE varchar(50) ,
	@PCP_INDICATOR varchar(20) ,
	@CMG varchar(20),
	@PCP_PHONE varchar(25),
	@PCP_FAX varchar(25),
	@PCP_ADDRESS varchar(100),
	@PCP_ADDRESS2 varchar(100) ,
	@PCP_CITY varchar(40) ,
	@PCP_STATE varchar(20) ,
	@PCP_ZIP varchar(15),
	@PCP_COUNTY varchar(50),
	@PCP_EFFECTIVE_DATE varchar(12) ,
	@PCP_TERM_DATE varchar(12),
	@PCP_PRACTICE_TIN varchar(15),
	@PCP_GROUP_ID varchar(50),
	@PCP_PRACTICE_NAME varchar(100),
	@IND_PRACT_ID varchar(50),
	@IND_PRACT_NAME varchar(100),
	@RECERT_DATE varchar(12),
	@ETHNICITY varchar(10),
	@ETHNICITY_DESC varchar(50),
	@AUTO_ASSIGN varchar(50),
	@ASAP_ID varchar(50),
	@FEW_ID varchar(50),
	@LST_HRA_DATE varchar(12),
	@NXT_HRA_DATE varchar(12),
	@HRA_ID varchar(50),
	@MEMBER_EMail varchar(125),
	@PCP_Specialty_Code varchar(50) ,
	@PCP_Specialty varchar(255),
	@SourceFileName varchar(100),
	@LoadType char(2),
  -- [LoadDate] [date] NOT NULL,
	@DataDate varchar(12),
	--@CreateDate] [datetime2](7) NOT NULL,
	@CreateBy varchar(50),
	--[LastUpdatedDate] [datetime2](7) NOT NULL,
	@LastUpdatedBy varchar(50),
	@COB_FLAG varchar(20)     
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
    	 
	IF (@mbrFName != '' and @UHC_SUBSCRIBER_ID != '')
	BEGIN
    -- Insert statements 
	INSERT INTO adi.mbrUhcMbrByPcp
	(
	[mbrFName],
	[mbrMName],
	[mbrLName] ,
	[UHC_SUBSCRIBER_ID] ,
	[CLASS] ,
	[PLAN_ID] ,
	[PRODUCT_CODE] ,
	[SUBGRP_ID] ,
	[SUBGRP_NAME] ,
	[MEDICARE_ID] ,
	[MEDICAID_ID] ,
	[AGE] ,
	[DATE_OF_BIRTH] ,
	[GENDER] ,
	[RELATIONSHIP_CODE] ,
	[LANG_CODE] ,
	[MEMBER_HOME_ADDRESS] ,
	[MEMBER_HOME_ADDRESS2] ,
	[MEMBER_HOME_CITY] ,
	[MEMBER_HOME_STATE] ,
	[MEMBER_HOME_ZIP] ,
	[MEMBER_HOME_PHONE] ,
	[MEMBER_MAIL_ADDRESS] ,
	[MEMBER_MAIL_ADDRESS2] ,
	[MEMBER_MAIL_CITY] ,
	[MEMBER_MAIL_STATE] ,
	[MEMBER_MAIL_ZIP] ,
	[MEMBER_MAIL_PHONE] ,
	[MEMBER_COUNTY_CODE] ,
	[MEMBER_COUNTY] ,
	[MEMBER_BUS_PHONE] ,
	[DUAL_COV_FLAG] ,
	[MEMBER_ORG_EFF_DATE] ,
	[MEMBER_CONT_EFF_DATE] ,
	[MEMBER_CUR_EFF_DATE] ,
	[MEMBER_CUR_TERM_DATE] ,
	[CLASS_PLAN_ID] ,
	[RESP_LAST_NAME] ,
	[RESP_FIRST_NAME] ,
	[RESP_ADDRESS] ,
	[RESP_ADDRESS2] ,
	[RESP_CITY] ,
	[RESP_STATE] ,
	[RESP_ZIP] ,
	[RESP_PHONE] ,
	[BROKER_ID] ,
	[PCP_UHC_ID] ,
	[PCP_FIRST_NAME] ,
	[PCP_LAST_NAME] ,
	[PCP_MPIN] ,
	[PCP_NPI] ,
	[PCP_PROV_TYPE_ID] ,
	[PCP_PROV_TYPE] ,
	[PCP_INDICATOR] ,
	[CMG] ,
	[PCP_PHONE] ,
	[PCP_FAX] ,
	[PCP_ADDRESS] ,
	[PCP_ADDRESS2] ,
	[PCP_CITY] ,
	[PCP_STATE] ,
	[PCP_ZIP] ,
	[PCP_COUNTY] ,
	[PCP_EFFECTIVE_DATE] ,
	[PCP_TERM_DATE] ,
	[PCP_PRACTICE_TIN] ,
	[PCP_GROUP_ID] ,
	[PCP_PRACTICE_NAME] ,
	[IND_PRACT_ID] ,
	[IND_PRACT_NAME] ,
	[RECERT_DATE] ,
	[ETHNICITY] ,
	[ETHNICITY_DESC] ,
	[AUTO_ASSIGN] ,
	[ASAP_ID] ,
	[FEW_ID] ,
	[LST_HRA_DATE] ,
	[NXT_HRA_DATE] ,
	[HRA_ID] ,
	[MEMBER_EMail] ,
	[PCP_Specialty_Code] ,
	[PCP_Specialty] ,
	[SourceFileName] ,
	[LoadType] ,
	[LoadDate] ,
	[DataDate] ,
	[CreateDate] ,
	[CreateBy] ,
	[LastUpdatedDate] ,
	[LastUpdatedBy], 
	[COB_FLAG] 
											 														
		)
	VALUES (

	@mbrFName ,
	@mbrMName ,
	@mbrLName ,
	@UHC_SUBSCRIBER_ID ,
	@CLASS ,
	@PLAN_ID ,
	@PRODUCT_CODE ,
	@SUBGRP_ID ,
	@SUBGRP_NAME ,
	@MEDICARE_ID ,
	@MEDICAID_ID ,
	@AGE ,
	CASE WHEN @DATE_OF_BIRTH = ''
	THEN NULL
	ELSE CONVERT(DATE, @DATE_OF_BIRTH)
	END,
	@GENDER ,
	@RELATIONSHIP_CODE ,
	@LANG_CODE ,
	@MEMBER_HOME_ADDRESS ,
	@MEMBER_HOME_ADDRESS2  ,
	@MEMBER_HOME_CITY ,
	@MEMBER_HOME_STATE ,
	@MEMBER_HOME_ZIP  ,
	@MEMBER_HOME_PHONE  ,
	@MEMBER_MAIL_ADDRESS ,
	@MEMBER_MAIL_ADDRESS2 ,
	@MEMBER_MAIL_CITY  ,
	@MEMBER_MAIL_STATE ,
	@MEMBER_MAIL_ZIP ,
	@MEMBER_MAIL_PHONE ,
	@MEMBER_COUNTY_CODE ,
	@MEMBER_COUNTY  ,
	@MEMBER_BUS_PHONE ,
	@DUAL_COV_FLAG ,
	CASE WHEN @MEMBER_ORG_EFF_DATE = ''
	THEN NULL
	ELSE CONVERT(DATE, @MEMBER_ORG_EFF_DATE)
	END,
	CASE WHEN 	@MEMBER_CONT_EFF_DATE = ''
	THEN NULL
	ELSE CONVERT(DATE, 	@MEMBER_CONT_EFF_DATE)
	END,
	CASE WHEN @MEMBER_CUR_EFF_DATE  = ''
	THEN NULL
	ELSE CONVERT(DATE, 	@MEMBER_CUR_EFF_DATE )
	END,
	CASE WHEN @MEMBER_CUR_TERM_DATE  = ''
	THEN NULL
	ELSE CONVERT(DATE, @MEMBER_CUR_TERM_DATE)
	END,
	@CLASS_PLAN_ID ,
	@RESP_LAST_NAME ,
	@RESP_FIRST_NAME ,
	@RESP_ADDRESS ,
	@RESP_ADDRESS2  ,
	@RESP_CITY ,
	@RESP_STATE  ,
	@RESP_ZIP ,
	@RESP_PHONE ,
	@BROKER_ID ,
	@PCP_UHC_ID ,
	@PCP_FIRST_NAME ,
	@PCP_LAST_NAME ,
	@PCP_MPIN ,
	@PCP_NPI ,
	@PCP_PROV_TYPE_ID ,
	@PCP_PROV_TYPE  ,
	@PCP_INDICATOR ,
	@CMG ,
	@PCP_PHONE ,
	@PCP_FAX ,
	@PCP_ADDRESS ,
	@PCP_ADDRESS2 ,
	@PCP_CITY ,
	@PCP_STATE ,
	@PCP_ZIP ,
	@PCP_COUNTY ,
	CASE WHEN @PCP_EFFECTIVE_DATE = ''
	THEN NULL
	ELSE CONVERT(DATE, @PCP_EFFECTIVE_DATE)
	END,
	CASE WHEN @PCP_TERM_DATE = ''
	THEN NULL
	ELSE CONVERT(DATE, @PCP_TERM_DATE)
	END,
	@PCP_PRACTICE_TIN ,
	@PCP_GROUP_ID ,
	@PCP_PRACTICE_NAME ,
	@IND_PRACT_ID,
	@IND_PRACT_NAME ,
	CASE WHEN @RECERT_DATE = ''
	THEN NULL
	ELSE CONVERT(DATE, @RECERT_DATE)
	END,
	@ETHNICITY ,
	@ETHNICITY_DESC ,
	@AUTO_ASSIGN ,
	@ASAP_ID ,
	@FEW_ID ,
	CASE WHEN 	@LST_HRA_DATE = ''
	THEN NULL
	ELSE CONVERT(DATE, 	@LST_HRA_DATE)
	END,
	CASE WHEN @NXT_HRA_DATE  = ''
	THEN NULL
	ELSE CONVERT(DATE, @NXT_HRA_DATE)
	END,
	@HRA_ID ,
	@MEMBER_EMail,
	@PCP_Specialty_Code ,
	@PCP_Specialty ,
	@SourceFileName ,
	@LoadType ,
    GETDATE(),
	-- [LoadDate] [date] NOT NULL,
	GETDATE(),
	--Convert(Date,  substring(@SourceFileName, CHARINDEX('By PCP', @SourceFileName) + 7, 8)),

	--CONVERT(DATE, Substring(@SourceFileName, CHARINDEX('Member By PCP', @SourceFileName) + 14, 7) + '-' + Substring(@SourceFileName, CHARINDEX('Member By PCP', @SourceFileName) + 21, 2)), 
	--@DataDate ,
	GETDATE(),
	--@CreateDate] [datetime2](7) NOT NULL,
	@CreateBy ,
	GETDATE(),
	--[LastUpdatedDate] [datetime2](7) NOT NULL,
	@LastUpdatedBy ,
	@COB_FLAG  
	
	) 

    END
END





