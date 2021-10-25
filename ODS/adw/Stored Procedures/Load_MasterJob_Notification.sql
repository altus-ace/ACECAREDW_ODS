
CREATE PROCEDURE [adw].[Load_MasterJob_Notification]
AS


				

  BEGIN
  			--Write to Stg
  			--Processing source files into staging
  
  			 EXECUTE [ast].[pls_NtfClients]
  
  END
  
  BEGIN
  			--Transforming data in staging
  			EXECUTE [ast].[pts_ntfNotification]
  
  
  END
  
  			--Inserting transformed data into adw
  BEGIN
  
  			EXECUTE [adw].[pdw_NtfNotification]
  
  END
  
  BEGIN
  			--Gets record sets ready for export
  			EXECUTE [adw].[pex_NtfNotification]
  
  END
  
  BEGIN
  			--Update lineage Keys
  			EXECUTE [adw].[plu_UpdateAdiStatusRow]
  
  END
  
  
  BEGIN
  			--Calculating for discharges
  			EXECUTE [adw].[NtfNotificationCalcDischarges]
  	
  END
  
  BEGIN
			---Calculating for SHCN Drg Code
			EXECUTE [ast].[pts_ntfNotification_MSSP_Drg_Trans] 
  END
  
  BEGIN 
  			--Inserting into SCHN MSSP Ntf Table
  			EXECUTE [ACDW_CLMS_SHCN_MSSP].[adw].[LoadNtfSchnMsspFromAdwNtfNotification]
  END	


  BEGIN 
  			--Inserting into SCHN BCBS Ntf Table
  			EXECUTE [ACDW_CLMS_SHCN_BCBS].[adw].[LoadNtfSchnBCBSFromAdwNtfNotification]
  END	

  BEGIN
			---Inserting ntf into AMGTX_MA
			EXECUTE [ACDW_CLMS_AMGTX_MA].[adw].[LoadNtfAMGTX_MAFromAdwNtfNotification]
  END


  BEGIN
			---Inserting ntf into AMGTX_MCD
			EXECUTE [ACDW_CLMS_AMGTX_MCD].[adw].[LoadNtfAMGTX_MCDFromAdwNtfNotification]
  END