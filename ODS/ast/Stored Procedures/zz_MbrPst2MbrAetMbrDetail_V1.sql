CREATE PROCEDURE [ast].[zz_MbrPst2MbrAetMbrDetail_V1]
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

INSERT INTO [ast].[MbrStg2_MbrData]
           (ClientSubscriberId
		  ,ClientKey 
		  ,MstrMrnKey 
		  ,LoadType
		  ,mbrLastName
		  ,mbrFirstName
		  ,mbrGENDER
		  ,mbrDob
		  ,HICN
		  ,prvNPI
		  ,prvTIN
		  ,prvAutoAssign
		  ,prvClientEffective
		  ,prvClientExpiration
		  ,plnProductPlan
		  ,plnProductSubPlan
		  ,plnProductSubPlanName
		  ,plnClientPlanEffective
		  ,SrcFileName
		  ,AdiTableName
		  ,AdiKey
		  ,LoadDate
		  ,DataDate)
OUTPUT inserted.AdiKey INTO @OutputTbl(ID)    
SELECT d.AetSubscriberID							 
    ,c.ClientKey								 
    ,mrn.MstrMrnKey								 
    ,@LoadType									 
    ,d.LastName 								 
    ,d.FirstName 								 
    ,d.Gender 									 
    ,d.DOB 									 
    ,d.HICN 									 
    ,d.NPI 									 
    ,d.TIN 									 
    ,msc.Destination AS prvAutoAssign				  
    ,d.EffectiveDate 							 
    ,d.TermDate 	
    ,d.Product									 
    ,CONVERT(VARCHAR(20), subplan.TargetValue) subPlanTarget  /* convert to Varchar 20 to fit the field, this could be an issue */
    ,subplanName.TargetValue
    ,CONVERT(DATE, DATEADD(DAY, (-1*DATEPART(day,@LoadDate)+1), @LoadDate)) 
    ,d.SrcFileName 								
    ,@AdiTableName
    ,d.mbrAetMbrByPcpKey 						
    ,d.LoadDate 								
    ,d.DataDate    
FROM adi.MbrAetMbrByPcp d
    JOIN lst.list_Client c ON 'Aet' = c.ClientShortName    
    LEFT JOIN adw.MstrMrn mrn ON 
		  d.LastName = mrn.LastName
	   AND d.FirstName = mrn.FirstName
	   AND d.DOB = mrn.DateOfBirth
	   AND mrn.Active = 1	
    JOIN lst.ListAceMapping Msc ON d.MSCIndicator = msc.Source AND msc.MappingTYpeKey = 9     
    JOIN lst.lstPlanMapping SubPlan  
		  ON d.Product = subPlan.SourceValue 
		  AND SubPlan.TargetSystem = 'ACDW'
		  AND @LoadDate BETWEEN SubPlan.EffectiveDate and SubPlan.ExpirationDate	
    JOIN lst.lstPlanMapping SubPlanName 
		  ON d.Product = subPlanName.SourceValue
		  AND SubPlanName.TargetSystem = 'ACDW'
		  AND @loadDate BETWEEN SubPlanName.EffectiveDate AND SubPlanName.ExpirationDate
		  /* gk 3/11/2019  
			 Added LOB and TIN expriration support: 
				IF the LOB changes from Medicare Advantage, we will need to fix the Hard coded value
				*/
     /*JOIN (SELECT  TIN--, EffectiveDate, TermDate, LOB 
			 FROM adw.tvf_GetValidProviderTinsByDate(GETDATE()) 
			 WHERE LOB = 'Medicare Advantage'
				AND ISNULL(TermDate, '1/1/2099') > GETDATE()
			 GROUP BY TIN)AS Tns 
	   ON d.TIN = Tns.TIN-- AND d.NPI = tns.NPI  REMOVED TO IMPLEMENT new Provider roster from fact.
	   */
     JOIN (SELECT pr.TIN , pr.CalcClientKey
				FROM dbo.vw_AllClient_ProviderRoster pr
				WHERE pr.providerType in ('PCP')
				    AND GETDATE() BETWEEN pr.EffectiveDate and pr.ExpirationDate
				GROUP BY pr.TIN, pr.CalcClientKey
				)as contractedTins 
	   ON c.ClientKey = contractedTins.CalcClientKey
		/* CONVERT TO INT to allow zero padded and non-zero padded values to compare properly */
		AND try_convert(int, d.TIN) = try_convert(int, contractedTins.TIN) 
WHERE d.LoadDate = @loadDate    
    AND d.TIN IN (SELECT vp.TIN FROM  adw.tvf_GetValidProviderTinsByDate(GETDATE())  vp) 
ORDER BY d.AetSubscriberID
;

SELECT @InsertCount = COUNT(*) 
FROM @OutputTbl;



--select * from adw.tvf_GetValidProviderTinsByDate(GETDATE())