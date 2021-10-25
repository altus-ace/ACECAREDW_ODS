CREATE FUNCTION [dbo].[tvf_Activemembers](@EffectiveDate DATE) 
RETURNS TABLE
    /* Purpose: gets all members active for all clients for a specific day.-
	   Incudes the keys of the Rows used to create the set. 
	   version history: 
	   02/02/2021: gk add code to remove uHC from member model from results. Handled in other view: vw_uhc_activeMembers, unioned into stream in dbo.Vw_ActiveMembers
	   Brit: 2021-02-03: Added code to eliminate duplicates as a result of multiple TINs
	   */
AS
    RETURN
(   --declare @EffectiveDate date = getdate();
SELECT		*
FROM		(SELECT DISTINCT 
           M.[mbrMemberKey]									  
		 , MbrDemo.mbrDemographicKey
		 , MbrPlan.mbrPlanKey
		 , MbrPcp.mbrPcpKey
		 , mbrCsPlan.mbrCsPlanKey
		 ,MbrPhone1.mbrPhoneKey MbrPhoneKeyType1
		 , MbrPhone2.mbrPhoneKey MbrPhoneKeyType4
		 , MbrPhone3.mbrPhoneKey MbrPHoneKeyType3
		 ,MbrAddress1.mbrAddressKey AS MbrAddressKey1
		 , MbrAddress2.mbrAddressKey AS MbrAddressKey2, 
           lc.ClientShortName	  AS CLIENT,
		 lc.ClientKey		  AS ClientKey,
           M.[ClientMemberKey]  AS MEMBER_ID,
		 m.MstrMrnKey		  AS Ace_ID,
           MbrDemo.[FirstName] AS [MEMBER_FIRST_NAME],
           MbrDemo.[MiddleName] AS [MEMBER_MI],
           MbrDemo.[LastName] AS [MEMBER_LAST_NAME],
           M.[ClientMemberKey] AS [CLIENT_SUBSCRIBER_ID],
           MbrPlan.ProductPlan AS [PLAN_ID],
           MbrPlan.ProductPlan AS [PRODUCT_CODE],
           MbrPlan.ProductSubPlan AS [SUBGRP_ID],
           MbrPlan.ProductSubPlanName AS [SUBGRP_NAME],
           MbrDemo.[MedicaidID] AS [MEDICAID_ID],
           DATEDIFF(MONTH, MbrDemo.DOB, GETDATE()) / 12 AS AGE,
           MbrDemo.[DOB] AS [DATE_OF_BIRTH],
           MbrDemo.[Gender] AS GENDER,
           [PrimaryLanguage] AS [LANG_CODE],
           MbrDemo.[Ethnicity] AS ETHNICITY,
           MbrDemo.[Race] AS RACE,
           MbrAddress1.Address1 AS [MEMBER_HOME_ADDRESS],
           MbrAddress1.Address2 AS [MEMBER_HOME_ADDRESS2],
           MbrAddress1.City AS [MEMBER_HOME_CITY],
           MbrAddress1.State AS [MEMBER_HOME_STATE],
           MbrAddress1.zip AS [MEMBER_HOME_ZIP_C],
           MbrPhone1.PhoneNumber AS [MEMBER_HOME_PHONE],
           MbrAddress2.Address1 [MEMBER_MAIL_ADDRESS],
           MbrAddress2.Address2 AS [MEMBER_MAIL_ADDRESS2],
           MbrAddress2.City AS [MEMBER_MAIL_CITY],
           MbrAddress2.State AS [MEMBER_MAIL_STATE],
           MbrAddress2.Zip AS [MEMBER_MAIL_ZIP_C],
           MbrPhone2.PhoneNumber AS [MEMBER_MAIL_PHONE],
           MbrAddress1.County AS [MEMBER_COUNTY],
           MbrPhone3.PhoneNumber AS [MEMBER_BUS_PHONE],
           ' ' AS [MEMBER_ORG_EFF_DATE],
           ' ' [MEMBER_CONT_EFF_DATE],
           MbrDemo.[EffectiveDate] AS [MEMBER_CUR_EFF_DATE],
           MbrDemo.[ExpirationDate] AS [MEMBER_CUR_TERM_DATE],
           MbrPcp.NPI AS [PCP_CLIENT_ID],
		 PR.AccountType AS PCP_AccountType,
           PR.FirstName [PCP_FIRST_NAME],
           PR.LastName [PCP_LAST_NAME],
           MbrPcp.NPI,
           pa.PrimaryAddressPhoneNumber AS [PCP_PHONE],
           '' AS [PCP_FAX],
           pa.PrimaryAddress AS [PCP_ADDRESS],
           '' AS [PCP_ADDRESS2],
           pa.PrimaryCity AS [PCP_CITY],
           pa.PrimaryState AS [PCP_STATE],
           pa.PrimaryZipcode AS [PCP_ZIP_C],
           MbrPcp.EffectiveDate AS [PCP_EFFECTIVE_DATE],
           MbrPcp.ExpirationDate AS [PCP_TERM_DATE],
           MbrPcp.tin AS [PCP_PRACTICE_TIN],		 
           '' AS [PCP_GROUP_ID],
           pr.GroupName AS [PCP_PRACTICE_NAME],
           MbrPcp.[AutoAssigned] AS [AUTO_ASSIGN],
           '' AS [MEMBER_STATUS],
           '' AS [MEMBER_TERM_DATE],
           '' as ClientRiskScore, -- rs.ClientRiskScore,
           '' AS [RISK_CATEGORY_C],
           lc.LobName AS [LINE_OF_BUSINESS],
           MbrPlan.ProductPlan AS [PLAN_CODE],
           MbrPlan.ProductSubPlanName AS [PLAN_DESC],
           '' AS [PRIMARY_RISK_FACTOR],
           '' AS [TOTAL_COSTS_LAST_12_MOS],
           '' AS [COUNT_OPEN_CARE_OPPS],
           '' AS [INP_COSTS_LAST_12_MOS],
           '' AS [ER_COSTS_LAST_12_MOS],
           '' AS [OUTP_COSTS_LAST_12_MOS],
           '' AS [PHARMACY_COSTS_LAST_12_MOS],
           '' AS [PRIMARY_CARE_COSTS_LAST_12_MOS],
           '' AS [BEHAVIORAL_COSTS_LAST_12_MOS],
           '' AS [OTHER_OFFICE_COSTS_LAST_12_MOS],
           '' AS [INP_ADMITS_LAST_12_MOS],
           '' AS [LAST_INP_DISCHARGE],
           '' AS [POST_DISCHARGE_FUP_VISIT],
           '' AS [INP_FUP_WITHIN_7_DAYS],
           NULL AS [ER_VISITS_LAST_12_MOS],
           '' AS [LAST_ER_VISIT],
           '' AS [POST_ER_FUP_VISIT],
           '' AS [ER_FUP_WITHIN_7_DAYS],
           '' AS [LAST_PCP_VISIT],
           '' AS [LAST_PCP_PRACTICE_SEEN],
           '' AS [LAST_BH_VISIT],
           '' AS [LAST_BH_PRACTICE_SEEN],
           '' AS [MEMBER_MONTH_COUNT],
           zp.Pod [MEMBER_POD_C],
           zp.Quadrant AS [MEMBER_POD_DESC],
           Pa.PrimaryPOD AS [PCP_POD_C],
           Pa.PrimaryQuadrant AS [PCP_POD_DESC],
           PR.FirstName+' '+PR.LastName AS [PCP_NAME],
           '' AS [CLIENT_UNIQUE_SYSTEM_ID],
           MbrDemo.medicareid AS [MEDICARE_ID],
           '' AS [RESP_LAST_NAME],
           '' AS [RESP_FIRST_NAME],
           '' AS [RESP_ADDRESS],
           '' AS [RESP_ADDRESS2],
           '' AS [RESP_CITY],
           '' AS [RESP_STATE],
           '' AS [RESP_ZIP],
           '' AS [RESP_PHONE],		   
           DATEDIFF(mm, CONVERT(DATE, MbrDemo.[DOB], 101), GETDATE()) AS CurMonthsOld,
           DATEDIFF(yy, CONVERT(DATE, MbrDemo.[DOB], 101), GETDATE()) AS CurYearsOld  
		 , mbrCsPlan.MbrCsSubPlan	    AhsPlanCode
		 , MbrCsPlan.MbrCsSubPlanName	    AhsPlanName
		 , m.LoadDate
		 , ROW_NUMBER() OVER(PARTITION BY m.ClientMemberKey, MbrPcp.NPI, GroupName ORDER BY m.LoadDate DESC)RwCnt -- Brit: To eliminate TIN duplicates 
    FROM [adw].[MbrMember] m    
         INNER JOIN [lst].[List_Client] lc ON lc.Clientkey = m.clientkey	
         INNER JOIN [adw].[MbrDemographic] MbrDemo ON MbrDemo.[mbrMemberKey] = m.[mbrMemberKey]
            AND @EffectiveDate BETWEEN MbrDemo.EffectiveDate AND MbrDemo.ExpirationDate    
         JOIN [adw].[MbrPlan] MbrPlan ON MbrPlan.mbrMemberKey = m.mbrMemberKey
            AND @EffectiveDate BETWEEN MbrPlan.EffectiveDate AND MbrPlan.ExpirationDate
	    JOIN [adw].[mbrCsPlanHistory] MbrCsPlan ON MbrCsPlan.mbrMemberKey = m.mbrMemberKey
		  AND @EffectiveDate BETWEEN MbrCsPlan.EffectiveDate AND MbrCsPlan.ExpirationDate
         LEFT JOIN (SELECT MbrMemberKey, EffectiveDate, ExpirationDate, AddressTypeKey, MbrAddressKey,
					   Address1, Address2, city, STATE, 
					   case when try_convert(int,RIGHT(address1,5)) IS null then ZIP 
						  else RIGHT(address1,5)  end  ZIP,COUNTY, TRY_CONVERT(int, Zip) AS zipCodeJoin
				FROM [adw].[MbrAddress]) AS MbrAddress1 ON MbrAddress1.MbrMemberKey = m.mbrMemberKey
		  AND MbrAddress1.AddressTypeKey = 1
		  AND @EffectiveDate BETWEEN MbrAddress1.EffectiveDate AND MbrAddress1.ExpirationDate
         LEFT JOIN lst.[lstAddressType] lstAddressType1 ON lstAddressType1.[lstAddressTypeKey] = MbrAddress1.[AddressTypeKey]
            AND lstAddressType1.lstAddressTypeKey = 1
         LEFT JOIN [adw].[MbrAddress] MbrAddress2 ON MbrAddress2.MbrMemberKey = m.mbrMemberKey
            AND MbrAddress2.AddressTypeKey = 2
            AND @EffectiveDate BETWEEN MbrAddress2.EffectiveDate AND MbrAddress2.ExpirationDate
         LEFT JOIN lst.[lstAddressType] lstAddressType2 ON lstAddressType2.[lstAddressTypeKey] = MbrAddress2.[AddressTypeKey]
            AND lstAddressType2.lstAddressTypeKey = 2
         LEFT JOIN(SELECT [mbrPhoneKey], [mbrMemberKey], [mbrLoadKey], [EffectiveDate], [ExpirationDate], [PhoneType], [PhoneNumber], rank
				FROM (SELECT p.[mbrPhoneKey], p.[mbrMemberKey], p.[mbrLoadKey], p.[EffectiveDate],p.[ExpirationDate], p.[PhoneType], p.[PhoneNumber]
					   , ROW_NUMBER() OVER(PARTITION BY p.[mbrMemberKey]/* force single phNUm ,p.[PhoneNumber]*/ ORDER BY p.[ExpirationDate] DESC) AS rank
					   FROM [adw].[MbrPhone] p
					   WHERE p.PhoneType = 1
					  ) AS c
				WHERE c.rank = 1
				) AS MbrPhone1 ON MbrPhone1.MbrMemberKey = m.MbrMemberKey
				    AND @EffectiveDate BETWEEN MbrPhone1.EffectiveDate AND MbrPhone1.ExpirationDate
	   LEFT JOIN lst.lstPhoneType lpt ON lpt.lstPhonetypeKey = MbrPhone1.phoneType
		  AND lpt.lstPhoneTYpekey = 1
        LEFT JOIN ( SELECT [mbrPhoneKey], [mbrMemberKey],[mbrLoadKey],[EffectiveDate], [ExpirationDate],[PhoneType],[PhoneNumber], [rank]
				    FROM (SELECT p.[mbrPhoneKey], p.[mbrMemberKey], p.[mbrLoadKey], p.[EffectiveDate],p.[ExpirationDate], p.[PhoneType], p.[PhoneNumber]
					   , ROW_NUMBER() OVER(PARTITION BY p.[mbrMemberKey]/* force single phNUm ,p.[PhoneNumber]*/ ORDER BY p.[ExpirationDate] DESC) AS rank
					   FROM [adw].[MbrPhone] p
					   WHERE p.PhoneType = 4
						  ) AS c1
				    WHERE c1.rank = 1) MbrPhone2 ON MbrPhone2.MbrMemberKey = m.MbrMemberKey
					   AND @EffectiveDate BETWEEN MbrPhone2.EffectiveDate AND MbrPhone2.ExpirationDate
	   LEFT JOIN lst.lstPhoneType lpt2 ON lpt2.lstPhonetypeKey = MbrPhone2.phoneType
            AND lpt2.lstPhoneTYpekey = 4
        LEFT JOIN(SELECT [mbrPhoneKey], [mbrMemberKey],[mbrLoadKey],[EffectiveDate],[ExpirationDate],[PhoneType],[PhoneNumber]
				FROM(SELECT p.[mbrPhoneKey], p.[mbrMemberKey], p.[mbrLoadKey], p.[EffectiveDate],p.[ExpirationDate], p.[PhoneType], p.[PhoneNumber]
					   , ROW_NUMBER() OVER(PARTITION BY p.[mbrMemberKey]/* force single phNUm ,p.[PhoneNumber]*/ ORDER BY p.[ExpirationDate] DESC) AS rank
					   FROM [adw].[MbrPhone] p
					   WHERE p.PhoneType = 3
					   ) AS c3
				WHERE c3.rank = 1) MbrPhone3 ON MbrPhone3.MbrMemberKey = m.MbrMemberKey
				    AND @EffectiveDate BETWEEN MbrPhone3.EffectiveDate AND MbrPhone3.ExpirationDate
	   LEFT JOIN lst.lstPhoneType lpt3 
		  ON lpt3.lstPhonetypeKey = MbrPhone3.phoneType AND lpt3.lstPhoneTYpekey = 3											 
	   JOIN [adw].[MbrPcp] MbrPcp ON MbrPcp.mbrMemberKey = m.mbrMemberKey
		  AND @EffectiveDate BETWEEN MbrPcp.EffectiveDate AND MbrPcp.ExpirationDate    
	   LEFT JOIN( SELECT pr.npi, pr.LastName, PR.FirstName, pr.AttribTIN TIN, pr.ProviderSpecialty
				, pr.ProviderSubSpecialty, pr.AttribTINName AS GroupName
				--, pa.PrimaryAddress, pa.PrimaryCity, pa.PrimaryState, pa.PrimaryZipcode, pa.PrimaryPOD, pa.PrimaryQuadrant, pa.PrimaryAddressPhoneNumber				
				, pr.ClientKey, pr.AccountType, '' NetworkContact
				FROM adw.tvf_AllClient_ProviderRoster(0, @effectiveDate, 1) pr
				   ) AS PR 
				    ON  PR.NPI =  MbrPcp.NPI
					AND PR.TIN = MbrPcp.tin
					AND pr.ClientKey= m.CLientKey
		LEFT JOIN  adw.FctProviderPracticePrimaryAddress pa
					   ON pr.TIN = pa.TIN 
					   and PR.GroupName = pa.TIN_NAME
        left JOIN (SELECT CONVERT(INT, zp.ZipCode) ZipCode, zp.Quadrant, zp.Pod FROM [dbo].[LIST_ZIPCODES] zp) zp ON zp.zipcode = MbrAddress1.zipCodeJoin
	where m.ClientKey <> 1
	)s
		 WHERE  RwCnt = 1

 UNION   
 ---MSSP
 --declare @EffectiveDate date = '12/15/2020'
 	SELECT		*
	FROM		(
					SELECT		DISTINCT 
								0 AS [mbrMemberKey], 
								0 AS mbrDemographicKey, 
								0 AS mbrPlanKey,
								0 AS mbrPcpKey,
								0 AS mbrCsPlanKey,
								0 AS MbrPhoneKeyType1,
								0 AS MbrPhoneKeyType4, 
								0 AS MbrPHoneKeyType3,
								0 AS MbrAddressKey1, 
								0 AS MbrAddressKey2, 
								client.ClientShortName  AS CLIENT,
								c.ClientKey		  AS ClientKey,
								c.ClientMemberKey  AS MEMBER_ID,
								Ace_ID	  AS Ace_ID,
								c.FirstName AS [MEMBER_FIRST_NAME],
								c.MiddleName AS [MEMBER_MI],
								c.LastName AS [MEMBER_LAST_NAME],
								c.[ClientMemberKey] AS [CLIENT_SUBSCRIBER_ID],
								c.PlanName AS [PLAN_ID],
								c.PlanName AS [PRODUCT_CODE],
								c.SubgrpID AS [SUBGRP_ID],
								c.SubgrpName [SUBGRP_NAME],
								c.MedicaidID AS [MEDICAID_ID],
								c.CurrentAge AS AGE,
								c.DOB AS [DATE_OF_BIRTH],
								c.Gender AS GENDER,
								c.LanguageCode AS [LANG_CODE],
								c.Ethnicity AS ETHNICITY,
								c.Race AS RACE,
								c.MemberHomeAddress AS [MEMBER_HOME_ADDRESS],
								c.MemberHomeAddress1 AS [MEMBER_HOME_ADDRESS2],
								c.MemberHomeCity AS [MEMBER_HOME_CITY],
								c.MemberHomeState AS [MEMBER_HOME_STATE],
								c.MemberHomeZip AS [MEMBER_HOME_ZIP_C],
								c.MemberHomePhone AS [MEMBER_HOME_PHONE],
								c.MemberMailingAddress [MEMBER_MAIL_ADDRESS],
								c.MemberMailingAddress1 AS [MEMBER_MAIL_ADDRESS2],
								c.MemberMailingCity AS [MEMBER_MAIL_CITY],
								c.MemberMailingState AS [MEMBER_MAIL_STATE],
								c.MemberMailingZip AS [MEMBER_MAIL_ZIP_C],
								c.MemberCellPhone AS [MEMBER_MAIL_PHONE],
								c.CountyName AS [MEMBER_COUNTY],
								'' AS [MEMBER_BUS_PHONE],
								' ' AS [MEMBER_ORG_EFF_DATE],
								' ' AS [MEMBER_CONT_EFF_DATE],
								c.RwEffectiveDate AS [MEMBER_CUR_EFF_DATE],
								'' AS [MEMBER_CUR_TERM_DATE],
								'' AS [PCP_CLIENT_ID],
								pr.AccountType AS PCP_AccountType,
								c.ProviderFirstName AS [PCP_FIRST_NAME],
								c.ProviderLastName AS [PCP_LAST_NAME],
								c.NPI AS NPI,
								c.ProviderPhone AS [PCP_PHONE],
								'' AS [PCP_FAX],
								c.ProviderAddressLine1 AS [PCP_ADDRESS],
								c.ProviderAddressLine2 AS [PCP_ADDRESS2],
								c.ProviderCity AS [PCP_CITY],
								'' AS [PCP_STATE],
								c.ProviderZip AS [PCP_ZIP_C],
								'' AS [PCP_EFFECTIVE_DATE],
								'' AS [PCP_TERM_DATE],
								c.PcpPracticeTIN AS [PCP_PRACTICE_TIN],		 
								'' AS [PCP_GROUP_ID],
								--c.ProviderPracticeName  AS [PCP_PRACTICE_NAME], 
								pr.AttribTinName AS [PCP_PRACTICE_NAME], -- changed to fix permian Tin Issue, after fix fact data, remove this
								'' AS [AUTO_ASSIGN],
								'' AS [MEMBER_STATUS],
								'' AS [MEMBER_TERM_DATE],
								CONVERT(VARCHAR(50),c.ClientRiskScore ) ClientRiskScore,
								'' AS [RISK_CATEGORY_C],
								c.LOB AS [LINE_OF_BUSINESS],
								c.PlanName AS [PLAN_CODE],
								c.Contract AS [PLAN_DESC],
								'' AS [PRIMARY_RISK_FACTOR],
								'' AS [TOTAL_COSTS_LAST_12_MOS],
								'' AS [COUNT_OPEN_CARE_OPPS],
								'' AS [INP_COSTS_LAST_12_MOS],
								'' AS [ER_COSTS_LAST_12_MOS],
								'' AS [OUTP_COSTS_LAST_12_MOS],
								'' AS [PHARMACY_COSTS_LAST_12_MOS],
								'' AS [PRIMARY_CARE_COSTS_LAST_12_MOS],
								'' AS [BEHAVIORAL_COSTS_LAST_12_MOS],
								'' AS [OTHER_OFFICE_COSTS_LAST_12_MOS],
								'' AS [INP_ADMITS_LAST_12_MOS],
								'' AS [LAST_INP_DISCHARGE],
								'' AS [POST_DISCHARGE_FUP_VISIT],
								'' AS [INP_FUP_WITHIN_7_DAYS],
								NULL AS [ER_VISITS_LAST_12_MOS],
								'' AS [LAST_ER_VISIT],
								'' AS [POST_ER_FUP_VISIT],
								'' AS [ER_FUP_WITHIN_7_DAYS],
								'' AS [LAST_PCP_VISIT],
								'' AS [LAST_PCP_PRACTICE_SEEN],
								'' AS [LAST_BH_VISIT],
								'' AS [LAST_BH_PRACTICE_SEEN],
								'' AS [MEMBER_MONTH_COUNT],
								'' AS [MEMBER_POD_C],
								c.ProviderPOD AS [MEMBER_POD_DESC],
								'' AS [PCP_POD_C],
								'' AS [PCP_POD_DESC],
								c.ProviderFirstName + ' ' + c.ProviderLastName AS [PCP_NAME],
								'' AS [CLIENT_UNIQUE_SYSTEM_ID],
								c.ClientMemberKey AS [MEDICARE_ID],
								'' AS [RESP_LAST_NAME],
								'' AS [RESP_FIRST_NAME],
								'' AS [RESP_ADDRESS],
								'' AS [RESP_ADDRESS2],
								'' AS [RESP_CITY],
								'' AS [RESP_STATE],
								'' AS [RESP_ZIP],
								'' AS [RESP_PHONE],
								'' AS CurMonthsOld,
								c.CurrentAge AS CurYearsOld,  
		 						c.PlanID AS AhsPlanCode,
		 						c.PlanName AS AhsPlanName
								,c.LoadDate
								,ROW_NUMBER() OVER(PARTITION BY ClientMemberKey, c.NPI, ProviderPracticeName ORDER BY c.LoadDate DESC)RwCnt -- Brit: To eliminate TIN duplicates
					FROM		ACDW_CLMS_SHCN_MSSP.adw.FctMembership c
					JOIN lst.List_Client Client ON c.ClientKey = Client.ClientKey
					-- Added join to fix permian Tin Issue, after fix fact data, remove this
					LEFT JOIN adw.tvf_AllClient_ProviderRoster(16, @effectiveDate, 0) PR  -- Changed to Left Join to not remove TINS 
					   ON c.PcpPracticeTIN = pr.AttribTIN
				    and c.NPI = pr.NPI				    
					WHERE	c.Active = 1 
					AND (SELECT CASE WHEN (@effectiveDate > 
						( SELECT Max(c.RwExpirationDate)  FROM ACDW_CLMS_SHCN_MSSP.adw.FctMembership c)) 
						THEN (SELECT Max(c.RwExpirationDate)  FROM ACDW_CLMS_SHCN_MSSP.adw.FctMembership c)
						ELSE @EffectiveDate END as aDate)	BETWEEN c.RwEffectiveDate and c.RwExpirationDate
						--Brit -- To select latest active records
				)a
		 WHERE  RwCnt = 1

		 UNION
		 --BCBS
		 SELECT		*
	     FROM		(
					SELECT		DISTINCT 
								0 AS [mbrMemberKey], 
								0 AS mbrDemographicKey, 
								0 AS mbrPlanKey,
								0 AS mbrPcpKey,
								0 AS mbrCsPlanKey,
								0 AS MbrPhoneKeyType1,
								0 AS MbrPhoneKeyType4, 
								0 AS MbrPHoneKeyType3,
								0 AS MbrAddressKey1, 
								0 AS MbrAddressKey2, 
								Client.ClientShortName AS CLIENT,
								c.ClientKey		  AS ClientKey,
								c.ClientMemberKey  AS MEMBER_ID,
								Ace_ID	  AS Ace_ID,
								c.FirstName AS [MEMBER_FIRST_NAME],
								c.MiddleName AS [MEMBER_MI],
								c.LastName AS [MEMBER_LAST_NAME],
								c.[ClientMemberKey] AS [CLIENT_SUBSCRIBER_ID],
								c.PlanName AS [PLAN_ID],
								c.PlanName AS [PRODUCT_CODE],
								c.SubgrpID AS [SUBGRP_ID],
								c.SubgrpName [SUBGRP_NAME],
								c.MedicaidID AS [MEDICAID_ID],
								c.CurrentAge AS AGE,
								c.DOB AS [DATE_OF_BIRTH],
								c.Gender AS GENDER,
								c.LanguageCode AS [LANG_CODE],
								c.Ethnicity AS ETHNICITY,
								c.Race AS RACE,
								c.MemberHomeAddress AS [MEMBER_HOME_ADDRESS],
								c.MemberHomeAddress1 AS [MEMBER_HOME_ADDRESS2],
								c.MemberHomeCity AS [MEMBER_HOME_CITY],
								c.MemberHomeState AS [MEMBER_HOME_STATE],
								c.MemberHomeZip AS [MEMBER_HOME_ZIP_C],
								c.MemberHomePhone AS [MEMBER_HOME_PHONE],
								c.MemberMailingAddress [MEMBER_MAIL_ADDRESS],
								c.MemberMailingAddress1 AS [MEMBER_MAIL_ADDRESS2],
								c.MemberMailingCity AS [MEMBER_MAIL_CITY],
								c.MemberMailingState AS [MEMBER_MAIL_STATE],
								c.MemberMailingZip AS [MEMBER_MAIL_ZIP_C],
								c.MemberCellPhone AS [MEMBER_MAIL_PHONE],
								c.CountyName AS [MEMBER_COUNTY],
								'' AS [MEMBER_BUS_PHONE],
								' ' AS [MEMBER_ORG_EFF_DATE],
								' ' AS [MEMBER_CONT_EFF_DATE],
								c.RwEffectiveDate AS [MEMBER_CUR_EFF_DATE],
								'' AS [MEMBER_CUR_TERM_DATE],
								'' AS [PCP_CLIENT_ID],
								pr.AccountType AS PCP_AccountType,
								c.ProviderFirstName AS [PCP_FIRST_NAME],
								c.ProviderLastName AS [PCP_LAST_NAME],
								c.NPI AS NPI,
								c.ProviderPhone AS [PCP_PHONE],
								'' AS [PCP_FAX],
								c.ProviderAddressLine1 AS [PCP_ADDRESS],
								c.ProviderAddressLine2 AS [PCP_ADDRESS2],
								c.ProviderCity AS [PCP_CITY],
								'' AS [PCP_STATE],
								c.ProviderZip AS [PCP_ZIP_C],
								'' AS [PCP_EFFECTIVE_DATE],
								'' AS [PCP_TERM_DATE],
								c.PcpPracticeTIN AS [PCP_PRACTICE_TIN],		 
								'' AS [PCP_GROUP_ID],
								--c.ProviderPracticeName  AS [PCP_PRACTICE_NAME], 
								pr.AttribTinName AS [PCP_PRACTICE_NAME], -- changed to fix permian Tin Issue, after fix fact data, remove this
								'' AS [AUTO_ASSIGN],
								'' AS [MEMBER_STATUS],
								'' AS [MEMBER_TERM_DATE],
								CONVERT(VARCHAR(50),c.ClientRiskScore ) ClientRiskScore,
								'' AS [RISK_CATEGORY_C],
								c.LOB AS [LINE_OF_BUSINESS],
								c.PlanName AS [PLAN_CODE],
								c.Contract AS [PLAN_DESC],
								'' AS [PRIMARY_RISK_FACTOR],
								'' AS [TOTAL_COSTS_LAST_12_MOS],
								'' AS [COUNT_OPEN_CARE_OPPS],
								'' AS [INP_COSTS_LAST_12_MOS],
								'' AS [ER_COSTS_LAST_12_MOS],
								'' AS [OUTP_COSTS_LAST_12_MOS],
								'' AS [PHARMACY_COSTS_LAST_12_MOS],
								'' AS [PRIMARY_CARE_COSTS_LAST_12_MOS],
								'' AS [BEHAVIORAL_COSTS_LAST_12_MOS],
								'' AS [OTHER_OFFICE_COSTS_LAST_12_MOS],
								'' AS [INP_ADMITS_LAST_12_MOS],
								'' AS [LAST_INP_DISCHARGE],
								'' AS [POST_DISCHARGE_FUP_VISIT],
								'' AS [INP_FUP_WITHIN_7_DAYS],
								NULL AS [ER_VISITS_LAST_12_MOS],
								'' AS [LAST_ER_VISIT],
								'' AS [POST_ER_FUP_VISIT],
								'' AS [ER_FUP_WITHIN_7_DAYS],
								'' AS [LAST_PCP_VISIT],
								'' AS [LAST_PCP_PRACTICE_SEEN],
								'' AS [LAST_BH_VISIT],
								'' AS [LAST_BH_PRACTICE_SEEN],
								'' AS [MEMBER_MONTH_COUNT],
								'' AS [MEMBER_POD_C],
								c.ProviderPOD AS [MEMBER_POD_DESC],
								'' AS [PCP_POD_C],
								'' AS [PCP_POD_DESC],
								c.ProviderFirstName + ' ' + c.ProviderLastName AS [PCP_NAME],
								'' AS [CLIENT_UNIQUE_SYSTEM_ID],
								c.ClientMemberKey AS [MEDICARE_ID],
								'' AS [RESP_LAST_NAME],
								'' AS [RESP_FIRST_NAME],
								'' AS [RESP_ADDRESS],
								'' AS [RESP_ADDRESS2],
								'' AS [RESP_CITY],
								'' AS [RESP_STATE],
								'' AS [RESP_ZIP],
								'' AS [RESP_PHONE],
								'' AS CurMonthsOld,
								c.CurrentAge AS CurYearsOld,  
		 						c.PlanID AS AhsPlanCode,
		 						c.PlanName AS AhsPlanName
								,c.LoadDate
								,ROW_NUMBER() OVER(PARTITION BY ClientMemberKey, c.NPI, ProviderPracticeName ORDER BY c.LoadDate DESC)RwCnt -- Brit: To eliminate TIN duplicates
					FROM		ACDW_CLMS_SHCN_BCBS.adw.FctMembership c
					JOIN lst.List_Client Client ON c.ClientKey = Client.ClientKey
					-- Added join to fix permian Tin Issue, after fix fact data, remove this
					LEFT JOIN adw.tvf_AllClient_ProviderRoster(20, @effectiveDate, 0) PR  -- Changed to Left Join to not remove TINS 
					ON c.PcpPracticeTIN = pr.AttribTIN
				    and c.NPI = pr.NPI
				    
					WHERE	c.Active = 1 
					AND (SELECT CASE WHEN (@effectiveDate > 
						( SELECT Max(c.RwExpirationDate)  FROM ACDW_CLMS_SHCN_BCBS.adw.FctMembership c)) 
						THEN (SELECT Max(c.RwExpirationDate)  FROM ACDW_CLMS_SHCN_BCBS.adw.FctMembership c)
						ELSE @EffectiveDate END as aDate)	BETWEEN c.RwEffectiveDate and c.RwExpirationDate
					--Brit -- To select latest active records
				)a
		 WHERE  RwCnt = 1
		  
         UNION
		  --Americ_Group ma
		 SELECT		*
	     FROM		(
					SELECT		DISTINCT 
								0 AS [mbrMemberKey], 
								0 AS mbrDemographicKey, 
								0 AS mbrPlanKey,
								0 AS mbrPcpKey,
								0 AS mbrCsPlanKey,
								0 AS MbrPhoneKeyType1,
								0 AS MbrPhoneKeyType4, 
								0 AS MbrPHoneKeyType3,
								0 AS MbrAddressKey1, 
								0 AS MbrAddressKey2, 
								Client.ClientShortName AS CLIENT,
								c.ClientKey		  AS ClientKey,
								c.ClientMemberKey  AS MEMBER_ID,
								Ace_ID	  AS Ace_ID,
								c.FirstName AS [MEMBER_FIRST_NAME],
								c.MiddleName AS [MEMBER_MI],
								c.LastName AS [MEMBER_LAST_NAME],
								c.[ClientMemberKey] AS [CLIENT_SUBSCRIBER_ID],
								c.PlanName AS [PLAN_ID],
								c.PlanName AS [PRODUCT_CODE],
								c.SubgrpID AS [SUBGRP_ID],
								c.SubgrpName [SUBGRP_NAME],
								c.MedicaidID AS [MEDICAID_ID],
								c.CurrentAge AS AGE,
								c.DOB AS [DATE_OF_BIRTH],
								c.Gender AS GENDER,
								c.LanguageCode AS [LANG_CODE],
								c.Ethnicity AS ETHNICITY,
								c.Race AS RACE,
								c.MemberHomeAddress AS [MEMBER_HOME_ADDRESS],
								c.MemberHomeAddress1 AS [MEMBER_HOME_ADDRESS2],
								c.MemberHomeCity AS [MEMBER_HOME_CITY],
								c.MemberHomeState AS [MEMBER_HOME_STATE],
								c.MemberHomeZip AS [MEMBER_HOME_ZIP_C],
								c.MemberHomePhone AS [MEMBER_HOME_PHONE],
								c.MemberMailingAddress [MEMBER_MAIL_ADDRESS],
								c.MemberMailingAddress1 AS [MEMBER_MAIL_ADDRESS2],
								c.MemberMailingCity AS [MEMBER_MAIL_CITY],
								c.MemberMailingState AS [MEMBER_MAIL_STATE],
								c.MemberMailingZip AS [MEMBER_MAIL_ZIP_C],
								c.MemberCellPhone AS [MEMBER_MAIL_PHONE],
								c.CountyName AS [MEMBER_COUNTY],
								'' AS [MEMBER_BUS_PHONE],
								' ' AS [MEMBER_ORG_EFF_DATE],
								' ' AS [MEMBER_CONT_EFF_DATE],
								c.RwEffectiveDate AS [MEMBER_CUR_EFF_DATE],
								'' AS [MEMBER_CUR_TERM_DATE],
								'' AS [PCP_CLIENT_ID],
								pr.AccountType AS PCP_AccountType,
								c.ProviderFirstName AS [PCP_FIRST_NAME],
								c.ProviderLastName AS [PCP_LAST_NAME],
								c.NPI AS NPI,
								c.ProviderPhone AS [PCP_PHONE],
								'' AS [PCP_FAX],
								c.ProviderAddressLine1 AS [PCP_ADDRESS],
								c.ProviderAddressLine2 AS [PCP_ADDRESS2],
								c.ProviderCity AS [PCP_CITY],
								'' AS [PCP_STATE],
								c.ProviderZip AS [PCP_ZIP_C],
								'' AS [PCP_EFFECTIVE_DATE],
								'' AS [PCP_TERM_DATE],
								c.PcpPracticeTIN AS [PCP_PRACTICE_TIN],		 
								'' AS [PCP_GROUP_ID],
								--c.ProviderPracticeName  AS [PCP_PRACTICE_NAME], 
								pr.AttribTinName AS [PCP_PRACTICE_NAME], -- changed to fix permian Tin Issue, after fix fact data, remove this
								'' AS [AUTO_ASSIGN],
								'' AS [MEMBER_STATUS],
								'' AS [MEMBER_TERM_DATE],
								CONVERT(VARCHAR(50),c.ClientRiskScore ) ClientRiskScore,
								'' AS [RISK_CATEGORY_C],
								c.LOB AS [LINE_OF_BUSINESS],
								c.PlanName AS [PLAN_CODE],
								c.Contract AS [PLAN_DESC],
								'' AS [PRIMARY_RISK_FACTOR],
								'' AS [TOTAL_COSTS_LAST_12_MOS],
								'' AS [COUNT_OPEN_CARE_OPPS],
								'' AS [INP_COSTS_LAST_12_MOS],
								'' AS [ER_COSTS_LAST_12_MOS],
								'' AS [OUTP_COSTS_LAST_12_MOS],
								'' AS [PHARMACY_COSTS_LAST_12_MOS],
								'' AS [PRIMARY_CARE_COSTS_LAST_12_MOS],
								'' AS [BEHAVIORAL_COSTS_LAST_12_MOS],
								'' AS [OTHER_OFFICE_COSTS_LAST_12_MOS],
								'' AS [INP_ADMITS_LAST_12_MOS],
								'' AS [LAST_INP_DISCHARGE],
								'' AS [POST_DISCHARGE_FUP_VISIT],
								'' AS [INP_FUP_WITHIN_7_DAYS],
								NULL AS [ER_VISITS_LAST_12_MOS],
								'' AS [LAST_ER_VISIT],
								'' AS [POST_ER_FUP_VISIT],
								'' AS [ER_FUP_WITHIN_7_DAYS],
								'' AS [LAST_PCP_VISIT],
								'' AS [LAST_PCP_PRACTICE_SEEN],
								'' AS [LAST_BH_VISIT],
								'' AS [LAST_BH_PRACTICE_SEEN],
								'' AS [MEMBER_MONTH_COUNT],
								'' AS [MEMBER_POD_C],
								c.ProviderPOD AS [MEMBER_POD_DESC],
								'' AS [PCP_POD_C],
								'' AS [PCP_POD_DESC],
								c.ProviderFirstName + ' ' + c.ProviderLastName AS [PCP_NAME],
								'' AS [CLIENT_UNIQUE_SYSTEM_ID],
								c.ClientMemberKey AS [MEDICARE_ID],
								'' AS [RESP_LAST_NAME],
								'' AS [RESP_FIRST_NAME],
								'' AS [RESP_ADDRESS],
								'' AS [RESP_ADDRESS2],
								'' AS [RESP_CITY],
								'' AS [RESP_STATE],
								'' AS [RESP_ZIP],
								'' AS [RESP_PHONE],
								'' AS CurMonthsOld,
								c.CurrentAge AS CurYearsOld,  
		 						c.PlanID AS AhsPlanCode,
		 						c.PlanName AS AhsPlanName
								,c.LoadDate
								,ROW_NUMBER() OVER(PARTITION BY ClientMemberKey, c.NPI, ProviderPracticeName ORDER BY c.LoadDate DESC)RwCnt -- Brit: To eliminate TIN duplicates
					FROM ACDW_CLMS_AMGTX_MA.adw.FctMembership c
					JOIN lst.List_Client Client ON c.ClientKey = Client.ClientKey
					-- Added join to fix permian Tin Issue, after fix fact data, remove this
					LEFT JOIN adw.tvf_AllClient_ProviderRoster(21, @effectiveDate, 0) PR  -- Changed to Left Join to not remove TINS 
					   ON c.PcpPracticeTIN = pr.AttribTIN
						  and c.NPI = pr.NPI						  
					WHERE	c.Active = 1 
					AND (SELECT CASE WHEN (@effectiveDate > 
						( SELECT Max(c.RwExpirationDate)  FROM ACDW_CLMS_AMGTX_MA.adw.FctMembership c)) 
						THEN (SELECT Max(c.RwExpirationDate)  FROM ACDW_CLMS_AMGTX_MA.adw.FctMembership c)
						ELSE @EffectiveDate END as aDate)	BETWEEN c.RwEffectiveDate and c.RwExpirationDate
					--Brit -- To select latest active records
				)a
		 WHERE  RwCnt = 1
		 )
	UNION  --AmgTx_Mcd
	   SELECT		*
	   FROM		(SELECT		DISTINCT 
								0 AS [mbrMemberKey], 
								0 AS mbrDemographicKey, 
								0 AS mbrPlanKey,
								0 AS mbrPcpKey,
								0 AS mbrCsPlanKey,
								0 AS MbrPhoneKeyType1,
								0 AS MbrPhoneKeyType4, 
								0 AS MbrPHoneKeyType3,
								0 AS MbrAddressKey1, 
								0 AS MbrAddressKey2, 
								client.ClientShortName AS CLIENT,
								c.ClientKey		  AS ClientKey,
								c.ClientMemberKey  AS MEMBER_ID,
								Ace_ID	  AS Ace_ID,
								c.FirstName AS [MEMBER_FIRST_NAME],
								c.MiddleName AS [MEMBER_MI],
								c.LastName AS [MEMBER_LAST_NAME],
								c.[ClientMemberKey] AS [CLIENT_SUBSCRIBER_ID],
								c.PlanName AS [PLAN_ID],
								c.PlanName AS [PRODUCT_CODE],
								c.SubgrpID AS [SUBGRP_ID],
								c.SubgrpName [SUBGRP_NAME],
								c.MedicaidID AS [MEDICAID_ID],
								c.CurrentAge AS AGE,
								c.DOB AS [DATE_OF_BIRTH],
								c.Gender AS GENDER,
								c.LanguageCode AS [LANG_CODE],
								c.Ethnicity AS ETHNICITY,
								c.Race AS RACE,
								c.MemberHomeAddress AS [MEMBER_HOME_ADDRESS],
								c.MemberHomeAddress1 AS [MEMBER_HOME_ADDRESS2],
								c.MemberHomeCity AS [MEMBER_HOME_CITY],
								c.MemberHomeState AS [MEMBER_HOME_STATE],
								c.MemberHomeZip AS [MEMBER_HOME_ZIP_C],
								c.MemberHomePhone AS [MEMBER_HOME_PHONE],
								c.MemberMailingAddress [MEMBER_MAIL_ADDRESS],
								c.MemberMailingAddress1 AS [MEMBER_MAIL_ADDRESS2],
								c.MemberMailingCity AS [MEMBER_MAIL_CITY],
								c.MemberMailingState AS [MEMBER_MAIL_STATE],
								c.MemberMailingZip AS [MEMBER_MAIL_ZIP_C],
								c.MemberCellPhone AS [MEMBER_MAIL_PHONE],
								c.CountyName AS [MEMBER_COUNTY],
								'' AS [MEMBER_BUS_PHONE],
								' ' AS [MEMBER_ORG_EFF_DATE],
								' ' AS [MEMBER_CONT_EFF_DATE],
								c.RwEffectiveDate AS [MEMBER_CUR_EFF_DATE],
								'' AS [MEMBER_CUR_TERM_DATE],
								'' AS [PCP_CLIENT_ID],
								pr.AccountType AS PCP_AccountType,
								c.ProviderFirstName AS [PCP_FIRST_NAME],
								c.ProviderLastName AS [PCP_LAST_NAME],
								c.NPI AS NPI,
								c.ProviderPhone AS [PCP_PHONE],
								'' AS [PCP_FAX],
								c.ProviderAddressLine1 AS [PCP_ADDRESS],
								c.ProviderAddressLine2 AS [PCP_ADDRESS2],
								c.ProviderCity AS [PCP_CITY],
								'' AS [PCP_STATE],
								c.ProviderZip AS [PCP_ZIP_C],
								'' AS [PCP_EFFECTIVE_DATE],
								'' AS [PCP_TERM_DATE],
								c.PcpPracticeTIN AS [PCP_PRACTICE_TIN],		 
								'' AS [PCP_GROUP_ID],
								--c.ProviderPracticeName  AS [PCP_PRACTICE_NAME], 
								pr.AttribTinName AS [PCP_PRACTICE_NAME], -- changed to fix permian Tin Issue, after fix fact data, remove this
								'' AS [AUTO_ASSIGN],
								'' AS [MEMBER_STATUS],
								'' AS [MEMBER_TERM_DATE],
								CONVERT(VARCHAR(50),c.ClientRiskScore ) ClientRiskScore,
								'' AS [RISK_CATEGORY_C],
								c.LOB AS [LINE_OF_BUSINESS],
								c.PlanName AS [PLAN_CODE],
								c.Contract AS [PLAN_DESC],
								'' AS [PRIMARY_RISK_FACTOR],
								'' AS [TOTAL_COSTS_LAST_12_MOS],
								'' AS [COUNT_OPEN_CARE_OPPS],
								'' AS [INP_COSTS_LAST_12_MOS],
								'' AS [ER_COSTS_LAST_12_MOS],
								'' AS [OUTP_COSTS_LAST_12_MOS],
								'' AS [PHARMACY_COSTS_LAST_12_MOS],
								'' AS [PRIMARY_CARE_COSTS_LAST_12_MOS],
								'' AS [BEHAVIORAL_COSTS_LAST_12_MOS],
								'' AS [OTHER_OFFICE_COSTS_LAST_12_MOS],
								'' AS [INP_ADMITS_LAST_12_MOS],
								'' AS [LAST_INP_DISCHARGE],
								'' AS [POST_DISCHARGE_FUP_VISIT],
								'' AS [INP_FUP_WITHIN_7_DAYS],
								NULL AS [ER_VISITS_LAST_12_MOS],
								'' AS [LAST_ER_VISIT],
								'' AS [POST_ER_FUP_VISIT],
								'' AS [ER_FUP_WITHIN_7_DAYS],
								'' AS [LAST_PCP_VISIT],
								'' AS [LAST_PCP_PRACTICE_SEEN],
								'' AS [LAST_BH_VISIT],
								'' AS [LAST_BH_PRACTICE_SEEN],
								'' AS [MEMBER_MONTH_COUNT],
								'' AS [MEMBER_POD_C],
								c.ProviderPOD AS [MEMBER_POD_DESC],
								'' AS [PCP_POD_C],
								'' AS [PCP_POD_DESC],
								c.ProviderFirstName + ' ' + c.ProviderLastName AS [PCP_NAME],
								'' AS [CLIENT_UNIQUE_SYSTEM_ID],
								c.ClientMemberKey AS [MEDICARE_ID],
								'' AS [RESP_LAST_NAME],
								'' AS [RESP_FIRST_NAME],
								'' AS [RESP_ADDRESS],
								'' AS [RESP_ADDRESS2],
								'' AS [RESP_CITY],
								'' AS [RESP_STATE],
								'' AS [RESP_ZIP],
								'' AS [RESP_PHONE],
								'' AS CurMonthsOld,
								c.CurrentAge AS CurYearsOld,  
		 						c.PlanID AS AhsPlanCode,
		 						c.PlanName AS AhsPlanName
								,c.LoadDate
								,ROW_NUMBER() OVER(PARTITION BY ClientMemberKey, c.NPI, ProviderPracticeName ORDER BY c.LoadDate DESC)RwCnt -- Brit: To eliminate TIN duplicates
					FROM ACDW_CLMS_AMGTX_Mcd.adw.FctMembership c
					-- Added join to fix permian Tin Issue, after fix fact data, remove this
					JOIN lst.List_Client Client ON c.ClientKey = Client.ClientKey
					LEFT JOIN adw.tvf_AllClient_ProviderRoster(22, @effectiveDate, 0) PR  -- Changed to Left Join to not remove TINS 
					   ON c.PcpPracticeTIN = pr.AttribTIN
						  and c.NPI = pr.NPI						  
					WHERE	c.Active = 1 
					AND (SELECT CASE WHEN (@effectiveDate > 
						( SELECT Max(c.RwExpirationDate)  FROM ACDW_CLMS_AMGTX_Mcd.adw.FctMembership c)) 
						THEN (SELECT Max(c.RwExpirationDate)  FROM ACDW_CLMS_AMGTX_Mcd.adw.FctMembership c)
						ELSE @EffectiveDate END as aDate)	BETWEEN c.RwEffectiveDate and c.RwExpirationDate
				)a
		 WHERE  RwCnt = 1
		 ;
		 