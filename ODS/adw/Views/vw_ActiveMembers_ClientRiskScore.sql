






CREATE VIEW [adw].[vw_ActiveMembers_ClientRiskScore]

AS

		--mssp
		
		SELECT		a.ClientKey
					, a.ClientMemberKey
					, a.Ace_ID
					, a.PlanName
					, a.LOB
					, a.Contract
					, CONVERT(VARCHAR(50),a.ClientRiskScore ) ClientRiskScore
		FROM		ACDW_CLMS_SHCN_MSSP.adw.FctMembership a
		WHERE		a.LoadDate = 
									(SELECT MAX(f.LoadDate) 
										FROM ACDW_CLMS_SHCN_MSSP.adw.FctMembership  f
										WHERE Active = 1	)
--		UNION ALL --uhc
--
--		SELECT		DISTINCT 
--					t.clientKey
--					, t.ClientMemberKey
--					, t.MstrMrnKey
--					, ''										AS PlanName
--					, ''										AS LOB
--					, ''										AS Contract
--					, uhc.[IPRO_ADMIT_RISK_SCORE]				AS ClientRiskScore
--		FROM		adw.MbrMember t
--		JOIN		(		SELECT	DataDate,UHC_SUBSCRIBER_ID, [IPRO_ADMIT_RISK_SCORE]
--									,LINE_OF_BUSINESS,PLAN_CODE,PLAN_DESC
--							FROM	[ACECAREDW].[adi].[MbrUhcMemberSummary]
--							WHERE	DataDate = 
--											(
--												SELECT		MAX(DataDate) 
--												FROM		adw.MbrMember
--												WHERE		ClientKey = 1
--											)
--					) uhc
--		ON			t.ClientMemberKey = uhc.UHC_SUBSCRIBER_ID
		
									
		UNION ALL --AetnaCom
		SELECT		DISTINCT 
					t.clientKey
					, t.ClientMemberKey
					, t.MstrMrnKey
					, ''										AS PlanName
					, ''										AS LOB
					, ''										AS Contract
					, ac.Pulse_score_Point_in_time				AS ClientRiskScore
		FROM		adw.MbrMember t
		JOIN		(		SELECT	DataDate, EffectiveMonth
									,(SELECT CONVERT(VARCHAR(50), CONVERT(NUMERIC(20, 0), MEMBER_ID))) Member_ID --
									, Pulse_score_Point_in_time
									,LINE_OF_BUSINESS
							FROM	[ACECAREDW].[adi].[MbrAetCom] 
							WHERE	EffectiveMonth = 
									(SELECT MAX(EffectiveMonth)
									 FROM [ACECAREDW].[adi].[MbrAetCom]
									)
					) ac
		ON			t.ClientMemberKey = ac.Member_ID
		
		
		UNION ALL --AetnaMA
		SELECT		DISTINCT 
					t.clientKey
					, t.ClientMemberKey
					, t.MstrMrnKey
					, ''										AS PlanName
					, ''										AS LOB
					, ''										AS Contract
					, atm.Pulse_score_Point_in_time				AS ClientRiskScore
		FROM		adw.MbrMember t
		JOIN		(		SELECT	DataDate, EffectiveMonth
									,(SELECT CONVERT(VARCHAR(50), CONVERT(NUMERIC(20, 0), MEMBER_ID))) Member_ID --
									, Pulse_score_Point_in_time
									,LINE_OF_BUSINESS
							FROM	[ACECAREDW].[adi].[MbrAetMaTx] 
							WHERE	EffectiveMonth = 
									(SELECT MAX(EffectiveMonth)
									 FROM [ACECAREDW].[adi].[MbrAetMaTx]
									)
					) atm
		ON			t.ClientMemberKey = atm.Member_ID 	

		UNION ALL --CignaMA
		SELECT		DISTINCT 
					t.clientKey
					, t.ClientMemberKey
					, t.MstrMrnKey
					, ''										AS PlanName
					, ''										AS LOB
					, ''										AS Contract
					, cig.Risk_Score							AS ClientRiskScore
		FROM		adw.MbrMember t
		JOIN		(		SELECT	DataDate, EffectiveDate
									, MemberID --
									, Risk_Score
							FROM	[ACDW_CLMS_CIGNA_MA].[adi].[tmp_CignaMAMembership] 
							WHERE	EffectiveDate =  -----Not right, change max datadate and effectivedate
									(SELECT MAX(EffectiveDate)
									 FROM [ACDW_CLMS_CIGNA_MA].[adi].[tmp_CignaMAMembership] 
									)				
					) cig
		ON			t.ClientMemberKey = cig.MemberID 	


--		UNION ALL --Devoted
--		SELECT		DISTINCT 
--					t.clientKey
--					, t.ClientMemberKey
--					, t.MstrMrnKey
--					, ''										AS PlanName
--					, ''										AS LOB
--					, ''										AS Contract
--					, dev.PartARiskScore						AS ClientRiskScore 
--		FROM		adw.MbrMember t
--		JOIN		(		SELECT				DISTINCT a.Mbi,b.MBI_or_HICN, Devoted_Member_ID, b.DataDate
--												,PartARiskScore,PartBRiskScore
--												,ROW_NUMBER()OVER(PARTITION BY MBI ORDER BY a.DataDate DESC)RwCnt
--							FROM				ACDW_CLMS_DHTX.[adi].[DHTX_Capitation] a
--							JOIN				ACDW_CLMS_DHTX.[adi].[DHTX_MembershipEnrollment] b
--							ON					a.Mbi = b.MBI_or_HICN	  
--							WHERE				b.DataDate =
--															(	SELECT	 MAX(DataDate) 
--																FROM	 ACDW_CLMS_DHTX.[adi].[DHTX_MembershipEnrollment] 
--															)
--					) dev
--		ON			t.ClientMemberKey = dev.Devoted_Member_ID 	--where ClientMemberKey = 'D4US4Z'
--		WHERE		RwCnt = 1
		
--		UNION ALL--Wellcare
--		 SELECT		DISTINCT 
--					t.clientKey
--					, t.ClientMemberKey
--					, t.MstrMrnKey
--					, ''															AS PlanName
--					, ''															AS LOB
--					, ''															AS Contract
--					, CONVERT(VARCHAR(50),wel.AvgDocumentedScore )					AS ClientRiskScore  -- ClientRiskScore
--		FROM		adw.MbrMember t
--		JOIN		(		SELECT				DISTINCT LEFT(Member,CHARINDEX(' ',Member,1)) Member
--												,DataDate
--												,AvgDocumentedScore
--							FROM				[ACDW_CLMS_WLC].[adi].[Wellcare_MWOV]	  
--							WHERE				DataDate =
--															(	SELECT	 MAX(DataDate) 
--																FROM	 [ACDW_CLMS_WLC].[adi].[Wellcare_MWOV] 
--															)
--					) wel
--		ON			t.ClientMemberKey =  LEFT(Member,CHARINDEX(' ',Member,1)) 
--		;



