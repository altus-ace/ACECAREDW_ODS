create PROCEDURE ast.MbrPstTransform_GetPlanDetailsUhc @LoadDate DATE
AS  -- created: 1/13/2021 BY GKuhfeldt:
    -- purpose, for uhc decode and transform Plan data from lookups
   -- 1. get working table: ast tmpMbrPlanUhc
    --2. get look up clean planCode
    --3. get plan name from plan mapping :acdw_plnName
    --4. get lob from 
BEGIN
    -- SELECT * FROM ast.tmpMbrPlanUhc
    /* create working table if it doesnt' exist	    */
    
    IF OBJECT_ID (N'ast.tmpMbrPlanUhc', N'U') IS NULL 
	   BEGIN
	   CREATE TABLE ast.tmpMbrPlanUhc ( mbrStg2_MbrDataUrn INT, plnProductPlan VARCHAR(20), plnProductSubPlan VARCHAR(20), plnProductSubPlanName VARCHAR(50)
								, srcProductPlan VARCHAR(20), srcProductSubPlan VARCHAR(20), srcProductSubPlanName VARCHAR(50)
								, AdiKey INT, createdDate Date DEFAULT(getDate()), CreatedBy VARCHAR(20) DEFAULT(system_user)
								);
	   END;	   			 
    TRUNCATE TABLE ast.tmpMbrPlanUhc;  -- select * from ast.tmpMbrPlanUhc;  
    /* load wrk table */
    --DECLARE @loaddate date = '12/18/2020'
    INSERT INTO ast.tmpMbrPlanUhc (mbrStg2_MbrDataUrn, plnProductPlan, plnProductSubPlan, plnProductSubPlanName
		  , srcProductPlan, srcProductSubPlan, srcProductSubPlanName, adiKey)
    SELECT m.mbrStg2_MbrDataUrn, m.plnProductPlan, m.plnProductSubPlan, m.plnProductSubPlanName
			 , m.plnProductPlan, m.plnProductSubPlan, m.plnProductSubPlanName, m.AdiKey
    FROM ast.MbrStg2_MbrData m
	   JOIN adi.mbrUhcMbrByProvider adi ON m.AdiKey = adi.UHCMbrMbrByProviderKey
    where m.ClientKey = 1 and m.LoadDate = @LoadDate
    
    /* get plan name : for UHC this turns the source field LOB into Plan Name using ace mapping table type 16 */
	   
	   /* error set for Plan Name */    
	   --SELECT wrk.plnProductSubPlan, plnProductPlan, am.Destination
	   --FROM ast.tmpMbrPlanUhc wrk
		--  LEFT JOIN lst.listAceMapping am ON wrk.plnProductPlan = am.Source AND am.ClientKey = 1 AND am.mappingTYpeKey = 16 
	   --WHERE am.Destination is null;
    --SELECT wrk.plnProductSubPlan, plnProductPlan, am.Destination
    UPDATE wrk SET wrk.plnProductPlan = am.Destination
    FROM ast.tmpMbrPlanUhc wrk
	   JOIN lst.listAceMapping am ON wrk.plnProductPlan = am.Source AND am.ClientKey = 1 AND am.mappingTYpeKey = 16 
    ;	   
	       	
    /* get subplan Name */
	   /* error set for SubPlan Name -> send to log : FOR Uhc: this convert source field plan_code into subPlanName using lstPlanMapping targetSystem 'ACDW_PlnName' */

	   --SELECT wrk.mbrStg2_MbrDataUrn,  wrk.plnProductSubPlan, wrk.plnProductSubPlanName, pm. TargetValue
	   --FROM ast.tmpMbrPlanUhc wrk
	   --   LEFT JOIN lst.lstPlanMapping pm ON wrk.plnProductSubPlan = pm.SourceValue AND pm.TargetSystem = 'ACDW_PlnName' AND pm.ClientKey =1
	   --WHERE pm.TargetValue is NULL;
	   -- WHAT IS THE LIST WE ARE MATCHING TOO : SELECT * FROM acemasterdata.lst.lstPlanMapping pm where pm.TargetSystem = 'ACDW_PlnName' AND pm.ClientKey =1
    --SELECT wrk.plnProductSubPlan, wrk.plnProductSubPlanName, pm. TargetValue
    UPDATE wrk SET wrk.plnProductSubPlanName = pm.TargetValue
    FROM ast.tmpMbrPlanUhc wrk
	   JOIN lst.lstPlanMapping pm 
		  ON wrk.plnProductSubPlan = pm.SourceValue 
		  AND pm.TargetSystem = 'ACDW_PlnName' 
		  AND pm.ClientKey =1
    ;
    
    /* clean sub plan code : update clean any subplan value, not clean */
	   /* Error NOt Mapped */
--	   SELECT wrk.mbrStg2_MbrDataUrn, wrk.plnProductSubPlan, PlanMapping.TargetValue
--	   FROM ast.tmpMbrPlanUhc wrk
--	      LEFT JOIN lst.lstPlanMapping PlanMapping ON wrk.plnProductSubPlan = PlanMapping.SourceValue
--	   			AND PlanMapping.ClientKey = 1
--	                  AND PlanMapping.TargetSystem = 'ACDW'
--	                  AND '12/18/2020' BETWEEN PlanMapping.EffectiveDate AND PlanMapping.ExpirationDate
--	   WHERE PlanMapping.TargetValue is null;

    --SELECT wrk.mbrStg2_MbrDataUrn, wrk.plnProductSubPlan, PlanMapping.TargetValue
    UPDATE wrk SET wrk.plnProductSubPlan = PlanMapping.TargetSystem
    FROM ast.tmpMbrPlanUhc wrk
	   LEFT JOIN lst.lstPlanMapping PlanMapping ON wrk.plnProductSubPlan = PlanMapping.SourceValue
		  AND PlanMapping.ClientKey = 1
	       AND PlanMapping.TargetSystem = 'ACDW'
	       AND '12/18/2020' BETWEEN PlanMapping.EffectiveDate AND PlanMapping.ExpirationDate
    WHERE PlanMapping.TargetValue is null and NOT srcProductSubPlan is null;

	/* do load */
    --SELECT wrk.plnProductPlan, wrk.plnProductSubPlan, wrk.plnProductSubPlanName, ast.plnProductPlan, ast.plnProductSubPlan
    UPDATE ast SET ast.plnProductPlan = wrk.plnProductPlan
	   , ast.plnProductSubPlan	= wrk.plnProductSubPlan
	   , ast.plnProductSubPlanName = wrk.plnProductSubPlanName
    FROM ast.tmpMbrPlanUhc wrk
	   JOIN ast.MbrStg2_MbrData ast ON wrk.mbrStg2_MbrDataUrn = ast.mbrStg2_MbrDataUrn   	
    ;

    /* some logging should be added this is an ast transform job */
END;        
	   
