

CREATE	PROCEDURE [ast].[ntfLoadToStgAetnaMA]
											      
											    

AS		

BEGIN

BEGIN TRY 
BEGIN TRAN
				
					DECLARE @AuditId INT;    
					DECLARE @JobStatus tinyInt = 1    
					DECLARE @JobType SmallInt = 9	  
					DECLARE @ClientKey INT	 = 0; 
					DECLARE @JobName VARCHAR(100) = 'ntfAetnaMA';
					DECLARE @ActionStart DATETIME2 = GETDATE();
					DECLARE @SrcName VARCHAR(100) = 'ACECAREDW.adi.NtfAetMaTxDlyCensus'
					DECLARE @DestName VARCHAR(100) = '[ast].[ntfNotification]'
					DECLARE @ErrorName VARCHAR(100) = 'NA';
					DECLARE @InpCnt INT = -1;
					DECLARE @OutCnt INT = -1;
					DECLARE @ErrCnt INT = -1;
					--DECLARE @DataDate DATE = GETDATE() 
					
					
					SELECT				 @InpCnt =  COUNT(aetma.NtfAetDlyCensusKey)    
					FROM				 ACECAREDW.adi.NtfAetMaTxDlyCensus aetMA
					LEFT JOIN			 [AceMPI].[adw].[MPI_ClientMemberAssociationHistoryODS] vw
					ON					 SUBSTRING(DWMEMBERID,CHARINDEX('0',DWMEMBERID)+2, LEN(DWMEMBERID)) = vw.ClientMemberKey 
					LEFT JOIN			 AceMPI.adw.MPI_MstrMrn mpi
					ON					 vw.MstrMrnKey = mpi.MstrMrnKey
					WHERE				 vw.MstrMrnKey IS NOT NULL
					AND					 Active = 1
					AND					 RowStatus = 0 
								
					-- SELECT				 @InpCnt  

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
					
					IF OBJECT_ID('tempdb..#ntfAetnaMA') IS NOT NULL DROP TABLE #ntfAetnaMA

					CREATE TABLE #ntfAetnaMA(AceID NUMERIC (15,0),ClientMemberKey VARCHAR(50),ClientKey INT,CreatedDate DATETIME,Client_Subscriber_ID VARCHAR(50),AdiNtfNotificationKey INT,DataDate DATE
										 ,LoadDate DATE
										 ,SrcFileName VARCHAR(200),NotificationType VARCHAR(50),EventType VARCHAR(50),PatientClass VARCHAR(50), AdmitDateTime DATE, DischargeDateTime DATE
										 ,DischargeDisposition VARCHAR(100), ChiefComplaint VARCHAR(1000), DiagnosisDescription VARCHAR(1000), DiagnosisCode VARCHAR(100), AdmitHospital VARCHAR(100)
										 ,NtfSource VARCHAR(50),AttendingDoctor VARCHAR(50),ReferringDoctor VARCHAR(50),ConsultingDoctor VARCHAR(50),AdmittingDoctor VARCHAR(50)
										 ,ReadmissionIndicator VARCHAR(50),DrgCode VARCHAR(50))

					CREATE TABLE		#OutputTbl (ID INT NOT NULL );
					--Convert Datetime to Date
					INSERT INTO #ntfAetnaMA(AceID, ClientMemberKey, ClientKey, CreatedDate, LoadDate,DataDate,Client_Subscriber_ID, AdiNtfNotificationKey
										 ,SrcFileName, NotificationType, EventType, PatientClass, AdmitDateTime, DischargeDateTime
										 ,DischargeDisposition, ChiefComplaint, DiagnosisDescription, DiagnosisCode, AdmitHospital
										 ,NtfSource, AttendingDoctor, ReferringDoctor, ConsultingDoctor, AdmittingDoctor
										 ,ReadmissionIndicator, DrgCode)
					OUTPUT				 inserted.AdiNtfNotificationKey INTO #OutputTbl(ID)
					SELECT				 vw.MstrMrnKey AS AceID--,active
										 ,SUBSTRING(DWMEMBERID,CHARINDEX('0',DWMEMBERID)+2, LEN(DWMEMBERID)) as aetMA_ClientMemberKey
										 ,vw.ClientKey,aetMA.CreatedDate,aetMA.LoadDate,aetMA.DataDate
										 ,vw.ClientMemberKey AS Client_Subscriber_ID,NtfAetDlyCensusKey,SourceFileName,''
										 ,AdmissionType,EventType,CONVERT(DATE,ActualAdmitDate),ISNULL(CONVERT(DATE,ActualDischargeDate),'') ActualDischargeDate
										 ,DischargeDisposition,''
										 ,DiagnosisDescription,DiagnosisCode,[FacilityName/Role],'Aetna' AS NtfSource
										 ,'','','','',[Readmission Predictor],'' AS DrgCode
					FROM				 ACECAREDW.adi.NtfAetMaTxDlyCensus aetMA
					LEFT JOIN			 [AceMPI].[adw].[MPI_ClientMemberAssociationHistoryODS] vw
					ON					 SUBSTRING(DWMEMBERID,CHARINDEX('0',DWMEMBERID)+2, LEN(DWMEMBERID)) = vw.ClientMemberKey 
					LEFT JOIN			 AceMPI.adw.MPI_MstrMrn mpi
					ON					 vw.MstrMrnKey = mpi.MstrMrnKey
					WHERE				 vw.MstrMrnKey IS NOT NULL
					AND					 Active = 1
					AND					 RowStatus = 0 
															
					
					--Insert into stg
					INSERT	INTO		ast.NtfNotification
										([CreatedDate],[LoadDate], [DataDate],[adiKey],[ClientMemberKey], [ClientKey]
										,NtfSource, [srcEventType]--,[srcNtfType]
										,[srcNtfPatientType]
										,[SrcAdmitDateTime]
										,SrcActualDischargeDate, [SrcDischargeDisposition]
										,[SrcDiagnosisCode], [SrcDiagnosisDesc]
										,[SrcAdmitHospital],SrcFileName,AceFollowUpDueDate,SrcChiefComplaint
										,AceID,DrgCode)

					SELECT				GETDATE(),a.LoadDate,a.DataDate, AdiNtfNotificationKey,ClientMemberKey,ClientKey
										,a.NtfSource
										,CASE					WHEN	DischargeDateTime = '' OR DischargeDateTime = '1900-01-01' OR DischargeDateTime IS NULL
																THEN   'ADM'
										ELSE   'DIS'
										END    EventType
										,CASE a.PatientClass	WHEN   ('Inpatient')
																THEN   (SELECT	Destination 
																		FROM	ACECAREDW.lst.ListAceMapping 
																		WHERE   ClientKey = 3
																		AND		Destination = 'IP')
																WHEN   ('Medical Inpatient')
																THEN   (SELECT	Destination 
																		FROM	ACECAREDW.lst.ListAceMapping 
																		WHERE   ClientKey = 3
																		AND		Destination = 'IP')
										ELSE 'NotAssigned'
										END PatientClass,a.AdmitDateTime
										,a.DischargeDateTime,a.DischargeDisposition
										,a.DiagnosisCode, a.DiagnosisDescription
										,a.AdmitHospital, a.SrcFileName,'',a.ChiefComplaint
										,a.AceID,a.DrgCode
					FROM				#ntfAetnaMA a
		
						

					
					SET					@ActionStart  = GETDATE();
					SET					@JobStatus =2  
					    				
					EXEC				amd.sp_AceEtlAudit_Close 
										@Audit_Id = @AuditID
										, @ActionStopTime = @ActionStart
										, @SourceCount = @InpCnt		  
										, @DestinationCount = @OutCnt
										, @ErrorCount = @ErrCnt
										, @JobStatus = @JobStatus


					DROP TABLE #ntfAetnaMA
					DROP TABLE #OutputTbl					
										

COMMIT
END TRY
BEGIN CATCH
EXECUTE				[dbo].[usp_QM_Error_handler]
END CATCH


END




										
										
										
