
CREATE PROCEDURE dbo.spExec_SufficientDiskSpace @MinMBFree int, @Drive char(1), 
@SendMail Int OUT
AS

/*
ALTER PROCEDURE [dbo].[AceCheckReplMonitor]
    (@TimeLimitInMinutes INT 
	   , @SendMail Int OUT) 
AS      
    DECLARE @NOW datetime = getdate();
    SET @SendMail = 0;
    SELECT-- 
	   @SendMail = CASE WHEN(DateDiff(minute, time_stamp, @Now) > @TimeLimitInMinutes ) THEN 1 else 0 END 	
    FROM dbo.REPL_MONITOR;
    --SELECT @SENDMAIL;

--
*/

SET NOCOUNT ON


BEGIN

EXEC [dbo].[spExec_SufficientDiskSpace]  @MinMBFree , @Drive, @SendMail OUT

END