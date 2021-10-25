CREATE FUNCTION adi.udf_CleanMemberNpiValue 
(@NpiToClean VARCHAR(100)
)
RETURNS VARCHAR(20)
AS
BEGIN    
    
    /* clean all values of NPI.
	   IF NULL Make UNKNOWN
	   IF '' MAKE UNKNOWN
	   IF ' ' MAKE UNKNOWN
	   ELSE TRIM AND RETURN */
	       
    DECLARE @vcNpi VARCHAR(100)
    SET @vcNpi = ISNULL(@NpiToClean, '') ;    
    SET @vcNpi =  [adi].[udf_GetCleanString](@vcNpi)
    IF @vcNpi = '' SET @vcNpi = 'Unknown' -- @UnknownNpi; this should be 
    
    RETURN RTRIM(LTRIM(@vcNpi));
END;
