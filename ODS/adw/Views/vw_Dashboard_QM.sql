
CREATE VIEW [adw].vw_Dashboard_QM

AS 
	SELECT src.ClientMemberKey, src.ACTIVE , src.QmMsr_Tb_Desc, src.AHR_QM_DESC , src.QmMsrId, src.QMDate     
		, src.LOB		
		, src.MeasureDesc
		, sum(src.MbrDen) MbrDen
		, sum(src.MbrNum) MbrNum
		, sum(src.MbrCop) MbrCop
		, src.AGE
		, src.PCP_PRACTICE_TIN
		, src.PCP_PRACTICE_NAME
		, src.ProviderAccountType
		, src.PCP_NPI
		, src.PrimaryAddressPhoneNum
		, src.MeasureID 
		, src.[CONTRACT?]
		, src.[ACE MBR?]
	--	, 'S.ExpirationYear from score' ExpirationYear
	--	, 'target' Target
		, src.Client
		, src.ProviderLastName
		, src.ProviderFirstName
		, src.IsMbrActive
		, src.TinInContractWithAce
		, src.MEMBER_FIRST_NAME
		, src.MEMBER_LAST_NAME, src.DATE_OF_BIRTH, src.MEMBER_HOME_PHONE, src.BusPhone, src.MailPhone
	
	FROM (
		SELECT 
			qm.ClientMemberKey
			, CopToPlan.ACTIVE 
			, lqm.Qm_DESC QmMsr_Tb_Desc
			, lqm.AHR_QM_DESC 
			, qm.QmMsrId
			, qm.QMDate     
			, Mbrs.LOB		
			, lqm.AHR_QM_DESC MeasureDesc
			, CASE WHEN qm.[QMCNTCAT] = 'DEN' THEN 1
		                    ELSE 0 END AS MbrDen
			, CASE WHEN [QMCNTCAT] = 'NUM' THEN 1
		                    ELSE 0 END AS MbrNum
			, CASE WHEN [QMCNTCAT] = 'COP' THEN 1
							ELSE 0 END AS MbrCop 
			, Mbrs.AGE
			, Mbrs.PCP_PRACTICE_TIN, Mbrs.PCP_PRACTICE_NAME
			, PR.AccountType ProviderAccountType
			, Mbrs.PCP_NPI
			, PR.PrimaryAddressPhoneNum
			, CopToPlan.MeasureID -- WHY?
			, CASE WHEN CopToPlan.MEASUREID IS NULL THEN 'NOT CONTRACTED'
					ELSE 'CONTRACTED' END AS 'CONTRACT?'
			, CASE WHEN Mbrs.ClientMemberKey IS NULL THEN 'NOT ACE_MBR'
		                    ELSE 'ACE MBR' END AS 'ACE MBR?'
		--	, 'S.ExpirationYear from score' ExpirationYear
		--	, 'target' Target
			, Client.ClientShortName AS Client
			, PR.LastName AS ProviderLastName, PR.FirstName ProviderFirstName
			, 'IsMbrActive' IsMbrActive
			, CASE WHEN(pr.AccountType IS NULL) THEN 'INACTIVE'
					ELSE 'ACTIVE' END AS TinInContractWithAce
			, Mbrs.MEMBER_FIRST_NAME, Mbrs.MEMBER_LAST_NAME, Mbrs.DATE_OF_BIRTH, Mbrs.MEMBER_HOME_PHONE, '' BusPhone, '' MailPhone
		FROM adw.QM_ResultByMember_History qm
			LEFT JOIN dbo.TmpAllMemberMonths Mbrs 
				ON qm.ClientMemberKey = Mbrs.ClientMemberKey 
					AND qm.ClientKey = Mbrs.CLientKey
			JOIN  lst.List_Client Client ON qm.ClientKey = Client.ClientKey
			JOIN lst.LIST_QM_Mapping lqm 
				ON qm.QmMsrId = lqm.QM 
					and qm.ClientKey = lqm.ClientKey 
					and qm.QMDate between lqm.EffectiveDate and lqm.ExpirationDate
			LEFT JOIN lst.LSTCAREOPTOPLAN CopToPlan ON QM.QmMsrId = CopToPlan.MeasureID	
				AND CopToPlan.CSPLAN = Mbrs.SUBGRP_ID
		        AND QM.QMDATE BETWEEN CopToPlan.EFFECTIVEDATE AND CopToPlan.EXPIRATIONDATE
			LEFT JOIN ACECAREDW.adw.fctProviderRoster PR
				ON Mbrs.PCP_NPI = PR.NPI
					and Mbrs.PCP_PRACTICE_TIN = PR.TIN
					and Mbrs.CLientKey = PR.ClientKey
					and qm.QMDate between PR.RowEffectiveDate and PR.RowExpirationDate
		WHERE  Mbrs.MemberMonth > '12/31/2018'
			and qm.QMDate > '12/31/2018'
		) src
	GROUP BY src.ClientMemberKey, src.ACTIVE , src.QmMsr_Tb_Desc, src.AHR_QM_DESC , src.QmMsrId, src.QMDate     
		, src.LOB		
		, src.MeasureDesc
		, src.AGE
		, src.PCP_PRACTICE_TIN
		, src.PCP_PRACTICE_NAME
		, src.ProviderAccountType
		, src.PCP_NPI
		, src.PrimaryAddressPhoneNum
		, src.MeasureID 
		, src.[CONTRACT?]
		, src.[ACE MBR?]
	--	, 'S.ExpirationYear from score' ExpirationYear
	--	, 'target' Target
		, src.Client
		, src.ProviderLastName
		, src.ProviderFirstName
		, src.IsMbrActive
		, src.TinInContractWithAce
		, src.MEMBER_FIRST_NAME
		, src.MEMBER_LAST_NAME, src.DATE_OF_BIRTH, src.MEMBER_HOME_PHONE, src.BusPhone, src.MailPhone
