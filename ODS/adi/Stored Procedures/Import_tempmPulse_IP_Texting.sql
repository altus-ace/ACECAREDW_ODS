-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[Import_tempmPulse_IP_Texting] (
  	@ENTITY varchar(20) ,
	@SITE varchar(20) ,
	@UID_STATE varchar(20) ,
	@PRAC_NAME varchar(50) ,
	@UID_PROVIDER varchar(25) ,
	@TREATMENT_TYPE varchar(20) ,
	@MEMEBR_ID varchar(20) ,
	@TEXT varchar(20) ,
	@MEMER_FIRST_NAME varchar(50) ,
	@MEMBER_LAST_NAME varchar(50) ,
	@MEMBER_DOB  varchar(10) ,
	@CASE_ID varchar(20) ,
	@CASE_TYPE varchar(20) ,
	@ADMIT_IFICATION_DATE varchar(10) ,
	@ADIMSSION_DATE varchar(10) ,
	@DISCHARGE_DATE varchar(10) ,
	@DISCHARGE_DISPOSITION varchar(100) ,
	@FOLLOW_UP_VISIT_DUE_DATE varchar(10) ,
	@SCHEDULED_VISIT_DATE varchar(10) ,
	@PRIMARY_DIAGNOSIS varchar(50) ,
	@ADMIT_HOSPITAL varchar(50) ,
	@CLIENT_ID varchar(20) ,
	@PhoneNumber varchar(20) ,
	@PhoneType varchar(20) ,
	@BenefitPlan varchar(50) ,
	--@LoadDate varchar(10) ,
	@DataDate varchar(10) ,
	@OrignalSrcFileName varchar(100)  ,
	@SrcFileName varchar(100)  ,
	--@CreatedDate datetime2 (7)  ,
	@CreatedBy varchar(50)  ,
	--@LastUpdatedDate datetime2 (7)  ,
	@LastUpdatedBy varchar(50) 
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
 BEGIN
 INSERT INTO [adi].[tempmPulse_IP_Texting]
   (
       [ENTITY]
      ,[SITE]
      ,[UID_STATE]
      ,[PRAC_NAME]
      ,[UID_PROVIDER]
      ,[TREATMENT_TYPE]
      ,[MEMEBR_ID]
      ,[TEXT]
      ,[MEMER_FIRST_NAME]
      ,[MEMBER_LAST_NAME]
      ,[MEMBER_DOB]
      ,[CASE_ID]
      ,[CASE_TYPE]
      ,[ADMIT_NOTIFICATION_DATE]
      ,[ADIMSSION_DATE]
      ,[DISCHARGE_DATE]
      ,[DISCHARGE_DISPOSITION]
      ,[FOLLOW_UP_VISIT_DUE_DATE]
      ,[SCHEDULED_VISIT_DATE]
      ,[PRIMARY_DIAGNOSIS]
      ,[ADMIT_HOSPITAL]
      ,[CLIENT_ID]
      ,[PhoneNumber]
      ,[PhoneType]
      ,[BenefitPlan]
      ,[LoadDate]
      ,[DataDate]
      ,[OrignalSrcFileName]
      ,[SrcFileName]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[LastUpdatedDate]
      ,[LastUpdatedBy]
     )
     VALUES
   (   
 	@ENTITY  ,
	@SITE  ,
	@UID_STATE  ,
	@PRAC_NAME  ,
	@UID_PROVIDER  ,
	@TREATMENT_TYPE  ,
	@MEMEBR_ID  ,
	@TEXT  ,
	@MEMER_FIRST_NAME  ,
	@MEMBER_LAST_NAME  ,
	CASE WHEN @MEMBER_DOB =''
	THEN NULL
	ELSE CONVERT(DATE,@MEMBER_DOB)
	END,
	@CASE_ID  ,
	@CASE_TYPE  ,
	CASE WHEN @ADMIT_IFICATION_DATE  =''
	THEN NULL
	ELSE CONVERT(DATE,@ADMIT_IFICATION_DATE )
	END,
	CASE WHEN @ADIMSSION_DATE  =''
	THEN NULL
	ELSE CONVERT(DATE,@ADIMSSION_DATE)
	END,	 
	CASE WHEN @DISCHARGE_DATE  =''
	THEN NULL
	ELSE CONVERT(DATE,@DISCHARGE_DATE)
	END,	 
	@DISCHARGE_DISPOSITION ,
	CASE WHEN @FOLLOW_UP_VISIT_DUE_DATE  =''
	THEN NULL
	ELSE CONVERT(DATE,@FOLLOW_UP_VISIT_DUE_DATE)
	END,
	CASE WHEN @SCHEDULED_VISIT_DATE  =''
	THEN NULL
	ELSE CONVERT(DATE,@SCHEDULED_VISIT_DATE )
	END,	
	@PRIMARY_DIAGNOSIS  ,
	@ADMIT_HOSPITAL  ,
	@CLIENT_ID  ,
	@PhoneNumber  ,
	@PhoneType  ,
	@BenefitPlan  ,
	GETDATE(),  
	@DataDate  ,
	@OrignalSrcFileName   ,
	@SrcFileName   ,
	GETDATE(),
	--@CreatedDate datetime2 (7)  ,
	@CreatedBy   ,
	GETDATE(),
	--@LastUpdatedDate datetime2 (7)  ,
	@LastUpdatedBy  
   )
  END
   BEGIN --- update Text cloumn 
   EXEC [abo].[UpdatemPulseIP_Texting] @MEMEBR_ID
   END
   
END