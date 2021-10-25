CREATE VIEW dbo.vw_Mpulse_Get_MemberPhones
AS
SELECT 
    mbrs.clientKey, mbrs.Ace_ID, mbrs.CLIENT_SUBSCRIBER_ID
	   
	   , scrubbedPhone.phoneNumber 
FROM dbo.vw_ActiveMembers mbrs
    LEFT JOIN (SELECT src.ClientMemberKey, src.ClientKey, src.phoneNumber, src.carrier_type
		  FROM (SELECT clientmemberKey, Client_id ClientKey, pHoneNUmber, carrier_type, LoadDate
				, ROW_NUMBER() OVER(PARTITION BY clientmemberKey, Client_id, pHoneNUmber ORDER BY LoadDate DESC) ARowNumber
				FROM adi.MPulsePhoneScrubbed
				) SRC
		  WHERE SRC.ARowNumber = 1
			 and NOT PHoneNUmber IS NULL
			 AND src.carrier_type = 'Mobile'
			 )scrubbedPhone
	   ON mbrs.CLIENT_SUBSCRIBER_ID = scrubbedPhone.ClientMemberKey
WHERE NOT scrubbedPhone.phoneNumber is null

    
