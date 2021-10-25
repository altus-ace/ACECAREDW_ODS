CREATE PROCEDURE ast.mbrPstTransform_GetEthnicityUhc 
    @LoadDate DATE
AS 
    /* Purpose Transform ast MbrEthnicity to value from lstAceMapping type 15 
		  if ast.eth = null set to unknown
		  if ast. eth = value in table update
		  if left over what?
	   Exception handling ???
    */
    --DECLARE @LoadDate DATE = '12/18/2020'
    
    /* if null set to '' */ 

    UPDATE ast SET ast.mbrEthnicity = ''
    FROM ast.MbrStg2_MbrData ast        
    WHERE ast.ClientKey = 1 and ast.LoadDate = @LoadDate 
	   and ast.mbrEthnicity is null
    /* lookup value in mapping and load into column */
    UPDATE ast SET ast.mbrEthnicity = am.Destination 
    --SELECT ast.mbrStg2_MbrDataUrn, ast.mbrEthnicity , am.Destination NewEth
    FROM ast.MbrStg2_MbrData ast
        LEFT JOIN lst.ListAceMapping am on ast.mbrEthnicity = am.Source and am.MappingTypeKey = 15	  
    WHERE ast.ClientKey = am.ClientKey AND ast.LoadDate = @LoadDate 

