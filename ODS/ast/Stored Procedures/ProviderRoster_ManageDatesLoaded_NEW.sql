
CREATE PROCEDURE [ast].[ProviderRoster_ManageDatesLoaded_NEW]

AS




 /* task 4 PRE COUNTS. Stg is what is going in, NewPr is what is being superceeded.
 Check Path - P:\Information Technology\iDrive\accessdata2\ACECAREDWImport\Salesforce\Staging
 */


	
	/*Validate Staging*/
	EXEC ast.Validate_Staging_PR

	SELECT COUNT(*) StgNpiCount
	FROM ast.vw_Get_FctProvRoster_NPIData_DevPR
	;
	
	--SELECT TOP 1 * FROM ast.vw_Get_FctProvRoster_NPIData_DevPR
	
	SELECT COUNT(*) StgTinCount
	FROM ast.vw_Get_FctProvRoster_TINData_DevPR
	
	--SELECT TOP 1 * FROM ast.vw_Get_FctProvRoster_TINData_DevPR
	
	SELECT COUNT(*) NewPR_LastLoadCount
	FROM adw.tvf_AllClient_ProviderRoster (0,getdate(), 0) pr;

	SELECT MAX(RowEffectiveDate)
	FROM adw.tvf_AllClient_ProviderRoster (0,getdate(), 0) pr
	
--Process Job 
	/* 
		DECLARE @d Date = getdate();
		Exec adw.PDW_Master_Load_ProviderRoster_DevPr @d,@d;
	*/



/* post run sniff test: does the counts look like what you got pre */
	DECLARE @d Date = getdate();
	DECLARE @dPrior date = dateadd(day, -1, @d);
	
	SELECT count(*) CntNewLoadAll	  FROM adw.tvf_AllClient_ProviderRoster (0, @d, 0);
	SELECT count(*) CntPriorLoadAll FROM adw.tvf_AllClient_ProviderRoster (0, @dPrior, 0);
	SELECT count(*) CntNewLoadActive	FROM adw.tvf_AllClient_ProviderRoster (0, @d, 1);
	SELECT count(*) CntPriorLoadActive FROM adw.tvf_AllClient_ProviderRoster (0, @dPrior, 1);
	
	SELECT MAX(LastUpdatedDate)MaxDateForPR 
	FROM adw.tvf_AllClient_ProviderRoster(0,GETDATE(),1)
	
	