CREATE PROCEDURE [ast].[Pst_MbrDetails_Validate]--'2021-10-01',12
	@LoadDate DATE 
	, @ClientKey INT 
 AS 
    /* Log summary, log business rule fails, exception handling
    Business Rules:
	   1. Provider NPI must be Valid
	   2. Provider TIN Must be Valid
	   3. Mrn Must be Valid (ie Not -1)
	   4. Plan must have valid values for Product, Product Sub Plan, Product Sub Plan Name
	   5. TIN must be in PR
	  
	   */
    
    UPDATE ast SET ast.stgRowStatus = src.NewStgRowStatus
    FROM ast.MbrStg2_MbrData ast
	   JOIN (SELECT m.mbrStg2_MbrDataURN, m.stgRowStatus, m.MstrMrnKey, m.PrvNpi, m.PrvTIN
			 , m.plnProductPlan, m.plnProductSubPlan, m.plnProductSubPlanName
			 , CASE 
				   --WHEN ISNULL(m.prvTIN, '') = 0 THEN 'Not Valid' -- BR TIN MUST HAVE A Value
				   --WHEN ISNULL(m.prvNPI, '0') = 0 THEN 'Not Valid' -- BR NPI Must have a value removed Per Ram Amajula, load with zero. They are still our member
				   WHEN m.prvTIN = 'NA' OR m.prvTIN = '' THEN 'Not Valid' --Made changes to capture multiple fot TINs values
				   WHEN m.prvNPI IS NULL OR M.prvNPI = 0 THEN 'Not Valid'
				   --WHEN m.MstrMrnKey = -1	    THEN 'Not Valid' -- BR MRN MUST HAVE A VALUE
				   WHEN ISNULL(m.plnProductPlan, '')	= ''    THEN 'Not Valid' -- BR plan
				  -- WHEN ISNULL(m.PlnProductSubPlan, '')	= ''    THEN 'Not Valid' -- BR plan
				  -- WHEN ISNULL(m.plnProductSubPlanName, '') = ''THEN 'Not Valid' -- BR plan
				ELSE 'Valid' END AS NewStgRowStatus
		  FROM ast.MbrStg2_MbrData m    		  
		  WHERE m.LoadDate = @LoadDate
			 AND m.ClientKey = @ClientKey 
			 AND m.stgRowStatus IN ('Loaded', 'Valid')	
		  ) src
		  ON ast.mbrStg2_MbrDataURN = src.mbrStg2_MbrDataURN
    
    ;
