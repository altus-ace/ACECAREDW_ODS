-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportMpulseAceMessages](
    @OriginalFileName varchar(100),
	@SrcFileName varchar(100) ,
	@DataDate Varchar(10) ,
	-- [CreatedDate] [date] NOT NULL,
	@CreatedBy varchar(50),
	--@LastUpdatedDate] [date] NOT NULL,
	@LastUpdatedBy varchar(50),
	@CLIENT_PATIENT_ID varchar(50),
	@CLIENT_ID VARCHAR(10),
	@ACE_ID VARCHAR(10),
	@FIRST_NAME varchar(50),
	@LAST_NAME varchar(50) ,
	@PHONE_NUMBER varchar(35),
	@UserName varchar(100) ,
	@WORKFLOW_ID varchar(20) ,
	@WORKFLOW_NAME varchar(50),
	@Content varchar(max) ,
	@CENTRAL_DATE_TIME VARCHAR(20)

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
 INSERT INTO [adi].[MpulseAceMessages]
   (
    [OriginalFileName] ,
	[SrcFileName] ,
	[DataDate] ,
	[CreatedDate] ,
	[CreatedBy] ,
	[LastUpdatedDate],
	[LastUpdatedBy],
	[CLIENT_PATIENT_ID] ,
	[CLIENT_ID] ,
	[ACE_ID],
	[FIRST_NAME] ,
	[LAST_NAME] ,
	[PHONE_NUMBER] ,
	[UserName] ,
	[WORKFLOW_ID],
	[WORKFLOW_NAME] ,
	[Content] ,
	[CENTRAL_DATE_TIME]
    )
     VALUES
   (
    
	@OriginalFileName ,
	@SrcFileName ,
	CASE WHEN @CENTRAL_DATE_TIME = '' --- use @CENTRAL_DATE_TIME as DataDate
	THEN NULL
	ELSE CONVERT(datetime, @CENTRAL_DATE_TIME)
	END ,
	--CASE WHEN @DataDate = ''
	--THEN NULL
	--ELSE CONVERT(DATE, @DataDate)
	--END ,
	GETDATE(),
	-- [CreatedDate] [date] NOT NULL,
	@CreatedBy,
	GETDATE(),
	--@LastUpdatedDate] [date] NOT NULL,
	@LastUpdatedBy ,
	@CLIENT_PATIENT_ID ,
	@CLIENT_ID,
 --   CASE WHEN @CLIENT_ID = ''
	--THEN NULL
	--ELSE CONVERT(int, @CLIENT_ID)
	--END ,
	CASE WHEN @ACE_ID = ''
	THEN NULL
	ELSE CONVERT(numeric(15,0), @ACE_ID)
	END ,
	@FIRST_NAME ,
	@LAST_NAME ,
	@PHONE_NUMBER ,
	@UserName,
	@WORKFLOW_ID ,
	@WORKFLOW_NAME ,
	@Content ,
	CASE WHEN @CENTRAL_DATE_TIME = ''
	THEN NULL
	ELSE CONVERT(datetime, @CENTRAL_DATE_TIME)
	END 

   )
   END;

  -- SET @ActionStopDateTime = GETDATE(); 
  -- EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditID, @ActionStopDateTime, 1,1,0,2   

  --  EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, '[ACECARDW].[adi].[copUhcPcor]', '';

END




