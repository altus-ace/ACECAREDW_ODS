

CREATE PROCEDURE [adw].[plu_UpdateAdiStatusRow]
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
		UPDATE			[ACDW_CLMS_DHTX].[adi].[DHTX_HospitalCensus]
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
--CignaMA
		UPDATE 			[ACDW_CLMS_CIGNA_MA].[adi].[NtfCignaMATXWklyCensus]
		SET				[RowStatus] = 1
		WHERE			[RowStatus] = 0

END

BEGIN

-- UPDATE ast.ntfNotification
		UPDATE			ast.NtfNotification 
		SET				RowStatus = 1
		FROM			ast.NtfNotification ast
		WHERE			RowStatus = 0
		AND				srcNtfPatientType <> 'unk'
		OR				srcEventType <> 'unk'

		UPDATE			ast.NtfNotification 
		SET				RowStatus = -1
		FROM			ast.NtfNotification ast
		WHERE			RowStatus = 0
		AND				srcNtfPatientType = 'unk'
		OR				srcEventType = 'unk'



END




		
