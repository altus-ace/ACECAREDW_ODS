-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportmbrUhcMbrByProvider](
    --@loadDate varchar(10) ,
	@DataDate varchar(10),
	@OriginalFileName varchar(100) ,
	@SrcFileName varchar(100) ,
	--@CreatedDate datetime2(7),
	@CreatedBy varchar(50),
	--@LastUpdatedDate datetime2(7) NOT ,
	@LastUpdatedBy varchar(50),
	@PLAN_DESC varchar(50) ,
	@MEMB_FIRST_NAME varchar(50) ,
	@MEMB_LAST_NAME varchar(50) ,
	@SUBSCRIBER_ID varchar(50) ,
	@MEDICAID_NO varchar(20) ,
	@MEDICARE_NO varchar(20) ,
	@SOCIAL_SEC_NO varchar(12) ,
	@AGE varchar(5) ,
	@DATE_OF_BIRTH varchar(20) ,
	@MEMB_GENDER varchar(10) ,
	@MEMB_LANGUAGE varchar(50) ,
	@MEMB_ADDRESS_LINE_1 varchar(50) ,
	@MEMB_ADDRESS_LINE_2 varchar(50) ,
	@MEMB_CITY varchar(50) ,
	@MEMB_STATE varchar(50) ,
	@MEMB_ZIP varchar(10) ,
	@HOME_PHONE_NUMBER varchar(12) ,
	@BUS_PHONE_NUMBER varchar(12) ,
	@PCP_EFFECTIVE_DATE varchar(50) ,
	@PCP_TERM_DATE varchar(10) ,
	@PLAN_CODE varchar(50) ,
	@PROVIDER_ID varchar(50) ,
	@PROV_FNAME varchar(50) ,
	@PROV_LNAME varchar(50) ,
	@PROV_PHONE varchar(12) ,
	@PROV_ADDRESS_LINE_1 varchar(50) ,
	@PROV_ADDRESS_LINE_2 varchar(50) ,
	@PROV_CITY varchar(50) ,
	@PROV_STATE varchar(50) ,
	@PROV_ZIP varchar(10) ,
	@PROV_EFF_DATE varchar(10) ,
	@PROV_TERM_DATE varchar(10) ,
	@IRS_TAX_ID varchar(20) ,
	@PAYEE_NAME varchar(50) ,
	@VENDOR_ID varchar(20) ,
	@LINE_OF_BUSINESS varchar(50) ,
	@MEMB_ETHNICITY varchar(20) ,
	@PANEL_ID varchar(50) ,
	@COSMOS_CUST_SEG varchar(20) ,
	@COSMOS_CUST_SEG_DESC varchar(100) ,
	@PROV_LANG_1 varchar(50) ,
	@PROV_LANG_2 varchar(50) ,
	@PROV_LANG_3 varchar(50) ,
	@PLANPROGCONTTYPE varchar(50) ,
	@LAST_PCP_VISIT_DATE varchar(10) ,
	@LAST_PCP_VISIT_DAYS_BACK varchar(10) ,
	@LAST_PCP_VISIT_NPI varchar(10) ,
	@LAST_PCP_VISIT_TIN varchar(9) ,
	@LAST_PCP_VISIT_ASSIGN_OR_ATTR varchar(50) ,
	@LAST_PCP_VISIT_PROV_TYPE varchar(20) ,
	@LAST_PCP_VISIT_PAR varchar(50) ,
	@CURRENT_EFFECTIVE_DATE varchar(10) ,
	@CONT_EFFECTIVE_DATE varchar(10) ,
	@ORIGINAL_EFFECTIVE_DATE varchar(10) ,
	@LIST_FLAG varchar(20) ,
	@AUTO_ASSIGNED varchar(10) ,
	@IPRO_Risk_Score varchar(10),
	@MbrLoadStatus char(1) 

)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--UPDATE adi.MbrAetCom

--IF (@LOB <> '' )
BEGIN
 INSERT INTO [adi].[mbrUhcMbrByProvider]
   (
       [loadDate]
      ,[DataDate]
      ,[OriginalFileName]
      ,[SrcFileName]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[LastUpdatedDate]
      ,[LastUpdatedBy]
      ,[PLAN_DESC]
      ,[MEMB_FIRST_NAME]
      ,[MEMB_LAST_NAME]
      ,[SUBSCRIBER_ID]
      ,[MEDICAID_NO]
      ,[MEDICARE_NO]
      ,[SOCIAL_SEC_NO]
      ,[AGE]
      ,[DATE_OF_BIRTH]
      ,[MEMB_GENDER]
      ,[MEMB_LANGUAGE]
      ,[MEMB_ADDRESS_LINE_1]
      ,[MEMB_ADDRESS_LINE_2]
      ,[MEMB_CITY]
      ,[MEMB_STATE]
      ,[MEMB_ZIP]
      ,[HOME_PHONE_NUMBER]
      ,[BUS_PHONE_NUMBER]
      ,[PCP_EFFECTIVE_DATE]
      ,[PCP_TERM_DATE]
      ,[PLAN_CODE]
      ,[PROVIDER_ID]
      ,[PROV_FNAME]
      ,[PROV_LNAME]
      ,[PROV_PHONE]
      ,[PROV_ADDRESS_LINE_1]
      ,[PROV_ADDRESS_LINE_2]
      ,[PROV_CITY]
      ,[PROV_STATE]
      ,[PROV_ZIP]
      ,[PROV_EFF_DATE]
      ,[PROV_TERM_DATE]
      ,[IRS_TAX_ID]
      ,[PAYEE_NAME]
      ,[VENDOR_ID]
      ,[LINE_OF_BUSINESS]
      ,[MEMB_ETHNICITY]
      ,[PANEL_ID]
      ,[COSMOS_CUST_SEG]
      ,[COSMOS_CUST_SEG_DESC]
      ,[PROV_LANG_1]
      ,[PROV_LANG_2]
      ,[PROV_LANG_3]
      ,[PLANPROGCONTTYPE]
      ,[LAST_PCP_VISIT_DATE]
      ,[LAST_PCP_VISIT_DAYS_BACK]
      ,[LAST_PCP_VISIT_NPI]
      ,[LAST_PCP_VISIT_TIN]
      ,[LAST_PCP_VISIT_ASSIGN_OR_ATTR]
      ,[LAST_PCP_VISIT_PROV_TYPE]
      ,[LAST_PCP_VISIT_PAR]
      ,[CURRENT_EFFECTIVE_DATE]
      ,[CONT_EFFECTIVE_DATE]
      ,[ORIGINAL_EFFECTIVE_DATE]
      ,[LIST_FLAG]
      ,[AUTO_ASSIGNED]
	  ,[IPRO_Risk_Score]
      ,[MbrLoadStatus]
    )
     VALUES
   (   
      --@loadDate date ,
	GETDATE(),
	@DataDate ,
	@OriginalFileName  ,
	@SrcFileName  ,
	GETDATE(),
	--@CreatedDate datetime2(7),
	@CreatedBy ,
	GETDATE(),
	--@LastUpdatedDate datetime2(7) NOT ,
	@LastUpdatedBy ,
	@PLAN_DESC  ,
	@MEMB_FIRST_NAME  ,
	@MEMB_LAST_NAME  ,
	@SUBSCRIBER_ID  ,
	@MEDICAID_NO  ,
	@MEDICARE_NO  ,
	@SOCIAL_SEC_NO  ,
	@AGE  ,
	@DATE_OF_BIRTH ,
	@MEMB_GENDER  ,
	@MEMB_LANGUAGE  ,
	@MEMB_ADDRESS_LINE_1  ,
	@MEMB_ADDRESS_LINE_2  ,
	@MEMB_CITY  ,
	@MEMB_STATE  ,
	@MEMB_ZIP  ,
	@HOME_PHONE_NUMBER  ,
	@BUS_PHONE_NUMBER  ,
	@PCP_EFFECTIVE_DATE  ,
	@PCP_TERM_DATE  ,
	@PLAN_CODE  ,
	@PROVIDER_ID  ,
	@PROV_FNAME  ,
	@PROV_LNAME  ,
	@PROV_PHONE  ,
	@PROV_ADDRESS_LINE_1  ,
	@PROV_ADDRESS_LINE_2  ,
	@PROV_CITY  ,
	@PROV_STATE  ,
	@PROV_ZIP  ,
	@PROV_EFF_DATE ,
	@PROV_TERM_DATE  ,
	@IRS_TAX_ID  ,
	@PAYEE_NAME  ,
	@VENDOR_ID  ,
	@LINE_OF_BUSINESS  ,
	@MEMB_ETHNICITY  ,
	@PANEL_ID  ,
	@COSMOS_CUST_SEG  ,
	@COSMOS_CUST_SEG_DESC  ,
	@PROV_LANG_1  ,
	@PROV_LANG_2  ,
	@PROV_LANG_3  ,
	@PLANPROGCONTTYPE  ,
	@LAST_PCP_VISIT_DATE  ,
	@LAST_PCP_VISIT_DAYS_BACK  ,
	@LAST_PCP_VISIT_NPI  ,
	@LAST_PCP_VISIT_TIN  ,
	@LAST_PCP_VISIT_ASSIGN_OR_ATTR  ,
	@LAST_PCP_VISIT_PROV_TYPE  ,
	@LAST_PCP_VISIT_PAR  ,
	@CURRENT_EFFECTIVE_DATE ,
	@CONT_EFFECTIVE_DATE ,
	@ORIGINAL_EFFECTIVE_DATE  ,
	@LIST_FLAG  ,
	@AUTO_ASSIGNED  ,
	CASE WHEN @IPRO_Risk_Score = ''
	THEN NULL
    ELSE CONVERT(decimal(10,3), @IPRO_Risk_Score)
	END,
	@MbrLoadStatus  
	 )
	 END
END



