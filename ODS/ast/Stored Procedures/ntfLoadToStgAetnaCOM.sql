


CREATE	PROCEDURE [ast].[ntfLoadToStgAetnaCOM]
											      
											    

AS		

BEGIN

BEGIN TRY 
BEGIN TRAN
				
					DECLARE @AuditId INT;    
					DECLARE @JobStatus tinyInt = 1    
					DECLARE @JobType SmallInt = 9	  
					DECLARE @ClientKey INT	 = 0; 
					DECLARE @JobName VARCHAR(100) = 'ntfAetnaCOM';
					DECLARE @ActionStart DATETIME2 = GETDATE();
					DECLARE @SrcName VARCHAR(100) = 'ACECAREDW.adi.NtfAetComDlyCensus'
					DECLARE @DestName VARCHAR(100) = '[ast].[ntfNotification]'
					DECLARE @ErrorName VARCHAR(100) = 'NA';
					DECLARE @InpCnt INT = -1;
					DECLARE @OutCnt INT = -1;
					DECLARE @ErrCnt INT = -1;
					--DECLARE @DataDate DATE = GETDATE() 
					
					
					SELECT				 @InpCnt = COUNT(aetcom.ntfAetComNotificationKey)    
					FROM				 ACECAREDW.adi.NtfAetComDlyCensus AetCom
					LEFT JOIN			 [AceMPI].[adw].[MPI_ClientMemberAssociationHistoryODS] vw
					ON					 SUBSTRING([DW Member ID],CHARINDEX('0',[DW Member ID])+2, LEN([DW Member ID]))= vw.ClientMemberKey 
					LEFT JOIN			 AceMPI.adw.MPI_MstrMrn mpi
					ON					 vw.MstrMrnKey = mpi.MstrMrnKey
					WHERE				 vw.MstrMrnKey IS NOT NULL
					AND					 Active = 1 
					AND					 RowStatus = 0
								
					

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
					
					IF OBJECT_ID('tempdb..#ntfAetnaCOM') IS NOT NULL DROP TABLE #ntfAetnaCOM

					CREATE TABLE #ntfAetnaCOM(AceID NUMERIC (15,0),ClientMemberKey VARCHAR(50),ClientKey INT,CreatedDate DATETIME,Client_Subscriber_ID VARCHAR(50),AdiNtfNotificationKey INT,DataDate DATE
										 ,LoadDate DATE
										 ,SrcFileName VARCHAR(200),NotificationType VARCHAR(50),EventType VARCHAR(50),PatientClass VARCHAR(50), AdmitDateTime DATE, DischargeDateTime DATE
										 ,DischargeDisposition VARCHAR(100), ChiefComplaint VARCHAR(1000), DiagnosisDescription VARCHAR(1000), DiagnosisCode VARCHAR(100), AdmitHospital VARCHAR(100)
										 ,NtfSource VARCHAR(50),AttendingDoctor VARCHAR(50),ReferringDoctor VARCHAR(50),ConsultingDoctor VARCHAR(50),AdmittingDoctor VARCHAR(50)
										 ,ReadmissionIndicator VARCHAR(50),DrgCode VARCHAR(50))

					CREATE TABLE		#OutputTbl (ID INT NOT NULL );
					--Convert Datetime to Date
					INSERT INTO #ntfAetnaCOM(AceID, ClientMemberKey, ClientKey, CreatedDate, LoadDate,DataDate,Client_Subscriber_ID, AdiNtfNotificationKey
										 ,SrcFileName, NotificationType, EventType, PatientClass, AdmitDateTime, DischargeDateTime
										 ,DischargeDisposition, ChiefComplaint, DiagnosisDescription, DiagnosisCode, AdmitHospital
										 ,NtfSource, AttendingDoctor, ReferringDoctor, ConsultingDoctor, AdmittingDoctor
										 ,ReadmissionIndicator, DrgCode)
					OUTPUT				 inserted.AdiNtfNotificationKey INTO #OutputTbl(ID)
					SELECT			     vw.MstrMrnKey AS AceID 
										 ,SUBSTRING([DW Member ID],CHARINDEX('0',[DW Member ID])+2, LEN([DW Member ID])) as AetCom_ClientMemberKey
										 ,vw.ClientKey,AetCom.CreatedDate,AetCom.LoadDate,AetCom.DataDate
										 ,vw.ClientMemberKey AS Client_Subscriber_ID
										 ,ntfAetComNotificationKey AS AdiNtfNotificationKey
										 ,AetCom.SrcFileName,''
										 ,[Admission Type],[Event Type],[Actual Admit Date],ISNULL([Actual Discharge Date],'')[Actual Discharge Date]
										 ,[Discharge Disposition ],''
										 ,[Diagnosis Description],[Diagnosis Code],[Facility Name/Role],'AetCom' AS NtfSource
										 ,'','','','',[ReadmissionPredictor],'' AS DrgCode
					FROM				 ACECAREDW.adi.NtfAetComDlyCensus AetCom
					LEFT JOIN			 [AceMPI].[adw].[MPI_ClientMemberAssociationHistoryODS] vw
					ON					 SUBSTRING([DW Member ID],CHARINDEX('0',[DW Member ID])+2, LEN([DW Member ID]))= vw.ClientMemberKey 
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
					FROM				#ntfAetnaCOM a 
		
						

					
					SET					@ActionStart  = GETDATE();
					SET					@JobStatus =2  
					    				
					EXEC				amd.sp_AceEtlAudit_Close 
										@Audit_Id = @AuditID
										, @ActionStopTime = @ActionStart
										, @SourceCount = @InpCnt		  
										, @DestinationCount = @OutCnt
										, @ErrorCount = @ErrCnt
										, @JobStatus = @JobStatus


					DROP TABLE #ntfAetnaCOM
					DROP TABLE #OutputTbl					
										

COMMIT
END TRY
BEGIN CATCH
EXECUTE				[dbo].[usp_QM_Error_handler]
END CATCH


END




										
										
										
