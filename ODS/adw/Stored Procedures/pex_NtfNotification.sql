


CREATE PROCEDURE [adw].[pex_NtfNotification]
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
					DECLARE @SrcName VARCHAR(100) = '[ACECAREDW].[adw].[ntfNotification]'
					DECLARE @DestName VARCHAR(100) = '[ACECAREDW].[dbo].[vw_ntfNotification]'
					DECLARE @ErrorName VARCHAR(100) = 'NA';
					DECLARE @InpCnt INT = -1;
					DECLARE @OutCnt INT = -1;
					DECLARE @ErrCnt INT = -1;
					--DECLARE @DataDate DATE = GETDATE() 
					
					
					SELECT				 @InpCnt = COUNT(ntf.ntfNotificationKey)    
					FROM				 ACECAREDW.adw.NtfNotification ntf
					WHERE				 Exported = 0
								
					

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

 --SET Exported Column to 2 for Never to Export Where dup occur --------------------------
		;WITH CTE_NtfNotToBeExported --consider activemembers 
		AS
		(
		SELECT 
									[CreatedDate],[LoadDate],[DataDate], [ClientKey], [ClientMemberKey],AceID,[NtfSource],[NtfPatientType]
									,[ntfEventType], [CaseType], [AdmitDateTime]
									,[ActualDischargeDate], [DischargeDisposition],  [ChiefComplaint]
									,[DiagnosisCode], [DiagnosisDesc], [AdmitHospital], [AceFollowUpDueDate]
									,[AdiKey],[SrcFileName]
									,ROW_NUMBER() OVER (PARTITION BY ClientMemberKey, NtfPatientType,CaseType
									, CONVERT(DATE, AdmitDateTime) , CONVERT(DATE, ActualDischargeDate)
									ORDER BY DataDate
									, CASE WHEN NtfSource = 'GHH' THEN 'zGhh' ELSE NtfSource end  ) aRowNumber	
									,Exported,ExportedDate
		FROM						adw.NtfNotification 
		WHERE						Exported = 0
		--AND							ClientKey <> 16 --exclude shcn a bug
		--AND							NtfPatientType IN ('IP','ER')
		--AND							CaseType NOT IN ( 'Inhospital','TRF')
		
		) 

		--SELECT						* FROM CTE_NtfNotToBeExported  WHERE aRowNumber >1 ORDER BY AceFollowUpDueDate DESC

		
		UPDATE						CTE_NtfNotToBeExported
		SET							Exported = 2 
		WHERE						aRowNumber >1
		AND							Exported = 0
		AND							ExportedDate IS NULL
									
		UPDATE						adw.NtfNotification
		SET							ExportedDate = GETDATE()
		WHERE						Exported = 2
		AND							Convert(Date,CreatedDate) = Convert(date,Getdate())

		
		BEGIN
		---Status for Members who are not active--SET Exported Column to 9 for Never to Export where member is inactive
		UPDATE						adw.NtfNotification
		SET							Exported = 9  --SELECT ClientMemberKey, Client_Subscriber_ID 
		FROM						adw.NtfNotification a
		LEFT JOIN					ACECAREDW.dbo.vw_ActiveMembers b
		ON							a.ClientMemberKey = b.CLIENT_SUBSCRIBER_ID
		WHERE						b.CLIENT_SUBSCRIBER_ID IS NULL 
		AND							Exported = 0
		--AND							a.ClientKey <> 16 uncommented becos no inactive members shud be exported
		--AND							ClientMemberKey in ('117642645','118107308','118540155')

		UPDATE						adw.NtfNotification
		SET							ExportedDate = CONVERT(DATE,GETDATE())  --SELECT ClientMemberKey, Client_Subscriber_ID,Exported 
		FROM						adw.NtfNotification a
		LEFT JOIN					ACECAREDW.dbo.vw_ActiveMembers b
		ON							a.ClientMemberKey = b.CLIENT_SUBSCRIBER_ID
		WHERE						b.CLIENT_SUBSCRIBER_ID IS NULL 
		AND							Exported = 9
		AND							CONVERT(DATE,CreatedDate) = CONVERT(DATE,GETDATE())
		--AND							a.ClientKey <> 16
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
