CREATE PROCEDURE [adw].[UpdateLineageKey]
AS

BEGIN

--AetnaMA
		UPDATE			ACECAREDW.adi.NtfAetMaTxDlyCensus  
		SET				RowStatus = 1
		WHERE			RowStatus = 0

END

BEGIN
-- UHCER 
		UPDATE			ACECAREDW.adi.NtfUhcErCensus  
		SET				RowStatus = 1
		WHERE			RowStatus = 0

END

BEGIN
--UHCIP 
		UPDATE			ACECAREDW.adi.NtfUhcIPCensus 
		SET				RowStatus = 1 
		WHERE			RowStatus = 0 

END

BEGIN
--AetnaCOM
		UPDATE 			adi.NtfAetComDlyCensus
		SET				RowStatus = 1
		WHERE			RowStatus = 0

END

BEGIN
--GHH
		UPDATE			adi.NtfGhhNotifications
		SET				Status = 1
		WHERE			Status = 0

END

BEGIN
--Devoted
		UPDATE			ACDW_CLMS_DHTX.ADI.DHTX_Census
		SET				RowStatus = 1
		WHERE			RowStatus = 0

END

BEGIN
--shcn
		UPDATE 			ACDW_CLMS_SHCN_MSSP.adi.Steward_MSSPDischargedMedicarePatients
		SET				[Status] = 1
		WHERE			[Status] = 0

END

BEGIN

--6a UPDATE ast.ntfNotification
		UPDATE			ast.NtfNotification SET RowStatus = 1
		FROM			ast.NtfNotification ast
		LEFT JOIN		adw.NtfNotification adw
		ON				ast.AdiKey = adw.AdiKey
		WHERE			CONVERT(DATE,ast.CreatedDate) = CONVERT(DATE,GETDATE()) 
AND				adw.AdiKey IS NOT  NULL


--6b UPDATE ast.ntfNotification to 2 
		UPDATE			ast.NtfNotification SET RowStatus = 2
		FROM			ast.NtfNotification ast
		LEFT JOIN		adw.NtfNotification adw
		ON				ast.AdiKey = adw.AdiKey
		WHERE			CONVERT(DATE,ast.CreatedDate) = CONVERT(DATE,GETDATE()) 
		AND				adw.AdiKey IS NULL 

END


----2A To get records that are new -GHH
--;WITH CTE_GHH
--AS
--(
--SELECT		CreatedDate,DataDate,AceID,EventType,PatientClass
--			,AdmitDateTime,DischargeDateTime,DiagnosisCode,Status
--			,ROW_NUMBER() OVER(Partition by AceID,EventType,PatientClass
--			,AdmitDateTime,DischargeDateTime,DiagnosisCode ORDER BY datadate DESC) RwCnt 
--FROM		adi.NtfGhhNotifications 
--WHERE		DataDate >= '2020-02-20'
--)
--UPDATE		CTE_GHH
--SET			Status = 1
--WHERE		RwCnt = 1

----2B To get records that existed already - GHH

--;WITH CTE_GHH2
--AS
--(
--SELECT		CreatedDate,DataDate,AceID,EventType,PatientClass
--			,AdmitDateTime,DischargeDateTime,DiagnosisCode,Status
--			,ROW_NUMBER() OVER(Partition by AceID,EventType,PatientClass
--			,AdmitDateTime,DischargeDateTime,DiagnosisCode ORDER BY datadate DESC) RwCnt 
--FROM		adi.NtfGhhNotifications 
--WHERE		DataDate >= '2020-02-20'
--)
--UPDATE		CTE_GHH2
--SET			Status = 2
--WHERE		RwCnt > 1






		