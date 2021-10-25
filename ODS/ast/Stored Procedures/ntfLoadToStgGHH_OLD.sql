


CREATE	PROCEDURE [ast].[ntfLoadToStgGHH_OLD]
											      
											    

AS		

BEGIN

BEGIN TRY 
BEGIN TRAN
				
					DECLARE @AuditId INT;    
					DECLARE @JobStatus tinyInt = 1    
					DECLARE @JobType SmallInt = 9	  
					DECLARE @ClientKey INT	 = 0; 
					DECLARE @JobName VARCHAR(100) = 'ntfGHH';
					DECLARE @ActionStart DATETIME2 = GETDATE();
					DECLARE @SrcName VARCHAR(100) = '[ACECAREDW].[adi].[NtfGhhNotifications]'
					DECLARE @DestName VARCHAR(100) = '[ast].[ntfNotification]'
					DECLARE @ErrorName VARCHAR(100) = 'NA';
					DECLARE @InpCnt INT = -1;
					DECLARE @OutCnt INT = -1;
					DECLARE @ErrCnt INT = -1;
					--DECLARE @DataDate DATE = GETDATE() 
					
					
					SELECT				@InpCnt =  COUNT(NtfGhhNotificationKey)    
					FROM				[ACECAREDW].[adi].[NtfGhhNotifications] gh 
					LEFT JOIN			[AceMPI].[adw].[MPI_ClientMemberAssociationHistoryODS] vw
					ON					AceID= vw.MstrMrnKey 
					WHERE				AceID IS NOT NULL
					AND					Status = 0 
								
				--	SELECT				@InpCnt  

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
					
					IF OBJECT_ID('tempdb..#ntfGHH') IS NOT NULL DROP TABLE #ntfGHH

					CREATE TABLE #ntfGHH(AceID NUMERIC (15,0),ClientMemberKey VARCHAR(50),ClientKey INT,CreatedDate DATETIME,Client_Subscriber_ID VARCHAR(50),LoadDate DATE,AdiNtfNotificationKey INT,DataDate DATE
										 ,SrcFileName VARCHAR(200),NotificationType VARCHAR(50),EventType VARCHAR(50),PatientClass VARCHAR(50), AdmitDateTime DATE, DischargeDateTime DATE
										 ,DischargeDisposition VARCHAR(200), ChiefComplaint VARCHAR(1000), DiagnosisDescription VARCHAR(1000), DiagnosisCode VARCHAR(100), AdmitHospital VARCHAR(100)
										 ,NtfSource VARCHAR(50),AttendingDoctor VARCHAR(100),ReferringDoctor VARCHAR(100),ConsultingDoctor VARCHAR(100),AdmittingDoctor VARCHAR(100)
										 ,ReadmissionIndicator VARCHAR(100),DrgCode VARCHAR(50))

					CREATE TABLE		#OutputTbl (ID INT NOT NULL )

					INSERT INTO #ntfGHH (AceID, ClientMemberKey, ClientKey, CreatedDate, LoadDate,DataDate,Client_Subscriber_ID, AdiNtfNotificationKey
										 ,SrcFileName, NotificationType, EventType, PatientClass, AdmitDateTime, DischargeDateTime
										 ,DischargeDisposition, ChiefComplaint, DiagnosisDescription, DiagnosisCode, AdmitHospital
										 ,NtfSource, AttendingDoctor, ReferringDoctor, ConsultingDoctor, AdmittingDoctor
										 ,ReadmissionIndicator, DrgCode)
					--OUTPUT				 inserted.AdiNtfNotificationKey INTO #OutputTbl(ID)
					SELECT				 gh.AceID, vw.ClientMemberKey
										 ,vw.ClientKey,gh.CreatedDate,CONVERT(DATE,GETDATE()) AS LoadDate ,gh.DataDate
										 ,vw.ClientMemberKey AS Client_Subscriber_ID,NtfGhhNotificationKey AS AdiNtfNotificationKey,SrcFileName,NotificationType
										 ,EventType ,PatientClass,CONVERT(DATE,AdmitDateTime) AS AdmitDateTime
										 ,ISNULL(CONVERT(DATE,DischargeDateTime),'') AS DischargeDateTime,DischargeDisposition,ChiefComplaint
										 ,DiagnosisDescription,DiagnosisCode,AdmitHospital,'GHH'AS NtfSource
										 ,AttendingDoctor,ReferringDoctor,ConsultingDoctor,AdmittingDoctor,ReadmissionIndicator,'' AS DrgCode
										 --,Status
					FROM				 [ACECAREDW].[adi].[NtfGhhNotifications] gh 
					LEFT JOIN			 [AceMPI].[adw].[MPI_ClientMemberAssociationHistoryODS] vw
					ON					 AceID= vw.MstrMrnKey 
					WHERE				 MstrMrnKey IS NOT NULL 
					AND					 Status = 0 

					--Transform to Decode
					UPDATE		#ntfGHH
					SET			EventType = ghh.Ace_Definition 
					FROM		#ntfGHH a
					JOIN		ACECAREDW.lst.lstGHHCodes ghh
					ON			a.EventType = ghh.Code	
					WHERE		[Type] = 'Event'

					UPDATE		#ntfGHH
					SET			PatientClass = ghh.Ace_Definition 
					FROM		#ntfGHH a
					JOIN		ACECAREDW.lst.lstGHHCodes ghh
					ON			a.PatientClass = ghh.Code	
					WHERE		[Type] = 'PatientType'

					UPDATE		#ntfGHH
					SET			DischargeDisposition = ghh.Ace_Definition 
					FROM		#ntfGHH a
					JOIN		ACECAREDW.lst.lstGHHCodes ghh
					ON			a.DischargeDisposition = ghh.Code	
					WHERE		[Type] = 'Discharge Disposition'

					UPDATE		#ntfGHH
					SET			AdmitHospital = ghh.Ace_Definition
					FROM		#ntfGHH a
					JOIN		ACECAREDW.lst.lstGHHCodes ghh
					ON			a.AdmitHospital = ghh.Code	
					WHERE		[Type] = 'FacilityCode'
					
					
					--Insert into stg 
					INSERT	INTO		ast.NtfNotification
										([CreatedDate],[LoadDate], [DataDate],[adiKey],[ClientMemberKey], [ClientKey]
										,NtfSource, [srcEventType]
										,[srcNtfPatientType]
										,[SrcAdmitDateTime]
										,SrcActualDischargeDate, [SrcDischargeDisposition]
										,[SrcDiagnosisCode], [SrcDiagnosisDesc]
										,[SrcAdmitHospital],SrcFileName,AceFollowUpDueDate,SrcChiefComplaint
										,AceID,DrgCode)
					SELECT				CreatedDate
										,LoadDate
										,DataDate
										,AdiNtfNotificationKey
										,ClientMemberKey
										,ClientKey
										,NtfSource
										,EventType
										,PatientClass
										,AdmitDateTime
										,DischargeDateTime
										,DischargeDisposition
										,DiagnosisCode, a.DiagnosisDescription
										,AdmitHospital, a.SrcFileName,'' AcefollowUpDueDate
										,ChiefComplaint
										,AceID,a.DrgCode
					FROM				(
					SELECT				GETDATE() CreatedDate,a.LoadDate,a.DataDate
										, AdiNtfNotificationKey,ClientMemberKey,ClientKey  
										,a.NtfSource
										,CASE EventType WHEN 'ADM' THEN 'ADM'
														WHEN 'DIS'THEN 'DIS'
														ELSE 'NotAssigned'
										END EventType
										,CASE a.PatientClass WHEN a.PatientClass THEN b.ACE_Definition
															 ELSE 'Not Assigned'
										END PatientClass
										,a.AdmitDateTime
										,a.DischargeDateTime
										,a.DischargeDisposition
										,a.DiagnosisCode, a.DiagnosisDescription
										,a.AdmitHospital, a.SrcFileName,'' AcefollowUpDueDate
										,a.ChiefComplaint
										,a.AceID,a.DrgCode
										,ROW_NUMBER() OVER(PARTITION BY AdiNtfNotificationKey,ClientMemberKey, ClientKey ORDER BY DataDate DESC ) RwCnt
					FROM				#ntfGHH a 
					JOIN				ACECAREDW.lst.lstGHHCodes b
					ON					a.PatientClass = b.ACE_Definition
										)a 
					WHERE				RwCnt = 1
							
					
					
					
					
					SET					@ActionStart  = GETDATE();
					SET					@JobStatus =2  
					    				
					EXEC				amd.sp_AceEtlAudit_Close 
										@Audit_Id = @AuditID
										, @ActionStopTime = @ActionStart
										, @SourceCount = @InpCnt		  
										, @DestinationCount = @OutCnt
										, @ErrorCount = @ErrCnt
										, @JobStatus = @JobStatus

					DROP TABLE #ntfGHH
					DROP TABLE #OutputTbl

COMMIT
END TRY
BEGIN CATCH
EXECUTE				[dbo].[usp_QM_Error_handler]
END CATCH


END


	

	
