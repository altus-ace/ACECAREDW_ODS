

CREATE  FUNCTION [dbo].[sv_CalcRiskCategory_V2]
(
	-- Altered to take a Varchar and handle cases where the value can not be converted to a number
	@iProRiskScore varchar(10)
)
RETURNS varchar(25)
AS
BEGIN
    DECLARE @IProNum AS NUMERIC(10,4) = TRY_CONVERT(NUMERIC(10,4), @iProRiskScore);
	DECLARE @Low NUMERIC(10,4) = CONVERT(NUMERIC(10,4), 5.0);
	DECLARE @High NUMERIC(10,4)= CONVERT(NUMERIC(10,4), 10.0);
	DECLARE @result VARCHAR(25);

	IF @IProNum is null SET @result = 'UNKNOWN'
	ELSE IF (@iProNum >=  @High) SET @result = 'HIGH' 
		ELSE IF  ((@iProNum < @High) AND (@iProNum >=  @Low)) SET @result = 'MED' 
		ELSE IF (@iProNum < @Low) SET @result = 'LOW'
		ELSE SET @result = 'LOW' 
			
	RETURN @result

END

