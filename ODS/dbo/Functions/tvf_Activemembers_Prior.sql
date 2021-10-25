CREATE FUNCTION [dbo].[tvf_Activemembers_Prior](@EffectiveDate DATE) 
RETURNS TABLE
    /* Purpose: gets all members active for all clients for a specific day.-
	   Incudes the keys of the Rows used to create the set. 
	   */
AS
    RETURN
(   --declare @EffectiveDate date = getdate();
    SELECT DISTINCT
           M.[mbrMemberKey], MbrDemo.mbrDemographicKey, MbrPlan.mbrPlanKey, MbrPcp.mbrPcpKey, mbrCsPlan.mbrCsPlanKey,
		 MbrPhone1.mbrPhoneKey MbrPhoneKeyType1, MbrPhone2.mbrPhoneKey MbrPhoneKeyType4, MbrPhone3.mbrPhoneKey MbrPHoneKeyType3,
		 MbrAddress1.mbrAddressKey AS MbrAddressKey1, MbrAddress2.mbrAddressKey AS MbrAddressKey2, 
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
           pr.PrimaryAddressPhoneNum AS [PCP_PHONE],
           '' AS [PCP_FAX],
           pr.PrimaryAddress AS [PCP_ADDRESS],
           '' AS [PCP_ADDRESS2],
           pr.PrimaryCity AS [PCP_CITY],
           pr.PrimaryState AS [PCP_STATE],
           pr.PrimaryZipcode AS [PCP_ZIP_C],
           MbrPcp.EffectiveDate AS [PCP_EFFECTIVE_DATE],
           MbrPcp.ExpirationDate AS [PCP_TERM_DATE],
           MbrPcp.tin AS [PCP_PRACTICE_TIN],		 
           '' AS [PCP_GROUP_ID],
           pr.GroupName AS [PCP_PRACTICE_NAME],
           MbrPcp.[AutoAssigned] AS [AUTO_ASSIGN],
           '' AS [MEMBER_STATUS],
           '' AS [MEMBER_TERM_DATE],
           '' AS [IPRO_ADMIT_RISK_SCORE],
           '' AS [RISK_CATEGORY_C],
           MbrPlan.ProductPlan AS [LINE_OF_BUSINESS],
           MbrPlan.ProductSubPlan AS [PLAN_CODE],
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
           PR.PrimaryPOD AS [PCP_POD_C],
           PR.PrimaryQuadrant AS [PCP_POD_DESC],
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
	   LEFT JOIN(SELECT PR.NPI, PR.LastName, PR.FirstName, PR.TIN, PR.PrimarySpeciality, 
					   PR.Sub_Speciality, PR.GroupName, PR.PrimaryAddress, PR.PrimaryCity, 
					   PR.PrimaryState,	PR.PrimaryZipcode, PR.PrimaryPOD, PR.PrimaryQuadrant, PR.PrimaryAddressPhoneNum, 
					   pr.CalcClientKey,
					   /* PR.Status not in fctPR */ pr.AccountType, PR.NetworkContact
				    FROM vw_AllClient_ProviderRoster PR
				    WHERE pr.providerType in ('PCP')) AS PR 
				    ON  PR.NPI =  MbrPcp.NPI
					AND PR.[TIN] = MbrPcp.tin
					AND pr.CalcClientKey= m.CLientKey
        left JOIN (SELECT CONVERT(INT, zp.ZipCode) ZipCode, zp.Quadrant, zp.Pod FROM [dbo].[LIST_ZIPCODES] zp) zp ON zp.zipcode = MbrAddress1.zipCodeJoin
	--where m.ClientKey <> 1
  --where  @EffectiveDate between m.effecti and m.ExpirationDate
  
);

