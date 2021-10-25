CREATE PROCEDURE [ast].[MbrPst2MbrCignaMaTxMbrDetail]--  [ast].[MbrPst2MbrCignaMaTxMbrDetail]'2021-10-04',509
    @DataDate DATE 
    , @InsertCount INT OUTPUT
AS	
    DECLARE @LoadType CHAR(1) = 'P'
    DECLARE @adiDataDate DATE = @DataDate;
	DECLARE @ClientKey INT = 12
    DECLARE @RowStatusValue VARCHAR(10) = 'Loaded';
    
 
	IF OBJECT_ID('tempdb..#Prr') IS NOT NULL DROP TABLE #Prr
	CREATE TABLE #Prr(PrKey INT PRIMARY KEY IDENTITY(1,1),NPI VARCHAR(50),ClientNPI VARCHAR(50),AttribTIN VARCHAR(50),ClientTIN VARCHAR(50),MemberID VARCHAR(50))

	INSERT INTO #Prr(PrKey,NPI,ClientNPI,AttribTIN,ClientTIN,MemberID)
	EXECUTE  [adi].[GetMbrNpiAndTin_CignaMA] @DataDate,0,@ClientKey 

    DECLARE @OutputTbl TABLE (ActionType VARCHAR(50), ID INT);
    
    MERGE ast.[MbrStg2_MbrData] trg
    USING ( -- DECLARE @LoadType CHAR(1) = 'P' DECLARE @DataDate DATE = '2021-10-04'; DECLARE @RowStatusValue VARCHAR(10) = 'Loaded'
				SELECT DISTINCT  src.ClientSubscriberId			as [ClientSubscriberId]																			    
					,src.ClientKey				as [ClientKey]						 
					,-1						as [MstrMrnKey]
					,@LoadType 				as [LoadType]
					,src.lastname 				as [mbrLastName]
					,src.firstname 			as [mbrFirstName]
					,src.middlename 			as [mbrMiddleName]
					,src.ssn 					as [mbrSSN]
					,src.gender 				as [mbrGENDER]
					,src.DOB 					as [mbrDob]
					,''						as [mbrInsuranceCardIdNum]
					,''					 	as [mbrMEDICAID_NO]
					,src.medicareid 			as [mbrMEDICARE_ID]
					,''	   					as [HICN]
					,''						as [MBI]
					,''						as [mbrEthnicity]
					,''			 			as [mbrRace]
					,src.LanguageDesc 			as [mbrPrimaryLanguage] -- some kinda map?
					,src.NPI 					as [prvNPI]
					,src.AttribTIN				as [prvTIN]
					,''				    		as [prvAutoAssign]
					,src.ClientEffectiveDate 	as [prvClientEffective]
					,''		   							as [prvClientExpiration]
					,tPlan.TargetValue					as [plnProductPlan]
					,''									as [plnProductSubPlan]
					,ISNULL(lstSubPln.TargetValue,'') 	as [plnProductSubPlanName]
					,PlnCsPln.TargetValue				as [CsplnProductSubPlanName]
					,''									as [plnMbrIsDualCoverage]
					,''									as [plnClientPlanEffective]
					,''									as [rspLastName]
					,''									as [rspFirstName]
					,''									as [rspAddress1]
					,''									as [rspAddress2]
					,''									as [rspCITY]
					,''									as [rspSTATE]
					,''									as [rspZIP]
					,''									as [rspPhone] 
					,src.SrcFileName 			as [SrcFileName]
					,src.AdiTableName 			as [AdiTableName]
					,src.adiKey 				as [AdiKey]
					,src.RowStatus 			as [stgRowStatus]
					,src.LoadDate				as [LoadDate]
					,src.DataDate				as [DataDate]
					,null				   	as [CreateDate]
					,null		 			as [CreateBy]
					,''						as [MbrMemberKey]
					,''						as [MbrPlanKey]
					,''						as [MbrPcpKey]
					,''						as [MbrCsPlanKey]
					,''						as [TransformPcpEffectiveDate]
					,''						as [TransfromPcpExpirationDate]
					,''						as [TransformPlanEffectiveDate]
					,''						as [TransfromPlanExpirationDate]
					,''						as [TransformCsPlanEffectiveDate]
					,''						as [TransfromCsPlanExpirationDate]
					,''						as [MbrLoadHistoryKey]
					,''						as [TransformDemoEffectiveDate]
					,''						as [TransformDemoExpirationDate]
					,''						as [TransformCsPlanNameDate]
					,''						as [plnClientPlanEndDate]
					, 'TX'					AS StgMbrState
					,@RowStatusValue			as [stgRowAction]
					,src.dualeligibility		as [Member_Dual_Eligible_Flag]
					,src.srcNPI					AS srcNPI
					,src.srcPln					AS srcPln	
					,src.Lob					AS Lob
			 FROM (    SELECT REPLACE(adiData.memberid,'*', '')  AS ClientSubscriberId /* clean the input, if astrick in source, remove */
					   , client.clientKey AS ClientKey, 			   
			           adiData.lastname, adiData.firstname, adiData.middlename, adiData.ssn, 				   
			           adiData.gender, adiData.DOB, adiData.medicareid, adiData.LanguageDesc, 				   
			           pr.NPI, pr.AttribTIN, adiData.effectivedate ClientEffectiveDate, adiData.groupid, 		   
			           adiData.plan_name, 														   
			           adiData.SrcFileName, 														   
			           'tmp_CignaMAMembership' AS AdiTableName, 										   
			           adiData.MbrKey AS adiKey, 													   
			           'Loaded' AS RowStatus, 
					   NPID AS srcNPI,
					   Plan_Name AS srcPln,														   
			           LoadDate AS LoadDate, 														   
			           adiData.DataDate, 															   
			           adiData.dualeligibility,												   
			           ROW_NUMBER() OVER(PARTITION BY adiData.MEMBERID ORDER BY adiData.dataDate DESC) aRowNumber  
					   ,Client.LOBName AS LOB
				    FROM Acdw_clms_Cigna_Ma.[adi].[tmp_CignaMAMembership] AS adiData						   
				         JOIN lst.list_client Client ON client.ClientShortName = 'Cigna_MA'					   
				         LEFT JOIN (																   
				        		SELECT *
								FROM (
				        				SELECT NPI,AttribTIN,ClientNPI,ClientTIN,MemberID,prKey
												,ROW_NUMBER()OVER(PARTITION BY NPI,MemberID ORDER BY AttribTIN)RwCnt
										FROM #Prr	
										)prr
								WHERE prr.RwCnt = 1							   
				        	  ) PR																	   
				        	  ON adiData.NPID = PR.NPI					   
				    WHERE adiData.DataDate = @DataDate ---Have to select the latest DataDate
					AND	  adiData.MbrLoadStatus = 0										   
			 ) src																			   
			LEFT JOIN (SELECT	ClientKey, TargetSystem
								,SourceValue, TargetValue
								,ACTIVE
							FROM	lst.lstPlanMapping
							WHERE	ClientKey = 12
							AND	   ACTIVE = 'Y'
							AND		TargetSystem = 'ACDW_PLAN'
						)  
			tPlan ON src.plan_name = tPlan.SourceValue
			LEFT JOIN		(SELECT	ClientKey, TargetSystem
								,SourceValue, TargetValue
								,ACTIVE
							FROM	lst.lstPlanMapping
							WHERE	ClientKey = 12
							AND	   ACTIVE = 'Y'
							AND		TargetSystem = 'ACDW_SubPlan') lstSubPln
		  ON src.plan_name = lstSubPln.SourceValue
		  LEFT JOIN		(SELECT	ClientKey, TargetSystem
								,SourceValue, TargetValue
								,ACTIVE
							FROM	lst.lstPlanMapping
							WHERE	ClientKey = 12
							AND	   ACTIVE = 'Y'
							AND		TargetSystem = 'CS_AHS') PlnCsPln
		  ON src.plan_name = lstSubPln.SourceValue
		  AND src.aRowNumber = 1
    		  )src		  
    ON trg.ClientKey = src.ClientKey
        AND trg.LoadDate = src.LoadDate
        AND trg.AdiKey = src.AdiKey
    WHEN NOT MATCHED THEN  
        INSERT 
        (ClientSubscriberId, ClientKey,LoadType
        		  ,mbrLastName,mbrFirstName,mbrMiddleName, mbrGENDER,mbrDob
        		  , mbrMEDICARE_ID, mbrMEDICAID_NO,HICN ,prvNPI ,prvTIN ,prvAutoAssign
        		  , prvClientEffective, prvClientExpiration
        		  , rspLastName, rspFirstName, rspAddress1, rspAddress2, rspCITY, rspSTATE, rspZIP, rspPhone
        		  , plnProductPlan, plnProductSubPlan ,plnProductSubPlanName,CsplnProductSubPlanName ,plnClientPlanEffective
			  , mbrState
        		  ,SrcFileName,AdiTableName,AdiKey,LoadDate,DataDate, stgRowStatus
				  ,srcNPI,srcPln,Lob)
        VALUES (Src.ClientSubscriberId, src.ClientKey, src.LoadType 
		   , src.mbrLastName, src.mbrFirstName, src.mbrMiddleName, src.mbrGENDER, src.mbrDob
        	   , src.mbrMEDICARE_ID, src.mbrMEDICAID_NO, src.HICN, src.prvNPI, src.prvTIN, src.prvAutoAssign
		   , src.prvClientEffective, src.prvClientExpiration
		   , src.rspLastName, src.rspFirstName, src.rspAddress1, src.rspAddress2, src.rspCITY, src.rspSTATE, src.rspZIP, src.rspPhone
		   , src.plnProductPlan, src.plnProductSubPlan, src.plnProductSubPlanName, CsplnProductSubPlanName, src.plnClientPlanEffective
		   , src.StgMbrState
        	   , src.SrcFileName, src.adiTableName, src.AdiKey, src.LoadDate, src.DataDate, src.stgRowStatus
			   ,srcNPI,srcPln, Lob)
    /*WHEN MATCHED THEN  	  UPDATE set blah blah blah*/
    OUTPUT $Action, Inserted.mbrStg2_MbrDataUrn INTO @OutputTbl
    ;
        
    SELECT @InsertCount = COUNT(*) 
    FROM @OutputTbl;


	/*Update with EffectiveDate*/
	BEGIN

	DECLARE @EffectiveDate DATE =  CONVERT(DATE,DATEADD(month, DATEDIFF(month, 0, Getdate()), 0)) 
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
					SET MbrPlnFlg = (CASE WHEN plnProductPlan IS NULL THEN 0 ELSE 1 END)
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

