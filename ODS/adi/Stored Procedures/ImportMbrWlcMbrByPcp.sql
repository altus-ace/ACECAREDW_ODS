-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportMbrWlcMbrByPcp](
    @SEQ_Mem_ID varchar(50),
	@Sub_ID varchar(50),
	@FirstName varchar(75),
	@LastName varchar(75),
	@GENDER varchar(10),
	@IPA varchar(20),
	@BirthDate varchar(12),
	@MEDICAID_NO varchar(10),
	@MEDICAL_REC_NO varchar(50),
	@EffDate varchar(10),
	@TermDate varchar(10),
	@Prov_id varchar(50),
	@Prov_Name varchar(150) ,
	@LOB varchar(50) ,
	@BenePLAN varchar(15),
	@ADDRESS_TYPE varchar(50),
	@Address varchar(100),
	@City varchar(40) ,
	@State varchar(35) ,
	@Zip varchar(20),
	@County varchar(35),
	@PhoneNumber varchar(35) ,
	@MOBILE_PHONE varchar(35),
	@ALT_PHONE varchar(35),
	@AGENT_NUM varchar(10),
	@Enrollment_Source varchar(10),
	@SrcFileName varchar(100),
	@InQuarantine varchar(5),
	--[LoadDate],
	@DataDate varchar(10),
	--[CreateDate] ,
	@CreateBy varchar(50) ,
	--[LastUpdatedDate] ,
	@LastUpdatedBy varchar(50),   
	@MEMBER_EFFECTIVE_DATE varchar(10),
	@VENDOR_NAME varchar(50),
	@IRS_TAX_ID varchar(20),
	@reporting_pcp_npi varchar(20)

)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--UPDATE adi.MbrAetCom
--	SET MEMBER_ID  =  @MEMBER_ID 

--    WHERE  MEMBER_ID = @MEMBER_ID

	 
--	IF @@ROWCOUNT = 0

    -- Insert statements for procedure here
IF (@LOB <> '' )
BEGIN
 INSERT INTO adi.MbrWlcMbrByPcp
   (
    [SEQ_Mem_ID],
	[Sub_ID],
	[FirstName] ,
	[LastName],
	[GENDER],
	[IPA] ,
	[BirthDate],
	[MEDICAID_NO] ,
	[MEDICAL_REC_NO],
	[EffDate] ,
	[TermDate] ,
	[Prov_id],
	[Prov_Name] ,
	[LOB] ,
	[BenePLAN] ,
	[ADDRESS_TYPE] ,
	[Address] ,
	[City] ,
	[State] ,
	[Zip] ,
	[County],
	[PhoneNumber] ,
	[MOBILE_PHONE] ,
	[ALT_PHONE] ,
	[AGENT_NUM] ,
	[Enrollment_Source],
	[SrcFileName],
	[InQuarantine],
	[LoadDate],
	[DataDate],
	[CreateDate] ,
	[CreateBy] ,
	[LastUpdatedDate] ,
	[LastUpdatedBy]    
	,[Name]
	,[MEMBER_EFFECTIVE_DATE]
	,VENDOR_NAME 
	,IRS_TAX_ID 
	,reporting_pcp_npi
    )
     VALUES
   (   
    @SEQ_Mem_ID ,
	@Sub_ID ,
	@FirstName ,
	@LastName ,
	@GENDER ,
	@IPA ,
	CASE WHEN (@BirthDate = '')
	THEN NULL
	ELSE CONVERT(date, @BirthDate)
	END ,
	@MEDICAID_NO ,
	@MEDICAL_REC_NO ,
	CASE WHEN (@EffDate = '')
	THEN NULL
	ELSE CONVERT(date, @EffDate)
	END ,
	CASE WHEN (@TermDate = '')
	THEN NULL
	ELSE CONVERT(date, @TermDate)
	END ,
	@Prov_id ,
	@Prov_Name  ,
	@LOB ,
	@BenePLAN ,
	@ADDRESS_TYPE ,
	@Address ,
	@City ,
	@State ,
	@Zip,
	@County,
	@PhoneNumber ,
	@MOBILE_PHONE ,
	@ALT_PHONE ,
	@AGENT_NUM ,
	@Enrollment_Source ,
	@SrcFileName ,
	@InQuarantine,
	--[LoadDate],
	DATEADD(mm, DATEDIFF(mm,0, GETDATE()), 0),
	--@DataDate,
	GETDATE(),
	--[CreateDate] ,
	GETDATE(),
	@CreateBy  ,
	--[LastUpdatedDate] ,
	GETDATE(),
	@LastUpdatedBy ,
	@FirstName,
	CASE WHEN (@MEMBER_EFFECTIVE_DATE = '')
	THEN NULL
	ELSE CONVERT(date, @MEMBER_EFFECTIVE_DATE)
	END,
	@VENDOR_NAME,
	@IRS_TAX_ID ,
	@reporting_pcp_npi 
	)
	 END

	 --BEGIN
	 --update [adi].[MbrWlcMbrByPcp]
  --   Set [LastName] = SUBSTRING(Name, 0, CHARINDEX(',', Name))
  --  , [FirstName]=SUBSTRING(Name, CHARINDEX(',', Name)  + 1, LEN(Name)) 
	 --FROM [ACECAREDW].[adi].[MbrWlcMbrByPcp]
	 --where LoadDate = CONVERT(DATE, GETDATE())
	 --END
END



