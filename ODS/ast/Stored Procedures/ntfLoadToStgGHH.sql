


CREATE	PROCEDURE [ast].[ntfLoadToStgGHH]
											      
											    

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
										 ,ReadmissionIndicator VARCHAR(100),DrgCode VARCHAR(50),RwCnt TinyINT)

					CREATE TABLE		#OutputTbl (ID INT NOT NULL )

					INSERT INTO #ntfGHH (AceID, ClientMemberKey, ClientKey, CreatedDate, LoadDate,DataDate,Client_Subscriber_ID, AdiNtfNotificationKey
										 ,SrcFileName, NotificationType, EventType, PatientClass, AdmitDateTime, RwCnt,DischargeDateTime
										 ,DischargeDisposition, ChiefComplaint, DiagnosisDescription, DiagnosisCode, AdmitHospital
										 ,NtfSource
										 --, AttendingDoctor, ReferringDoctor, ConsultingDoctor, AdmittingDoctor,ReadmissionIndicator
										 , DrgCode)
					-- OUTPUT				 inserted.AdiNtfNotificationKey INTO #OutputTbl(ID)
					SELECT				 gh.AceID, vw.ClientMemberKey
										 ,vw.ClientKey
										 ,gh.CreatedDate
										 ,CONVERT(DATE,GETDATE()) AS LoadDate 
										 ,gh.DataDate
										 ,vw.ClientMemberKey AS Client_Subscriber_ID
										 ,NtfGhhNotificationKey AS AdiNtfNotificationKey
										 ,'[ACECAREDW].[adi].[NtfGhhNotifications]' AS SrcFileName
										 ,NotificationType
										 ,EventType 
										 ,PatientClass
										 ,CONVERT(DATE,AdmitDateTime) AS AdmitDateTime
										 ,ROW_NUMBER()OVER(PARTITION BY AceID, PatientClass,AdmitDateTime,DischargeDateTime,AdmitHospital ORDER BY EventType ASC)RwCnt
										 ,ISNULL(CONVERT(DATE,DischargeDateTime),'') AS DischargeDateTime
										 ,DischargeDisposition
										 ,ChiefComplaint
										 ,DiagnosisDescription
										 ,DiagnosisCode
										 ,AdmitHospital
										 ,'GHH'AS NtfSource
										-- ,AttendingDoctor ,ReferringDoctor,ConsultingDoctor,AdmittingDoctor,ReadmissionIndicator
										 ,'' AS DrgCode
					FROM				 [ACECAREDW].[adi].[NtfGhhNotifications] gh 
					LEFT JOIN			 [AceMPI].[adw].[MPI_ClientMemberAssociationHistoryODS] vw
					ON					 AceID= vw.MstrMrnKey 
					WHERE				 MstrMrnKey IS NOT NULL 
					AND					 Status = 0

					/*Transformation to Decode*/
					/*Transform EventType*/
					UPDATE		#ntfGHH
					SET EventType = ( CASE WHEN EventType = 'A01' AND AdmitDateTime IS NOT NULL THEN 'ADM' /*Admission*/
									WHEN EventType = 'A03' AND AdmitDateTime  IS NOT NULL THEN 'DIS' 
									WHEN EventType = 'A03' AND DischargeDateTime <> '1900-01-01' THEN 'DIS' /*Discharge*/
									WHEN EventType = 'A04' AND AdmitDateTime  IS NOT NULL THEN 'ADM' /**Registration*/
									WHEN EventType = 'A08' AND AdmitDateTime IS NOT NULL AND DischargeDateTime = '1900-01-01' THEN 'ADM' 
									WHEN EventType = 'A08' AND AdmitDateTime IS NOT NULL AND DischargeDateTime <> '1900-01-01' THEN 'DIS' 
									WHEN EventType = 'A08' AND AdmitDateTime IS NULL AND DischargeDateTime <> '1900-01-01' THEN 'DIS'
									WHEN  AdmitDateTime IS NULL AND DischargeDateTime = '1900-01-01' THEN 'ERROR'
								 ELSE 'Not Assigned' END) 
					
						/*Transform PatientType*/
					UPDATE		#ntfGHH
					SET			PatientClass = ghh.Ace_Definition 
					FROM		#ntfGHH a
					JOIN		ACECAREDW.lst.lstGHHCodes ghh
					ON			a.PatientClass = ghh.Code	
					WHERE		[Type] = 'PatientType'

					/*Transform Discharge Disposition*/
					UPDATE		#ntfGHH
					SET			DischargeDisposition = ghh.Ace_Definition 
					FROM		#ntfGHH a
					JOIN		ACECAREDW.lst.lstGHHCodes ghh
					ON			a.DischargeDisposition = ghh.Code	
					WHERE		[Type] = 'Discharge Disposition'

					/*Transform FacilityCode*/
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
					SELECT				DISTINCT ghh.CreatedDate
										,ghh.LoadDate
										,ghh.DataDate
										,ghh.AdiNtfNotificationKey
										,ghh.ClientMemberKey
										,ghh.ClientKey
										,ghh.NtfSource
										,ghh.EventType
										,ghh.PatientClass
										,ghh.AdmitDateTime
										,ghh.DischargeDateTime
										,ghh.DischargeDisposition
										,ghh.DiagnosisCode
										, ghh.DiagnosisDescription
										,ghh.AdmitHospital
										, ghh.SrcFileName
										,'' AcefollowUpDueDate
										,ghh.ChiefComplaint
										,ghh.AceID,ghh.DrgCode
										--,rwcnt,dups
					
					FROM				(
					SELECT				GETDATE() CreatedDate,ghh.LoadDate,ghh.DataDate
										, AdiNtfNotificationKey,ClientMemberKey,ClientKey  
										,ghh.NtfSource
										,ghh.EventType
										,ghh.PatientClass
										,ghh.AdmitDateTime
										,ghh.DischargeDateTime
										,ghh.DischargeDisposition
										,ghh.DiagnosisCode, ghh.DiagnosisDescription
										,ghh.AdmitHospital, ghh.SrcFileName,'' AcefollowUpDueDate
										,ghh.ChiefComplaint
										,ghh.AceID,ghh.DrgCode
										,ghh.RwCnt
										,ROW_NUMBER() OVER(PARTITION BY ClientMemberKey
																		,EventType
																		,PatientClass
																		,AdmitDateTime
																		,DischargeDateTime
																		, ClientKey ORDER BY AdiNtfNotificationKey ASC ) Dups
										
					FROM				#ntfGHH  ghh
										)ghh   
					WHERE				RwCnt = 1
					AND					Dups = 1
					AND					EventType <> 'Error'
					
					
					
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


	

	
