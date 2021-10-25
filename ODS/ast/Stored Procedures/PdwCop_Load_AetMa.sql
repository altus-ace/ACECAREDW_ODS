

CREATE PROCEDURE [ast].[PdwCop_Load_AetMa]@QMDATE DATE
AS 
    /* version History: 
	   1. Created 3/17/2020: GK
		   */
		   
		   
    DECLARE @LoadDate Date = getdate()
    DECLARE @ClientKey INT = 3;

  
	   /* Validation Code: check for missing mapping */ 
   /* */
    DECLARE @cntMissingMapping INT    
	    EXEC @cntMissingMapping = [ast].[pstCopValidAetMa_mapping]
--    -- the error output here should be exported to a table so a data steward task can be completed prior to new load attempt
--    -- IF errors found exit.
    IF @cntMissingMapping > 0 
		BEGIN
					raiserror('Ace invalid Mapping found: ast.vw_AetnaMaCareOpsUnpivotedFromAdi', 16, -1)
	   
		RETURN  
    END   
	 /* [ast].[pstCopValidAetMa_mapping]
	[adi].[AceValidCopWlcTxM_mapping] */
	ELSE  
	   BEGIN  
			 EXEC ast.PSTCopLoadToStg_AetMa @LoadDate,@QMDate;
		      EXEC ast.pstCopTransformStaging @LoadDate, @CLientKey;
			 EXEC ast.pstCopValidateStaging @QMDATE, @ClientKey;
			 EXEC ast.pstCopExportStagingToAdw @QMDATE, @ClientKey;    
	   END ;
