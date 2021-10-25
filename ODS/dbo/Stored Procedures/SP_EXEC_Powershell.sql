CREATE PROCEDURE SP_EXEC_Powershell
AS
BEGIN
EXEC master..xp_cmdshell 'powershell.exe C:\Data\PowerShell\SendEmail.ps1'
END
