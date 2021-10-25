
CREATE PROCEDURE [ast].[MbrPst2MbrUhcMTxMbrPhnAdd_V0]
    (@loadDate DATE
    , @LoadType CHAR(1)
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

IF @LoadType NOT IN ('S','P') 
    raiserror('Ace ETL Error: Mbr Load terminated. @LoadType not a valid value.', 20, -1) with log;

DECLARE @OutputTbl TABLE (ActionType VARCHAR(50), ID INT);

MERGE ast.MbrStg2_PhoneAddEmail trg
USING(SELECT phnAdd.ClientMemberKey, phnAdd.SrcFileName, phnAdd.LoadType,  phnAdd.LoadDate,  phnAdd.DataDate
	   , phnAdd.AdiTableName, phnAdd.AdiKey, phnAdd.PhoneNumber, phnAdd.PhoneTypeKey AS lstPhoneTypeKey, phnAdd.PhoneCarrierType, phnAdd.PhoneIsPrimary
	   , phnAdd.AddTypeKey AS lstAddressTypeKey, phnAdd.Add1 AddAddress1, phnAdd.Add2 AS [AddAddress2], phnAdd.AddCity, phnAdd.AddState, phnAdd.AddZip, phnAdd.County AS [AddCounty]
	   , phnAdd.EmailTypeKey as lstEmailTypeKey, phnAdd.EMAIL AS EmailAddress, phnAdd.EmailIsPrimary
	   , phnAdd.StgRowStatus, phnAdd.ClientKey
    FROM adi.vw_pdwSrc_MbrUhcMbrByPcp_PhnAddEmail phnAdd
	   /* Joining to MbrStg, lets the provider tin business rule apply here with out the check */
	   JOIN (SELECT mbrStg.ClientSubscriberId , mbrStg.LoadDate, mbrStg.stgRowStatus
			 FROM ast.MbrStg2_MbrData MbrStg 
			 WHERE MbrStg.ClientKey = 1
				and mbrStg.stgRowStatus IN ('Loaded', 'VALID')) AS MbrStg
	      ON phnAdd.ClientMemberKey = MbrStg.ClientSubscriberId	   
	   JOIN lst.List_Client c ON c.ClientKey = phnAdd.ClientKey        
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
		  , src.lstAddressTypeKey, src.AddAddress1, src.[AddAddress2], src.[AddCity],src.[AddState],src.[AddZip],src.[AddCounty]
		  , src.lstEmailTypeKey,src.EmailAddress, src.EmailIsPrimary
		  , src.stgRowStatus, src.clientKey)
    OUTPUT $Action, Inserted.mbrStg2_PhoneAddEmailUrn INTO @OutputTbl
    ;
    
SELECT @InsertCount = COUNT(ID) 
FROM @OutputTbl;