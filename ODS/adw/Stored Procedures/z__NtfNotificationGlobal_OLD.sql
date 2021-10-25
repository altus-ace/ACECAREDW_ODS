
CREATE PROCEDURE [adw].[z__NtfNotificationGlobal_OLD]
AS
BEGIN

    BEGIN
		--TRUNCATE TABLE [adw].[NtfNotification] 
		--Get Ghh and MCO records into adw
		--Supress the latest record and export the earliest record
		IF OBJECT_ID('tempdb..#ntfAdwNotf') IS NOT NULL DROP TABLE #ntfAdwNotf
			;WITH CTE_ntfNotification
		AS ---
		( 
		SELECT		stg.[LoadDate],stg.[DataDate],stg.[ClientKey],stg.[ClientMemberKey],stg.AceID
					,stg.NtfSource
					,srcNtfPatientType
					,CASE WHEN  [SrcActualDischargeDate] IS NULL AND stg.NtfSource NOT IN ('shcn_mssp')
								OR [SrcActualDischargeDate] = '1900-01-01' AND stg.NtfSource NOT IN ('shcn_mssp')
						THEN 'ADM'
						ELSE srcEventType
						END 
						srcEventType
					,CASE WHEN [SrcActualDischargeDate] IS NOT NULL AND LEFT(SrcDiagnosisCode,1) = 'F' THEN (SELECT Destination FROM ACECAREDW.lst.ListAceMapping WHERE Source = 'Mental Health')
						  WHEN [SrcActualDischargeDate] IS NOT NULL AND LEFT(srcDiagnosisCode,1) = 'O' THEN (SELECT Destination FROM ACECAREDW.lst.ListAceMapping WHERE Source = 'Post Partum')
						  WHEN [SrcDischargeDisposition] LIKE '%/Trans%' THEN (SELECT Destination FROM ACECAREDW.lst.ListAceMapping WHERE Source = 'Transfer') 
						  WHEN [SrcActualDischargeDate] = '' OR [SrcActualDischargeDate] IS NULL THEN (SELECT Destination FROM ACECAREDW.lst.ListAceMapping WHERE Source = 'If DischargeDate is Blank')--Should this be Admission?, if yes, select from the lst table
						  ----When discharge disposition like expired, case type = expired
						  WHEN SrcDischargeDisposition LIKE '%Expi%' THEN 'Expired'
						  ELSE srcNtfPatientType 
						  END  CaseType,SrcAdmitDateTime,SrcActualDischargeDate,SrcDischargeDisposition,SrcChiefComplaint,SrcDiagnosisCode
						  ,SrcDiagnosisDesc,SrcAdmitHospital,RowStatus
					,CASE WHEN stg.NtfSource = 'GHH' AND stg.CLIENTKEY = 1 THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 1),stg.LoadDate)))
						  WHEN stg.NtfSource = 'GHH' AND stg.CLIENTKEY = 2 THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 2),stg.LoadDate)))
						  WHEN stg.NtfSource = 'GHH' AND stg.CLIENTKEY = 3 THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 3),stg.LoadDate)))
						  WHEN stg.NtfSource = 'GHH' AND stg.CLIENTKEY = 9 THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 3),stg.LoadDate)))
						  WHEN stg.NtfSource = 'GHH' AND stg.CLIENTKEY = 11 THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 11),stg.LoadDate)))
						  WHEN stg.NtfSource = 'GHH' AND stg.CLIENTKEY = 12 THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 12),stg.LoadDate)))
						  WHEN stg.NtfSource = 'GHH' AND stg.CLIENTKEY = 16 THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT NtfFollupDays FROM [AceMasterData].lst.[NtfConfigClient] WHERE ntftype = 'IP'),stg.LoadDate)))
						  WHEN stg.NtfSource = 'Aetna' THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 3),stg.LoadDate)))
						  WHEN stg.NtfSource = 'uhcIP' THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 1),stg.LoadDate)))
						  WHEN stg.NtfSource = 'uhcER' THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 1),stg.LoadDate)))
						  WHEN stg.NtfSource = 'AetCom' THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 9),stg.LoadDate)))
						  WHEN stg.NtfSource = 'Devoted' THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT IpDischargeFollupIntervalInDays  FROM lst.List_Client WHERE ClientKey = 11),stg.LoadDate)))
						  WHEN stg.NtfSource = 'SHCN_MSSP' AND stg.CLIENTKEY = 16 THEN (SELECT CONVERT(DATE,DATEADD(DD,(SELECT NtfFollupDays FROM [AceMasterData].lst.[NtfConfigClient] WHERE ntftype = 'IP'),stg.LoadDate)))
						END AceFollowUpDueDate
					,stg.AdiKey,'ast.NtfNotification' AS SrcFileName,DrgCode 
					,ROW_NUMBER() OVER(PARTITION BY stg.[ClientMemberKey],stg.SrcAdmitDateTime,stg.SrcActualDischargeDate,stg.srcNtfPatientType,
										stg.SrcEventType,stg.ntfsource
										 ORDER BY stg.[ClientMemberKey],stg.SrcAdmitDateTime,stg.SrcActualDischargeDate,stg.srcNtfPatientType,
										stg.SrcEventType,stg.ntfsource)
										   RwCnt
		FROM		ast.NtfNotification stg
		WHERE		CONVERT(DATE,stg.CreatedDate) = CONVERT(DATE,GETDATE()) 
		GROUP BY	stg.[LoadDate],stg.[ClientKey],stg.[ClientMemberKey],stg.Aceid,stg.NtfSource,srcNtfPatientType
					,srcEventType
					,srcNtfPatientType
					,SrcAdmitDateTime,SrcActualDischargeDate,SrcDischargeDisposition
					,SrcChiefComplaint,SrcDiagnosisCode,SrcDiagnosisDesc
					,SrcAdmitHospital
					,stg.AceFollowUpDueDate
					,stg.AdiKey,stg.SrcFileName ,RowStatus,stg.DataDate,DrgCode
					--	ORDER BY ClientMemberKey		
		)  
		--SELECT * FROM CTE_ntfNotification WHERE CLIENTKEY = 16
				
		SELECT								 [LoadDate], [DataDate], [ClientKey], [ClientMemberKey],AceID, [NtfSource],[srcNtfPatientType]
											,[srcEventType],[CaseType], [SrcAdmitDateTime]
											,[srcActualDischargeDate], [srcDischargeDisposition],[SrcChiefComplaint]
											,[srcDiagnosisCode], [srcDiagnosisDesc], [SrcAdmitHospital], [AceFollowUpDueDate]
											,[AdiKey],[SrcFileName],RowStatus,DrgCode 
											,ROW_NUMBER() OVER (PARTITION BY [ClientMemberKey],[srcEventType],[SrcAdmitDateTime],[srcActualDischargeDate]
											,[srcNtfPatientType],[NtfSource]
											ORDER BY [ClientMemberKey],[srcEventType],[SrcAdmitDateTime],[srcActualDischargeDate]
											,[srcNtfPatientType],[NtfSource] ) RwCnt
		INTO								#ntfAdwNotf
		FROM								CTE_ntfNotification 
		WHERE								RwCnt =1
		AND									AceFollowUpDueDate >= CONVERT(DATE,GETDATE())
		AND									RowStatus = 0 
		
		--For Shcn Inferred CalcDischarges shud also have AceFolloUpDueDate Value
		UPDATE								#ntfAdwNotf
		SET									AceFollowUpDueDate = NULL
		WHERE								SrcActualDischargeDate IS NULL
		AND									ClientKey <>16

		BEGIN
		;WITH CTE_SHCN_MSSP_Drg
		AS 
		(
		SELECT								AceFollowUpDueDate = DATEADD(DD,(SELECT TOP 1 NtfFollupDays FROM [AceMasterData].lst.[NtfConfigClientDrg] WHERE ntftype = 'IP'),LoadDate)
											,b.ClientKey
		FROM								#ntfAdwNotf a
		JOIN								[AceMasterData].lst.[NtfConfigClientDrg] b
		ON									a.ClientKey = b.ClientKey
		WHERE								a.ClientKey = 16
		)
		
		 UPDATE								#ntfAdwNotf
		 SET								AceFollowUpDueDate = b.AceFollowUpDueDate 
		 FROM								#ntfAdwNotf a
		 JOIN								CTE_SHCN_MSSP_Drg b
		 ON									a.ClientKey = b.ClientKey
		 WHERE								a.ClientKey = '16'
		 AND								SrcDiagnosisCode IN (SELECT DrgCode FROM [AceMasterData].lst.[NtfConfigClientDrg])
		 END
		
		BEGIN
		 ;WITH CTE_SHCN_MSSP_Diag
		AS 
		(
		SELECT								AceFollowUpDueDate = DATEADD(DD,(SELECT TOP 1 NtfFollupDays FROM [AceMasterData].lst.[NtfConfigClientDiag] WHERE ntftype = 'IP'),LoadDate)
											,b.ClientKey
		FROM								#ntfAdwNotf a
		JOIN								[AceMasterData].lst.[NtfConfigClientDiag] b
		ON									a.ClientKey = b.ClientKey
		WHERE								a.ClientKey = 16
		)
		
		 UPDATE								#ntfAdwNotf
		 SET								AceFollowUpDueDate = b.AceFollowUpDueDate 
		 FROM								#ntfAdwNotf a
		 JOIN								CTE_SHCN_MSSP_Diag b
		 ON									a.ClientKey = b.ClientKey
		 WHERE								a.ClientKey = '16'
		 AND								SrcDiagnosisCode IN (SELECT DiagCode FROM [AceMasterData].lst.[NtfConfigClientDiag])
		 END
		--select * from #ntfAdwNotf  where CLIENTKEY = 16

		BEGIN		
		INSERT INTO [adw].[NtfNotification]([LoadDate], [DataDate], [ClientKey], [ClientMemberKey],AceID,[NtfSource],[NtfPatientType]
											,[ntfEventType], [CaseType], [AdmitDateTime]
											,[ActualDischargeDate], [DischargeDisposition],  [ChiefComplaint]
											,[DiagnosisCode], [DiagnosisDesc], [AdmitHospital], [AceFollowUpDueDate]
											,[AdiKey],[SrcFileName],DrgCode )
		SELECT								 tmp.[LoadDate], tmp.[DataDate], tmp.[ClientKey], tmp.[ClientMemberKey],tmp.AceID, tmp.[NtfSource],[srcNtfPatientType]
											,[srcEventType],tmp.[CaseType], [SrcAdmitDateTime]
											,[srcActualDischargeDate], [srcDischargeDisposition],[SrcChiefComplaint]
											,[srcDiagnosisCode], [srcDiagnosisDesc], [SrcAdmitHospital], tmp.[AceFollowUpDueDate]
											,tmp.[AdiKey],tmp.[SrcFileName],tmp.[DrgCode] 
		FROM								#ntfAdwNotf tmp
		LEFT JOIN							adw.NtfNotification adw
		ON									adw.ClientMemberKey =		tmp.ClientMemberKey
		AND									adw.AdmitDateTime =			tmp.SrcAdmitDateTime
		AND									adw.ActualDischargeDate =	tmp.srcActualDischargeDate
		AND									adw.NtfPatientType =		tmp.srcNtfPatientType	
		WHERE								adw.ClientMemberKey IS NULL
		AND									adw.AdmitDateTime IS NULL
		AND									adw.ActualDischargeDate IS NULL
		AND									adw.NtfPatientType IS NULL 


		END
    
	BEGIN
		--SET Exported Column to 2 for Nerver to Export Where dup occur --------------------------
		;WITH CTE_NtfNotToBeExported
		AS
		(
		SELECT 
									[LoadDate],[DataDate]DataDate, [ClientKey], [ClientMemberKey],AceID,[NtfSource],[NtfPatientType]
									,[ntfEventType], [CaseType], [AdmitDateTime]
									,[ActualDischargeDate], [DischargeDisposition],  [ChiefComplaint]
									,[DiagnosisCode], [DiagnosisDesc], [AdmitHospital], [AceFollowUpDueDate]
									,[AdiKey],[SrcFileName]
									,ROW_NUMBER() OVER (PARTITION BY ClientMemberKey, NtfPatientType,CaseType
									, CONVERT(DATE, AdmitDateTime) , CONVERT(DATE, ActualDischargeDate)
									ORDER BY DataDate
									, CASE WHEN NtfSource = 'GHH' THEN 'zGhh' ELSE NtfSource end  ) aRowNumber	
									,Exported,ExportedDate
		FROM						adw.NtfNotification --ORDER BY LoadDate DESC
		WHERE						Exported = 0-- CONVERT(DATE,CreatedDate) = CONVERT(DATE,GETDATE())
		AND							(ClientKey <> 16
		AND							NtfPatientType = 'IP'
		AND							CaseType NOT IN ( 'Inhospital','TRF')
		AND							DischargeDisposition NOT LIKE '%/Tran%')
		
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

		---Status for Members who are not active
		UPDATE						adw.NtfNotification
		SET							Exported = 2  --SELECT ClientMemberKey, Client_Subscriber_ID 
		FROM						adw.NtfNotification a
		LEFT JOIN					ACECAREDW.dbo.vw_ActiveMembers b
		ON							a.ClientMemberKey = b.CLIENT_SUBSCRIBER_ID
		WHERE						b.CLIENT_SUBSCRIBER_ID IS NULL 
		AND							a.ClientKey <> 16
		--AND							ClientMemberKey in ('117642645','118107308','118540155')

		UPDATE						adw.NtfNotification
		SET							ExportedDate = CONVERT(DATE,GETDATE())  --SELECT ClientMemberKey, Client_Subscriber_ID,Exported 
		FROM						adw.NtfNotification a
		LEFT JOIN					ACECAREDW.dbo.vw_ActiveMembers b
		ON							a.ClientMemberKey = b.CLIENT_SUBSCRIBER_ID
		WHERE						b.CLIENT_SUBSCRIBER_ID IS NULL 
		AND							Exported = 2 
		AND							a.ClientKey <> 16
		
    END		

END



BEGIN

--Update all dependable objects RowStatus
EXECUTE [adw].[UpdateLineageKey]

END
END






