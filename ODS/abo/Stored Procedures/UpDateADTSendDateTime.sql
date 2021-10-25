-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [abo].[UpDateADTSendDateTime]
   



	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE [adi].[NtfGhhNotifications]
	SET [SendADTDate] = GETDATE(), ADTExport = 'Y'

	WHERE EventType = 'A03'
			AND DischargeDateTime IS NOT NULL
		    AND  [SendADTDate] IS NULL AND ADTExport IS NULL
			AND  CONVERT(DATE, CreatedDate) <=  CONVERT(DATE, DATEADD(day, -1, GETDATE()))
END




