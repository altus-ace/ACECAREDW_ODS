
  /* Purpose: Get the Member month using the 
	   Load Month from adi (this is a  questionable but as good as it gets now starting point)
	   Returns member, client, plan info by member month

Modification: Brit
Date :2021/01/18
Purpose: Parameterize

 */
CREATE PROCEDURE [dbo].[GetMemberMonths]--     [dbo].[GetMemberMonths]20,'2021-01-01'
    @ClientKey INT, @LoadDate DATE OUTPUT
AS 
    /* create date refernce table */    
    DECLARE @clientKeyInternal int = @ClientKey
    CREATE TABLE #tDates (LoadDate DATE); -- drop table #tDates
    
    --SELECT * FROM #tDates
    /* load correct dates into reference table */ -- DECLARE @clientKeyInternal INT = 3
    IF @clientKeyInternal = 3
	   BEGIN
	   INSERT INTO #tDAtes (LoadDate)
	   SELECT LoadDate
	   FROM adi.MbrAetMaTx mbr    
	   WHERE loadDate > '01/01/2019'
	   GROUP BY LoadDate
	   ORDER BY mbr.LoadDate DESC
	   END
    ELSE IF @clientKeyInternal = 2
	   BEGIN
	   INSERT INTO #tDAtes (LoadDate)
	   SELECT LoadDate
	   FROM adi.MbrWlcMbrByPcp mbr    
	   WHERE loadDate > '01/01/2019'
	   GROUP BY LoadDate
	   ORDER BY mbr.LoadDate DESC
	   END
    Else if @clientKeyInternal = 9
	   BEGIN 
	   INSERT INTO #tDAtes (LoadDate)
	   SELECT LoadDate
	   FROM adi.MbrAetCom mbr    
	   WHERE loadDate > '01/01/2019'
	   GROUP BY LoadDate
	   ORDER BY mbr.LoadDate DESC	   
	   END; 
	Else if @clientKeyInternal = 11
	   BEGIN 
	   INSERT INTO #tDAtes (LoadDate)
	   SELECT		DataDate
	   FROM			(
	   SELECT		DataDate
	   FROM			[ACDW_CLMS_DHTX].[adi].[DHTX_MembershipEnrollment]
	   UNION	
	   SELECT		DataDate
	   FROM			[ACDW_CLMS_DHTX].[adi].[DHTX_EligibilityMonthly]   
					)mbr
	   GROUP		BY datadate
	   ORDER BY		mbr.DataDate DESC
	   END; 
	Else if @clientKeyInternal = 12
	   BEGIN 
	   INSERT INTO #tDAtes (LoadDate)
	   SELECT		DataDate
	   FROM			[ACDW_CLMS_CIGNA_MA].adi.tmp_CignaMAMembership mbr
	   GROUP		BY DataDate
	   ORDER BY		mbr.DataDate DESC	   
	   END; 
	Else if @clientKeyInternal = 16
	   BEGIN 
	   INSERT INTO #tDAtes (LoadDate)
	   SELECT		RwEffectiveDate
	   FROM			[ACDW_CLMS_SHCN_MSSP].adw.FctMembership mbr
	   GROUP		BY RwEffectiveDate
	   ORDER BY		mbr.RwEffectiveDate DESC	   
	   END; 
	Else if @clientKeyInternal = 20
	   BEGIN    
	   INSERT INTO #tDAtes (LoadDate)
	   SELECT		RwEffectiveDate 
	   FROM			[ACDW_CLMS_SHCN_BCBS].adw.FctMembership mbr
	   GROUP		BY RwEffectiveDate
	   ORDER BY		mbr.RwEffectiveDate asc	   
	   END; 
    /* Get result set */  -- DECLARE @clientKeyInternal INT = 3 DECLARE @DataDate DATE = '2020-04-17' SELECT * FROM #tDAtes ORDER BY ADATE
     SELECT Dates.LoadDate MbrMonth
	      , MbrMonths.ClientKey
	      , pln.ProductPlan AS LINE_OF_BUSINESS
	      , Mbr.ClientMemberKey AS Member_id
	      , pcp.NPI PCP_NPI
	      , pln.ProductPlan AS PLAN_ID
	      , pln.ProductPlan AS PLAN_CODE 
	      , pln.ProductSubPlan as SUBGRP_ID
	      , pln.ProductSubPlanName as SUBGRP_NAME
	      , pcp.TIN as PCP_PRACTICE_TIN 
	      , ProvRoster.GroupName AS PCP_PRACTICE_NAME
	      , demo.FirstName AS   MEMBER_FIRST_NAME 
	      , demo.LastName	AS  MEMBER_LAST_NAME 
	      , demo.GENDER
	      , DateDiff(YEAR, demo.DOB, Dates.LoadDate) AS AGE
	      , demo.DOB AS [DATE_OF_BIRTH] 
	      , HomeAdd.Address1 AS MEMBER_HOME_ADDRESS   
	      , HomeAdd.Address2 AS MEMBER_HOME_ADDRESS2  
	      , HomeAdd.CITY	   AS MEMBER_HOME_CITY	   
	      , HomeAdd.STATE	   AS MEMBER_HOME_STATE	   
	      , HomeAdd.ZIP	   AS MEMBER_HOME_ZIP	   
	      , HomePhone.PhoneNumber AS MEMBER_HOME_PHONE	   
	      , '' AS IPRO_ADMIT_RISK_SCORE 
	      , getdate() AS RunDate
	      , SYSTEM_USER RunBy
	   FROM #tDAtes Dates 
	      CROSS APPLY dbo.tvf_activeMembers_Keys(Dates.LoadDate, @clientKeyInternal) MbrMonths
	      JOIN adw.mbrMember Mbr ON MbrMonths.[mbrMemberKey] = Mbr.[mbrMemberKey]
	      JOIN adw.mbrPlan Pln ON mbrMonths.mbrPlanKey = Pln.MbrPlanKey
	      JOIN adw.mbrPcp Pcp ON mbrMonths.mbrPcpKey = pcp.mbrPcpKey
	      JOIN adw.mbrDemographic demo ON mbrMonths.MbrDemographicKey = demo.mbrDemographicKey
	      LEFT JOIN adw.MbrAddress HomeAdd ON mbrMonths.MbrAddressKey1 = HomeAdd.mbrAddressKey
	      LEFT JOIN adw.MbrPhone   HomePhone ON MbrMonths.MbrPhoneKeyType1 = HomePhone.mbrPhoneKey
		 LEFT JOIN (SELECT PR.GroupName, pr.Tin, pr.EffectiveDate, pr.ExpirationDate
			 FROM dbo.vw_AllClient_ProviderRoster PR
			 WHERE PR.CalcClientKey = @clientKeyInternal
				--and pr.providerType in ('PCP')
				--AND MMonths.MbrMonth between pr.EffectiveDate and pr.ExpirationDate
			 GROUP BY pr.TIN, pr.GroupName, pr.EffectiveDate, pr.ExpirationDate) ProvRoster 
			 ON pcp.Tin = ProvRoster.TIN
				AND Dates.LoadDate between ProvRoster.EffectiveDate and ProvRoster.ExpirationDate
	   WHERE dates.LoadDate in  (@LoadDate) --  (select max(aDate) from #tDAtes k) -- ('2020-11-17') --- 
	   AND	 mbr.ClientKey = @clientKeyInternal
	   --(select max(aDate) from #tDAtes k) /* To get the latest data load for clients: 2,3 and 9 respectively*/
    --ORDER BY Dates.aDAte Asc

	--Data for SHCN_MSSP - ClientKey (16)
	UNION							-- DECLARE @clientKeyInternal INT = 16 DECLARE @DataDate DATE = '2021-01-01' 
	  SELECT DISTINCT Dates.LoadDate				AS	MbrMonth
	      , src.ClientKey							AS	ClientKey
	      , src.PlanName							AS	LINE_OF_BUSINESS
	      , src.ClientMemberKey						AS	Member_id
	      , src.NPI									AS	PCP_NPI
	      , src.PlanName							AS	PLAN_ID
	      , src.PlanName							AS	PLAN_CODE 
	      , src.PlanName							AS	SUBGRP_ID
	      , src.PlanName							AS	SUBGRP_NAME
	      , src.PcpPracticeTIN						AS	PCP_PRACTICE_TIN 
		  , src.ProviderPracticeName				AS	PCP_PRACTICE_NAME
	      , src.FirstName							AS  MEMBER_FIRST_NAME 
	      , src.LastName							AS  MEMBER_LAST_NAME 
	      , src.GENDER								AS	Gender
	      , DateDiff(YEAR, src.DOB, Dates.LoadDate)	AS	AGE
	      , src.DOB									AS	[DATE_OF_BIRTH] 
	      , src.MemberHomeAddress					AS	MEMBER_HOME_ADDRESS   
	      , src.MemberHomeAddress					AS	MEMBER_HOME_ADDRESS2  
	      , src.MemberHomeCity						AS	MEMBER_HOME_CITY	   
	      , src.MemberHomeState						AS	MEMBER_HOME_STATE	   
	      , src.MemberHomeZip						AS	MEMBER_HOME_ZIP	   
	      , src.MemberPhone							AS	MEMBER_HOME_PHONE	   
	      , CONVERT(VARCHAR(50),src.AceRiskScore)	AS	IPRO_ADMIT_RISK_SCORE 
	      , getdate() AS RunDate
	      , SYSTEM_USER RunBy
	FROM	 #tDAtes Dates  
	JOIN	ACDW_CLMS_SHCN_MSSP.adw.FctMembership src
	ON		Dates.LoadDate = src.RwEffectiveDate  
	LEFT JOIN (SELECT PR.GroupName, pr.Tin, pr.EffectiveDate, pr.ExpirationDate
			 FROM dbo.vw_AllClient_ProviderRoster PR
			 WHERE PR.CalcClientKey = @clientKeyInternal
				--and pr.providerType in ('PCP')
				--AND MMonths.MbrMonth between pr.EffectiveDate and pr.ExpirationDate
			 GROUP BY pr.TIN, pr.GroupName, pr.EffectiveDate, pr.ExpirationDate) ProvRoster 
			 ON src.PcpPracticeTIN = ProvRoster.TIN
				AND Dates.LoadDate between ProvRoster.EffectiveDate and ProvRoster.ExpirationDate
	WHERE Dates.LoadDate in  (@LoadDate) 
	AND		ClientKey = @clientKeyInternal

	--Data for SHCN_BCBS - ClientKey (20)
	UNION							-- DECLARE @clientKeyInternal INT = 20 DECLARE @DataDate DATE = '2021-01-01' DECLARE @ClientKey INT = 20
	  SELECT DISTINCT Dates.LoadDate				AS	MbrMonth
	      , src.ClientKey							AS	ClientKey
	      , src.LOB									AS	LINE_OF_BUSINESS
	      , src.ClientMemberKey						AS	Member_id
	      , src.NPI									AS	PCP_NPI
	      , src.LOB									AS	PLAN_ID
	      , src.PlanName							AS	PLAN_CODE 
	      , src.PlanName							AS	SUBGRP_ID
	      , src.SubgrpName							AS	SUBGRP_NAME
	      , src.PcpPracticeTIN						AS	PCP_PRACTICE_TIN 
		  , src.ProviderPracticeName				AS	PCP_PRACTICE_NAME
	      , src.FirstName							AS  MEMBER_FIRST_NAME 
	      , src.LastName							AS  MEMBER_LAST_NAME 
	      , src.GENDER								AS	Gender
	      , DateDiff(YEAR, src.DOB, Dates.LoadDate)	AS	AGE
	      , src.DOB									AS	[DATE_OF_BIRTH] 
	      , src.MemberHomeAddress					AS	MEMBER_HOME_ADDRESS   
	      , src.MemberHomeAddress					AS	MEMBER_HOME_ADDRESS2  
	      , src.MemberHomeCity						AS	MEMBER_HOME_CITY	   
	      , src.MemberHomeState						AS	MEMBER_HOME_STATE	   
	      , src.MemberHomeZip						AS	MEMBER_HOME_ZIP	   
	      , src.MemberPhone							AS	MEMBER_HOME_PHONE	   
	      , CONVERT(VARCHAR(50),src.AceRiskScore)	AS	IPRO_ADMIT_RISK_SCORE 
	      , getdate() AS RunDate
	      , SYSTEM_USER RunBy
	FROM	 #tDAtes Dates  
	JOIN	ACDW_CLMS_SHCN_BCBS.adw.FctMembership src
	ON		Dates.LoadDate = src.RwEffectiveDate 
	LEFT JOIN (SELECT PR.GroupName, pr.Tin, pr.EffectiveDate, pr.ExpirationDate
			 FROM dbo.vw_AllClient_ProviderRoster PR
			 WHERE PR.CalcClientKey = @clientKeyInternal
				--and pr.providerType in ('PCP')
				--AND MMonths.MbrMonth between pr.EffectiveDate and pr.ExpirationDate
			 GROUP BY pr.TIN, pr.GroupName, pr.EffectiveDate, pr.ExpirationDate) ProvRoster 
			 ON src.PcpPracticeTIN = ProvRoster.TIN
				AND Dates.LoadDate between ProvRoster.EffectiveDate and ProvRoster.ExpirationDate
	WHERE Dates.LoadDate in  (@LoadDate) 
	AND	 ClientKey = @clientKeyInternal

	  DROP TABLE #tDAtes 


	 
	  