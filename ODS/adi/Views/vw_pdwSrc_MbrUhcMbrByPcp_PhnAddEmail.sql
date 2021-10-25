

CREATE VIEW [adi].[vw_pdwSrc_MbrUhcMbrByPcp_PhnAddEmail]
AS
--	[mbrStg2_PhoneAddEmailUrn] [int] IDENTITY(1,1) NOT NULL,

    -- get phones 
     SELECT 
            m.UHC_SUBSCRIBER_ID AS ClientMemberKey, 		  	--	[ClientMemberKey] [varchar](50) NULL,								
			uphones.PhoneTypeKey,
			uphones.PhoneNumber,
			'' AS [PhoneCarrierType] ,
			'' AS [PhoneIsPrimary] ,
			0 AS AddTypeKey,
			'' AS Add1,
			'' AS Add2, 
			'' AS AddCity,
			'' AS AddState,
			'' AS AddZip, 
			'' AS County,
			0 AS EmailTypeKey, 
			'' AS EmailTypeName,
			'' AS EMAIL,	
			'' AS EmailIsPrimary,	
			lc.ClientKey,	
			'adi.MbrUhcMbrByPcp' AS	AdiTableName,				
			m.SourceFileName AS SrcFileName,									
			m.mbrMbrByPcpKey AS AdiKey,
            --m.InQuarantine, 
            m.LoadType,											
            m.LoadDate,											
            m.DataDate              							            
			,'Loaded' AS stgRowStatus
			, m.PCP_PRACTICE_TIN 
     FROM adi.MbrUhcMbrByPcp m
		JOIN lst.List_Client lc ON 1 = lc.ClientKey          
		LEFT JOIN adi.vw_pdwSrc_MbrUhcMbrByPcp_Phones uPhones ON m.mbrMbrByPcpKey = uPhones.AdiKey 		
	 WHERE ISNULL(uPhones.PhoneNumber,'') <> ''
    UNION ALL -- Addresses
	   SELECT 
            m.UHC_SUBSCRIBER_ID AS ClientMemberKey, 		  	--	[ClientMemberKey] [varchar](50) NULL,									
			0 AS PhoneTypeKey,
			'' AS PhoneNumber,
			'' AS [PhoneCarrierType] ,
			'' AS [PhoneIsPrimary] ,
			uAddress.AddTypeKey,
			uAddress.Add1,
			uAddress.Add2, 
			uAddress.AddCity,
			uAddress.AddState,
			uAddress.AddZip, 
			m.MEMBER_COUNTY AS County,
			0 AS EmailTypeKey, 
			'' AS EmailTypeName,
			'' AS EMAIL,	
			'' AS EmailIsPrimary,	
			lc.ClientKey,	
			'adi.MbrUhcMbrByPcp' AS	AdiTableName,				
			m.SourceFileName AS SrcFileName,									
			m.mbrMbrByPcpKey AS AdiKey,
            --m.InQuarantine, 
            m.LoadType,											
            m.LoadDate,											
            m.DataDate              							            
			,'Loaded' AS stgRowStatus
			, m.PCP_PRACTICE_TIN
     FROM adi.MbrUhcMbrByPcp m
		JOIN lst.List_Client lc ON 1 = lc.ClientKey          		
		LEFT JOIN adi.vw_pdwSrc_MbrUhcMbrByPcp_Address uAddress ON m.mbrMbrByPcpKey = uAddress.AdiKey		
     WHERE uAddress.add1 <> ''
    UNION  ALL -- Email
	   SELECT 
            m.UHC_SUBSCRIBER_ID AS ClientMemberKey, 		  	--	[ClientMemberKey] [varchar](50) NULL,									
			0 AS PhoneTypeKey,
			'' AS PhoneNumber,
			'' AS [PhoneCarrierType] ,
			'' AS [PhoneIsPrimary] ,
			0 AS AddTypeKey,
			'' AS Add1,
			'' AS Add2, 
			'' AS AddCity,
			'' AS AddState,
			'' AS AddZip, 
			'' AS County,
			EmailType.lstEmailTypeKey AS EmailTypeKey, 
			EmailType.EmailTypeName,
			m.MEMBER_EMail AS EMAIL,	
			'' AS EmailIsPrimary,	
			lc.ClientKey,	
			'adi.MbrUhcMbrByPcp' AS	AdiTableName,				
			m.SourceFileName AS SrcFileName,									
			m.mbrMbrByPcpKey AS AdiKey,
            --m.InQuarantine, 
            m.LoadType,											
            m.LoadDate,											
            m.DataDate              							            
			,'Loaded' AS stgRowStatus
			, m.PCP_PRACTICE_TIN
     FROM adi.MbrUhcMbrByPcp m
		JOIN lst.List_Client lc ON 1 = lc.ClientKey
		LEFT JOIN (SELECT Email.mbrMbrByPcpKey AS AdiKey, Email.UHC_SUBSCRIBER_ID, Email.MEMBER_EMail 
				    FROM adi.mbrUhcMbrByPcp Email
				    WHERE ISNULL(Email.MEMBER_EMail, '')  <> ''
					   and Email.MbrLoadStatus = 0) AS uEmail ON m.mbrMbrByPcpKey = uEmail.AdiKey		          		
		JOIN (SELECT e.lstEmailTypeKey, e.EmailTypeCode, e.EmailTypeName FROM lst.lstEmailType e ) EmailType 
			ON EmailType.EmailTypeCode = 'D'
    WHERE ISNULL(m.MEMBER_EMail , '') <> '' 
	   AND m.MbrLoadStatus = 0
