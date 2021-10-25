
CREATE PROCEDURE [adi].[AceValidCopUhcCareOpsPcor_Old]
AS 
    /* how do we make this useful?
	   as it is, it returns a great result
    */

    DECLARE @MissingMapping TABLE (ValidationType VARCHAR(100), CopMsrName VARCHAR(400), CntMeasures INT);
    INSERT INTO @MissingMapping (ValidationType, CopMsrName, CntMeasures)
    SELECT 'Mapping: Missing QM Mapping to listAceMapping' AS ValidationType, pcor.CopMsrName, count(*) cntMsr
    FROM adi.vw_pdwSrc_CopUhcPcor pcor
    where pcor.Destination is null
	   AND pcor.IncentiveProgram = 'ACO'
    GROUP BY pcor.CopMsrName
    UNION
    SELECT 'Mapping: Missing values in QM_Mapping' AS ValidationType, pcor.CopMsrName, count(*) cntMsr
    FROM adi.vw_pdwSrc_CopUhcPcor pcor
    where pcor.QM_ID is null
	   AND pcor.IncentiveProgram = 'ACO'
    GROUP BY pcor.CopMsrName;

    DECLARE @cntMissingMapping INT = 0
    SELECT @cntMissingMapping = SUM(CntMeasures)
    FROM @MissingMapping;

    IF @cntMissingMapping > 0 
	   BEGIN 
	   SELECT * FROM @MissingMapping;
	   END
    RETURN @cntMissingMapping;

