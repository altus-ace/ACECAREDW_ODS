-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportMpulseMessages](
    @OriginalFileName VARCHAR(100),
	@SrcFileName VARCHAR(100),
	--[DataDate] [date] NOT NULL,
	-- [CreatedDate] [date] NOT NULL,
	@CreatedBy varchar(50),
	--[LastUpdatedDate] [date] NOT NULL,
	@LastUpdatedBy varchar(50) ,
	@CENTRAL_DATE_TIME VARCHAR(10),
	@CLIENT_PATIENT_ID varchar(50),
	@CLIENT_ID varchar(25),
	@ACE_ID varchar(20),
	@FIRST_NAME varchar(50) ,
	@LAST_NAME varchar(50) ,
	@PHONE_NUMBER varchar(35) ,
	@Content varchar(max) ,
	@WORKFLOW_ID varchar(20) ,
	@WORKFLOW_NAME varchar(50) ,
	@UserName varchar(100) 

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
 IF (@ACE_ID NOT LIKE '%E+%')
 BEGIN
 INSERT INTO [adi].[MpulseMessages]
   ( 
    [OriginalFileName] ,
	[SrcFileName] ,
	[DataDate] ,
	[CreatedDate],
	[CreatedBy] ,
	[LastUpdatedDate] ,
	[LastUpdatedBy] ,
	[CENTRAL_DATE_TIME] ,
	[CLIENT_PATIENT_ID] ,
	[CLIENT_ID],
	[ACE_ID] ,
	[FIRST_NAME],
	[LAST_NAME] ,
	[PHONE_NUMBER] ,
	[Content] ,
	[WORKFLOW_ID] ,
	[WORKFLOW_NAME] ,
	[UserName] 
    )
     VALUES
   (
    @OriginalFileName ,
	@SrcFileName ,
	CASE WHEN @CENTRAL_DATE_TIME = '' --- use @CENTRAL_DATE_TIME as DataDate
	THEN NULL
	ELSE CONVERT(datetime, @CENTRAL_DATE_TIME)
	END ,

	--GETDATE(),
	GETDATE(),
	--[DataDate] [date] NOT NULL,
	-- [CreatedDate] [date] NOT NULL,
	@CreatedBy ,
	GETDATE(),
	--[LastUpdatedDate] [date] NOT NULL,
	@LastUpdatedBy ,
	CASE WHEN @CENTRAL_DATE_TIME = ''
	THEN NULL
	ELSE CONVERT(datetime, @CENTRAL_DATE_TIME)
	END ,

	@CLIENT_PATIENT_ID ,
	@CLIENT_ID,
	@ACE_ID,
 --   CASE WHEN @ACE_ID = ''
	--THEN NULL
	--ELSE CONVERT(NUMERIC(15,0), @ACE_ID)
	--END ,

	@FIRST_NAME  ,
	@LAST_NAME  ,
	@PHONE_NUMBER,
	@Content  ,
	@WORKFLOW_ID  ,
	@WORKFLOW_NAME ,
	@UserName 
   )
   END;

  -- SET @ActionStopDateTime = GETDATE(); 
  -- EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditID, @ActionStopDateTime, 1,1,0,2   

  --  EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, '[ACECARDW].[adi].[copUhcPcor]', '';

END




