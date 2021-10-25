CREATE PROCEDURE [adw].[NtfExportUpdateExportStatus]
AS

BEGIN
		  /* Update the rows to export as Identified by view to reflect their export status */
		  UPDATE		a
		  	SET		a.Exported = 1, a.ExportedDate = GETDATE() --SELECT *			
		  FROM		adw.NtfNotification a				
		  	JOIN		adw.vw_EXP_Notifications b
		  ON			a.ntfNotificationKey = b.ntfNOtificationKey
		  WHERE		a.Exported = 0;
END
BEGIN
		  /* mark all other rows as not exported (for some reason) 3 */
		  --SELECT	    n.ntfNotificationKey, n.Exported, n.ExportedDate , getdate() NewExportDate, 3 NewExportValue
		  UPDATE n 
			 SET	    n.Exported = 3, n.ExportedDate = GETDATE()
			 --SELECT	    n.ntfNotificationKey, n.Exported, n.ExportedDate , getdate() NewExportDate, 3 NewExportValue
		  FROM adw.NtfNotification N
		  WHERE n.Exported = 0
			 AND n.NtfPatientType <> 'IP';

				  
END
