CREATE PROCEDURE adw.PDW_ExportPrograms_UpdateExported (
	@ClientKey INT )
AS
BEGIN
	IF @CLientkey = 21 
		update e set e.Exported = 1 , e.ExportedDate = getdate()
		FROM Acdw_Clms_amgtx_ma.adw.ExportAhsPrograms e
		where e.Exported = 0
	ELSE IF @CLientkey = 2 
		update e set e.Exported = 1 , e.ExportedDate = getdate()
		FROM Acdw_Clms_wlc.adw.ExportAhsPrograms e
		where e.Exported = 0
	ELSE IF @ClientKey = 12 
		update e set e.Exported = 1 , e.ExportedDate = getdate()
		FROM Acdw_Clms_Cigna_Ma.adw.ExportAhsPrograms e
		where e.Exported = 0;
END;

