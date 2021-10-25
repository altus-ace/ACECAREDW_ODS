CREATE Procedure adw.PDW_Master_Load_ProviderRoster_DevPr(
    @LoadDate DATE = '01/01/1900'
    , @DataDate DATE = '01/01/1900'
    )
AS 
BEGIN
    -- If zero dates are passed throught the sp will use today's date as the dd and ld
    /* MASTER  LOADER  override the default load/data dates if needed */	        
    EXEC ast.PST_FctProvRoster_LoadToStg_DevPR @LoadDate, @DataDate;
    EXEC ast.PTS_FctProvRoster_Transform_DevPR @LoadDate ;
    EXEC adw.PDW_FctProvRoster_ExportToAdw_DevPR;
END;