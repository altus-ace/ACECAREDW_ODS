-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportMPulseDailyIPCensus](
    --@LoadDate  ,
	@DataDate varchar(50) ,
	@SrcFileName varchar(100) ,
	--@CreatedDate date NOT ,
	@CreatedBy varchar(50),
	--@LastUpdatedDate date NOT ,
	@LastUpdatedBy varchar(50),
	@ENTITY varchar(10) ,
	@SITE varchar(20) ,
	@UID_STATE varchar(50) ,
	@PRAC_NAME numeric(15, 0) ,
	@UID_PROVIDER varchar(15) ,
	@TREATMENT_TYPE varchar(10) ,
	@MEMEBR_ID varchar(10) ,
	@MEMER_FIRST_NAME varchar(20) ,
	@MEMBER_LAST_NAME varchar(20) ,
	@MEMBER_DOB varchar(10) ,
	@CASE_ID varchar(10),
	@CASE_TYPE varchar(15) ,
	@ADMIT_NOTIFICATION_DATE varchar(15) ,
	@ADIMSSION_DATE varchar(10),
	@DISCHARGE_DATE varchar(10) ,
	@DISCHARGE_DISPOSITION varchar(20) ,
	@FOLLOW_UP_VISIT_DUE_DATE varchar(10) ,
	@SCHEDULED_VISIT_DATE varchar(10)  ,
	@PRIMARY_DIAGNOSIS varchar(10) ,
	@ADMIT_HOSPITAL varchar(10) ,
	@CLIENT_ID varchar(10) ,
	@PhoneNumber varchar(10) ,
	@PhoneType varchar(10) ,
	@BenefitPlan varchar(20) 
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	-- ADD ACE ETL AUDIT
	--DECLARE @AuditID AS INT, @ActionStartDateTime AS datetime2, @ActionStopDateTime as datetime2
	
	--SET @ActionStartDateTime = GETDATE(); 
	
	--'2017-12-16 11:15:23.2393473'
    
--	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 1, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, '[ACECARDW].[adi].[copUhcPcor]', '';
--	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR',  @ActionStartDateTime , 'Test', '[ACECARDW].[adi].[copUhcPcor]', '' ;



 --IF (@Physician <>'' AND @FirstName <> '' AND @LastName <> ''  AND @MemberID <> '') 
 BEGIN
 INSERT INTO [adi].[MPulseDailyIPCensus]
   (
       [LoadDate]
      ,[DataDate]
      ,[SrcFileName]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[LastUpdatedDate]
      ,[LastUpdatedBy]
      ,[ENTITY]
      ,[SITE]
      ,[UID_STATE]
      ,[PRAC_NAME]
      ,[UID_PROVIDER]
      ,[TREATMENT_TYPE]
      ,[MEMEBR_ID]
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
	
    )
     VALUES
   (
    GETDATE(), --@LoadDate  ,
	@DataDate  ,
	@SrcFileName  ,
	GETDATE(),
	--@CreatedDate date NOT ,
	@CreatedBy ,
	GETDATE(),
	--@LastUpdatedDate date NOT ,
	@LastUpdatedBy ,
	@ENTITY  ,
	@SITE  ,
	@UID_STATE  ,
	@PRAC_NAME  ,
	@UID_PROVIDER  ,
	@TREATMENT_TYPE  ,
	@MEMEBR_ID  ,
	@MEMER_FIRST_NAME  ,
	@MEMBER_LAST_NAME  ,
	@MEMBER_DOB  ,
	@CASE_ID ,
	@CASE_TYPE  ,
	@ADMIT_NOTIFICATION_DATE ,
	@ADIMSSION_DATE ,
	@DISCHARGE_DATE  ,
	@DISCHARGE_DISPOSITION  ,
	@FOLLOW_UP_VISIT_DUE_DATE  ,
	@SCHEDULED_VISIT_DATE   ,
	@PRIMARY_DIAGNOSIS  ,
	@ADMIT_HOSPITAL  ,
	@CLIENT_ID  ,
	@PhoneNumber  ,
	@PhoneType  ,
	@BenefitPlan  
   )
   END;

  -- SET @ActionStopDateTime = GETDATE(); 
  -- EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditID, @ActionStopDateTime, 1,1,0,2   

  --  EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, '[ACECARDW].[adi].[copUhcPcor]', '';

END




