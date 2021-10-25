CREATE FUNCTION [adi].[tvf_PdwSrc_Wlc_MemberByPcp]( 
    @DataDate DATE
    )
    RETURNS TABLE
    AS 
    RETURN
       -- Declare @DataDate date = '2021-07-06' 
    SELECT adiMbrs.mbrWlcMbrByPcpKey
	   , Client.ClientKey
	   , adiMbrs.SEQ_Mem_ID
	   , adiMbrs.Sub_ID
	   , RTRIM(LTRIM(adiMbrs.FirstName)) FirstName
	   , RTRIM(LTRIM(adiMbrs.LastName))  LastName
	   , adiMbrs.GENDER
	   , adiMbrs.IPA
	   , adiMbrs.BirthDate
	   , adiMbrs.MEDICAID_NO
	   , adiMbrs.MEDICAL_REC_NO
	   , adiMbrs.MEMBER_EFFECTIVE_DATE
	   , ISNULL(adiMbrs.TermDate, '12/31/2099') AS TermDate
	   , adiMbrs.Prov_id
	   , adiMbrs.Prov_Name
	   , adiMbrs.LOB
	   , adiMbrs.BenePLAN
	   /*added case for event on blank address type, default to primary */
	   , CASE WHEN (ISNULL(adiMbrs.ADDRESS_TYPE, '') = '') THEN 'R1 - Primary Residen' ELSE adiMbrs.ADDRESS_TYPE END AS ADDRESS_TYPE
	   , adiMbrs.Address
	   , adiMbrs.City
	   , adiMbrs.State
	   , adiMbrs.Zip
	   , adiMbrs.County
	   , adiMbrs.PhoneNumber
	   , adiMbrs.MOBILE_PHONE
	   , adiMbrs.ALT_PHONE
	   , adiMbrs.AGENT_NUM
	   , adiMbrs.Enrollment_Source
	   , adiMbrs.SrcFileName
	   , adiMbrs.LoadDate
	   , adiMbrs.DataDate  
	   , adimbrs.mbrWlcMbrByPcpKey AS AdiKey
	   , 'MbrWlcMbrByPcp'		 AS AdiTableName
	   , ROW_NUMBER() OVER(PARTITION BY EffectiveMembers.ClientMemberKey ORDER BY EffectiveMembers.MbrWlcMbrByPcpKey DESC) AS BestMemberRow -- Identifies the best member cord
	   , ROW_NUMBER() OVER(PARTITION BY EffectiveMembers.ClientMemberKey, EffectiveMembers.ADDRESS_TYPE ORDER BY EffectiveMembers.MbrWlcMbrByPcpKey DESC) AS BestAddressRowByAddressType -- Identifies the best address row by Address Type
    FROM adi.MbrWlcMbrByPcp adiMbrs -- list of members
	   JOIN lst.List_Client Client 
		  ON 2 /*wlc client id */ = Client.ClientKey
        JOIN (/* What is the sub select for */
			 SELECT m.mbrWlcMbrByPcpKey, m.SUB_ID ClientMemberKey -- list of effective members
			 , m.MEMBER_EFFECTIVE_DATE, ISNULL(m.TermDate, '12/31/2099') TERMDATE
			 , m.ADDRESS_TYPE
			 FROM adi.MbrWlcMbrByPcp m
			 WHERE m.DataDate = @DataDate
				AND @DataDate < ISNULL(TERMDATE, '12/31/2099')
			 ) EffectiveMembers ON adiMbrs.mbrWlcMbrByPcpKey = EffectiveMembers.mbrWlcMbrByPcpKey
	   JOIN lst.lstPlanMapping pm  -- VERSION: Added PlanMapping to filter out plans not in use by ACE
		  ON pm.SourceValue = adiMbrs.BenePlan
			 and pm.ClientKey = 2
			 and @DataDate between pm.EffectiveDate and pm.ExpirationDate
			 and targetsystem = 'ACDW'
	   /* added for testing, the CSPlan, Pcp, adn Plan processessing to this check independently 
	   LEFT JOIN (SELECT DISTINCT pr.tin, pr.ClientProviderID
				FROM dbo.vw_AllClient_ProviderRoster PR
				WHERE pr.CalcClientKey = 2
				    AND @Loaddate between pr.EffectiveDate and pr.ExpirationDate
				) pr ON adiMbrs.Prov_id = pr.ClientProviderID 		  
		  */
    WHERE @DataDate BETWEEN EffectiveMembers.MEMBER_EFFECTIVE_DATE AND EffectiveMembers.TermDate
	   
    ;

