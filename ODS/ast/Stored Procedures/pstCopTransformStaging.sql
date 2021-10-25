


CREATE PROCEDURE ast.pstCopTransformStaging
    @LoadDate DATE
    , @CLientKey INT
AS
    /* no transformations at this time but I am adding them asap
    1. all the codes from adi should be in here as adi value, then transform to platform value here, then the failure could be captured, reported/log, fixed and then exported
    */
    SELECT 1;
