






CREATE	PROCEDURE [ast].[ntfLoadToStgShcnBCBS]
											      
											    

AS		

BEGIN

BEGIN TRY 
BEGIN TRAN
				
					DECLARE @AuditId INT;    
					DECLARE @JobStatus tinyInt = 1    
					DECLARE @JobType SmallInt = 9	  
					DECLARE @ClientKey INT	 = 0; 
					DECLARE @JobName VARCHAR(100) = 'ntfShcnBCBS';
					DECLARE @ActionStart DATETIME2 = GETDATE();
					DECLARE @SrcName VARCHAR(100) = 'ACDW_CLMS_SHCN_MSSP.[adi].[Steward_MSSPDischargedMedicarePatients]'
					DECLARE @DestName VARCHAR(100) = '[ast].[ntfNotification]'
					DECLARE @ErrorName VARCHAR(100) = 'NA';
					DECLARE @InpCnt INT = -1;
					DECLARE @OutCnt INT = -1;
					DECLARE @ErrCnt INT = -1;
					--DECLARE @DataDate DATE = GETDATE() 
					
					
					SELECT				 @InpCnt = COUNT(shcn.DischargedMedicarePatientsKey)    
					FROM				 ACDW_CLMS_SHCN_MSSP.[adi].[Steward_MSSPDischargedMedicarePatients] shcn
					LEFT JOIN			 [AceMPI].[adw].[MPI_ClientMemberAssociationHistoryODS] vw
					ON					 InsuranceMemberID= vw.ClientMemberKey 
					LEFT JOIN			 AceMPI.adw.MPI_MstrMrn mpi
					ON					 vw.MstrMrnKey = mpi.MstrMrnKey
					WHERE				 vw.MstrMrnKey IS NOT NULL
					AND					 Active = 1
					AND					 Status = 0
								
			--		SELECT				 @InpCnt  

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
					
					IF OBJECT_ID('tempdb..#ntfShcnBCBS') IS NOT NULL DROP TABLE #ntfShcnMssp

					CREATE TABLE #ntfShcnBCBS(AceID NUMERIC (15,0),ClientMemberKey VARCHAR(50),ClientKey INT,CreatedDate DATETIME,Client_Subscriber_ID VARCHAR(50),AdiNtfNotificationKey INT,DataDate DATE
										 ,LoadDate DATE
										 ,SrcFileName VARCHAR(200),NotificationType VARCHAR(50),EventType VARCHAR(50),PatientClass VARCHAR(50), AdmitDateTime DATE, DischargeDateTime DATE
										 ,DischargeDisposition VARCHAR(100), ChiefComplaint VARCHAR(1000), DiagnosisDescription VARCHAR(1000), DiagnosisCode VARCHAR(100), AdmitHospital VARCHAR(100)
										 ,NtfSource VARCHAR(50),AttendingDoctor VARCHAR(50),ReferringDoctor VARCHAR(50),ConsultingDoctor VARCHAR(50),AdmittingDoctor VARCHAR(50)
										 ,ReadmissionIndicator VARCHAR(50),DrgCode VARCHAR(50))

					CREATE TABLE		#OutputTbl (ID INT NOT NULL );
					--Convert Datetime to Date							
					---1 ---Inserting records for BCBS
					INSERT INTO #ntfShcnBCBS(AceID, ClientMemberKey, ClientKey, CreatedDate, LoadDate,DataDate,Client_Subscriber_ID, AdiNtfNotificationKey
										 ,SrcFileName, NotificationType, EventType, PatientClass, AdmitDateTime, DischargeDateTime
										 ,DischargeDisposition, ChiefComplaint, DiagnosisDescription, DiagnosisCode, AdmitHospital
										 ,NtfSource, AttendingDoctor, ReferringDoctor, ConsultingDoctor, AdmittingDoctor
										 ,ReadmissionIndicator, DrgCode)
					OUTPUT				 inserted.AdiNtfNotificationKey INTO #OutputTbl(ID)
					SELECT				 vw.Ace_ID AS AceID --, FileDate
										 ,vw.PatientID as SHCN_ClientMemberKey
										 ,vw.ClientKey,shcn.CreateDate,shcn.CreateDate,shcn.DataDate
										 ,vw.PatientID AS Client_Subscriber_ID
										 ,shcn.DischargedMedicarePatientsKey AS AdiNtfNotificationKey
										 ,shcn.SrcFileName,''
										 ,(CASE WHEN DischargeDateTime IS NULL AND shcn.IPAdmitDateTime IS NOT NULL THEN 'ADM'
												ELSE 'Unk'
												END )
										 ,CASE  WHEN DischargeDateTime IS NULL AND shcn.IPAdmitDateTime IS NOT NULL THEN 'IP'
												ELSE 'Unk'   
												END  
										,CONVERT(DATE,shcn.IPAdmitDateTime)
										,ISNULL(CONVERT(DATE,DischargeDateTime),'') DischargeDateTime
										 ,DischargeDisposition,''
										 ,DRGDescription,DRG,HospitalName
										 ,'Shcn_BCBS' AS NtfSource
										 ,'','','','','',DRG 
					FROM				 ACDW_CLMS_SHCN_MSSP.[adi].[Steward_MSSPDischargedMedicarePatients] shcn
					LEFT JOIN			 (	
											SELECT	 *
											FROM	(
														SELECT   PriInsurance,InsuranceMemberID,b.SubscriberID,b.PatientID
																 ,ClientMemberKey,Ace_ID,ClientKey ,IPAdmitDateTime,a.DataDate,a.FName,a.LName,Birth
																 ,DischargedMedicarePatientsKey,b.MemberFirstName,b.MemberLastName,b.MemberDateBirth
																 ,ROW_NUMBER()OVER(PARTITION BY PatientID,IPAdmitDateTime,Birth--,FName,LName
																 ORDER BY a.DataDate DESC ) RwCnt 
														FROM	 ACDW_CLMS_SHCN_MSSP.[adi].Steward_MSSPDischargedMedicarePatients a
														JOIN	 ACDW_CLMS_SHCN_BCBS.[adi].Steward_BCBS_MemberCrosswalk b
														ON		 a.InsuranceMemberID =b.SubscriberID
														AND		 a.Birth = b.MemberDateBirth 
														JOIN	 ACDW_CLMS_SHCN_BCBS.adw.FctMembership vw
														ON		 CONVERT(VARCHAR(50),b.PatientID) = vw.ClientMemberKey
													)z
											WHERE	RwCnt = 1
										) vw
					ON					 shcn.InsuranceMemberID= vw.InsuranceMemberID 
					AND					 shcn.Birth = vw.Birth
					WHERE				 vw.Ace_ID IS NOT NULL					
					--AND					shcn.FName = vw.FName
					--AND					shcn.LName = vw.LName
					AND					 Status = 0	
					

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

					SELECT				GETDATE(),a.LoadDate,a.DataDate, AdiNtfNotificationKey,ClientMemberKey,ClientKey
										,a.NtfSource,a.EventType 
										,PatientClass,a.AdmitDateTime
										,a.DischargeDateTime,a.DischargeDisposition
										,a.DiagnosisCode, a.DiagnosisDescription
										,a.AdmitHospital, a.SrcFileName,'',a.ChiefComplaint
										,a.AceID,a.DrgCode
					FROM				#ntfShcnBCBS a 
		
						

					
					SET					@ActionStart  = GETDATE();
					SET					@JobStatus =2  
					    				
					EXEC				amd.sp_AceEtlAudit_Close 
										@Audit_Id = @AuditID
										, @ActionStopTime = @ActionStart
										, @SourceCount = @InpCnt		  
										, @DestinationCount = @OutCnt
										, @ErrorCount = @ErrCnt
										, @JobStatus = @JobStatus


					DROP TABLE #ntfShcnBCBS
					DROP TABLE #OutputTbl					
										

COMMIT
END TRY
BEGIN CATCH
EXECUTE				[dbo].[usp_QM_Error_handler]
END CATCH


END

	/*
	--Validation
		SELECT		DISTINCT COUNT(*)
		FROM		(
						SELECT		DISTINCT InsuranceMemberID,SubscriberID,a.IPAdmitDateTime
									,b.MemberDateBirth ,a.Birth,PatientID,ClientMemberKey
						FROM		ACDW_CLMS_SHCN_MSSP.[adi].Steward_MSSPDischargedMedicarePatients a
						JOIN		ACDW_CLMS_SHCN_BCBS.adi.Steward_BCBS_MemberCrosswalk b
						ON			a.InsuranceMemberID = b.SubscriberID
						AND			a.Birth = b.MemberDateBirth
						JOIN		ACDW_CLMS_SHCN_BCBS.adw.FctMembership c
						ON			CONVERT(VARCHAR(50),b.PatientID) = c.ClientMemberKey
						WHERE		PriInsurance NOT LIKE '%Medic%'
					)z
	*/

