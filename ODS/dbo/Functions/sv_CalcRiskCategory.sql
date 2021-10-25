

CREATE FUNCTION [dbo].[sv_CalcRiskCategory]
(
	-- Add the parameters for the function here
	@iProRiskScore NUMERIC(10,4)
)
RETURNS varchar(25)
AS
BEGIN
	DECLARE @Low NUMERIC(10,4) = CONVERT(NUMERIC(10,4), 5.0);
	DECLARE @High NUMERIC(10,4)= CONVERT(NUMERIC(10,4), 10.0);
	DECLARE @result VARCHAR(25);

	IF (@iProRiskScore >=  @High) SET @result = 'HIGH' 
		ELSE IF  ((@iProRiskScore < @High) AND (@iProRiskScore >=  @Low)) SET @result = 'MED' 
		ELSE IF (@iProRiskScore < @Low) SET @result = 'LOW'
		ELSE SET @result = 'LOW' 
			
	RETURN @result

END

