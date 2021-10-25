

CREATE VIEW [adi].[vw_pdwSrc_MbrUhcMbrByPcp_Address]
/* get addresses */	
AS 
WITH cteMbrPhnAddEmail2 ( ClientMemberKey, AdiKey
			, HomeAdd1,HomeAdd2,HomeCity,HomeState,HomeZip
			, MailAdd1,MailAdd2,MailCity,MailState, MailZip)
	AS (SELECT m.UHC_SUBSCRIBER_ID AS ClientMemberKey, m.mbrMbrByPcpKey, 		  	
				MEMBER_HOME_ADDRESS,MEMBER_HOME_ADDRESS2,MEMBER_HOME_CITY,MEMBER_HOME_STATE,MEMBER_HOME_ZIP,
				MEMBER_MAIL_ADDRESS,MEMBER_MAIL_ADDRESS2,MEMBER_MAIL_CITY,MEMBER_MAIL_STATE,MEMBER_MAIL_ZIP	
			FROM adi.mbrUhcMbrByPcp m
			WHERE m.MbrLoadStatus = 0				
				) 
	SELECT HomeAdd.ClientMemberKey, HomeAdd.AdiKey, AddType.lstAddressTypeKey AS AddTypeKey
		, HomeAdd.HomeAdd1 AS Add1, HomeAdd.HomeAdd2 AS Add2, HomeAdd.HomeCity AddCity, HomeAdd.HomeState AddState, HomeAdd.HomeZip	AddZip		
	FROM cteMbrPhnAddEmail2 HomeAdd
		JOIN (SELECT a.lstAddressTypeKey, a.AddressTypeName, a.AddressTypeCode 
				FROM lst.lstAddressType a 
				) AddType ON AddType.AddressTypeCode = 'H'
	UNION ALL
	SELECT MailAdd.ClientMemberKey, MailAdd.AdiKey, AddType.lstAddressTypeKey AS AddTypeKey
		, MailAdd.MailAdd1 AS Add1, MailAdd.MailAdd2 AS Add2, MailAdd.MailCity AddCity, MailAdd.MailState AddState, MailAdd.HomeZip	AddZip		
	FROM cteMbrPhnAddEmail2 MailAdd
		JOIN (SELECT a.lstAddressTypeKey, a.AddressTypeName, a.AddressTypeCode 
				FROM lst.lstAddressType a 
				) AddType ON AddType.AddressTypeCode = 'M';
