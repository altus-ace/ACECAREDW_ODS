CREATE PROCEDURE ast.mbrPstTransformMbrDemographic  @LoadDate Date, @ClientKey Int, @DefaultTermDate DATE
AS 
    /* what demo*/
    /* gender */    
    /* Ethnicity */
    /* Race */
    /* Primary Language */
    -- None for now
    DECLARE @EndDate Date =  @DefaultTermDate;
    
    -- Must set start stop dates for each effective row
    -- How to capture changes in member data. THis is not implemented: next month
	   -- compare old/new,  if different, then change dates (new set start this month)
	   -- insert new row, set MbrDemo Key here
	   -- then on term, term all for member active except the mbrDemoKey in stg
    SELECT TOP 1 * from ast.mbrstg2_mbrdata
    MERGE ast.mbrStg2_MbrData trg
    USING (SELECT stg.mbrStg2_MbrDataUrn, stg.mbrMemberKey, stg.LoadDate, stg.DataDate	   
			 , Demo.mbrDemographicKey, Demo.EffectiveDate, Demo.ExpirationDate
			 , CASE WHEN (DEMO.EffectiveDate IS NULL) THEN 
	   			 CONVERT(DATE, DATEADD(DAY, (-1*DATEPART(day,stg.DataDate)+1), stg.DataDate)) 
			 	 ELSE DEMO.EffectiveDate END AS NewEffectiveDate 
			 , @EndDate NewExpirationDate
		  FROM ast.MbrStg2_MbrData stg
			 LEFT JOIN adw.MbrMember Mbr
				ON stg.MbrMemberKey = Mbr.mbrMemberKey
			 LEFT JOIN adw.MbrDemographic Demo 
				ON stg.MbrMemberKey = Demo.mbrMemberKey
				AND stg.LoadDate BETWEEN Demo.EffectiveDate and demo.ExpirationDate
		  WHERE stg.stgRowStatus in ('Loaded')
			 AND NOT stg.AdiKey IS NULL 
			 ) src
    ON trg.mbrStg2_MbrDataUrn = src.mbrStg2_MbrDataUrn
    WHEN MATCHED THEN 
    UPDATE SET 
	   trg.TransformDemoEffectiveDate = src.NewEffectiveDate
	   , trg.TransformDemoExpirationDate = src.NewExpirationDate
    ;


