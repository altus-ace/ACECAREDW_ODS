CREATE PROCEDURE [adw].[z__Load_MasterJob_Notification_OLD]
AS

--Step 1 Truncate staging table
	DECLARE @InsertCount INT;
	DECLARE	@SourceCount INT;
    DECLARE @QueryCount INT				= 0;    
    DECLARE @Audit_ID INT				= 0;
    DECLARE @ClientKey INT				=1;
    DECLARE @qmFx VARCHAR(100);
    DECLARE @Destination VARCHAR(100)	= 'ast.NtfNotification';
    DECLARE @JobName VARCHAR(100)		= '[adw].[Load_MasterJob_Notification]';
    DECLARE @StartTime DATETIME2;
	DECLARE @OutputTbl Table (ID INT);
	INSERT INTO @OutputTbl (ID)
	SELECT NtfSkey FROM ast.NtfNotification 
	SELECT @SourceCount = COUNT(*) FROM @OutputTbl 
	
	   -- Audit Status     1	In process,     2	Success,    3	Fail-- Job Type        4	Move File,    5	ETL Data,     6	Export Data
   /* 
   ***The logging calls is called inside the QM Procedure 
   ***Set Open logging
   ***Set Close logging
   */

BEGIN
IF EXISTS (SELECT * FROM adi.NtfGhhNotifications WHERE CONVERT(DATE,CreatedDate) =  CONVERT(DATE,GETDATE()))--LEFT(GETDATE(),11)) 
--PRINT 'Yes Record Exist' ELSE PRINT 'No it does not Exist' 
     --TRUNCATE TABLE [ast].[NtfNotification];

--Write to Stg

	SET @StartTime = GETDATE();	   
	SET @qmFx = '[ast].[NtfNotificationStg]'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'Check table , AceEtlAuditErrorLog' 
	EXEC [ast].[NtfNotificationStg]	
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = @SourceCount, @DestinationCount = @SourceCount,@ErrorCount = @@ERROR;  

END


--Inserting into adw
--The ODS stores the transformed data from the staging for export. The biz rules are applied from staging to adw
BEGIN

	DECLARE @Destination1 VARCHAR(100)	= 'adw.NtfNotification';

	SET @StartTime = GETDATE();	   
	SET @qmFx = '[adw].[NtfNotificationGlobal]'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination1, @ErrorName = 'Check table , AceEtlAuditErrorLog' 
	EXEC [adw].[NtfNotificationGlobal]	
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = @SourceCount, @DestinationCount = @SourceCount,@ErrorCount = @@ERROR;  

END

--Calculating for discharges

BEGIN

	DECLARE @Destination2 VARCHAR(100)	= 'adw.NtfNotification';

	SET @StartTime = GETDATE();	   
	SET @qmFx = '[adw].[NtfNotificationGlobal]'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination2, @ErrorName = 'Check table , AceEtlAuditErrorLog' 
	EXEC [adw].[NtfNotificationCalcDischarges]
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = @SourceCount, @DestinationCount = @SourceCount,@ErrorCount = @@ERROR; 
	
END

--Inserting into SCHN MSSP Ntf Table
BEGIN 

	DECLARE @Destination3 VARCHAR(100)	= 'SCHNMSSPadw.NtfNotification';

	SET @StartTime = GETDATE();	   
	SET @qmFx = 'adw.LoadNtfSchnMsspFromAdwNtfNotification'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination3, @ErrorName = 'Check table , AceEtlAuditErrorLog' 
	EXEC [ACDW_CLMS_SHCN_MSSP].[adw].[LoadNtfSchnMsspFromAdwNtfNotification]
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = @SourceCount, @DestinationCount = @SourceCount,@ErrorCount = @@ERROR;  

END

