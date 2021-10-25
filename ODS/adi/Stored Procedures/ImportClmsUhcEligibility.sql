-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert UHC Claim file to DB
-- =============================================
CREATE PROCEDURE adi.ImportClmsUhcEligibility
	@DataDate VARCHAR(10), 
	@OriginalFileName varchar(100)  ,
	@SrcFileName varchar(100)  ,
	@CreatedBy varchar(50)  ,
	@LastUpdatedBy varchar(50)  ,
	@COMPANY_CODE varchar(5),
	@LINE_OF_BUSINESS_DESC varchar(30),
	@MEDICAID_NO varchar(20) ,
	@MEDICARE_NO varchar(12) ,
	@SUBSCRIBER_ID varchar(20) ,
	@MEMB_FIRST_NAME varchar(50) ,
	@MEMB_MIDDLE_INITIAL char(1) ,
	@MEMB_LAST_NAME varchar(50),
	@GENDER char(1),
	@DOB varchar(10), 
	@MEMB_ADDRESS_LINE_1 varchar(55),
	@MEMB_ADDRESS_LINE_2 varchar(55),
	@MEMB_CITY varchar(35) ,
	@MEMB_STATE varchar(30) ,
	@MEMB_ZIP varchar(25) ,
	@HOME_PHONE_NUMBER varchar(35) ,
    @IPRO_RISK_SCORE varchar(10),
	@PROVIDER_ID varchar(20) ,
	@NATIONAL_PROVIDER_ID varchar(10) ,
	@MPIN varchar(15) ,
	@PROV_FULL_NAME varchar(75),
	@PROV_TAX_ID varchar(50) ,
	@ELIG_START_DATE varchar(10)
          
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
	 
	--IF @@ROWCOUNT = 0
	
    EXEC [ACDW_CLMS_UHC].[adi].[ImportClmsUhcEligibility] 
	@DataDate , 
	@OriginalFileName ,
	@SrcFileName ,
	@CreatedBy ,
	@LastUpdatedBy ,
	@COMPANY_CODE ,
	@LINE_OF_BUSINESS_DESC ,
	@MEDICAID_NO  ,
	@MEDICARE_NO ,
	@SUBSCRIBER_ID  ,
	@MEMB_FIRST_NAME  ,
	@MEMB_MIDDLE_INITIAL ,
	@MEMB_LAST_NAME ,
	@GENDER ,
	@DOB , 
	@MEMB_ADDRESS_LINE_1 ,
	@MEMB_ADDRESS_LINE_2 ,
	@MEMB_CITY ,
	@MEMB_STATE  ,
	@MEMB_ZIP ,
	@HOME_PHONE_NUMBER ,
    @IPRO_RISK_SCORE ,
	@PROVIDER_ID  ,
	@NATIONAL_PROVIDER_ID ,
	@MPIN ,
	@PROV_FULL_NAME ,
	@PROV_TAX_ID  ,
	@ELIG_START_DATE
	
END

