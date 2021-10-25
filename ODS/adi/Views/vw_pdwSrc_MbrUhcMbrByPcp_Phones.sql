
CREATE VIEW [adi].[vw_pdwSrc_MbrUhcMbrByPcp_Phones]
/* get phones */
AS 

    WITH cteMbrPhnAddEmail ( ClientMemberKey, AdiKey, HomePhone, MailPhone, BusPhone)
    	AS (SELECT src.ClientMemberKey, src.mbrMbrByPcpKey, src.HomePhone, src.MailPhone, src.BusPhone
    		FROM (SELECT m.mbrMbrByPcpKey, m.UHC_SUBSCRIBER_ID AS ClientMemberKey, 		  	
    					ISNULL(m.MEMBER_HOME_PHONE, '') HomePhone, 
    					ISNULL(m.MEMBER_MAIL_PHONE, '') MailPhone,
    					ISNULL(m.MEMBER_BUS_PHONE , '') BusPhone				
    				
    				FROM adi.mbrUhcMbrByPcp m
				WHERE m.MbrLoadStatus = 0    					
    				) src		
    	) 
    
    SELECT home.ClientMemberKey, home.AdiKey, HomePhone.lstPhoneTypeKey AS PhoneTypeKey, home.HomePhone AS PhoneNumber
    FROM cteMbrPhnAddEmail home
    	JOIN 	(SELECT p.lstPhoneTypeKey, p.PhoneTypeCode, p.PhoneTypeName 
    				FROM lst.lstPhoneType p 
    				) AS HomePhone ON HomePhone.PhoneTypeCode = 'H'
    WHERE home.HomePhone <> ''
    UNION ALL 
    SELECT mail.ClientMemberKey, mail.AdiKey, MailPhone.lstPhoneTypeKey AS PhoneTypeKey, mail.MailPhone AS PhoneNumber
    FROM cteMbrPhnAddEmail mail
    	JOIN 	(SELECT p.lstPhoneTypeKey, p.PhoneTypeCode, p.PhoneTypeName 
    				FROM lst.lstPhoneType p 
    				) AS MailPhone ON MailPhone.PhoneTypeCode = 'M'
    WHERE mail.MailPhone <> ''    
    UNION ALL 
    SELECT bus.ClientMemberKey, bus.AdiKey, BusPhone.lstPhoneTypeKey AS PhoneTypeKey, bus.BusPhone AS PhoneNumber
    FROM cteMbrPhnAddEmail bus
    	JOIN 	(SELECT p.lstPhoneTypeKey, p.PhoneTypeCode, p.PhoneTypeName 
    				FROM lst.lstPhoneType p 
    				) AS BusPhone ON BusPhone.PhoneTypeCode = 'W'
    WHERE bus.BusPhone <> ''	    
;
