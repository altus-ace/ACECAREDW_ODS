CREATE PROCEDURE ast.mbrPstTransformMbrCsPlanHist	  @LoadDate Date, @ClientKey Int, @DefaultTermDate DATE
AS 
    /* transforms: done : Cs Plan Effective Date, Cs Plan Expiration Date, 
    /* MbrCsSubPlan */
    /* MbrCsSubPlanName */
    */

    DECLARE @EndDate Date = '12/31/2099';    
    /* transformed: plan effective DAte, Plan expiration date, Product plan Sub Plan Name */
    /* To Do: Product Plan, Product Plan  SubPlan
	   Also SbuPlanName needs to be tranformed into it's own field,instead of thesource field.
    */
    
    MERGE ast.MbrStg2_MbrData trg
    USING(    SELECT stg.mbrStg2_MbrDataUrn, stg.mbrMemberKey, stg.LoadDate, stg.DataDate	   
			 , CsPln.mbrCsPlanKey , CsPln.EffectiveDate, CsPln.ExpirationDate
			 , CASE WHEN (CsPln.EffectiveDate IS NULL) THEN 
	   			 CONVERT(DATE, DATEADD(DAY, (-1*DATEPART(day,stg.DataDate)+1), stg.DataDate)) 
			 	 ELSE CsPln.EffectiveDate END AS NewEffectiveDate 
			 , @EndDate NewExpirationDate
			 , planMap.TargetValue AS NewCsPlanName
		  FROM ast.MbrStg2_MbrData stg
			 LEFT JOIN adw.MbrMember Mbr
				ON stg.MbrMemberKey = Mbr.mbrMemberKey
			 LEFT JOIN adw.mbrCsPlanHistory CsPln
				ON stg.MbrMemberKey = CsPln.mbrMemberKey
				AND stg.LoadDate BETWEEN CsPln.EffectiveDate and CsPln.ExpirationDate
			 LEFT JOIN lst.lstPlanMapping planMap ON stg.plnProductSubPlan = planMap.SourceValue
					   AND planMap.ClientKey = stg.ClientKey
					   AND planMap.TargetSystem = 'CS_AHS'
					   AND stg.DataDate BETWEEN planMap.EffectiveDate and planMap.ExpirationDate		
		  WHERE stg.stgRowStatus in ('Loaded')
			 AND NOT stg.AdiKey IS NULL 
		  ) src
    ON trg.MbrStg2_MbrDataUrn = src.MbrStg2_MbrDataUrn
    WHEN MATCHED then UPDATE
	   SET   trg.TransformPlanEffectiveDate	   = src.NewEffectiveDate
		  , trg.TransfromPlanExpirationDate   = src.NewExpirationDate
		  , trg.TransformCsPlanNameDate   = src.NewCsPlanName
    ;
