



CREATE  PROCEDURE [ast].[ntfLoadToStgCignaMA]
											      
											    

AS		

BEGIN

BEGIN TRY 
BEGIN TRAN
				
					DECLARE @AuditId INT;    
					DECLARE @JobStatus tinyInt = 1    
					DECLARE @JobType SmallInt = 9	  
					DECLARE @ClientKey INT	 = 0; 
					DECLARE @JobName VARCHAR(100) = 'ntfCignaMA';
					DECLARE @ActionStart DATETIME2 = GETDATE();
					DECLARE @SrcName VARCHAR(100) = '[adi].[NtfCignaMATXWklyCensus]'
					DECLARE @DestName VARCHAR(100) = '[ast].[ntfNotification]'
					DECLARE @ErrorName VARCHAR(100) = 'NA';
					DECLARE @InpCnt INT = -1;
					DECLARE @OutCnt INT = -1;
					DECLARE @ErrCnt INT = -1;
					--DECLARE @DataDate DATE = GETDATE() 
					
					
					SELECT				 @InpCnt = COUNT(CignaMA.NtfCignaMATXWklyCensusKey)    
					FROM				 [ACDW_CLMS_CIGNA_MA].[adi].[NtfCignaMATXWklyCensus] CignaMA
					LEFT JOIN			 [AceMPI].[adw].[MPI_ClientMemberAssociationHistoryODS] vw
					ON					 REPLACE(Member_ID,'*','') = vw.ClientMemberKey 
					LEFT JOIN			 AceMPI.adw.MPI_MstrMrn mpi
					ON					 vw.MstrMrnKey = mpi.MstrMrnKey
					WHERE				 vw.MstrMrnKey IS NOT NULL
					AND					 Active = 1 
					AND					 RowStatus = 0
								
					--SELECT				 @InpCnt  

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
					
					IF OBJECT_ID('tempdb..#ntfCignaMA') IS NOT NULL DROP TABLE #ntfCignaMA

					CREATE TABLE #ntfCignaMA(AceID NUMERIC (15,0),ClientMemberKey VARCHAR(50),ClientKey INT,CreatedDate DATETIME,Client_Subscriber_ID VARCHAR(50),AdiNtfNotificationKey INT,DataDate DATE
										 ,LoadDate DATE
										 ,SrcFileName VARCHAR(200),NotificationType VARCHAR(50),EventType VARCHAR(50),PatientClass VARCHAR(50), AdmitDateTime DATE, DischargeDateTime DATE
										 ,DischargeDisposition VARCHAR(100), ChiefComplaint VARCHAR(1000), DiagnosisDescription VARCHAR(1000), DiagnosisCode VARCHAR(100), AdmitHospital VARCHAR(100)
										 ,NtfSource VARCHAR(50),AttendingDoctor VARCHAR(50),ReferringDoctor VARCHAR(50),ConsultingDoctor VARCHAR(50),AdmittingDoctor VARCHAR(50)
										 ,ReadmissionIndicator VARCHAR(50),DrgCode VARCHAR(50))

					CREATE TABLE		#OutputTbl (ID INT NOT NULL ); -- DROP TABLE #OutputTbl
					--Convert Datetime to Date
					INSERT INTO #ntfCignaMA(AceID, ClientMemberKey, ClientKey, CreatedDate, LoadDate,DataDate,Client_Subscriber_ID, AdiNtfNotificationKey
										 ,SrcFileName, NotificationType, EventType, PatientClass, AdmitDateTime, DischargeDateTime
										 ,DischargeDisposition, ChiefComplaint, DiagnosisDescription, DiagnosisCode, AdmitHospital
										 ,NtfSource, AttendingDoctor, ReferringDoctor, ConsultingDoctor, AdmittingDoctor
										 ,ReadmissionIndicator, DrgCode)
					OUTPUT				 inserted.AdiNtfNotificationKey INTO #OutputTbl(ID)
					SELECT			     vw.MstrMrnKey AS AceID 
										 ,REPLACE(Member_ID,'*','') as CignaMA_ClientMemberKey
										 ,vw.ClientKey,CignaMA.CreatedDate,CignaMA.LoadDate,CignaMA.DataDate
										 ,vw.ClientMemberKey AS Client_Subscriber_ID
										 ,CignaMA.NtfCignaMATXWklyCensusKey AS AdiNtfNotificationKey
										 ,CignaMA.SrcFileName--,''
										 ,''
										 ,CONVERT(DATE,[Actual_Discharge_Date]) Event_Type
										 ,Bed_Type,CONVERT(DATE,[Admission_Date])
										 ,ISNULL(CONVERT(DATE,[Actual_Discharge_Date]),'') [Actual_Discharge_Date]
										 ,[Discharge_Status],'' 
										 ,[Diagnosis_Desc],[Diagnosis_Code],[Facility_Name],'CignaMA' AS NtfSource
										 ,'','','','','','' AS DrgCode
					FROM				 [ACDW_CLMS_CIGNA_MA].[adi].[NtfCignaMATXWklyCensus] CignaMA
					LEFT JOIN			 [AceMPI].[adw].[MPI_ClientMemberAssociationHistoryODS] vw
					ON					 REPLACE(Member_ID,'*','') = vw.ClientMemberKey 
					LEFT JOIN			 AceMPI.adw.MPI_MstrMrn mpi
					ON					 vw.MstrMrnKey = mpi.MstrMrnKey
					WHERE				 vw.MstrMrnKey IS NOT NULL
					AND					 Active = 1 
					AND					 RowStatus = 0
														--SELECT * FROM #ntfCignaMA
					
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
										,CASE a.PatientClass	WHEN   'Acute'
																THEN   'IP'/*(SELECT	Destination 
																		FROM	ACECAREDW.lst.ListAceMapping 
																		WHERE   ClientKey = 3
																		AND		Destination = 'IP')*/
																WHEN   'OBS'
																THEN   'OP'/*(SELECT	Destination 
																		FROM	ACECAREDW.lst.ListAceMapping 
																		WHERE   ClientKey = 3
																		AND		Destination = 'IP')*/
										ELSE 'NotAssigned'
										END PatientClass,a.AdmitDateTime
										,a.DischargeDateTime
										,CASE					WHEN  a.DischargeDisposition = 'H'  OR a.DischargeDisposition = 'Home' THEN 'Home'
																WHEN  a.DischargeDisposition =  'Skilled Nursing Facility' THEN 'Skilled Nursing Facility'
																WHEN  a.DischargeDisposition IS NULL OR a.DischargeDisposition = '' THEN 'InHospital'
										ELSE 'NotAssigned'
										END	DischargeDisposition
										,a.DiagnosisCode, a.DiagnosisDescription
										,a.AdmitHospital, a.SrcFileName,'',a.ChiefComplaint
										,a.AceID,a.DrgCode
					FROM				#ntfCignaMA a 
		
						

					
					SET					@ActionStart  = GETDATE();
					SET					@JobStatus =2  
					    				
					EXEC				amd.sp_AceEtlAudit_Close 
										@Audit_Id = @AuditID
										, @ActionStopTime = @ActionStart
										, @SourceCount = @InpCnt		  
										, @DestinationCount = @OutCnt
										, @ErrorCount = @ErrCnt
										, @JobStatus = @JobStatus


					DROP TABLE #ntfCignaMA
					DROP TABLE #OutputTbl					
										

COMMIT
END TRY
BEGIN CATCH
EXECUTE				[dbo].[usp_QM_Error_handler]
END CATCH


END
			
										
