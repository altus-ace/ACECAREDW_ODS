
/*
Brit - 2021-03-20 : Changes applied
1. Inferred Date and indicator for only the max date of record for Event type ADM , ie all prior existing records wont be updated
2. Existing record inferred should have a default export of 5 to avoid export, ie with the event type ADM
3. Newly created Inferred record of DIS as event type to have a default export of 0 to enable export, ie event type DIS
*/

CREATE		PROCEDURE [adw].[NtfNotificationCalcDischarges_OLD]

AS
BEGIN
---Create Discharges calculation
--A

		IF OBJECT_ID('tempdb..#Output') IS NOT NULL DROP TABLE #Output	
		/*All Records except todays records. We want to get records that are
			in this set but not in the set after the except operator*/
		SELECT			ClientKey
						,ClientMemberKey
						,SrcAdmitDateTime
						--,CONVERT(DATE,CreatedDate) CreatedDate
						,(SELECT DATEADD(day, -1, CAST(GETDATE() AS DATE)) ) AS DschrgInferredDate
						,1 AS DschrgInferredInd
						,5 AS Exported-- 5 is used to surpress the record for being exported (Set Exported to anthying other than 0 to avoid export) -- ,ExportedDate ---
		INTO			#Output
		FROM			ast.NtfNotification
		WHERE			NtfSource = 'Shcn_MSSP' 
		AND				srcEventType = 'ADM'
		AND				srcNtfPatientType = 'IP'
		AND				CONVERT(Date,CreatedDate) = (	SELECT TOP 1 --Max record not in Max date
														CreatedDate
														FROM (
																SELECT DISTINCT TOP 2 ---Gives me 2 of the recent created date 
																CONVERT(DATE,CreatedDate) CreatedDate
																FROM ast.NtfNotification
																ORDER BY CreatedDate DESC -- descending order gives me the lastest records
															  ) AS  z
														ORDER BY CreatedDate ASC
													 ) ----DATEADD(DAY,-1,CONVERT(DATE,GETDATE()))	
				-- select * from #Output
		EXCEPT
		--Records for Getdate()  
		SELECT			ClientKey
						,ClientMemberKey
						,srcAdmitDateTime
						--,CONVERT(DATE,CreatedDate) CreatedDate
						,(SELECT DATEADD(day, -1, CAST(GETDATE() AS DATE)) ) AS DschrgInferredDate
						,1 AS DschrgInferredInd
						,5 AS Exported
		FROM			(
		SELECT			CreatedDate,DataDate,[NtfSource],ClientKey,ClientMemberKey,srcEventType,srcAdmitDateTime
						,SrcActualDischargeDate, srcNtfPatientType,SrcDiagnosisCode
						,SrcAdmitHospital
						,AdiKey, ROW_NUMBER() OVER(PARTITION BY ClientMemberKey,srcEventType,srcAdmitDateTime
												,srcNtfPatientType,ntfSource ORDER BY LoadDate DESC) RwCnt
						,Exported--,ExportedDate
		FROM			ast.ntfnotification
		WHERE			srcNtfPatientType = 'IP'
		AND				srcEventType = 'ADM'
		AND				CONVERT(Date,CreatedDate)  =  CONVERT(Date,Getdate()) 
		AND				NtfSource = 'Shcn_MSSP'
						)a 
						
END		

BEGIN
		--update adw
		--B
		--	Update the max existing record as 5
		-- BEGIN TRAN  ----  ROLLBACK
		UPDATE			ast.NtfNotification
		SET				Exported = b.Exported 
						,DschrgInferredDate = b.DschrgInferredDate
						,DschrgInferredInd = b.DschrgInferredInd
						--,ExportedDate  = NULL
						--- SELECT DISTINCT a.ClientMemberKey,a.srcAdmitDateTime,a.srcEventType,a.LoadDate,b.Exported,a.ClientKey,b.DschrgInferredDate,b.DschrgInferredInd
		FROM			ast.NtfNotification a
		JOIN
		(		SELECT		DISTINCT ClientMemberKey,srcAdmitDateTime,srcEventType,srcNtfPatientType,LoadDate
							,DschrgInferredDate,DschrgInferredInd,ClientKey,b.Exported,RwCnt  
				FROM		(
								SELECT	DISTINCT a.ClientMemberKey
										,a.srcAdmitDateTime
										,a.srcEventType
										,a.srcNtfPatientType
										,a.LoadDate
										,a.ClientKey
										,b.Exported
										,b.DschrgInferredDate,b.DschrgInferredInd
										--,b.ClientMemberKey
										--,b.AdmitDateTime
										,ROW_NUMBER()OVER(PARTITION BY a.ClientMemberKey,a.srcAdmitDateTime,a.srcEventType,a.srcNtfPatientType
														  ORDER BY a.LoadDate DESC) RwCnt
								FROM	ACECAREDW.ast.NtfNotification a
								JOIN	#Output b
								ON		a.ClientMemberKey = b.ClientMemberKey
								AND		a.srcAdmitDateTime=b.srcAdmitDateTime
								AND		a.ClientKey = b.ClientKey
								WHERE	a.srcNtfPatientType = 'IP'
								AND		a.srcEventType = 'ADM'
								--ORDER BY a.ClientMemberKey, a.AdmitDateTime,LoadDate
							)b
				WHERE			RwCnt = 1
		)b
		ON		a.ClientMemberKey = b.ClientMemberKey
		AND		a.srcAdmitDateTime =b.srcAdmitDateTime
		AND		a.srcEventType = b.srcEventType
		AND		a.srcNtfPatientType = b.srcNtfPatientType
		AND		a.ClientKey = b.ClientKey
		WHERE	b.RwCnt = 1
		AND		B.Exported = 5
		AND		a.LoadDate = b.LoadDate 
		-- ORDER BY a.ClientMemberKey, a.AdmitDateTime  --,a.LoadDate
	
END	 

BEGIN
		
		---Inserting a new record for event status DIS
		INSERT INTO		adw.NtfNotification(
							[LoadDate]
							, [DataDate]
							, [ClientKey]
							, [NtfSource]
							, [ClientMemberKey]
							, [ntfEventType]
							, [NtfPatientType]
							, [CaseType]
							, [AdmitDateTime]
							, [ActualDischargeDate]
							, [DischargeDisposition]
							--, [ChiefComplaint]
							, [DiagnosisDesc]
							, [DiagnosisCode]
							, [AdmitHospital]
							, [AceFollowUpDueDate]
							, [AdiKey]
							, [SrcFileName]
							, [AceID]
							, [DrgCode]
							, [DschrgInferredDate]
							, [DschrgInferredInd]
							, [Exported]
							)
		SELECT				LoadDate
							,DataDate
							,ClientKey
							,NtfSource
							,ClientMemberKey
							,[ntfEventType]
							,NtfPatientType
							,CaseType
							,SrcAdmitDateTime
							,ActualDischargeDate
							,SrcDischargeDisposition
							--,[ChiefComplaint]
							,[srcDiagnosisDesc]
							,[srcDiagnosisCode]
							,[SrcAdmitHospital]
							,[AceFollowUpDueDate]
							,[AdiKey]
							,[SrcFileName]
							,[AceID]
							,[DrgCode]
							,[DschrgInferredDate]
							,[DschrgInferredInd]
							,Exported -- Set as default 0 to enable export
		FROM				(
								SELECT				LoadDate
													,DataDate
													,a.ClientKey
													,NtfSource						AS NtfSource
													,a.ClientMemberKey
													,'DIS'							AS [ntfEventType]
													, 'IP'							AS NtfPatientType
													, 'IP'							AS CaseType
													, a.srcAdmitDateTime
													, a.DschrgInferredDate			AS ActualDischargeDate --a.ActualDischargeDate
													,b.srcDischargeDisposition
													--,[ChiefComplaint]
													,[srcDiagnosisDesc]
													, b.[srcDiagnosisCode]
													, b.[srcAdmitHospital]
													, CASE			WHEN NtfSource IN ('SHCN_MSSP', 'GHH' )
																	THEN (	SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  
																			FROM lst.List_Client WHERE ClientKey = 16),CONVERT(DATE,GETDATE())))
																		 )
													END				[AceFollowUpDueDate]
													, [AdiKey]
													, [SrcFileName]
													, [AceID]
													, [DrgCode]
													, a.DschrgInferredDate
													,a.DschrgInferredInd
													,0 AS Exported
													,ROW_NUMBER() OVER(PARTITION BY a.ClientMemberKey,a.srcAdmitDateTime ORDER BY LoadDate DESC)RwCnt
								FROM			#Output a
								JOIN			ast.NtfNotification b
								ON				a.ClientMemberKey = b.ClientMemberKey
								AND				a.srcAdmitDateTime = b.srcAdmitDateTime
								AND				a.ClientKey = b.ClientKey
												)e
		WHERE			RwCnt = 1
		
END



BEGIN
		---Updating in active members to 9 
		UPDATE		adw.NtfNotification
		SET			Exported = 9   --- SELECT a.CreatedDate,a.ClientMemberKey,b.CLIENT_SUBSCRIBER_ID,ntfEventType,Exported
		FROM		adw.NtfNotification a
		LEFT JOIN	dbo.vw_ActiveMembers b
		ON			a.ClientMemberKey = b.CLIENT_SUBSCRIBER_ID
		WHERE		CONVERT(Date,a.CreatedDate)  =  CONVERT(Date,Getdate())
		AND			a.ClientKey = 16 
		AND			a.NtfSource = 'SHCN_MSSP'
		AND			a.ntfEventType = 'DIS'
		AND			a.NtfPatientType = 'IP'
		AND			b.CLIENT_SUBSCRIBER_ID IS NULL



END


