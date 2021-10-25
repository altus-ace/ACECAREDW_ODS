
CREATE VIEW [adw].[vw_MPulse_Exp_PhoneScrub]
AS

  -- GET All Active members phone numbers from all clients 
  /* 02/03/2021: gk added bcbs, and modified Mssp/Bcbs to get the Max rwEffectiveDate set from Membership */
  /* get Uhc data */
    WITH CTE_GetUhcPhones (
	   uhc_subscriber_id, 
	   MRN,
	   ClientKey,
	   A_Last_update_Date, 	  
	   A_LAST_UPDATE_FLAG, 
        HomePhone, 
	   MailPhone, 
	   BusinessPhone)
    AS (SELECT m.uhc_subscriber_id, 
	  mbr.A_MSTR_MRN AS MRN,
	  1 As CLIentKey,
       m.A_Last_update_Date, 	  
	  m.A_LAST_UPDATE_FLAG, 
       adw.AceCleanPhoneNumber(m.MEMBER_HOME_PHONE) AS HomePhone,
	  adw.AceCleanPhoneNumber(m.MEMBER_MAIL_PHONE) AS MailPhone, 
	  adw.AceCleanPhoneNumber(m.MEMBER_BUS_PHONE)  AS BusinessPhone
    FROM dbo.UHC_MembersByPcp m
	   JOIN (SELECT m.uhc_subscriber_id, MAX(m.A_Last_update_Date) MaxLastUpDate
			 FROM dbo.UHC_MembersByPcp m
				JOIN dbo.vw_UHC_ActiveMembers am  ON m.UHC_SUBSCRIBER_ID = am.UHC_SUBSCRIBER_ID
				GROUP BY m.UHC_SUBSCRIBER_ID) MaxMemRec 
		  ON m.UHC_SUBSCRIBER_ID = MaxMemRec.UHC_SUBSCRIBER_ID
			 AND m.A_Last_Update_Date = MaxMemRec.MaxLastUpDate
	   JOIN adw.A_Mbr_Members mbr ON MaxMemRec.UHC_SUBSCRIBER_ID = mbr.Client_Member_ID
		  and 1 = mbr.A_Client_ID
			 )    
    SELECT ph.Uhc_Subscriber_ID AS CLIENT_PATIENT_ID
	   , ph.ClientKey AS A_Client_ID
	   , ph.ACE_ID
	   , ph.PHONE AS MOBILE_PHONE
	   , vPhones.ClientMemberKey ScrubbedMemberId
	   , vPhones.phoneNumber ScrubbedPhoneNumber
    FROM (SELECT h.uhc_subscriber_id, h.ClientKey AS ClientKey, h.MRN AS Ace_ID, h.HomePhone AS Phone
			 , CASE WHEN (SUBSTRING(h.HomePhone,1,1) = '1') THEN h.HomePhone
				    ELSE '1'+h.HomePhone END AS  MatchPhone
		  FROM CTE_GetUhcPhones H
		  WHERE isnull(h.HomePhone, '') <> ''
		UNION ALL
		  SELECT h.uhc_subscriber_id, h.ClientKey AS ClientKey, h.MRN AS Ace_ID, h.MailPhone
			 , CASE WHEN (SUBSTRING(h.MailPhone,1,1) = '1') THEN h.MailPhone
				    ELSE '1'+h.MailPhone END AS  MatchPhone
		  FROM CTE_GetUhcPhones H
		  WHERE isnull(h.MailPhone, '') <> ''
		UNION ALL
		  SELECT h.uhc_subscriber_id, h.ClientKey AS ClientKey, h.MRN AS Ace_ID, h.BusinessPhone
			 , CASE WHEN (SUBSTRING(h.BusinessPhone,1,1) = '1') THEN h.BusinessPhone
				    ELSE '1'+h.BusinessPhone END AS  MatchPhone
		  FROM CTE_GetUhcPhones H
		  WHERE isnull(h.BusinessPhone, '') <> ''
		  ) ph
    JOIN adw.A_LIST_Clients c ON ph.ClientKey = c.A_Client_ID
    JOIN adw.A_Mbr_Members mbr ON ph.uhc_subscriber_id= mbr.Client_Member_ID
    LEFT JOIN (SELECT ClientMemberKey, phoneNumber
			 FROM adi.MPulsePhoneScrubbed) vPhones 
        		ON ph.UHC_SUBSCRIBER_ID = vPhones.ClientMemberKey
    			 AND (ph.Phone = vPhones.phoneNumber 
				OR ph.MatchPhone = vPhones.PhoneNumber)    
    UNION    
    /* Clients from data model */
    
    SELECT DISTINCT
                 s.CLIENT_PATIENT_ID
               , s.ClientKey AS A_Client_ID
               , s.ACE_ID
               , s.MOBILE_PHONE AS MOBILE_PHONE
			, s.ScrubedMemberID
			, s.ScrubbedPhoneNumber

        FROM
        (
            SELECT m.ClientMemberKey AS CLIENT_PATIENT_ID,
                   C.ClientKey,
                   C.ClientShortName,
                   p.mbrMemberKey,
                   m.MstrMrnKey AS ACE_ID,
                   adw.AceCleanPhoneNumber(p.PhoneNumber) AS MOBILE_PHONE,
                   d.FirstName AS FIRST_NAME,
                   d.LastName AS LAST_NAME,
			    PS.ClientMemberKey AS ScrubedMemberID,
			    PS.PhoneNumber AS ScrubbedPhoneNumber
            FROM adw.MbrPhone p
                JOIN adw.MbrMember m
                    ON p.mbrMemberKey = m.mbrMemberKey
                JOIN adw.MbrDemographic d
                    ON m.mbrMemberKey = d.mbrMemberKey
                       AND GETDATE() BETWEEN d.EffectiveDate AND d.ExpirationDate
                JOIN adw.MbrPlan pl
                    ON m.mbrMemberKey = pl.mbrMemberKey
                       AND GETDATE() BETWEEN pl.EffectiveDate AND pl.ExpirationDate
                JOIN lst.List_Client C
                    ON m.ClientKey = C.ClientKey
			 LEFT JOIN adi.MPulsePhoneScrubbed PS ON m.ClientMemberKey = PS.ClientMemberKey
				AND (PS.phoneNumber = '1'+ p.PhoneNumber
					   OR ps.phoneNumber = p.phoneNumber)
            WHERE GETDATE()
            BETWEEN p.EffectiveDate AND p.ExpirationDate
        ) s
    UNION
   /* MSSP */
    SELECT DISTINCT
                 mbr.ClientMemberKey AS CLIENT_PATIENT_ID
               , mbr.ClientKey AS A_Client_ID
               , mbr.Ace_ID
               , adw.AceCleanPhoneNumber(mbr.MemberCellPhone) AS MOBILE_PHONE
			, mbr.ClientMemberKey AS ScrubedMemberID
			, adw.AceCleanPhoneNumber(mbr.MemberCellPhone) AS ScrubbedPhoneNumber
    FROM ACDW_CLMS_SHCN_MSSP.adw.vw_Dashboard_Membership mbr
    WHERE (SELECT MAX(m.RwEffectiveDate) FROM ACDW_CLMS_SHCN_MSSP.adw.vw_Dashboard_Membership m) between mbr.RwEffectiveDate and mbr.RwExpirationDate    
	   AND ISNULL(mbr.MemberCellPhone, '') <> ''
    /* MssP home number */
    UNION
    SELECT DISTINCT
                 mbr.ClientMemberKey AS CLIENT_PATIENT_ID
               , mbr.ClientKey AS A_Client_ID
               , mbr.Ace_ID
               , adw.AceCleanPhoneNumber(mbr.MemberHomePhone) AS MOBILE_PHONE
			, mbr.ClientMemberKey AS ScrubedMemberID
			, adw.AceCleanPhoneNumber(mbr.MemberHomePhone) AS ScrubbedPhoneNumber
    FROM ACDW_CLMS_SHCN_MSSP.adw.vw_Dashboard_Membership mbr
    WHERE (SELECT MAX(m.RwEffectiveDate) FROM ACDW_CLMS_SHCN_MSSP.adw.vw_Dashboard_Membership m) between mbr.RwEffectiveDate and mbr.RwExpirationDate    
	   AND ISNULL(mbr.MemberHomePhone,'') <> ''
    UNION 
    /* BCBS data */
    SELECT DISTINCT
                 mbr.ClientMemberKey AS CLIENT_PATIENT_ID
               , mbr.ClientKey AS A_Client_ID
               , mbr.Ace_ID
               , adw.AceCleanPhoneNumber(mbr.MemberCellPhone) AS MOBILE_PHONE
			, mbr.ClientMemberKey AS ScrubedMemberID
			, adw.AceCleanPhoneNumber(mbr.MemberCellPhone) AS ScrubbedPhoneNumber
    FROM ACDW_CLMS_SHCN_BCBS.adw.vw_Dashboard_Membership mbr
    WHERE (SELECT MAX(m.RwEffectiveDate) FROM ACDW_CLMS_SHCN_BCBS.adw.vw_Dashboard_Membership m) between mbr.RwEffectiveDate and mbr.RwExpirationDate    
	   AND ISNULL(mbr.MemberCellPhone, '') <> ''
    /* MssP home number */
    UNION
    SELECT DISTINCT
                 mbr.ClientMemberKey AS CLIENT_PATIENT_ID
               , mbr.ClientKey AS A_Client_ID
               , mbr.Ace_ID
               , adw.AceCleanPhoneNumber(mbr.MemberHomePhone) AS MOBILE_PHONE
			, mbr.ClientMemberKey AS ScrubedMemberID
			, adw.AceCleanPhoneNumber(mbr.MemberHomePhone) AS ScrubbedPhoneNumber    
    FROM ACDW_CLMS_SHCN_BCBS.adw.vw_Dashboard_Membership mbr
    WHERE (SELECT MAX(m.RwEffectiveDate) FROM ACDW_CLMS_SHCN_BCBS.adw.vw_Dashboard_Membership m) between mbr.RwEffectiveDate and mbr.RwExpirationDate    
	   AND ISNULL(mbr.MemberHomePhone,'') <> ''
    UNION 
    SELECT DISTINCT
                 mbr.ClientMemberKey AS CLIENT_PATIENT_ID
               , mbr.ClientKey AS A_Client_ID
               , mbr.Ace_ID
               , adw.AceCleanPhoneNumber(mbr.MemberPhone) AS MOBILE_PHONE
			, mbr.ClientMemberKey AS ScrubedMemberID
			, adw.AceCleanPhoneNumber(mbr.MemberPhone) AS ScrubbedPhoneNumber
    FROM ACDW_CLMS_SHCN_BCBS.adw.vw_Dashboard_Membership mbr
    WHERE (SELECT MAX(m.RwEffectiveDate) FROM ACDW_CLMS_SHCN_BCBS.adw.vw_Dashboard_Membership m) between mbr.RwEffectiveDate and mbr.RwExpirationDate    
	   AND ISNULL(mbr.MemberPhone,'') <> ''    
    UNION
	SELECT distinct m.ClientMemberKey AS CLIENT_PATIENT_ID
			, m.ClientKey AS A_Client_ID
			, ActiveMbrsAceID.Ace_ID
			, adw.AceCleanPhoneNumber(m.PhoneNumber) MobilePhone
			, '' AS ScrubbedMemberID
			, '' as ScrubbedPhoneNumber			
	FROM ACDW_CLMS_AMGTX_MA.adw.mbrPhone m
		JOIN (SELECT f.Ace_ID, f.ClientMemberKey 
				FROM ACDW_CLMS_AMGTX_MA.adw.FctMembership f 
				WHERE (SELECT MAX(m.RwEffectiveDate) 
						FROM ACDW_CLMS_AMGTX_MA.adw.vw_Dashboard_Membership m) between f.RwEffectiveDate and f.RwExpirationDate    
					AND f.Active = 1
			) ActiveMbrsAceID
			ON m.clientMemberKey = ActiveMbrsAceID.ClientMemberKey
	WHERE LEN(m.PhoneNumber ) >= 10 AND ISNULL(m.PhoneNumber,'') <> '' 
    UNION
    SELECT distinct m.ClientMemberKey AS CLIENT_PATIENT_ID
			, m.ClientKey AS A_Client_ID
			, ActiveMbrsAceID.Ace_ID
			, adw.AceCleanPhoneNumber(m.PhoneNumber) MobilePhone
			, '' AS ScrubbedMemberID
			, '' as ScrubbedPhoneNumber			
	FROM ACDW_CLMS_AMGTX_MCD.adw.mbrPhone m
		JOIN (SELECT f.Ace_ID, f.ClientMemberKey 
				FROM ACDW_CLMS_AMGTX_MCD.adw.FctMembership f 
				WHERE (SELECT MAX(m.RwEffectiveDate) 
						FROM ACDW_CLMS_AMGTX_MCD.adw.vw_Dashboard_Membership m) between f.RwEffectiveDate and f.RwExpirationDate    
					AND f.Active = 1
			) ActiveMbrsAceID
			ON m.clientMemberKey = ActiveMbrsAceID.ClientMemberKey
	WHERE LEN(m.PhoneNumber ) >= 10 AND ISNULL(m.PhoneNumber,'') <> '' 
    
    
    /* New phone scrub source */
    /*
    
    UNION
    
    SELECT distinct s.CLIENT_PATIENT_ID,
            s.ClientKey AS A_Client_ID,       
           s.ACE_ID ,
           adw.AceCleanPhoneNumber(s.MOBILE_PHONE) AS MOBILE_PHONE 
    FROM (SELECT m.ClientMemberKey AS CLIENT_PATIENT_ID,c.ClientKey, c.ClientShortName, p.mbrMemberKey, m.MstrMrnKey AS ACE_ID
    	   , p.PhoneNumber AS MOBILE_PHONE, d.FirstName AS FIRST_NAME, d.LastName AS LAST_NAME
    	   FROM adw.MbrPhone p
    	       JOIN adw.MbrMember m ON p.mbrMemberKey = m.mbrMemberKey
    	       JOIN adw.MbrDemographic d ON m.mbrMemberKey = d.mbrMemberKey
    	   		 AND GETDATE() BETWEEN d.EffectiveDate and d.ExpirationDate
    		  JOIN adw.MbrPlan pl ON m.mbrMemberKey = pl.mbrMemberKey 
    			 AND GETDATE() BETWEEN pl.EffectiveDate and Pl.ExpirationDate
    	       JOIN lst.List_Client C ON m.ClientKey = c.ClientKey 
    	   WHERE GETDATE() BETWEEN p.EffectiveDate and p.ExpirationDate		  		  
        )s
        ) ph 
    WHERE not ph.MOBILE_PHONE is null
        ;
    */
