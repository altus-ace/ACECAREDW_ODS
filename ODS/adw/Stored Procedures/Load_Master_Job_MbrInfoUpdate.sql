-- =============================================
-- Author:		Bing Yu
-- Create date: 12/04/2019
-- Description:	Insert enrollment Membership_Enrollment file to DB
-- 
-- =============================================

CREATE PROCEDURE [adw].[Load_Master_Job_MbrInfoUpdate]
         
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
	DECLARE @DataDate DATE
	SET @DataDate = GETDATE()

	BEGIN TRY 

	EXEC [ACDW_CLMS_SHCN_MSSP].[adw].[Load_Master_Job_MbrInfoUpdate]
	@DataDate

     END TRY


	 BEGIN CATCH 

	 END CATCH 




END
