
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImporExp_LabCorpMembershipRoster](
   	@SrcFileName  varchar(100) ,
	--@CreateDate  @datetime  ,
	@CreateBy  varchar(100) ,
	@OriginalFileName  varchar(100) ,
	@Status  int  ,
	@UniqueRequestID  varchar(50) ,
	@MemberID  varchar(50) ,
	@SubscriberID  varchar(50) ,
	@FIRST_NAME  varchar(100) ,
	@MIDDLE_NAME  varchar(10) ,
	@LAST_NAME  varchar(100) ,
	@DATE_OF_BIRTH  varchar(10) ,
	@GENDER  varchar(10) ,
	@RaceCode  varchar(50) ,
	@DriversLicenseNumber  varchar(20) ,
	@DriversLicenseState  varchar(20) ,
	@SSN9  varchar(10) ,
	@SSN4  varchar(10) ,
	@MRN  varchar(50) ,
	@Ordering_Account_Number  varchar(20) ,
	@MEMBER_HOME_ADDRESS  varchar(100) ,
	@MEMBER_HOME_ADDRESS2  varchar(100) ,
	@MEMBER_HOME_CITY  varchar(100) ,
	@MEMBER_HOME_STATE  varchar(20) ,
	@MEMBER_HOME_ZIP5  varchar(10) ,
	@zip4  varchar(10) ,
	@Country  varchar(100) ,
	@MemberPrimaryPhone  varchar(20) ,
	@CellPhone  varchar(20) ,
	@HomePhone  varchar(20) ,
	@EmailAddress  varchar(50) ,
	@PayerName  varchar(50) ,
	@PayerGroupNumber  varchar(20) ,
	@RecordIndicator  char(1) 
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here


 --IF (@Physician <>'' AND @FirstName <> '' AND @LastName <> ''  AND @MemberID <> '') 
 BEGIN
 INSERT INTO [adi].[Exp_LabCorpMembershipRoster]
   (
       
      [SrcFileName]
      ,[CreateDate]
      ,[CreateBy]
      ,[OriginalFileName]
      ,[Status]
      ,[UniqueRequestID]
      ,[MemberID]
      ,[SubscriberID]
      ,[FIRST_NAME]
      ,[MIDDLE_NAME]
      ,[LAST_NAME]
      ,[DATE_OF_BIRTH]
      ,[GENDER]
      ,[RaceCode]
      ,[DriversLicenseNumber]
      ,[DriversLicenseState]
      ,[SSN9]
      ,[SSN4]
      ,[MRN]
      ,[Ordering_Account_Number]
      ,[MEMBER_HOME_ADDRESS]
      ,[MEMBER_HOME_ADDRESS2]
      ,[MEMBER_HOME_CITY]
      ,[MEMBER_HOME_STATE]
      ,[MEMBER_HOME_ZIP5]
      ,[zip4]
      ,[Country]
      ,[MemberPrimaryPhone]
      ,[CellPhone]
      ,[HomePhone]
      ,[EmailAddress]
      ,[PayerName]
      ,[PayerGroupNumber]
      ,[RecordIndicator] 
    )
     VALUES
   (
    @SrcFileName   ,
	GETDATE(),
	--@CreateDate  @datetime  ,
	@CreateBy   ,
	@OriginalFileName   ,
	@Status    ,
	@UniqueRequestID   ,
	@MemberID   ,
	@SubscriberID   ,
	@FIRST_NAME   ,
	@MIDDLE_NAME   ,
	@LAST_NAME   ,
	@DATE_OF_BIRTH   ,
	@GENDER   ,
	@RaceCode   ,
	@DriversLicenseNumber   ,
	@DriversLicenseState   ,
	@SSN9   ,
	@SSN4   ,
	@MRN   ,
	@Ordering_Account_Number   ,
	@MEMBER_HOME_ADDRESS   ,
	@MEMBER_HOME_ADDRESS2   ,
	@MEMBER_HOME_CITY   ,
	@MEMBER_HOME_STATE   ,
	@MEMBER_HOME_ZIP5   ,
	@zip4   ,
	@Country   ,
	@MemberPrimaryPhone   ,
	@CellPhone   ,
	@HomePhone   ,
	@EmailAddress   ,
	@PayerName   ,
	@PayerGroupNumber   ,
	@RecordIndicator  
)
  
END


END

