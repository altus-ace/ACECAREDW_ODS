


CREATE PROCEDURE [adw].[pdw_NtfNotification]
AS
BEGIN
 --Log code
BEGIN TRY 
BEGIN TRAN
				
					DECLARE @AuditId INT;    
					DECLARE @JobStatus tinyInt = 1    
					DECLARE @JobType SmallInt = 9	  
					DECLARE @ClientKey INT	 = 0; 
					DECLARE @JobName VARCHAR(100) = 'ntfNotificationStg';
					DECLARE @ActionStart DATETIME2 = GETDATE();
					DECLARE @SrcName VARCHAR(100) = '[ACECAREDW].[ast].[ntfNotification]'
					DECLARE @DestName VARCHAR(100) = '[ACECAREDW].[adw].[ntfNotification]'
					DECLARE @ErrorName VARCHAR(100) = 'NA';
					DECLARE @InpCnt INT = -1;
					DECLARE @OutCnt INT = -1;
					DECLARE @ErrCnt INT = -1;
					--DECLARE @DataDate DATE = GETDATE() 
					
					
					SELECT				 @InpCnt = COUNT(ntf.NtfSkey)    
					FROM				 ACECAREDW.ast.NtfNotification ntf
					WHERE				 RowStatus = 0
								
					

EXEC				amd.sp_AceEtlAudit_Open 
					@AuditID = @AuditID OUTPUT
					, @AuditStatus = @JobStatus
					, @JobType = @JobType
					, @ClientKey = @ClientKey
					, @JobName = @JobName
					, @ActionStartTime = @ActionStart
					, @InputSourceName = @SrcName
					, @DestinationName = @DestName
					, @ErrorName = @ErrorName

    BEGIN
		--TRUNCATE TABLE [adw].[NtfNotification] 
		--Get Ghh and MCO records into adw
		--Supress the latest record and export the earliest record
		IF OBJECT_ID('tempdb..#ntfAdwNotf') IS NOT NULL DROP TABLE #ntfAdwNotf
			;WITH CTE_ntfNotification
		AS ---
		( 
		SELECT								 stg.CreatedDate,stg.[LoadDate],stg.[DataDate],stg.[ClientKey],stg.[ClientMemberKey],stg.AceID
											 ,stg.NtfSource
											 ,srcNtfPatientType
											 ,srcEventType
											 ,CaseType
											 ,SrcAdmitDateTime
											 ,SrcActualDischargeDate
											 ,SrcDischargeDisposition
											 ,SrcChiefComplaint
											 ,SrcDiagnosisCode
											 ,SrcDiagnosisDesc
											 ,SrcAdmitHospital
											 ,RowStatus
											 ,AceFollowUpDueDate
											 ,stg.AdiKey
											 ,'ast.NtfNotification' AS SrcFileName
											 ,DrgCode
											 ,Exported
											 ,ROW_NUMBER() OVER(PARTITION BY stg.[ClientMemberKey],stg.SrcAdmitDateTime
											 								,stg.SrcActualDischargeDate,stg.srcNtfPatientType,
											 								stg.SrcEventType,stg.ntfsource
											 								ORDER BY DataDate DESC)RwCnt
		FROM								 ast.NtfNotification stg
		WHERE								 RowStatus = 0
				
		)  
						
		SELECT								 [CreatedDate],[LoadDate]
											 ,[DataDate], [ClientKey]
											 ,[ClientMemberKey],AceID
											 ,[NtfSource],[srcNtfPatientType]
											 ,[srcEventType],[CaseType], [SrcAdmitDateTime]
											 ,[srcActualDischargeDate], [srcDischargeDisposition]
											 ,[SrcChiefComplaint]
											 ,[srcDiagnosisCode], [srcDiagnosisDesc]
											 ,[SrcAdmitHospital],RowStatus 
											 ,[AceFollowUpDueDate]
											 ,[AdiKey],[SrcFileName],DrgCode
											 ,Exported
		INTO								 #ntfAdwNotf
		FROM								 CTE_ntfNotification 
		WHERE								 RwCnt =1

		END

		BEGIN		
		INSERT INTO [adw].[NtfNotification] ([CreatedDate],[LoadDate], [DataDate]
											,[ClientKey], [ClientMemberKey],AceID
											,[NtfSource],[NtfPatientType]
											,[ntfEventType], [CaseType],[AdmitDateTime]
											,[ActualDischargeDate],[DischargeDisposition]
											,[ChiefComplaint],[DiagnosisCode]
											,[DiagnosisDesc], [AdmitHospital], [AceFollowUpDueDate]
											,[AdiKey],[SrcFileName],DrgCode,Exported )
		SELECT								 tmp.[CreatedDate],tmp.[LoadDate], tmp.[DataDate]
											,tmp.[ClientKey], tmp.[ClientMemberKey]
											,tmp.AceID, tmp.[NtfSource]
											,[srcNtfPatientType]
											,[srcEventType],tmp.[CaseType],[SrcAdmitDateTime]
											,[srcActualDischargeDate], [srcDischargeDisposition]
											,[SrcChiefComplaint],[srcDiagnosisCode], [srcDiagnosisDesc]
											,[SrcAdmitHospital], tmp.[AceFollowUpDueDate]
											,tmp.[AdiKey],tmp.[SrcFileName],tmp.[DrgCode]
											,tmp.Exported 
		FROM								#ntfAdwNotf tmp
		LEFT JOIN							adw.NtfNotification adw
		ON									adw.ClientMemberKey =		tmp.ClientMemberKey
		AND									adw.AdmitDateTime =			tmp.SrcAdmitDateTime
		AND									adw.ActualDischargeDate =	tmp.srcActualDischargeDate
		AND									adw.NtfPatientType =		tmp.srcNtfPatientType	
		WHERE								adw.ClientMemberKey IS NULL
		AND									adw.AdmitDateTime IS NULL
		AND									adw.ActualDischargeDate IS NULL
		AND									adw.NtfPatientType IS NULL 


		END
    
					 SET				@ActionStart  = GETDATE();
					 SET				@JobStatus =2  
					    				
					 EXEC				amd.sp_AceEtlAudit_Close 
										@Audit_Id = @AuditID
										, @ActionStopTime = @ActionStart
										, @SourceCount = @InpCnt		  
										, @DestinationCount = @OutCnt
										, @ErrorCount = @ErrCnt
										, @JobStatus = @JobStatus


					

COMMIT
END TRY
BEGIN CATCH
EXECUTE				[dbo].[usp_QM_Error_handler]
END CATCH


END
		









