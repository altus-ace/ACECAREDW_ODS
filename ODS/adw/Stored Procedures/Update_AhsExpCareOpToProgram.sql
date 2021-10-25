CREATE PROCEDURE [adw].[Update_AhsExpCareOpToProgram]( @ExportDate Date, @ClientKey INT)
AS 
begin

    UPDATE Cop set Cop.Exported = 1, Cop.ExportedDate = @ExportDate    
    --DECLARE @CLientKey int = 16
    --SELECT Cop.QMDate    
    FROM adw.AhsExpCareOpsToPrograms Cop	   
    where COP.clientKey = @ClientKey
	   and COP.Exported = 0;

END


