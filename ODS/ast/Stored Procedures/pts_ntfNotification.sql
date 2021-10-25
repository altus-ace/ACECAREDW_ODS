






CREATE	PROCEDURE [ast].[pts_ntfNotification] 
--Process transformation in staging
											      								    

AS		

BEGIN

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
					;
					
					--Transformation Applying Biz rules
					
					--(1)--Transforming AcefollowUpDueDate

					UPDATE		ast.NtfNotification
					SET			AceFollowUpDueDate = (CASE 
									   WHEN NtfSource = 'GHH' AND CLIENTKEY = 1 THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 1),CONVERT(DATE,CreatedDate))))
									   WHEN NtfSource = 'GHH' AND CLIENTKEY = 2 THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 2),CONVERT(DATE,CreatedDate))))
									   WHEN NtfSource = 'GHH' AND CLIENTKEY = 3 THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 3),CONVERT(DATE,CreatedDate))))
									   WHEN NtfSource = 'GHH' AND CLIENTKEY = 9 THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 3),CONVERT(DATE,CreatedDate))))
									   WHEN NtfSource = 'GHH' AND CLIENTKEY = 11 THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 11),CONVERT(DATE,CreatedDate))))
									   WHEN NtfSource = 'GHH' AND CLIENTKEY = 12 THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 12),CONVERT(DATE,CreatedDate))))
									   WHEN NtfSource = 'GHH' AND CLIENTKEY = 16 THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 16),CONVERT(DATE,CreatedDate))))
									   WHEN NtfSource = 'GHH' AND CLIENTKEY = 20 THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 20),CONVERT(DATE,CreatedDate))))
									   WHEN NtfSource = 'GHH' AND CLIENTKEY = 21 THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 21),CONVERT(DATE,CreatedDate))))
									   WHEN NtfSource = 'GHH' AND CLIENTKEY = 22 THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 22),CONVERT(DATE,CreatedDate))))
									   WHEN NtfSource = 'Aetna' THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 3),CONVERT(DATE,CreatedDate))))
									   WHEN NtfSource = 'uhcIP' THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 1),CONVERT(DATE,CreatedDate))))
									   WHEN NtfSource = 'uhcER' THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 1),CONVERT(DATE,CreatedDate))))
									   WHEN NtfSource = 'AetCom' THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 9),CONVERT(DATE,CreatedDate))))
									   WHEN NtfSource = 'Devoted' THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 11),CONVERT(DATE,CreatedDate))))
									   WHEN NtfSource = 'CignaMA' THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 12),CONVERT(DATE,CreatedDate))))
									   WHEN NtfSource = 'SHCN_MSSP' THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 16),CONVERT(DATE,CreatedDate))))
									   WHEN NtfSource = 'SHCN_BCBS' THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 20),CONVERT(DATE,CreatedDate))))
									   --WHEN NtfSource = 'AMGTX_MA' THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 21),CONVERT(DATE,CreatedDate))))
									   --WHEN NtfSource = 'AMGTX_MCD' THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 22),CONVERT(DATE,CreatedDate))))
										ELSE ''  END)
					WHERE		CONVERT(DATE,CreatedDate) = CONVERT(DATE,GETDATE())
												
					UPDATE		ast.NtfNotification
					SET			AceFollowUpDueDate = '1900-01-01'													
					WHERE		ClientKey <> 16
					AND			SrcActualDischargeDate = '1900-01-01'
					AND			CONVERT(DATE,CreatedDate) = CONVERT(DATE,GETDATE())
					--For Shcn Inferred CalcDischarges shud also have AceFolloUpDueDate Value
					
					--(2)--Transforming CaseType
					UPDATE		ast.NtfNotification
					SET			CaseType = 
								(CASE WHEN [SrcActualDischargeDate] IS NOT NULL AND LEFT(SrcDiagnosisCode,1) = 'F' THEN (SELECT Destination FROM ACECAREDW.lst.ListAceMapping WHERE Source = 'Mental Health')
									  WHEN [SrcActualDischargeDate] IS NOT NULL AND LEFT(srcDiagnosisCode,1) = 'O' THEN (SELECT Destination FROM ACECAREDW.lst.ListAceMapping WHERE Source = 'Post Partum')
									  WHEN [SrcDischargeDisposition] LIKE '%/Trans%' THEN (SELECT Destination FROM ACECAREDW.lst.ListAceMapping WHERE Source = 'Transfer') 
									  WHEN [SrcActualDischargeDate] = '' OR [SrcActualDischargeDate] IS NULL THEN (SELECT Destination FROM ACECAREDW.lst.ListAceMapping WHERE Source = 'If DischargeDate is Blank')
									  WHEN SrcDischargeDisposition LIKE '%Expi%' THEN 'Expired'
									  ELSE srcNtfPatientType END)
					WHERE		CONVERT(DATE,CreatedDate) = CONVERT(DATE,GETDATE())
					
					--(3) Setting records for export
					BEGIN
						
						UPDATE ast.NtfNotification
						SET	Exported = (CASE WHEN (srcNtfPatientType = 'IP' AND srcEventType = 'DIS' AND CaseType IN ('ER','Expired','IP','MH','PP')) THEN 0
										WHEN ClientKey IN (1,16,20) AND (srcNtfPatientType = 'ER' AND srcEventType = 'DIS' AND CaseType NOT IN ('TRF','Inhospital')) THEN 0
										WHEN ClientKey = 16 AND (srcNtfPatientType = 'IP' AND srcEventType = 'ADM' AND CaseType <> 'TRF' ) THEN 0 ---Peculiar to just MSSP
										ELSE 3
										END 
										)
						WHERE	CONVERT(DATE,CreatedDate) = CONVERT(DATE,GETDATE())

					END

					--(4) --- Set Export to 3 when the field Discharge Disposition have values like Discharge/Transfer, ie Never get exported
					BEGIN

							UPDATE		ast.NtfNotification
							SET			Exported = (CASE WHEN SrcDischargeDisposition LIKE '%/Tran%' THEN 3 END )
							WHERE		srcDischargeDisposition  LIKE '%/Tran%' 
							AND			CONVERT(DATE,CreatedDate) = CONVERT(DATE,GETDATE())
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



										  																






	
