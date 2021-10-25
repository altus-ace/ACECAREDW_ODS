



CREATE PROCEDURE [ast].[PdwCop_Load_Wlc] @QMDATE DATE
AS 
    /* version History: 
	   1. Created 3/17/2020: GK
		   */
    
    DECLARE @LoadDate Date = GETDATE();
    DECLARE @ClientKey INT = 2;

   /* Validation Code: check for missing mapping */ 
   /* */
    DECLARE @cntMissingMapping INT    
    EXEC @cntMissingMapping = [adi].[AceValidCopWlcTxM_mapping]
    -- the error output here should be exported to a table so a data steward task can be completed prior to new load attempt
    -- IF errors found exit.
   --SELECT @cntMissingMapping
    IF @cntMissingMapping >0 
	   raiserror('Ace invalid Mapping found: PdwCop_Load_Wlc', 20, -1) with log
    /* */

    EXEC ast.pstCopLoadToStg_WlcTxM @LoadDate,@QMDATE;
             
    EXEC ast.pstCopTransformStaging @QMDATE, @CLientKey;
    
    EXEC ast.pstCopValidateStaging @QMDATE, @ClientKey;
    
    EXEC ast.pstCopExportStagingToAdw @QMDATE, @ClientKey;
   
   

    RETURN;



/* missing mapping code:

Mapping: Missing values in QM_Mapping	Appointment Agenda - Range $100 - $150	362

 DECLARE @MissingMapping TABLE (ValidationType VARCHAR(100), CopMsrName VARCHAR(400), CntMeasures INT);
    INSERT INTO @MissingMapping (ValidationType, CopMsrName, CntMeasures)    
    SELECT 'Mapping: Missing QM Mapping to listAceMapping' AS ValidationType, cop.CopMsrName, count(*) cntMsr    
    FROM adi.vw_pstSrc_CopWlcTxM cop
    where cop.Destination is null	   
    GROUP BY cop.CopMsrName
    UNION
    SELECT 'Mapping: Missing values in QM_Mapping' AS ValidationType, cop.CopMsrName, count(*) cntMsr
    FROM adi.vw_pstSrc_CopWlcTxM cop
    where cop.QM_ID is null	   
    GROUP BY cop.CopMsrName;

    DECLARE @cntMissingMapping INT = 0
    SELECT @cntMissingMapping = SUM(CntMeasures)
    FROM @MissingMapping;

    SELECT * FROM @MissingMapping;
*/