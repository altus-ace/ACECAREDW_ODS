CREATE PROCEDURE [ast].[MbrPst2MbrWlcTxMbrPhnAdd]
    (@loadDate DATE    
    , @InsertCount INT OUTPUT)
AS	

    DECLARE @adiLoadDate DATE = @LoadDate;    
    DECLARE @ClientKey INT = 2;
    DECLARE @StgRowStatus VARCHAR(10) = 'Loaded';

    DECLARE @OutputTbl TABLE (ActionType VARCHAR(50), ID INT);  


    MERGE ast.MbrStg2_PhoneAddEmail trg
    USING(SELECT AdiMbrs.Sub_ID AS ClientMemberKey, adiMbrs.SrcFileName
			 , adimbrs.LoadDate, AdiMbrs.DataDate, AdiMbrs.AdiTableName, adiMbrs.AdiKey			 
			 , (SELECT lstPhoneTypeKey FROM lst.lstPhoneType WHERE lstPhoneType.PhoneTypeCode = 'H') AS PhoneTypeKey	   
			 , adw.AceCleanPhoneNumber(AdiMbrs.PhoneNumber) PhoneNumber  
			 , (SELECT lstPhoneCarrierTypeKey FROM lst.lstPhoneCarrierType WHERE lstPhoneCarrierType.PhoneCarrierTypeCode = 'NK') AS PhoneCarrierTypeKey
			 , '' As PhoneIsPrimary
			 , '' AddressType, ''AddressTypeKey,''[AddAddress1],''[AddAddress2]
			 , ''[AddCity], ''[AddState],''[AddZip],''[AddCounty], ''[AddCountyCode]
			 , '' [lstEmailTypeKey],''[EmailAddress],''[EmailIsPrimary]    
			 , GETDATE() AS StgLoadDate, System_user AS CreatedUser
			 , @ClientKey AS ClientKey, @StgRowStatus As StgRowStatus        
		  FROM  adi.tvf_PdwSrc_Wlc_MemberByPcp( @LoadDate) AdiMbrs    
		  WHERE ISNULL(adw.AceCleanPhoneNumber(AdiMbrs.PhoneNumber), '') <> ''
		  UNION   /* Mobile Phone */
		  SELECT AdiMbrs.Sub_ID AS ClientMemberKey, adiMbrs.SrcFileName			 
			 , adimbrs.LoadDate, AdiMbrs.DataDate, AdiMbrs.AdiTableName, adiMbrs.AdiKey
			 , (SELECT lstPhoneTypeKey FROM lst.lstPhoneType WHERE lstPhoneType.PhoneTypeCode = 'M') AS PhoneTypeKey	   
			 , adw.AceCleanPhoneNumber(AdiMbrs.MOBILE_PHONE) adiMobilePhone
	   		 , (SELECT lstPhoneCarrierTypeKey FROM lst.lstPhoneCarrierType WHERE lstPhoneCarrierType.PhoneCarrierTypeCode = 'NK') AS PhoneCarrierTypeKey
	   		 , '' As PhoneIsPrimary
	   		 , '' AddressType, ''AddressTypeKey,''[AddAddress1],''[AddAddress2]
	   		 , ''[AddCity], ''[AddState],''[AddZip],''[AddCounty], ''[AddCountyCode]
	   		 , '' [lstEmailTypeKey],''[EmailAddress],''[EmailIsPrimary]    
	   		 , GETDATE() AS StgLoadDate, System_user AS CreatedUser
	   		 , @ClientKey AS ClientKey, @StgRowStatus As StgRowStatus        
	       FROM adi.tvf_PdwSrc_Wlc_MemberByPcp( @LoadDate) AdiMbrs        
	       WHERE ISNULL(adw.AceCleanPhoneNumber(AdiMbrs.MOBILE_PHONE), '') <> ''	   
	       UNION	/* Alternate Phone */
		  SELECT AdiMbrs.Sub_ID AS ClientMemberKey, adiMbrs.SrcFileName 			 
			 , adimbrs.LoadDate, AdiMbrs.DataDate, AdiMbrs.AdiTableName, adiMbrs.AdiKey
			 , (SELECT lstPhoneTypeKey FROM lst.lstPhoneType WHERE lstPhoneType.PhoneTypeCode = 'A') AS PhoneTypeKey	   
			 , adw.AceCleanPhoneNumber(adiMbrs.ALT_PHONE) adiAltPhone
			 , (SELECT lstPhoneCarrierTypeKey FROM lst.lstPhoneCarrierType WHERE lstPhoneCarrierType.PhoneCarrierTypeCode = 'NK') AS PhoneCarrierTypeKey
			 , '' As PhoneIsPrimary
			 , '' AddressType, ''AddressTypeKey,''[AddAddress1],''[AddAddress2]
			 , ''[AddCity], ''[AddState],''[AddZip],''[AddCounty], ''[AddCounttyCode]
			 , '' [lstEmailTypeKey],''[EmailAddress],''[EmailIsPrimary]    
			 , GETDATE() AS StgLoadDate, System_user AS CreatedUser
			 , @ClientKey AS ClientKey , @StgRowStatus As StgRowStatus               
		  FROM adi.tvf_PdwSrc_Wlc_MemberByPcp( @LoadDate) AdiMbrs        
		  WHERE ISNULL(adw.AceCleanPhoneNumber(adiMbrs.ALT_PHONE), '') <> ''
		  UNION /* Addresses */
		  SELECT AdiMbrs.Sub_ID AS ClientMemberKey, adiMbrs.SrcFileName			 
			 , adimbrs.LoadDate, AdiMbrs.DataDate, AdiMbrs.AdiTableName, adiMbrs.AdiKey
			 , ''PhoneTypeKey	   , '' adiPhone, '' PhoneCarrierTypeKey, '' As PhoneIsPrimary
			 , AdiMbrs.ADDRESS_TYPE AddressType, AddressTargetValues.MappedTypeKey AS AddressTypeKey, AdiMbrs.Address AS [AddAddress1],''[AddAddress2]
			 , AdiMbrs.City AS [AddCity], AdiMbrs.State AS [AddState], AdiMbrs.Zip AS [AddZip], AdiMbrs.County AS [AddCounty], ''[AddCountyCode]
			 , '' [lstEmailTypeKey],''[EmailAddress],''[EmailIsPrimary]    
			 , GETDATE() AS StgLoadDate, System_user AS CreatedUser
			 , @ClientKey AS ClientKey    , @StgRowStatus As StgRowStatus                
		  FROM adi.tvf_PdwSrc_Wlc_MemberByPcp( @LoadDate) AdiMbrs			 
			 JOIN (SELECT source, Destination MappedTypeKey, ClientKey 
					   FROM lst.ListAceMapping 
					   WHERE isActive = 1  and MappingTypeKey = 6 
				    ) AS AddressTargetValues
					   ON AdiMbrs.Address_TYPE = AddressTargetValues.Source
						  AND AddressTargetValues.ClientKey = AdiMbrs.ClientKey
		  WHERE ISNULL(AdiMbrs.ADDRESS_TYPE, '') <> ''
		  ) src
    ON trg.ClientMemberKey = src.ClientMemberKey
	   AND trg.ClientKey = src.ClientKey
	   AND trg.LoadDate = src.LoadDate
    WHEN NOT MATCHED THEN 
	   INSERT ([ClientMemberKey],[SrcFileName],[LoadDate],[DataDate]
			 ,[AdiTableName],[AdiKey],[PhoneNumber], lstPhoneTypeKey, PhoneCarrierType, lstAddressTypeKey
			 ,AddAddress1, [AddAddress2], [AddCity],[AddState]
			 ,[AddCounty], [AddZip], stgRowStatus, clientKey)
	   VALUES (src.ClientMemberKey, src.SrcFileName , src.LoadDate, src.DataDate
	   	       , src.adiTableName, src.adiKey, src.PhoneNumber
	   	       , src.PhoneTypeKey, src.PhoneCarrierTypeKey, src.AddressTypeKey
	   	       , src.[AddAddress1], src.[AddAddress2], src.[AddCity], src.[AddState]
	   	       , src.[AddCounty]  , src.[AddZip]  , src.stgRowStatus, src.ClientKey
			  )
    WHEN MATCHED THEN UPDATE
	   SET  trg.[SrcFileName]	= src.SrcFileName 
		  ,trg.[DataDate]		= src.DataDate
		  ,trg.[AdiTableName]	= src.adiTableName
		  ,trg.[AdiKey]		= src.adiKey
		  ,trg.[PhoneNumber]	= src.PhoneNumber
		  ,trg.lstPhoneTypeKey	= src.PhoneTypeKey
		  ,trg.PhoneCarrierType	= src.PhoneCarrierTypeKey
		  ,trg.lstAddressTypeKey	= src.AddressTypeKey
		  ,trg.AddAddress1		= src.[AddAddress1]
		  ,trg.[AddAddress2]	= src.[AddAddress2]
		  ,trg.[AddCity]		= src.[AddCity]
		  ,trg.[AddState]		= src.[AddState]
		  ,trg.[AddCounty]		= src.[AddCounty]  
		  ,trg.[AddZip]		= src.[AddZip]  
		  ,trg.stgRowStatus		= src.stgRowStatus
     OUTPUT $Action, Inserted.mbrStg2_PhoneAddEmailUrn INTO @OutputTbl
    ;
	       
    SELECT @InsertCount = COUNT(ID) 
    FROM @OutputTbl;
