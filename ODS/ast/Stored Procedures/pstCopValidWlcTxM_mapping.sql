


CREATE PROCEDURE [ast].[pstCopValidWlcTxM_mapping]
AS 
    -- name pst process to staging
    -- cop care ops
    -- Valid Validation
    -- WlcTxM client Wellcare
    -- Mapping : verify mapping
    /* should this be self containted, call it, it logs, errors, captures errors, and then throws error up stack?
    */

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

    IF @cntMissingMapping > 0 
	   BEGIN 
	   SELECT * FROM @MissingMapping;
	   END
    RETURN @cntMissingMapping;
