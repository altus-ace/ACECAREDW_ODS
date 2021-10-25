

CREATE PROCEDURE [ast].[pstCopValidAetMa_mapping]
AS 
    -- name pst process to staging
    -- cop care Valid
    -- ops Validation
    -- WlcTxM client Wellcare
    -- Mapping : verify mapping
    /* should this be self containted, call it, it logs, errors, captures errors, and then throws error up stack?
    */

    DECLARE @MissingMapping TABLE (ValidationType VARCHAR(100), CopMsrName VARCHAR(400), CntMeasures INT);
    INSERT INTO @MissingMapping (ValidationType, CopMsrName, CntMeasures)    
    SELECT 'Mapping: Missing QM Mapping to listAceMapping' AS ValidationType, cop.Measure, count(*) cntMsr                
    FROM ast.vw_AetnaMaCareOpsUnpivotedFromAdi cop
    where cop.AceQmMsrId is null	   
    GROUP BY cop.Measure
   
    UNION
    SELECT 'Mapping: Missing values in QM_Mapping' AS ValidationType, cop.Measure, count(*) cntMsr
    FROM ast.vw_AetnaMaCareOpsUnpivotedFromAdi cop
    where cop.AceQmMsrId is null	   
    GROUP BY cop.Measure
	
	UNION
    SELECT 'Mapping: Missing values in QM_Mapping' AS ValidationType, cop.Measure,    count(*) cntMsr
	 --, cop.LoadtoAST
    FROM ast.vw_AetnaMaCareOpsUnpivotedFromAdi cop
    WHERE cop.qmComp  = 'UNK'
	  and cop.LoadtoAST = 'Y'   
    GROUP BY cop.Measure;
	--SELECT 'Mapping: Missing values in QM_Mapping' AS ValidationType, cop.Measure, count(*) cntMsr
 --   FROM ast.vw_AetnaMaCareOpsUnpivotedFromAdi cop
 --   WHERE cop.qmComp = 'UNK'   
 --   GROUP BY cop.Measure;


    DECLARE @cntMissingMapping INT = 0
    SELECT @cntMissingMapping = SUM(CntMeasures)
    FROM @MissingMapping;

    IF @cntMissingMapping > 0 
	   BEGIN 
	   SELECT * FROM @MissingMapping;
	   END
    RETURN @cntMissingMapping;
