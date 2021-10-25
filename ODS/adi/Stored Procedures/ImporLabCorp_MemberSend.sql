
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImporLabCorp_MemberSend](
   	
	@First_Name  varchar(50)  ,
	@Middle_Name  varchar(50) ,
	@Last_Name  varchar(50)  ,
	@DOB  varchar(20)  ,
	@Gender  varchar(10) ,
	@Race_code  varchar(5) ,
	@DriversLicenseNumber  varchar(50) ,
	@DriversLicenseState  varchar(50) ,
	@SSN9  varchar(10) ,
	@SSN4  varchar(5) ,
	@MRN  varchar(50) ,
	@Ordering_Account_Number  varchar(50) ,
	@Address_Line1  varchar(50) ,
	@Address_Line2  varchar(50) ,
	@city  varchar(50) ,
	@state  varchar(50) ,
	@zip5  varchar(10) ,
	@zip4  varchar(10) ,
	@country  varchar(50) ,
	@Primary_phone  varchar(50) ,
	@CellPhone  varchar(50) ,
	@Home_Phone  varchar(50) ,
	@Email_Address  varchar(50) ,
	@Payer_name  varchar(50) ,
	@Payor_group_Number  varchar(50) ,
	@Member_ID  varchar(50),
	@Subscriber_ID  varchar(50) ,
	@Unique_Request_ID  varchar(50) ,
	@Record_Indicator  varchar(5)  
--	@SendDate  @date  
	
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
 INSERT INTO [adi].[LabCorp_MemberSend]
   (
       [First_Name]
      ,[Middle_Name]
      ,[Last_Name]
      ,[DOB]
      ,[Gender]
      ,[Race_code]
      ,[DriversLicenseNumber]
      ,[DriversLicenseState]
      ,[SSN9]
      ,[SSN4]
      ,[MRN]
      ,[Ordering_Account_Number]
      ,[Address_Line1]
      ,[Address_Line2]
      ,[city]
      ,[state]
      ,[zip5]
      ,[zip4]
      ,[country]
      ,[Primary_phone]
      ,[CellPhone]
      ,[Home_Phone]
      ,[Email_Address]
      ,[Payer_name]
      ,[Payor_group_Number]
      ,[Member_ID]
      ,[Subscriber_ID]
      ,[Unique_Request_ID]
      ,[Record_Indicator]
	  ,SendDate
       
     
    )
     VALUES
   (
    @First_Name    ,
	@Middle_Name   ,
	@Last_Name    ,
	CASE WHEN @DOB =''
	THEN NULL
	ELSE CONVERT(DATE,
	@DOB )
	END,
	@Gender   ,
	@Race_code   ,
	@DriversLicenseNumber   ,
	@DriversLicenseState   ,
	@SSN9   ,
	@SSN4   ,
	@MRN   ,
	@Ordering_Account_Number   ,
	@Address_Line1   ,
	@Address_Line2   ,
	@city   ,
	@state   ,
	@zip5   ,
	@zip4   ,
	@country   ,
	@Primary_phone   ,
	@CellPhone   ,
	@Home_Phone   ,
	@Email_Address   ,
	@Payer_name   ,
	@Payor_group_Number   ,
	@Member_ID  ,
	@Subscriber_ID   ,
	@Unique_Request_ID   ,
	@Record_Indicator  ,
	GETDATE()
)
  
END


END

