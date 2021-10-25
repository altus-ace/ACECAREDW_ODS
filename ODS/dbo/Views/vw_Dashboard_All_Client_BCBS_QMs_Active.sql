


CREATE VIEW [dbo].[vw_Dashboard_All_Client_BCBS_QMs_Active]
AS

/**
Created this view for Boomi to drop the file in SFTP 
ALL Clients QMs view JK created for AG
06/29 JK : AG added filter on srcfilename
**/

  --   SELECT DISTINCT 
  --          QM.QMdate AS							 EffectiveDate, 
  --          QM.clientKey AS							 ClientId, 
  --          pr.MbrHealthPlan					AS	 Client, 
  --          QM.ClientMemberkey					AS   MemberId, 
  --          UPPER(tmp.MEMBER_FIRST_NAME)			 MemberFirstName, 
  --          UPPER(tmp.MEMBER_LAST_NAME)				 MemberLastName, 
  --          UPPER(tmp.GENDER)						 MemberGender, 
  --          UPPER(tmp.AGE)							 MemberAge, 
  --          UPPER(tmp.DATE_OF_BIRTH)				 MemberDOB, 
  --          UPPER(tmp.MEMBER_HOME_ADDRESS)			 MemberAddress, 
  --          UPPER(tmp.MEMBER_HOME_ADDRESS2)			 MemberAddress1, 
  --          UPPER(tmp.MEMBER_HOME_CITY)				 MemberCity, 
  --          UPPER(tmp.MEMBER_HOME_STATE)			 MemberState, 
  --          tmp.MEMBER_HOME_ZIP						 MemberZip, 
  --          tmp.Member_Home_Phone					 MemberPhone, 
  --          QM.QmMsrId							AS   MeasureId, 
  --          lqm.QM_DESC								 Measure_Description,
  --          CASE
  --              WHEN QM.QmCntCat = 'NUM'
  --              THEN 'YES'
  --              WHEN QM.QmCntCat = 'COP'
  --              THEN 'NO'
  --              ELSE QM.QmCntCat
  --          END AS									ComplaintStatus,
  --          tmp.PCP_NPI								PCPNPI, 
  --          UPPER(pr.FirstName)						ProviderFirstName, 
  --          UPPER(pr.LastName)						ProviderLastName, 
  --          tmp.PCP_PRACTICE_TIN					ProviderTIN, 
  --         -- UPPER(tmp.PCP_PRACTICE_NAME) PracticeName, 
	--	  UPPER(pr.AttribTINName)					PracticeName, --'IS THIS ARBITRARY?'
  --          pr.AccountType							AccountType, 
  --          UPPER(pr.Chapter)						ProviderChapter, 
  --          GETDATE() AS							RunDate     
  --   FROM ACECAREDW.adw.QM_ResultByMember_History QM
  --      INNER JOIN ( SELECT MaxQmDate.clientkey, MAX(MaxQmDate.QmDate) MaxQmDate
	--			    FROM acecaredw.adw.QM_ResultByMember_History MaxQmDate
	--			    GROUP BY MaxQmDate.ClientKey
	--		 ) MaxQm ON qm.QMDate = MaxQm.MaxQmDate
	--			AND qm.ClientKey = MaxQm.ClientKey
  --      INNER JOIN ACECAREDW.lst.LIST_QM_Mapping lqm 
	--	  ON qm.QmMsrId = lqm.QM
	--		 AND qm.ClientKey = lqm.ClientKey
  --              AND qm.QMDate BETWEEN lqm.EffectiveDate AND lqm.ExpirationDate
  --      INNER JOIN [ACECAREDW].[dbo].[TmpAllMemberMonths] tmp 
	--	  ON qm.clientKey = tmp.clientkey
	--		 AND QM.clientmemberkey = tmp.clientmemberkey
  --              AND YEAR(QM.QMDate) = YEAR(tmp.membermonth)
  --              AND MONTH(qm.qmdate) = MONTH(tmp.membermonth)
	--   LEFT JOIN ACECAREDW.adw.tvf_AllClient_ProviderRoster(0, GETDATE(), 1) pr 
	--	  ON pr.ClientKey = qm.ClientKey
	--		 AND pr.NPI = tmp.PCP_NPI
	--		 AND pr.AttribTIN = tmp.PCP_PRACTICE_TIN
  --   WHERE lqm.srcfilename <> 'ATHENAEMRmeasurenamemappingtoACEmeasures_V1.csv'
  --      AND qm.QmCntCat <> 'DEN'
	--   AND qm.ClientKey IN(3)--, '3')
	--   AND lqm.active = 'Y'
	--   AND pr.AccountType IN('SHCN_AFF', 'SHCN_SMG')
  --  

 --   UNION ALL
   SELECT DISTINCT 
           QM.QMdate AS							EffectiveDate,
           QM.clientKey AS						ClientId, 
           pr.MbrHealthPlan						 AS	 Client, 
           QM.ClientMemberkey					AS   MemberId, 
           UPPER(mbr.FirstName)			 MemberFirstName, 
           UPPER(mbr.LastName)				 MemberLastName, 
           UPPER(mbr.GENDER)						 MemberGender, 
           UPPER(mbr.AvgAge)							 MemberAge, 
           UPPER(mbr.DOB)				 MemberDOB, 
           UPPER(mbr.MemberHomeAddress)			 MemberAddress, 
           UPPER(mbr.MemberHomeAddress1)			 MemberAddress1, 
           UPPER(mbr.MemberHomeCity)				 MemberCity, 
           UPPER(mbr.MemberHomeState)			 MemberState, 
           mbr.MemberHomeZip						 MemberZip, 
           mbr.MemberHomePhone					 MemberPhone, 
           QM.QmMsrId							AS   MeasureId, 
           lqm.QM_DESC								 Measure_Description,
           CASE
               WHEN QM.QmCntCat = 'NUM'
               THEN 'YES'
               WHEN QM.QmCntCat = 'COP'
               THEN 'NO'
               ELSE QM.QmCntCat
           END AS									ComplaintStatus,
           mbr.NPI								PCPNPI, 
           UPPER(pr.FirstName)						ProviderFirstName, 
           UPPER(pr.LastName)						ProviderLastName, 
           mbr.PCPPRACTICETIN					ProviderTIN, 
          -- UPPER(tmp.PCP_PRACTICE_NAME) PracticeName, 
	  UPPER(pr.AttribTINName)					PracticeName, --'IS THIS ARBITRARY?'
           pr.AccountType							AccountType, 
           UPPER(pr.Chapter)						ProviderChapter, 
           GETDATE() AS							RunDate     
    FROM ACDW_CLMS_SHCN_BCBS.adw.QM_ResultByMember_History QM
       INNER JOIN ( SELECT MaxQmDate.clientkey, MAX(MaxQmDate.QmDate) MaxQmDate
			    FROM ACDW_CLMS_SHCN_BCBS.adw.QM_ResultByMember_History MaxQmDate
			    GROUP BY MaxQmDate.ClientKey
		 ) MaxQm ON qm.QMDate = MaxQm.MaxQmDate
			AND qm.ClientKey = MaxQm.ClientKey
       INNER JOIN ACDW_CLMS_SHCN_BCBS.lst.LIST_QM_Mapping lqm 
	  ON qm.QmMsrId = lqm.QM
		 AND qm.ClientKey = lqm.ClientKey
               AND qm.QMDate BETWEEN lqm.EffectiveDate AND lqm.ExpirationDate
       INNER JOIN ACDW_CLMS_SHCN_BCBS.adw.vw_FctMembership mbr
	  ON qm.clientKey = mbr.clientkey
		 AND QM.clientmemberkey = mbr.clientmemberkey
               AND YEAR(QM.QMDate) = YEAR(mbr.RowEffectiveDate)
               AND MONTH(qm.qmdate) = MONTH(mbr.RowEffectiveDate)			
   LEFT JOIN ACECAREDW.adw.tvf_AllClient_ProviderRoster(20, (SELECT CONVERT(Date, Max(c.RwEffectiveDate))  FROM ACDW_CLMS_SHCN_BCBS.adw.FctMembership c), 1) pr 
	  ON pr.ClientKey = qm.ClientKey
		 AND pr.NPI = mbr.NPI
		 AND pr.AttribTIN = mbr.PcpPracticeTIN
    WHERE qm.QmCntCat <> 'DEN'
       AND qm.ClientKey IN(20)
   AND lqm.active = 'Y'
   AND mbr.RowEffectiveDate = (SELECT Max(c.RwEffectiveDate)  FROM ACDW_CLMS_SHCN_BCBS.adw.FctMembership c)
   AND mbr.Active = 1
   AND lqm.SrcFileName <> 'SHCN_BCBS_ATHENA_QM_MAPPING 04202021.csv'
   AND pr.AccountType IN('SHCN_AFF', 'SHCN_SMG');

