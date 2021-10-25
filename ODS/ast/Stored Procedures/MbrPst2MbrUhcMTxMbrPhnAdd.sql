
CREATE PROCEDURE [ast].[MbrPst2MbrUhcMTxMbrPhnAdd]
    (@loadDate DATE
    , @InsertCount INT OUTPUT)
AS	
/* this function loads 
    Phones
    , Addresses
    , Emails 
    into seperate rows. 
    they will have to be validated and exported individually.
    */
DECLARE @adiLoadDate DATE = @LoadDate;
DECLARE @LoadType CHAR(1) = 'P';


DECLARE @OutputTbl TABLE (ActionType VARCHAR(50), ID INT);
/* 2 load  */
    /* load to staging home phone/address */
    MERGE ast.MbrStg2_PhoneAddEmail trg
    USING(SELECT phnAdd.ClientMemberKey, phnAdd.SrcFileName, phnAdd.LoadType,  phnAdd.LoadDate,  phnAdd.DataDate
    	   , phnAdd.AdiTableName, phnAdd.AdiKey, phnAdd.PhoneNumber, phnAdd.lstPhoneTypeKey, phnAdd.PhoneCarrierType, phnAdd.PhoneIsPrimary
    	   , phnAdd.AddressTypeKey, phnAdd.MEMB_ADDRESS_LINE_1 AddAddress1, phnAdd.MEMB_ADDRESS_LINE_2 AS [AddAddress2], phnAdd.MEMB_CITY AddCity, phnAdd.MEMB_STATE AddState
    		  , phnAdd.MEMB_ZIP AddZip, '' AS AddCounty
    	   , 0 as lstEmailTypeKey, '' AS EmailAddress, 0 AS EmailIsPrimary
    	   , phnAdd.StgRowStatus, phnAdd.ClientKey
        FROM (SELECT mbr.[SUBSCRIBER_ID] ClientMemberKey, mbr.[SrcFileName], 'P' AS LoadType, mbr.[LoadDate], mbr.[DataDate]
    		  , 'adi.mbrUhcMbrByProvider' AS adiTableName, mbr.[UHCMbrMbrByProviderKey] AS adiKey
    		  , HomePhone.lstPhoneTypeKey LstPhoneTYpeKey, mbr.[HOME_PHONE_NUMBER] AS PhoneNumber
    		  , 5 AS PhoneCarrierType, 0 AS PhoneIsPrimary
    		  , 1 AS AddressTypeKey, mbr.[MEMB_ADDRESS_LINE_1]  , mbr.[MEMB_ADDRESS_LINE_2] , mbr.[MEMB_CITY], mbr.[MEMB_STATE], mbr.[MEMB_ZIP]
    		  , 'Loaded' AS stgRowStatus, 1 AS ClientKey
    	   FROM adi.mbrUhcMbrByProvider mbr
    		  JOIN (SELECT pt.lstPhoneTypeKey, pt.PhoneTypeName       
    				FROM lst.lstPhoneType pt
    				WHERE pt.PhoneTypeCode = 'H' 
    				) HomePhone ON 1=1
    	   WHERE mbr.MbrLoadStatus = 0
    		  AND mbr.HOME_PHONE_NUMBER <> '') AS phnAdd
    		  /* Joining to MbrStg, lets the provider tin business rule apply here with out the check */
    	JOIN (SELECT mbrStg.ClientSubscriberId , mbrStg.LoadDate, mbrStg.stgRowStatus
    		  FROM ast.MbrStg2_MbrData MbrStg 
    		  WHERE MbrStg.ClientKey = 1
    			 and mbrStg.stgRowStatus IN ('Loaded', 'VALID')
    	   ) AS MbrStg ON phnAdd.ClientMemberKey = MbrStg.ClientSubscriberId	   
        JOIN lst.List_Client AS C ON c.ClientKey = phnAdd.ClientKey        
        	) src
    ON trg.ClientMemberKey = src.ClientMemberKey
        and trg.SrcFileName = src.srcFileName
        and trg.LoadDate = src.LoadDate
    WHEN NOT MATCHED THEN 
	   INSERT ([ClientMemberKey],[SrcFileName],[LoadType],[LoadDate],[DataDate]
	          ,[AdiTableName],[AdiKey],[PhoneNumber], lstPhoneTypeKey, PhoneCarrierType, PhoneIsPrimary
	   	   , lstAddressTypeKey, AddAddress1, [AddAddress2], [AddCity],[AddState],[AddZip],[AddCounty]
	   	   , lstEmailTypeKey,EmailAddress, EmailIsPrimary
	   	   , stgRowStatus, clientKey)
	   VALUES (src.[ClientMemberKey],src.[SrcFileName],src.[LoadType],src.[LoadDate],src.[DataDate]
	           , src.[AdiTableName],src.[AdiKey],src.[PhoneNumber], src.lstPhoneTypeKey, src.PhoneCarrierType, src.PhoneIsPrimary
	   	  , src.AddressTypeKey, src.AddAddress1, src.[AddAddress2], src.[AddCity],src.[AddState],src.[AddZip],src.[AddCounty]
	   	  , src.lstEmailTypeKey,src.EmailAddress, src.EmailIsPrimary
	   	  , src.stgRowStatus, src.clientKey)
	   OUTPUT $Action, Inserted.mbrStg2_PhoneAddEmailUrn INTO @OutputTbl
    ;
    /* load business Address/phone */
    MERGE ast.MbrStg2_PhoneAddEmail trg
    USING(SELECT phnAdd.ClientMemberKey, phnAdd.SrcFileName, phnAdd.LoadType,  phnAdd.LoadDate,  phnAdd.DataDate
    	   , phnAdd.AdiTableName, phnAdd.AdiKey, phnAdd.PhoneNumber, phnAdd.lstPhoneTypeKey, phnAdd.PhoneCarrierType, phnAdd.PhoneIsPrimary
    	   , 0 AS AddressTypeKey, '' AddAddress1, '' AS [AddAddress2], '' AS AddCity, '' AS  AddState, '' AS AddZip, '' AS AddCounty
    	   , 0 as lstEmailTypeKey, '' AS EmailAddress, 0 AS EmailIsPrimary
    	   , phnAdd.StgRowStatus, phnAdd.ClientKey
        FROM (SELECT mbr.[SUBSCRIBER_ID] AS ClientMemberKey, mbr.[SrcFileName], 'P' AS LoadType, mbr.[LoadDate], mbr.[DataDate]
		  , 'adi.mbrUhcMbrByProvider' AS adiTableName, mbr.[UHCMbrMbrByProviderKey] AS adiKey
		  , WorkPhone.lstPhoneTypeKey , mbr.[BUS_PHONE_NUMBER] AS PhoneNumber
		  , 5 AS PhoneCarrierType, 0 AS PhoneIsPrimary		  , 'Loaded' AS stgRowStatus, 1 AS ClientKey
	   FROM adi.mbrUhcMbrByProvider mbr    
		  JOIN (SELECT pt.lstPhoneTypeKey, pt.PhoneTypeName       
				FROM lst.lstPhoneType pt
				WHERE pt.PhoneTypeCode = 'W' 
			 ) WorkPhone ON 1 = 1
	   WHERE mbr.MbrLoadStatus = 0
		  AND mbr.BUS_PHONE_NUMBER <> ''
	   ) AS phnAdd
    	/* Joining to MbrStg, lets the provider tin business rule apply here with out the check */
    	JOIN (SELECT mbrStg.ClientSubscriberId , mbrStg.LoadDate, mbrStg.stgRowStatus
    		  FROM ast.MbrStg2_MbrData MbrStg 
    		  WHERE MbrStg.ClientKey = 1
    			 and mbrStg.stgRowStatus IN ('Loaded', 'VALID')
    	   ) AS MbrStg ON phnAdd.ClientMemberKey = MbrStg.ClientSubscriberId	   
        JOIN lst.List_Client AS C ON c.ClientKey = phnAdd.ClientKey
        	) src
    ON trg.ClientMemberKey = src.ClientMemberKey
        and trg.SrcFileName = src.srcFileName
        and trg.LoadDate = src.LoadDate
    WHEN NOT MATCHED THEN 
	   INSERT ([ClientMemberKey],[SrcFileName],[LoadType],[LoadDate],[DataDate]
	          ,[AdiTableName],[AdiKey],[PhoneNumber], lstPhoneTypeKey, PhoneCarrierType, PhoneIsPrimary
	   	   , lstAddressTypeKey, AddAddress1, [AddAddress2], [AddCity],[AddState],[AddZip],[AddCounty]
	   	   , lstEmailTypeKey,EmailAddress, EmailIsPrimary
	   	   , stgRowStatus, clientKey)
	   VALUES (src.[ClientMemberKey],src.[SrcFileName],src.[LoadType],src.[LoadDate],src.[DataDate]
	           , src.[AdiTableName],src.[AdiKey],src.[PhoneNumber], src.lstPhoneTypeKey, src.PhoneCarrierType, src.PhoneIsPrimary
	   	  , src.AddressTypeKey, src.AddAddress1, src.[AddAddress2], src.[AddCity],src.[AddState],src.[AddZip],src.[AddCounty]
	   	  , src.lstEmailTypeKey,src.EmailAddress, src.EmailIsPrimary
	   	  , src.stgRowStatus, src.clientKey)
	OUTPUT $Action, Inserted.mbrStg2_PhoneAddEmailUrn INTO @OutputTbl
    ;


    
SELECT @InsertCount = COUNT(ID) 
FROM @OutputTbl

;