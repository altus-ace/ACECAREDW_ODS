
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportUHC_PvdrPanel_CareOpps](
   
	@ACCOUNT_ID varchar(50) ,
	@GROUP_NAME varchar(50) ,
	@PRACTICE_NAME varchar(50) ,
	@Member_Id varchar(50) ,
	@MEDICAID_NO varchar(50) ,
	@Lastname varchar(50) ,
	@Firstname varchar(50) ,
	@MEMB_GENDER varchar(10) ,
	@DOB varchar(50) ,
	@Telephone varchar(50) ,
	@Measure_Id varchar(50) ,
	@Measure_Description varchar(200) ,
	@Submeasure_Id varchar(50) ,
	@Submeasure_Description varchar(50) ,
	@Compliance_Date varchar(50) ,
	@COMPLIANCE varchar(50) ,
	@MBR_HIST_LOB varchar(50) ,
	@MBR_HIST_LOB_DESC varchar(50) ,
	@PLAN_CODE varchar(50) ,
	@PLAN_DESC varchar(50) ,
	@Assigned_Provider_TIN_Name varchar(50) ,
	@Assigned_Provider_Medicaid_Id varchar(50) ,
	@Assigned_Provider_Lastname varchar(50) ,
	@Assigned_Provider_Firstname varchar(50) ,
	@Assigned_Provider_Address1 varchar(50) ,
	@Assigned_Provider_Address2 varchar(50) ,
	@Assigned_Provider_City varchar(50) ,
	@Assigned_Provider_County varchar(50) ,
	@Assigned_Provider_State varchar(50) ,
	@Assigned_Provider_Zipcode varchar(50) ,
	@Assigned_Provider_Telephone varchar(50) ,
	@Assigned_Provider_Last_Visit varchar(50) ,
	@Assigned_Provider_TIN varchar(50) ,
	@Assigned_Provider_NPI varchar(50) ,
	@Assigned_Provider_MPIN varchar(50) ,
	@Assigned_Provider_Id varchar(50) ,
	@Extract_Timestamp varchar(50) ,
	@SMART_Load_Timestamp varchar(50) ,
	@ReviewSet varchar(50) ,
	@REPORTDATE varchar(50) ,
	@MeasureID varchar(50) ,
	@SubMeasure varchar(50) ,
	@SrcFileName varchar(100) ,
	@OriginalFileName varchar(100) ,
	--@LoadDate date ,
	--@DataDate date ,
	--@CreatedDate datetime ,
	@CreatedBy varchar(50) ,
	--@LastUpdatedDate datetime ,
	@LastUpdatedBy varchar(50) 

)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
 INSERT INTO [adi].[UHC_PvdrPanel_CareOpps]
   (
       [ACCOUNT_ID]
      ,[GROUP_NAME]
      ,[PRACTICE_NAME]
      ,[Member_Id]
      ,[MEDICAID_NO]
      ,[Lastname]
      ,[Firstname]
      ,[MEMB_GENDER]
      ,[DOB]
      ,[Telephone]
      ,[Measure_Id]
      ,[Measure_Description]
      ,[Submeasure_Id]
      ,[Submeasure_Description]
      ,[Compliance_Date]
      ,[COMPLIANCE]
      ,[MBR_HIST_LOB]
      ,[MBR_HIST_LOB_DESC]
      ,[PLAN_CODE]
      ,[PLAN_DESC]
      ,[Assigned_Provider_TIN_Name]
      ,[Assigned_Provider_Medicaid_Id]
      ,[Assigned_Provider_Lastname]
      ,[Assigned_Provider_Firstname]
      ,[Assigned_Provider_Address1]
      ,[Assigned_Provider_Address2]
      ,[Assigned_Provider_City]
      ,[Assigned_Provider_County]
      ,[Assigned_Provider_State]
      ,[Assigned_Provider_Zipcode]
      ,[Assigned_Provider_Telephone]
      ,[Assigned_Provider_Last_Visit]
      ,[Assigned_Provider_TIN]
      ,[Assigned_Provider_NPI]
      ,[Assigned_Provider_MPIN]
      ,[Assigned_Provider_Id]
      ,[Extract_Timestamp]
      ,[SMART_Load_Timestamp]
      ,[ReviewSet]
      ,[REPORTDATE]
      ,[MeasureID]
      ,[SubMeasure]
      ,[SrcFileName]
      ,[OriginalFileName]
      ,[LoadDate]
      ,[DataDate]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[LastUpdatedDate]
      ,[LastUpdatedBy]
      
	)
     VALUES
   (
    @ACCOUNT_ID  ,
	@GROUP_NAME,
	@PRACTICE_NAME,
	@Member_Id  ,
	@MEDICAID_NO  ,
	@Lastname  ,
	@Firstname  ,
	@MEMB_GENDER ,
	@DOB  ,
	@Telephone  ,
	@Measure_Id  ,
	@Measure_Description ,
	@Submeasure_Id  ,
	@Submeasure_Description  ,
	@Compliance_Date  ,
	@COMPLIANCE  ,
	@MBR_HIST_LOB  ,
	@MBR_HIST_LOB_DESC  ,
	@PLAN_CODE  ,
	@PLAN_DESC  ,
	@Assigned_Provider_TIN_Name  ,
	@Assigned_Provider_Medicaid_Id  ,
	@Assigned_Provider_Lastname  ,
	@Assigned_Provider_Firstname  ,
	@Assigned_Provider_Address1  ,
	@Assigned_Provider_Address2  ,
	@Assigned_Provider_City  ,
	@Assigned_Provider_County  ,
	@Assigned_Provider_State  ,
	@Assigned_Provider_Zipcode  ,
	@Assigned_Provider_Telephone  ,
	@Assigned_Provider_Last_Visit  ,
	@Assigned_Provider_TIN  ,
	@Assigned_Provider_NPI  ,
	@Assigned_Provider_MPIN  ,
	@Assigned_Provider_Id  ,
	@Extract_Timestamp  ,
	@SMART_Load_Timestamp  ,
	@ReviewSet  ,
	@REPORTDATE  ,
	@MeasureID ,
	@SubMeasure  ,
	@SrcFileName  ,
	@OriginalFileName ,
	GETDATE(),
	--@LoadDate date ,
	GETDATE(),
	--@DataDate date ,
	GETDATE(),
	--@CreatedDate datetime ,
	@CreatedBy ,
	GETDATE(),
	--@LastUpdatedDate datetime ,
	@LastUpdatedBy 
   );
END





