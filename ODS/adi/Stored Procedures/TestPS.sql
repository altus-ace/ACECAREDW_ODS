
CREATE PROCEDURE [adi].[TestPS] 
    -- No parameters    
AS
BEGIN
    SET NOCOUNT ON;
    -- Step 1
    exec xp_cmdshell 'powershell "C:\Data\PowerShell\SendEmail.ps1"'

    -- Step 2: TODO: Run SSIS package
END