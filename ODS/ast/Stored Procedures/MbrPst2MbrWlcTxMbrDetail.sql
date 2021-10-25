	    
CREATE PROCEDURE [ast].[MbrPst2MbrWlcTxMbrDetail] -- [ast].[MbrPst2MbrWlcTxMbrDetail]'04/20/2021',915
    @loadDate DATE     
    , @InsertCount INT OUTPUT
AS	

    --declare @LoadDate date = '11/22/2019';
    DECLARE @adiLoadDate DATE = @LoadDate;
    DECLARE @ClientKey INT = 2;
    DECLARE @RowStatusValue VARCHAR(10) = 'Loaded';   
    DECLARE @Plan varchar(20) = 'Medicare';     --this is a staging load business rule 
    DECLARE @PlanDualCoverage VARCHAR(1) = '0'; -- this is a staging load business rule 
    DECLARE @OutputTbl TABLE (ActionType VARCHAR(50), ID INT);  

    MERGE ast.MbrStg2_MbrData trg
    USING (SELECT AdiMbrs.SUB_ID ClientMemberKey, '' AS MstrMrnKey,c.ClientKey -- hardcoded/joined in during load to stg	   
		  	   , AdiMbrs.LastName AS LastName, AdiMbrs.FirstName FirstName, '' AS MiddleName, '' AS Gender, AdiMbrs.BirthDate AS DOB
		  	   , '' SSN, '' HICN, AdiMbrs.MEDICAID_NO as MedicaidNo, '' as MedicareId
		  	   , CASE WHEN (pl.NPI IS NULL) THEN 'NoPCP' ELSE pl.NPI END AS NPI, CASE WHEN (pl.TIN IS NULL) THEN 'NoPCP' ELSE pl.TIN END AS TIN, 'Unknown' AS AutoAssign
		  	   , AdiMbrs.EffDate ClientEffectiveDate, AdiMbrs.TermDate AS ClientExpirationDate
		  	   , @Plan AS PlnProductPlan, AdiMbrs.BenePlan AS plnProductSUbPlan , AdiMbrs.BenePLAN AS PlnProductSubPlanName , @PlanDualCoverage AS PlnIsDualCoverage	  
		  	   , AdiMbrs.EffDate plnClientEffective, AdiMbrs.TermDate AS srcPlnExpirationDate
		  	   , AdiMbrs.SrcFileName, adiMbrs.AdiTableName , AdiMbrs.mbrWlcMbrByPcpKey AS AdiKey, AdiMbrs.LoadDate AS LoadDate, AdiMbrs.DataDate AS DataDate, @RowStatusValue AS stgRowStatus
			   ,'TX'AS mbrState
		      FROM  adi.tvf_PdwSrc_Wlc_MemberByPcp( @LoadDate) AdiMbrs        
		  	   JOIN (SELECT c.ClientKey FROM lst.List_Client c ) c ON @CLientKey = c.ClientKey        	   
		  	   LEFT JOIN adw.MbrWlcProviderLookup pl ON AdiMbrs.Prov_id = pl.Prov_id  
		  		  AND @loaddate <= pl.Term_Date        
		      WHERE AdiMbrs.BestMemberRow = 1 /* gets 1 row per member. the load history needs to get all rows. this is a challenge 
		  								    1. do I load in all rows (mbr and phone and set the phone to something that will always be invalid?
		  								    2. do I impleament a possible mbrLoadHistoyr load from other sources? aka From PHones?
		  								    3. do I make tables have a SrcFileName, AdiKey, AdiTable fields directly? this still has the problem of how to combined sources. 
		  								    3. do I change the load history to have a load history detail? 
		  										  1 row per member in load history: this is attached to the mbrModel row
		  										  2.n rows per member in detail: this is attached to the Adi row. It allows mutliple files in a pretty inarticulate way*/
		  
		  	   --AND ISNULL(adiMbrs.BenePLAN, '') <> '' let validation do this work.		       
			 ) src
    ON trg.ClientSubscriberId = src.ClientMemberKey
	   AND trg.ClientKey = src.ClientKey
	   AND trg.LoadDate = src.LoadDate
    WHEN NOT MATCHED THEN 
	   INSERT (ClientSubscriberId, ClientKey
		  ,mbrLastName,mbrFirstName,mbrMiddleName, mbrGENDER,mbrDob
		  ,[mbrSSN],HICN, mbrMEDICAID_NO, mbrMEDICARE_ID, prvNPI ,prvTIN ,prvAutoAssign
		  ,prvClientEffective, prvClientExpiration 
		  ,plnProductPlan, plnProductSubPlan ,plnProductSubPlanName,plnMbrIsDualCoverage 
		  ,plnClientPlanEffective
		  ,SrcFileName,AdiTableName,AdiKey,LoadDate,DataDate, stgRowStatus,mbrState)
	   VALUES (src.ClientMemberKey, src.ClientKey
			 , src.LastName, src.FirstName, src.MiddleName, src.Gender, src.DOB
			 , src.SSN, src.HICN, src.MedicaidNo, src.MedicareId , src.NPI, src.TIN, src.AutoAssign
			 , src.ClientEffectiveDate, src.ClientExpirationDate
			 , src.PlnProductPlan, src.plnProductSUbPlan, src.plnProductSubPlanName,src.PlnIsDualCoverage
			 , src.plnClientEffective
			 , src.SrcFileName, src.adiTableName, src.adiKey, src.LoadDate, src.DataDate, src.stgRowStatus
			 ,src.MbrState)
    WHEN MATCHED THEN UPDATE
	   SET  trg.mbrLastName			= src.LastName
		  ,trg.mbrFirstName			= src.FirstName
		  ,trg.mbrMiddleName		= src.MiddleName
		  ,trg.mbrGENDER			= src.Gender
		  ,trg.mbrDob				= src.DOB
		  ,trg.mbrSSN				= src.SSN
		  ,trg.HICN 				= src.HICN
		  ,trg.mbrMEDICAID_NO		= src.MedicaidNo
		  ,trg.mbrMEDICARE_ID		= src.MedicareId
		  ,trg.prvNPI				= src.NPI
		  ,trg.prvTIN 				= src.TIN
		  ,trg.prvAutoAssign		= src.AutoAssign
		  ,trg.prvClientEffective	= src.ClientEffectiveDate
		  ,trg.prvClientExpiration 	= src.ClientExpirationDate
		  ,trg.plnProductPlan		= src.PlnProductPlan
		  ,trg.plnProductSubPlan 	= src.plnProductSUbPlan
		  ,trg.plnProductSubPlanName 	= src.plnProductSubPlanName
		  ,trg.plnMbrIsDualCoverage	= src.PlnIsDualCoverage
		  ,trg.plnClientPlanEffective	= src.plnClientEffective
		  ,trg.SrcFileName			= src.SrcFileName
		  ,trg.AdiTableName			= src.adiTableName
		  ,trg.AdiKey				= src.adiKey	   	   
		  ,trg.stgRowStatus			= src.stgRowStatus
		  ,trg.MbrState				=src.MbrState
    OUTPUT $Action, Inserted.mbrStg2_MbrDataUrn INTO @OutputTbl
    ;

    SELECT @InsertCount = COUNT(*) 
    FROM @OutputTbl;



