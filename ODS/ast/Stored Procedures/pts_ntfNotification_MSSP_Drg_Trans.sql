

CREATE	PROCEDURE [ast].[pts_ntfNotification_MSSP_Drg_Trans] 

											      								    

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
					DECLARE @SrcName VARCHAR(100) = '[ACECAREDW].[adw].[ntfNotification]'
					DECLARE @DestName VARCHAR(100) = '[ACECAREDW].[adw].[ntfNotification]'
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
					;



						--(1)--Applying Drg Rules to ShcnMssp
					 BEGIN
					 
							UPDATE		adw.NtfNotification
							SET			AceFollowUpDueDate = f.Transformed_AceFolloUp --- SELECT *
							FROM		adw.NtfNotification c
							JOIN		( 
											SELECT		*
											FROM		(
															SELECT
															CASE WHEN a.ClientKey = 16  
															THEN (	SELECT Transformed_AceFolloUp = CONVERT(DATE,DATEADD(DD,(SELECT 3 IpDischargeFollupIntervalInDays  
																	FROM   lst.List_Client z
																	JOIN	(	SELECT	TOP 1 a.ClientKey, a.ClientMemberKey,a.DrgCode
																				FROM	adw.NtfNotification a 
																				JOIN	AceMasterData.lst.NtfConfigClientDrg b
																				ON		a.DrgCode = b.DrgCode
																				AND		a.ClientKey = b.ClientKey
																				WHERE	a.ClientKey = 16
																				AND		CONVERT(DATE,a.CreatedDate) = CONVERT(DATE,GETDATE())
																			)e
																	ON		z.ClientKey = e.ClientKey
																	WHERE  z.ClientKey = 16),CONVERT(DATE,a.CreatedDate))) -- CONVERT(DATE,GETDATE()))) --- 
																)End Transformed_AceFolloUp,AceFollowUpDueDate,ClientMemberKey,a.CreatedDate,AdmitDateTime
															FROM	adw.NtfNotification a
															JOIN	AceMasterData.lst.NtfConfigClientDrg c
															ON		a.ClientKey = c.ClientKey
															AND		a.DrgCode = c.DrgCode
															WHERE	a.ClientKey = 16
															AND		CONVERT(DATE,a.CreatedDate) =CONVERT(DATE,GETDATE())
														)b
														WHERE		CONVERT(DATE,CreatedDate) =CONVERT(DATE,GETDATE())
										)f
							ON			c.ClientMemberKey = f.ClientMemberKey
							AND			c.AdmitDateTime = f.AdmitDateTime
							WHERE		CONVERT(DATE,c.CreatedDate) =CONVERT(DATE,GETDATE())	
											
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