
CREATE PROCEDURE [ast].[PdwCop_Load_Uhc]
AS 

    /* version History: 
	   1. created using adi.vw_pdwSrc_CopUhcPcor as source. adi.CopUhcPcor (pivoted src)
		  This source is pivoted and hard to modify/add measures. This was a known issue.
		  This source controled what adi candidtate rows where loaded. This was a known issue
	   2. Created using adi.vw_pdwSrc_CopUhcPcor as source. Using table adi.CopUhcPcorMeasureView, unpivoted, and scalable.
	   3. gk: 9/10/2020: refactored to Procedures for Load, validate, transform, export
		   */
    /* load to staging -- ast.Pdw_QM_LoadStaging */   
   DECLARE @LoadDate Date = CONVERT(date, GETDATE()) ;	    
   DECLARE @ClientKey INT = 1;
   
   /* Validation Code: check for missing mapping */ 
    DECLARE @cntMissingMapping INT
    EXEC @cntMissingMapping = adi.[AceValidCopUhcCareOps] 
    -- the error output here should be exported to a table so a data steward task can be completed prior to new load attempt
    -- IF errors found exit.
    IF @cntMissingMapping >0 
	   raiserror('Ace invalid Mapping found: PdwCop_Load_Uhc, for info review ast.AceValidationLog for details.', 20, -1) with log
    
    EXEC [ast].[pstCopLoadToStg_Uhc] @LoadDate;

    /* transform */    
    -- none currently
     EXEC ast.pstCopTransformStaging @LoadDate, @ClientKey;

    /* validate -- */
    EXEC ast.pstCopValidateStaging @LoadDate, @clientKey;    
    
    /* xport -- ast.Pdw_QM_Export */
    EXEC ast.pstCopExportStagingToAdw @LoadDate, @ClientKey;    
    

    RETURN;
    
;