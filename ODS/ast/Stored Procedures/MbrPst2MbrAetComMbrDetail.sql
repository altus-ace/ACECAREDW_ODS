﻿CREATE PROCEDURE [ast].[MbrPst2MbrAetComMbrDetail] --  [ast].[MbrPst2MbrAetComMbrDetail]'2021-10-01',3050
    @loadDate DATE     
    , @InsertCount INT OUTPUT
AS	

    --DECLARE @AdiTableName VARCHAR(50) = 'MbrAetCom';
    DECLARE @adiLoadDate DATE = @LoadDate; 
    DECLARE @Product VARCHAR(20) = 'Commercial';
    DECLARE @RowStatusValue VARCHAR(10) = 'Loaded';
	DECLARE @ClientKey INT = 9
    
    DECLARE @OutputTbl TABLE (ActionType VARCHAR(50), ID INT);  
    
	IF OBJECT_ID('tempdb..#Prr') IS NOT NULL DROP TABLE #Prr
	CREATE TABLE #Prr(NPI VARCHAR(50),ClientNPI VARCHAR(50),AttribTIN VARCHAR(50),ClientTIN VARCHAR(50),MemberID VARCHAR(50))

	INSERT INTO #Prr(NPI,ClientNPI,AttribTIN,ClientTIN,MemberID)
	EXECUTE  [adi].[GetMbrNpiAndTin_AetnaCOMM] @LoadDate,0,@ClientKey 

    MERGE ast.MbrStg2_MbrData trg
    USING(SELECT DISTINCT CurrentMbrToLoad.CLientMemberKey, c.ClientKey
		      , adiMbrs.[LastName], adiMbrs.[Member_First_Name] FirstName, adiMbrs.[Middle_Name] MiddleName, adiMbrs.[Member_Gender] GENDER, adiMbrs.[Member_Date_of_Birth] DOB
		      , adiMbrs.[Members_SSN] SSN, '' AS Hicn, adiMbrs.NPI NPI, adiMbrs.AttribTIN TIN, '' AutoAssign
			  , NULL as ClientEffectiveDate, NULL AS ClientExpirationDate, '' AS mbrMEDICARE_ID, '' AS mbrMEDICAID_NO, adimbrs.Aetna_Card_ID AS mbrInsuranceCardIdNum		      
		      , lstpln.TargetValue AS plnProductPlan, lstSubpln.TargetValue  AS plnProductSubPlan, lstSubpln.TargetValue plnProductSubPlanName
			  , lstCsPln.TargetValue AS CsplnProductSubPlanName
		      , adiMbrs.[Individual_Original_Effective_date_at_Aetna] as plnClientEffective
		      , adiMbrs.SrcFileName, CurrentMbrToLoad.AdiTableName , CurrentMbrToLoad.adiKey,  adiMbrs.LoadDate AS LoadDate, adiMbrs.dataDate as DataDAte, @RowStatusValue AS stgRowStatus			 		      
			 , 'TX' AS MbrState, [Attributed_Provider_NPI_Number] AS srcNPI,Line_of_Business
		  FROM (SELECT  * FROM adi.mbrAetCom m
					LEFT JOIN #Prr pr
					ON pr.MemberID = m.Member_ID
					AND pr.NPI = [Attributed_Provider_NPI_Number]
					--AND pr.AttribTIN = [Attributed_Provider_Tax_ID_Number_TIN]
					) adiMbrs 
		      JOIN lst.List_Client c ON c.ClientKey = @ClientKey
		      JOIN (SELECT t.ClientMemberKey, t.EffectiveMonth, t.LastClientUpdateDate, t.adiKey, t.adiTableName, t.LoadDate
		  		  FROM adi.tvf_MbrAetCom_GetCurrentMembers(@adiLoadDate) t
		  		  ) CurrentMbrToLoad ON adiMbrs.mbrAetComMbr = CurrentMbrToLoad.AdiKey    
		     LEFT JOIN(	SELECT	ClientKey, TargetSystem, SourceValue,ExpirationDate
								,EffectiveDate,TargetValue
					FROM		lst.lstPlanMapping
					WHERE		ClientKey = 9
					AND			Active = 'Y'
					AND			TargetSystem = 'ACDW_Plan') lstpln  
		  	  ON adiMbrs.[Line_of_Business] = lstpln.SourceValue 
			  LEFT JOIN(	SELECT	ClientKey, TargetSystem, SourceValue,ExpirationDate
								,EffectiveDate,TargetValue
					FROM		lst.lstPlanMapping
					WHERE		ClientKey = 9
					AND			Active = 'Y'
					AND			TargetSystem = 'ACDW_SubPlan') lstSubpln  
		  	  ON adiMbrs.[Line_of_Business] = lstSubpln.SourceValue 
			  LEFT JOIN(	SELECT	ClientKey, TargetSystem, SourceValue,ExpirationDate
								,EffectiveDate,TargetValue
					FROM		lst.lstPlanMapping
					WHERE		ClientKey = 9
					AND			Active = 'Y'
					AND			TargetSystem = 'CS_AHS') lstCspln  
		  	  ON adiMbrs.[Line_of_Business] = lstCspln.SourceValue 		  		  
		  		    AND @adiLoadDate BETWEEN lstpln.EffectiveDate and lstpln.ExpirationDate	        
		    LEFT JOIN (
						SELECT DISTINCT pr.AttribTIN, pr.NPI
		  					FROM #Prr PR 				 
		  		    ) ProviderRoster 
		  			 ON adiMbrs.[Attributed_Provider_NPI_Number] = ProviderRoster.NPI
						)src
      ON trg.ClientSubscriberId = src.ClientMemberKey
	   AND trg.ClientKey = src.ClientKey
	   AND trg.LoadDate = src.LoadDate
	 WHEN NOT MATCHED THEN 
	   INSERT (ClientSubscriberId, ClientKey
		  ,mbrLastName,mbrFirstName,mbrMiddleName, mbrGENDER,mbrDob
		  ,[mbrSSN],HICN ,prvNPI ,prvTIN ,prvAutoAssign, mbrMEDICAID_NO, mbrMEDICARE_ID, mbrInsuranceCardIdNum
		  ,prvClientEffective, prvClientExpiration 
		  ,plnProductPlan, plnProductSubPlan ,plnProductSubPlanName, CsplnProductSubPlanName 
		  ,plnClientPlanEffective
		  ,SrcFileName,AdiTableName,AdiKey,LoadDate,DataDate, stgRowStatus, MbrState
		  , srcNPI, srcPLN)
	   VALUES (src.ClientMemberKey, src.ClientKey
			 , src.LastName, src.FirstName, src.MiddleName, src.Gender, src.DOB
			 , src.SSN, src.HICN, src.NPI, src.TIN, src.AutoAssign, src.mbrMEDICAID_NO, src.mbrMEDICARE_ID, src.mbrInsuranceCardIdNum
			 , src.ClientEffectiveDate, src.ClientExpirationDate
			 , src.PlnProductPlan, src.plnProductSUbPlan, src.plnProductSubPlanName, src.CsplnProductSubPlanName 
			 , src.plnClientEffective
			 , src.SrcFileName, src.adiTableName, src.adiKey, src.LoadDate, src.DataDate, src.stgRowStatus, src.MbrState
			 , src.srcNPI, src.Line_of_Business)
	   WHEN MATCHED THEN UPDATE
		  SET  trg.mbrLastName			= src.LastName
		  ,trg.mbrFirstName			= src.FirstName
		  ,trg.mbrMiddleName		= src.MiddleName
		  ,trg.mbrGENDER			= src.Gender
		  ,trg.mbrDob				= src.DOB
		  ,trg.mbrSSN				= src.SSN
		  ,trg.HICN 				= src.HICN
		  ,trg.prvNPI				= src.NPI
		  ,trg.prvTIN 				= src.TIN
		  ,trg.prvAutoAssign		= src.AutoAssign
		  ,trg.mbrMEDICAID_NO		= src.mbrMEDICAID_NO
		  ,trg.mbrMEDICARE_ID		= src.mbrMEDICARE_ID
		  ,trg.mbrInsuranceCardIdNum	= src.mbrInsuranceCardIdNum
		  ,trg.prvClientEffective	= src.ClientEffectiveDate
		  ,trg.prvClientExpiration 	= src.ClientExpirationDate
		  ,trg.plnProductPlan		= src.PlnProductPlan
		  ,trg.plnProductSubPlan 	= src.plnProductSUbPlan
		  ,trg.plnProductSubPlanName 	= src.plnProductSubPlanName
		  ,trg.CsplnProductSubPlanName	=src.CsplnProductSubPlanName 
		  ,trg.plnClientPlanEffective	= src.plnClientEffective
		  ,trg.SrcFileName			= src.SrcFileName
		  ,trg.AdiTableName			= src.adiTableName
		  ,trg.AdiKey				= src.adiKey	   	   
		  ,trg.stgRowStatus			= src.stgRowStatus
		  ,trg.MbrState			= src.MbrState
        OUTPUT $Action, Inserted.mbrStg2_MbrDataUrn INTO @OutputTbl
    ;

    SELECT @InsertCount = COUNT(*) 
    FROM @OutputTbl;

	/*Update with EffectiveDate*/
	BEGIN

	DECLARE @EffectiveDate DATE =  CONVERT(DATE,DATEADD(month, DATEDIFF(month, 0, @LoadDate), 0)) 
	DECLARE @MbrShipDataDate DATE = (SELECT MAX(DataDate) 
											FROM ACECAREDW.ast.MbrStg2_MbrData
											WHERE	ClientKey = @ClientKey)
	UPDATE ACECAREDW.ast.MbrStg2_MbrData
	SET	EffectiveDate = @EffectiveDate --- 
	WHERE	ClientKey = @ClientKey
	AND		DataDate = @MbrShipDataDate

	END
	
	BEGIN		
	
			/*Create validation metrics for Member, NPI and Pln count*/	
		

					--Update MbrNPIFlg
					UPDATE ACECAREDW.ast.MbrStg2_MbrData
					SET MbrNPIFlg = (CASE WHEN prvNPI IS NULL THEN 0 ELSE 1 END)
					WHERE	EffectiveDate =  @EffectiveDate
					AND		DataDate =  @MbrShipDataDate
					AND		ClientKey = @ClientKey 
					AND		EffectiveDate = (SELECT MAX(EffectiveDate)
											  FROM ACECAREDW.ast.MbrStg2_MbrData 
												WHERE ClientKey = @ClientKey)

					--Update MbrPlnFlg
					UPDATE ACECAREDW.ast.MbrStg2_MbrData
					SET MbrPlnFlg = (CASE WHEN plnProductSubPlanName IS NULL THEN 0 ELSE 1 END)
					WHERE	EffectiveDate =  @EffectiveDate
					AND		DataDate =  @MbrShipDataDate
					AND		ClientKey = @ClientKey 
					AND		EffectiveDate = (SELECT MAX(EffectiveDate) 
												FROM ACECAREDW.ast.MbrStg2_MbrData 
													WHERE ClientKey = @ClientKey)
					
					--Update MbrFlgCount
					UPDATE ACECAREDW.ast.MbrStg2_MbrData
					SET MbrFlgCount = OutputResult  --- Select OutputResult,MbrFlgCount,*
					FROM	ACECAREDW.ast.MbrStg2_MbrData trg
					JOIN 	(SELECT CASE WHEN MbrCount >1 
										THEN MbrCount ELSE 1 END OutputResult
										,ClientSubscriberId
											FROM (
												SELECT	 COUNT(*) MbrCount
														,ClientSubscriberId
												FROM	 ACECAREDW.ast.MbrStg2_MbrData
												GROUP BY ClientSubscriberId
												)cnt
										)src
					ON		trg.ClientSubscriberId = src.ClientSubscriberId
					WHERE	ClientKey = @ClientKey 
					AND		EffectiveDate = (SELECT MAX(EffectiveDate) 
												FROM ACECAREDW.ast.MbrStg2_MbrData 
													WHERE ClientKey = @ClientKey)

		END

