
CREATE VIEW [adw].[zz_vw_MPulse_Exp_PhoneScrub_V1]
AS
    
    SELECT s.CLIENT_PATIENT_ID, s.A_Client_ID, s.ACE_ID, s.MOBILE_PHONE
    FROM (SELECT DISTINCT 
            m.UHC_SUBSCRIBER_ID AS CLIENT_PATIENT_ID,
             1 AS A_Client_ID,
             mbr.A_MSTR_MRN AS ACE_ID,
             adw.AceCleanPhoneNumber(m.MEMBER_HOME_PHONE) AS MOBILE_PHONE    		 
        FROM dbo.UHC_MembersByPCP m    
            JOIN (SELECT m.urn, m.SOURCE_VALUE
        	   FROM dbo.ALT_MAPPING_TABLES m
        	   WHERE m.urn  BETWEEN 61 AND 71) AS s ON m.SUBGRP_ID = s.SOURCE_VALUE
            JOIN adw.A_Mbr_Members mbr ON m.UHC_SUBSCRIBER_ID = mbr.Client_Member_ID
        WHERE m.A_LAST_UPDATE_FLAG = 'Y'
            AND ISNULL(m.MEMBER_HOME_PHONE, '') <> ''
        UNION   
        /* mail*/
        SELECT DISTINCT 
            m.UHC_SUBSCRIBER_ID AS CLIENT_PATIENT_ID,
             1 AS A_Client_ID,
             mbr.A_MSTR_MRN AS ACE_ID,
             adw.AceCleanPhoneNumber(m.MEMBER_MAIL_PHONE) AS MOBILE_PHONE    		     
        FROM dbo.UHC_MembersByPCP m    
            JOIN (SELECT m.urn, m.SOURCE_VALUE
        	   FROM dbo.ALT_MAPPING_TABLES m
        	   WHERE m.urn  BETWEEN 61 AND 71) AS s ON m.SUBGRP_ID = s.SOURCE_VALUE
            JOIN adw.A_Mbr_Members mbr ON m.UHC_SUBSCRIBER_ID = mbr.Client_Member_ID
        WHERE m.A_LAST_UPDATE_FLAG = 'Y'
            AND ISNULL(m.member_mail_Phone, '') <> ''
        UNION
        /* business */
        SELECT DISTINCT 
            m.UHC_SUBSCRIBER_ID AS CLIENT_PATIENT_ID,
             1 AS A_Client_ID,
             mbr.A_MSTR_MRN AS ACE_ID,
             adw.AceCleanPhoneNumber(m.MEMBER_BUS_PHONE) AS MOBILE_PHONE    		 
        FROM dbo.UHC_MembersByPCP m    
            JOIN (SELECT m.urn, m.SOURCE_VALUE
        	   FROM dbo.ALT_MAPPING_TABLES m
        	   WHERE m.urn  BETWEEN 61 AND 71) AS s ON m.SUBGRP_ID = s.SOURCE_VALUE
            JOIN adw.A_Mbr_Members mbr ON m.UHC_SUBSCRIBER_ID = mbr.Client_Member_ID
        WHERE m.A_LAST_UPDATE_FLAG = 'Y'
            AND ISNULL(m.MEMBER_BUS_PHONE, '') <> ''
    	   ) s
    UNION
    /* AET /WLC */
    
    SELECT DISTINCT
               s.CLIENT_PATIENT_ID,
               s.ClientKey AS A_Client_ID,
               s.ACE_ID,
               adw.AceCleanPhoneNumber(s.MOBILE_PHONE) AS MOBILE_PHONE
        FROM
        (
            SELECT m.ClientMemberKey AS CLIENT_PATIENT_ID,
                   C.ClientKey,
                   C.ClientShortName,
                   p.mbrMemberKey,
                   m.MstrMrnKey AS ACE_ID,
                   p.PhoneNumber AS MOBILE_PHONE,
                   d.FirstName AS FIRST_NAME,
                   d.LastName AS LAST_NAME
            FROM adw.MbrPhone p
                JOIN adw.MbrMember m
                    ON p.mbrMemberKey = m.mbrMemberKey
                JOIN adw.MbrDemographic d
                    ON m.mbrMemberKey = d.mbrMemberKey
                       AND GETDATE()
                       BETWEEN d.EffectiveDate AND d.ExpirationDate
                JOIN adw.MbrPlan pl
                    ON m.mbrMemberKey = pl.mbrMemberKey
                       AND GETDATE()
                       BETWEEN pl.EffectiveDate AND pl.ExpirationDate
                JOIN lst.List_Client C
                    ON m.ClientKey = C.ClientKey
            WHERE GETDATE()
            BETWEEN p.EffectiveDate AND p.ExpirationDate
        ) s
    
    UNION
    /* uhc Membership old model */
    SELECT ph.CLIENT_PATIENT_ID, ph.A_Client_ID, ph.ACE_ID, ph.MOBILE_PHONE
    FROM (
    SELECT DISTINCT 
    	  LTRIM(RTRIM(mPhones.UHC_SUBSCRIBER_ID)) AS CLIENT_PATIENT_ID,
           LTRIM(RTRIM(c.A_Client_ID)) AS A_Client_ID,       
           LTRIM(RTRIM(mbr.A_MSTR_MRN)) AS ACE_ID,
           adw.AceCleanPhoneNumber(mPhones.PhoneNumber) AS MOBILE_PHONE 
    	  --,vPhones.phoneNumber AS vPhoneNumber, nvPhones.PhoneNumber AS nvPhoneNumber
    FROM(   /* get Home Phones */
        SELECT hp.UHC_SUBSCRIBER_ID,           
               hp.MEMBER_HOME_PHONE AS PhoneNumber
        FROM (SELECT 
               m.uhc_subscriber_id,
               A_Last_update_Date,
               LTRIM(RTRIM(m.MEMBER_HOME_PHONE)) AS MEMBER_HOME_PHONE,           
               ROW_NUMBER() OVER(PARTITION BY m.UHC_SUBSCRIBER_ID ORDER BY m.A_LAST_UPDATE_DATE DESC) rn
    		FROM dbo.UHC_MembersByPcp m
    		WHERE ISNULL(m.MEMBER_HOME_PHONE, '') <> ''
    	   ) AS hp
        WHERE hp.rn = 1
        UNION
        /* get Mail Phones */
        SELECT mp.UHC_SUBSCRIBER_ID,    
               mp.MEMBER_MAIL_PHONE AS PhoneNumber
        FROM (SELECT 
               m.uhc_subscriber_id,
               A_Last_update_Date,
               LTRIM(RTRIM(m.MEMBER_MAIL_PHONE)) AS MEMBER_MAIL_PHONE,           
               ROW_NUMBER() OVER(PARTITION BY m.UHC_SUBSCRIBER_ID ORDER BY m.A_LAST_UPDATE_DATE DESC) rn
    	     FROM dbo.UHC_MembersByPcp m
    		WHERE ISNULL(m.MEMBER_MAIL_PHONE, '') <> ''
    		  AND NOT TRY_CONVERT( BIGINT, m.MEMBER_MAIL_PHONE) IS NULL
    	   ) AS mp
        WHERE mp.rn = 1
        UNION
        /* get Bus Phones */
        SELECT bp.UHC_SUBSCRIBER_ID,           
               bp.MEMBER_BUS_PHONE AS PhoneNumber           
        FROM (SELECT 
               m.uhc_subscriber_id,
               A_Last_update_Date,
               LTRIM(RTRIM(m.MEMBER_BUS_PHONE)) AS MEMBER_BUS_PHONE,           
               ROW_NUMBER() OVER(PARTITION BY m.UHC_SUBSCRIBER_ID ORDER BY m.A_LAST_UPDATE_DATE DESC) rn
    	     FROM dbo.UHC_MembersByPcp m
    		WHERE ISNULL(m.MEMBER_BUS_PHONE, '') <> ''
    	   ) AS bp
        WHERE bp.rn = 1
        ) AS mPhones
    JOIN adw.A_LIST_Clients c ON 1 = c.A_Client_ID
    JOIN adw.A_Mbr_Members mbr ON mPhones.UHC_SUBSCRIBER_ID = mbr.Client_Member_ID
    LEFT JOIN (SELECT ClientMemberKey, phoneNumber 
    		  FROM AceCareDw_Qa.adi.MPulsePhoneScrubbed) vPhones 
    			 ON mPhones.UHC_SUBSCRIBER_ID = vPhones.ClientMemberKey
    				AND '1'+mPhones.PhoneNumber  = vPhones.phoneNumber
    LEFT JOIN (SELECT ClientMemberKey, phoneNumber 
    		  FROM AceCareDw_Qa.adi.MPulsePhoneScrubbed) nvPhones 
    			 ON mPhones.UHC_SUBSCRIBER_ID = nvPhones.ClientMemberKey
    				AND mPhones.PhoneNumber  = nvPhones.phoneNumber
    WHERE vPhones.phoneNumber is null and nvPhones.phoneNumber is NULL
    ) ph
    
    
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

