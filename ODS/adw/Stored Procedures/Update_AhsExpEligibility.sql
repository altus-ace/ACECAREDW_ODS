CREATE PROCEDURE [adw].[Update_AhsExpEligibility]( @ExportDate Date, @ClientKey INT)
AS 
begin
    /* distribute to client db */
    IF @ClientKey = 16
    begin
	   UPDATE elig set elig.Exported = 1, elig.ExportedDate = @ExportDate
	   --SELECT Elig.*
	   FROM Acdw_CLMS_SHCN_MSSP.adw.AhsExpEligiblity elig 
	   where elig.ClientKey = @ClientKey and elig.Exported = 0
    end
    else if @ClientKey = 20
    begin
	   UPDATE elig set elig.Exported = 1, elig.ExportedDate = @ExportDate
	   --SELECT Elig.*
	   FROM Acdw_CLMS_SHCN_BCBS.adw.AhsExpEligiblity elig 
	   where elig.ClientKey = @ClientKey and elig.Exported = 0
    end
--    else if @ClientKey = 21
--    begin 
--	   UPDATE elig set elig.Exported = 1, elig.ExportedDate = @ExportDate
--	   --SELECT Elig.*
--	   FROM Acdw_CLMS_AMGTX_MA.adw.AhsExpEligiblity elig 
--	   where elig.ClientKey = @ClientKey and elig.Exported = 0
--    end
--    else if @ClientKey = 22
--    begin 
--	   UPDATE elig set elig.Exported = 1, elig.ExportedDate = @ExportDate
--	   --SELECT Elig.*
--	   FROM Acdw_CLMS_AMGTX_MCD.adw.AhsExpEligiblity elig 
--	   where elig.ClientKey = @ClientKey and elig.Exported = 0
--    end
    else 
    begin 
	   UPDATE elig set elig.Exported = 1, elig.ExportedDate = @ExportDate
	   --SELECT Elig.*
	   FROM adw.AhsExpEligiblity elig 
	   where elig.ClientKey = @ClientKey and elig.Exported = 0
    END


END
