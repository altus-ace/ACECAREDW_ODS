
CREATE PROCEDURE ast.mbrPstTransformMbrPcp	@LoadDate Date, @ClientKey Int, @DefaultTermDate DATE
AS     
    /*  if provider id, must convert to tin/npi done in load to stage 
    
	   transforms: done : Pcp Effective Date, Expiration Date    
    */

    DECLARE @EndDate Date = @DefaultTermDate;
        
    MERGE ast.MbrStg2_MbrData trg 
    USING(  SELECT stg.mbrStg2_MbrDataUrn, stg.mbrMemberKey, stg.LoadDate, stg.DataDate	   
			 , Pcp.mbrPcpKey , Pcp.EffectiveDate, Pcp.ExpirationDate
			 , CASE WHEN (Pcp.EffectiveDate IS NULL) THEN 
	   			 CONVERT(DATE, DATEADD(DAY, (-1*DATEPART(day,stg.DataDate)+1), stg.DataDate)) 
			 	 ELSE Pcp.EffectiveDate END AS NewEffectiveDate 
			 , @EndDate NewExpirationDate			 
		  FROM ast.MbrStg2_MbrData stg
			 LEFT JOIN adw.MbrMember Mbr
				ON stg.MbrMemberKey = Mbr.mbrMemberKey
			 LEFT JOIN adw.mbrPcp Pcp
				ON stg.MbrMemberKey = Pcp.mbrMemberKey
				AND stg.LoadDate BETWEEN Pcp.EffectiveDate and Pcp.ExpirationDate
			 /* pcp lookup */
		  WHERE stg.stgRowStatus in ('Loaded')
			 AND NOT stg.AdiKey IS NULL 
		  ) src
    ON trg.MbrStg2_MbrDataUrn = src.MbrStg2_MbrDataUrn
    WHEN MATCHED then UPDATE
	   SET   trg.TransformPlanEffectiveDate	   = src.NewEffectiveDate
		  , trg.TransfromPlanExpirationDate   = src.NewExpirationDate		 
    ;

