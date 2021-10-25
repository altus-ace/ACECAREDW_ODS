
CREATE PROCEDURE [adi].[ValidateCignaMAMembership]

AS

DECLARE @DataDate DATE = '2021-09-03'
DECLARE @ClientKey INT = 12

					--Select count datadate
					SELECT   COUNT(*)RecCnt,[DataDate]
							 ,MbrLoadStatus
					FROM	 [ACDW_CLMS_CIGNA_MA].[adi].[tmp_CignaMAMembership] 
					GROUP BY [DataDate],MbrLoadStatus
					ORDER BY DataDate DESC
					
					
					--New Roster
					--Step 1 matches on NPI and then TIN to return the exact matches of both for the npi set
					--Insert into a temp table DROP TABLE #Pr  -- SELECT * FROM #Pr order by npi
					--  DECLARE @LoadDate DATE = '2021-07-07' DECLARE @ClientKey INT = 12 
					IF OBJECT_ID('tempdb..#Prr') IS NOT NULL DROP TABLE #Prr
					CREATE TABLE #Prr(PrKey INT PRIMARY KEY IDENTITY(1,1),NPI VARCHAR(50),ClientNPI VARCHAR(50),AttribTIN VARCHAR(50),ClientTIN VARCHAR(50),MemberID VARCHAR(50))

					INSERT INTO #Prr(PrKey,NPI,ClientNPI,AttribTIN,ClientTIN,MemberID)
					EXECUTE  [adi].[GetMbrNpiAndTin_CignaMA] @DataDate,0,@ClientKey 

					---- Checking for Valid Plans
					SELECT	adi.plan_name,PLN.SourceValue
					FROM	Acdw_clms_Cigna_Ma.[adi].[tmp_CignaMAMembership] adi
					LEFT JOIN (SELECT * 
											FROM lst.lstPlanMapping pl
											WHERE ClientKey = 12
											AND  TargetSystem = 'CS_AHS'
											AND ACTIVE = 'Y') pln
					ON		adi.plan_name = pln.SourceValue
					WHERE	adi.DataDate = @DataDate
					AND		pln.SourceValue IS NULL
					
	-----1st Membership Validation
					-- DECLARE @LoadDate DATE = '2021-07-07'
					SELECT DISTINCT NPI,AttribTIN,* FROM (
					  SELECT REPLACE(adiData.memberid,'*', '')  AS ClientSubscriberId /* clean the input, if astrick in source, remove */
					   , client.clientKey AS ClientKey, 			   
			           adiData.lastname, adiData.firstname, adiData.middlename, adiData.ssn, 				   
			           adiData.gender, adiData.DOB, adiData.medicareid, adiData.LanguageDesc, 				   
			           pr.NPI, pr.AttribTIN, adiData.effectivedate ClientEffectiveDate, adiData.groupid, 		   
			           adiData.plan_name, 														   
			           adiData.SrcFileName, 														   
			           'tmp_CignaMAMembership' AS AdiTableName, 										   
			           adiData.MbrKey AS adiKey, 													   
			           'Loaded' AS RowStatus, 														   
			          @DataDate AS LoadDate, 														   
			           adiData.DataDate, 															   
			           adiData.dualeligibility,													   
			           ROW_NUMBER() OVER(PARTITION BY adiData.MEMBERID ORDER BY adiData.dataDate DESC) aRowNumber  				    
				    FROM Acdw_clms_Cigna_Ma.[adi].[tmp_CignaMAMembership] AS adiData						   
				         JOIN lst.list_client Client ON client.ClientShortName = 'Cigna_MA'					   
				         LEFT JOIN (																   
				        	  SELECT * FROM #Prr									   
				        	  ) PR																	   
				        	  ON adiData.NPID = PR.NPI									   
				        		 --AND @LoadDate BETWEEN Pr.EffectiveDate AND pr.ExpirationDate					   
				    WHERE adiData.DataDate = @DataDate
					AND	  adiData.MbrLoadStatus = 0
					--AND pr.RwCnt = 1											   
			 ) src																			   
			LEFT JOIN lst.lstPlanMapping tPlan 
			 ON src.plan_name = tPlan.SourceValue
			 WHERE TargetSystem = 'ACDW'
		  AND src.aRowNumber = 1
		  AND NPI IS NOT NULL
		  ORDER BY ClientSubscriberId
		---2nd Membership Validation
		-- DECLARE @DataDate DATE = '2021-07-07'
		SELECT	*
		FROM	(
			 SELECT			m.NPID,pr.NPI,AttribTIN
							,REPLACE(m.memberid,'*','') Memberid
							,SourceValue,m.plan_name
							,ROW_NUMBER()OVER(PARTITION BY NPI,REPLACE(m.memberid,'*','') ORDER BY DataDate ) RwCnt
			 FROM			Acdw_clms_Cigna_Ma.[adi].[tmp_CignaMAMembership] m
			 LEFT	JOIN	adw.tvf_AllClient_ProviderRoster(12,@DataDate,1) pr
			 ON				m.NPID = pr.NPI
			 LEFT JOIN		(SELECT * 
								FROM lst.lstPlanMapping pl
								WHERE ClientKey = 12
								AND  TargetSystem = 'CS_AHS'
								AND ACTIVE = 'Y')	pln
			ON				m.plan_name = pln.SourceValue
			WHERE			m.DataDate = @DataDate
			--ORDER BY		m.memberid
			)src
			WHERE RwCnt = 1
			AND	NPI IS NOT NULL
			AND plan_name IS NOT NULL

-----
--------Validating in staging
					SELECT stgRowStatus,prvNPI,prvTIN
							,MstrMrnKey,LoadDate,* 
					FROM ast.MbrStg2_MbrData 
					WHERE ClientKey = 12
					AND LoadDate = '2021-07-07'
					AND stgRowStatus = 'VALID'
		
					SELECT stgRowStatus,prvNPI,prvTIN,* 
					FROM ast.MbrStg2_MbrData 
					WHERE ClientKey = 12
					AND LoadDate = '2021-07-07'
					AND stgRowStatus = 'Not VALID'

					SELECT	* 
					FROM		ast.MbrStg2_PhoneAddEmail 
					WHERE		ClientKey = 12 
					AND		LoadDate = '2021-07-07'
					AND		stgRowStatus = 'Valid'
	
		  SELECT * FROM [ACDW_CLMS_CIGNA_MA].[adi].[tmp_CignaMAMembership] WHERE DataDate = '2021-05-03'
		  --Membership Validation
		  --1
		  ---SELECT COUNT(*), MstrMrnKey from(
		  SELECT prvNPI,prvTIN,plnProductSubPlanName
				 ,plnProductPlan,plnProductSubPlan
				 ,MstrMrnKey --,* 
		  FROM	 ast.MbrStg2_MbrData 
		  WHERE	 ClientKey = 12 AND LoadDate = '2021-05-03'
		  AND    prvNPI IS NOT NULL
		  AND    plnProductSubPlanName IS NOT NULL
		  --)a
		  --GROUP BY MstrMrnKey
		  --HAVING COUNT(*)>1

		  

		  --2
		  ---Update invalid Mbrs records BEGIN TRAN COMMIT
		  
		  SELECT prvNPI,prvTIN,plnProductSubPlanName
				 ,plnProductPlan,plnProductSubPlan
				 ,MstrMrnKey ,stgRowStatus,AdiKey,* 
		  FROM	 ast.MbrStg2_MbrData 
		  WHERE	 ClientKey = 12 AND LoadDate = '2021-05-03'  ---495
		  AND    (prvNPI IS  NULL
		  OR    plnProductSubPlanName IS  NULL) ---Not Null = 487

		  --Update Not Valid Records
		  UPDATE ast.MbrStg2_MbrData 
		  SET	stgRowStatus = 'Not Valid'
		  WHERE	 ClientKey = 12 AND LoadDate = '2021-05-03'  ---495
		  AND    (prvNPI IS  NULL
		  OR    plnProductSubPlanName IS  NULL) ---Not Null = 487

		  --Update Invalid Members Address, Email and Phones
		  SELECT * FROM ast.MbrStg2_PhoneAddEmail WHERE ClientKey = 12 AND LoadDate = '2021-05-03'

		  SELECT		em.AdiKey,mbr.AdiKey,em.stgRowStatus,mbr.stgRowStatus
		  FROM			ast.MbrStg2_PhoneAddEmail em
		  JOIN			ast.MbrStg2_MbrData mbr
		  ON			em.AdiKey = mbr.AdiKey
		  WHERE			mbr.LoadDate = '2021-05-03'
		  AND			mbr.stgRowStatus = 'Not Valid'

		  --update records
		  --begin tran commit
		  --UPDATE		ast.MbrStg2_PhoneAddEmail
		  --SET			stgRowStatus = mbr.stgRowStatus
		  ---- SELECT		em.AdiKey,mbr.AdiKey,em.stgRowStatus,mbr.stgRowStatus
		  --FROM			ast.MbrStg2_PhoneAddEmail em
		  --JOIN			ast.MbrStg2_MbrData mbr
		  --ON			em.AdiKey = mbr.AdiKey
		  --WHERE			mbr.LoadDate = '2021-05-03'
		  --AND			mbr.stgRowStatus = 'Not Valid'


		  ----CignaMA CareOpps
		  SELECT		COUNT(*)RecCnt, LoadDate,DataDate
						, a.CopLoadStatus
		  FROM			[ACDW_CLMS_CIGNA_MA].[adi].[CignaMA_ACECustomerSummary] a
		  GROUP BY		LoadDate,DataDate ,CopLoadStatus
		  ORDER BY		DataDate DESC

		  ---CignaMA Careopps
		  SELECT		DISTINCT a.Meas_Abbv
		  FROM			[ACDW_CLMS_CIGNA_MA].[adi].[CignaMA_ACECustomerSummary] a
		  WHERE			DataDate = '2021-04-06' --'2021-04-23'

		  ---Careopps Validation
		 SELECT		COUNT(*)RecCnt, QmCntCat,QmMsrId
		 FROM		ast.QM_ResultByMember_History a
		 WHERE		ClientKey = 12
		 AND		QMDATE = '2021-05-15'
		 GROUP BY	 QmCntCat,QmMsrId
		 ORDER BY	QmMsrId

		 SELECT		*
		 FROM		adw.QM_ResultByMember_History a
		 WHERE		QMDate = '2021-04-06'
		 AND		ClientKey = 12


		 SELECT * FROM lst.list_client 