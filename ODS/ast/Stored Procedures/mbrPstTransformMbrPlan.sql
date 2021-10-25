CREATE PROCEDURE ast.mbrPstTransformMbrPlan		  @LoadDate Date, @ClientKey Int, @DefaultTermDate DATE
AS 
    DECLARE @EndDate Date = @DefaultTermDate;
    /* transformed: plan effective DAte, Plan expiration date, Product plan Sub Plan Name */
    /* To Do: Product Plan, Product Plan  SubPlan
	   Also SbuPlanName needs to be tranformed into it's own field,instead of thesource field.
    */
        
    MERGE ast.MbrStg2_MbrData trg
    USING(SELECT stg.mbrStg2_MbrDataUrn, stg.mbrMemberKey, stg.LoadDate, stg.DataDate	   
			 , Pln.mbrPlanKey, Pln.EffectiveDate, Pln.ExpirationDate
			 , stg.plnClientPlanEffective, stg.plnMbrIsDualCoverage, stg.plnProductPlan, stg.plnProductSubPlan, stg.plnProductSubPlanName
			 , CASE WHEN (Pln.EffectiveDate IS NULL) THEN 
	   			 CONVERT(DATE, DATEADD(DAY, (-1*DATEPART(day,stg.DataDate)+1), stg.DataDate)) 
			 	 ELSE Pln.EffectiveDate END AS NewEffectiveDate 
			 , @EndDate NewExpirationDate
			 , planMap.TargetValue AS NewSubPlanName
		  FROM ast.MbrStg2_MbrData stg
			 LEFT JOIN adw.MbrMember Mbr
				ON stg.MbrMemberKey = Mbr.mbrMemberKey
			 LEFT JOIN adw.MbrPlan Pln
				ON stg.MbrMemberKey = Pln.mbrMemberKey
				AND stg.LoadDate BETWEEN Pln.EffectiveDate and Pln.ExpirationDate
			 LEFT JOIN lst.lstPlanMapping planMap ON stg.plnProductSubPlan = planMap.SourceValue
					   AND planMap.ClientKey = stg.ClientKey
					   AND planMap.TargetSystem = 'ACDW' /* map for ACDW */
					   AND stg.DataDate BETWEEN planMap.EffectiveDate and planMap.ExpirationDate		
		  WHERE stg.stgRowStatus in ('Loaded')
			 AND NOT stg.AdiKey IS NULL 
		  ) src
    ON trg.MbrStg2_MbrDataUrn = src.MbrStg2_MbrDataUrn
    WHEN MATCHED then UPDATE
	   SET   trg.TransformPlanEffectiveDate	   = src.NewEffectiveDate
		  , trg.TransfromPlanExpirationDate   = src.NewExpirationDate
		  , trg.plnProductSubPlanName		   = src.NewSubPlanName
    ;

