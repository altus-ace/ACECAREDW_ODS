-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportAce_Messages](
    @CLIENT_PATIENT_ID varchar(50),
	@CLIENT_ID varchar(50) ,
	@ACE_ID varchar(50) ,
	@FIRST_NAME varchar(50),
	@LAST_NAME varchar(50) ,
	@PHONE_NUMBER varchar(50) ,
	@USERNAME varchar(50) ,
	@WORKFLOW_NAME varchar(100) ,
	@WORKFLOW_ID VARCHAR(50),
	@CONTENT varchar(250) ,
	@CENTRAL_DATE_TIME datetime,
	@SrcFileName varchar(100),
	@CreatedDate datetime,
	@DataDate date ,
	@CreatedBy varchar(50) 


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
 INSERT INTO [adi].[MpulseAceMessages]
   (
    [CLIENT_PATIENT_ID],
	[CLIENT_ID] ,
	[ACE_ID] ,
	[FIRST_NAME] ,
	[LAST_NAME] ,
	[PHONE_NUMBER] ,
	[USERNAME] ,
	[WORKFLOW_NAME] ,
	[WORKFLOW_ID] ,
	[CONTENT] ,
	[CENTRAL_DATE_TIME],
	SrcFileName,
	CreatedDate,
	DataDate ,
	CreatedBy 
    )
     VALUES
   (
    @CLIENT_PATIENT_ID ,
	@CLIENT_ID  ,
	@ACE_ID  ,
	@FIRST_NAME ,
	@LAST_NAME ,
	@PHONE_NUMBER  ,
	@USERNAME  ,
	@WORKFLOW_NAME ,
	@WORKFLOW_ID ,
	@CONTENT,
	CASE WHEN @CENTRAL_DATE_TIME = ''
	THEN NULL
	ELSE CONVERT(datetime,@CENTRAL_DATE_TIME)
	END,
	-- datetime,
	@SrcFileName,
	GETDATE(),
	--@CreatedDate datetime,
	CASE WHEN @DataDate = ''
	THEN NULL
	ELSE CONVERT(date, @DataDate)
	END,
	@CreatedBy 
    --@loadDate,

   )
   END;

  -- SET @ActionStopDateTime = GETDATE(); 
  -- EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditID, @ActionStopDateTime, 1,1,0,2   

  --  EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, '[ACECARDW].[adi].[copUhcPcor]', '';

END




