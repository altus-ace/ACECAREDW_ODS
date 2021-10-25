
CREATE PROCEDURE [dbo].[dev_ntfTestSimulation]

AS


EXEC [DEV_ACECAREDW].[dbo].[dev_ntfTestSimulation]
--Step 1 execute ntfclients to retrieve records where rowstatus =0

--EXECUTE ast.pls_NtfClients

----Step 2 Process transformation in staging
--EXECUTE [ast].[pts_NtfNotification]

----Step 3 Process into data warehouse from stating
--EXECUTE [adw].[pdw_NtfNotification]
