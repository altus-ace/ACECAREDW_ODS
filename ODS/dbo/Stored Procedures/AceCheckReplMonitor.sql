CREATE PROCEDURE [dbo].[AceCheckReplMonitor]
  (@TimeLimitInMinutes INT 
	   , @SendMail Int OUT)
AS 
BEGIN
 
EXEC [ACE-SDV-DB02].[Ahs_Altus_Prod].[dbo].[AceCheckReplMonitor] @TimeLimitInMinutes, @SendMail OUTPUT

--[AceMetaData].[amd].[sp_AceEtlAudit_Open] @AuditID OUTPUT,  @AuditStatus, @JobType, @ClientKey, @JobName, @ActionStartTime, @InputSourceName, @DestinationName, @ErrorName 

END
--EXEC [AceMetaData].[amd].[sp_AceEtlAudit_Close]
--EXEC [AceMetaData].[amd].[sp_AceEtlAudit_sp_AceEtlAuditLogError]
-- [dbo].[AceCheckReplMonitor]