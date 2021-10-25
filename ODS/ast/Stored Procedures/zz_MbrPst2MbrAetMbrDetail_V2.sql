CREATE PROCEDURE [ast].[zz_MbrPst2MbrAetMbrDetail_V2]	
    @loadDate DATE 
    , @LoadType CHAR(1) 
    , @InsertCount INT OUTPUT
AS	

DECLARE @AdiTableName VARCHAR(50) = 'MbrAetMbrByPcp';

IF @LoadType NOT IN ('S','P') 
    raiserror('Ace ETL Error: Mbr Load terminated. @LoadType not a valid value.', 20, -1) with log;

DECLARE @OutputTbl TABLE (ID INT);

/* remove any prior staged records */
TRUNCATE TABLE ast.MbrStg2_MbrData;
/* insert adi target rows */
INSERT INTO [ast].[MbrStg2_MbrData]
           (ClientSubscriberId ,ClientKey 	
		  ,LoadType
		  ,mbrLastName,mbrFirstName,mbrGENDER,mbrDob,HICN
		  ,prvNPI,prvTIN,prvAutoAssign,prvClientEffective,prvClientExpiration
		  ,plnProductPlan,plnProductSubPlan,plnProductSubPlanName,plnClientPlanEffective
		  ,SrcFileName,AdiTableName,AdiKey,LoadDate,DataDate)
OUTPUT inserted.AdiKey INTO @OutputTbl(ID)    
SELECT d.AetSubscriberID,c.ClientKey 
    ,@LoadType									 
    ,d.LastName,d.FirstName ,d.Gender,d.DOB ,d.HICN 	 
    ,d.NPI,d.TIN,msc.Destination AS prvAutoAssign,d.EffectiveDate AS prvClientEffective, d.TermDate AS prvClientExpiration
    ,d.Product ,CONVERT(VARCHAR(20), subplan.TargetValue) subPlanTarget  
		  ,subplanName.TargetValue as SubPlanName, CONVERT(DATE, DATEADD(DAY, (-1*DATEPART(day,@LoadDate)+1), @LoadDate)) AS EndDate
    ,d.SrcFileName ,@AdiTableName,d.mbrAetMbrByPcpKey ,d.LoadDate,d.DataDate    
FROM adi.MbrAetMbrByPcp d
    JOIN lst.list_Client c ON 'Aet' = c.ClientShortName    
    /* Mappings should be done into their own target column so it can be validated */    
    JOIN lst.ListAceMapping Msc ON d.MSCIndicator = msc.Source AND msc.MappingTYpeKey = 9     
    JOIN lst.lstPlanMapping SubPlan  
		  ON d.Product = subPlan.SourceValue 
		  AND SubPlan.TargetSystem = 'ACDW'
		  AND @LoadDate BETWEEN SubPlan.EffectiveDate and SubPlan.ExpirationDate	
    JOIN lst.lstPlanMapping SubPlanName 
		  ON d.Product = subPlanName.SourceValue
		  AND SubPlanName.TargetSystem = 'ACDW'
		  AND @loadDate BETWEEN SubPlanName.EffectiveDate AND SubPlanName.ExpirationDate
WHERE d.LoadDate = @loadDate    
    AND d.TIN IN (SELECT vp.TIN FROM  adw.[tvf_Get_AetMa_ValidProviderTinsByDate](GETDATE())  vp) 
ORDER BY d.AetSubscriberID
;

/* this should be a call to the Member Matching tool to get MPIs */
MERGE ast.MbrStg2_MbrData trg
USING(SELECT d.mbrStg2_MbrDataUrn, MIN(mrn.MstrMrnKey)MstrMrnKey
	   FROM ast.MbrStg2_MbrData d
		  LEFT JOIN adw.MstrMrn mrn ON 
	   		  d.mbrLastName = mrn.LastName
	   	   AND d.mbrFirstName = mrn.FirstName
	   	   AND d.mbrDob = mrn.DateOfBirth
	   		  AND mrn.Active = 1	
	    GROUP BY mbrStg2_MbrDataUrn
	   )src
ON trg.mbrStg2_MbrDataUrn = src.mbrStg2_MbrDataUrn
    and NOT src.mstrMrnKey IS NULL
WHEN MATCHED THEN 
    UPDATE SET trg.[MstrMrnKey] = src.[MstrMrnKey]
;

SELECT @InsertCount = COUNT(*) 
FROM @OutputTbl;


