
CREATE PROCEDURE [adi].[spExec_SufficientDiskSpace](@MinMBFree int, @Drive char(1), 
@SendMail INT OUT)
AS


SET NOCOUNT ON

BEGIN


EXEC [master].[dbo].[spExec_SufficientDiskSpace]  @MinMBFree , @Drive, @SendMail OUT

END