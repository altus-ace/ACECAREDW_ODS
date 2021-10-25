CREATE PROCEDURE [ast].[zz_MbrPst2MbrAetMbrPhnAdd_V1]	
    (@loadDate DATE
    , @LoadType CHAR(1)
    , @InsertCount INT OUTPUT)

AS	

DECLARE @AdiTableName VARCHAR(50) = 'MbrAetMbrByPcp';

IF @LoadType NOT IN ('S','P') 
    raiserror('Ace ETL Error: Mbr Load terminated. @LoadType not a valid value.', 20, -1) with log;

DECLARE @OutputTbl TABLE (ID INT);

/* remove any prior staged records */
TRUNCATE TABLE [ast].[MbrStg2_PhoneAddEmail];

INSERT INTO [ast].[MbrStg2_PhoneAddEmail]
           ([ClientMemberKey]
           ,[SrcFileName]
           ,[LoadType]
           ,[LoadDate]
           ,[DataDate]
           ,[AdiTableName]
           ,[AdiKey]
		 ,[lstPhoneTypeKey]
           ,[PhoneNumber]
		 ,lstAddressTypeKey
           ,AddAddress1)
OUTPUT inserted.AdiKey INTO @OutputTbl(ID)
SELECT * 
FROM (select d.AetSubscriberID 
	       , d.SrcFileName 
	       , @LoadType	  AS LoadType
	       , d.LoadDate 
	       , d.DataDate 
	       , @AdiTableName AS adiTableName		  
	       , mbrAetMbrByPcpKey AS adiKey
		  , 1 AS PhoneType
	       , adw.AceCleanPhoneNumber(PhoneNumber) AS PhoneNumber
		  , 1 as AddressType
	       , d.Address AS Address1
	   FROM adi.MbrAetMbrByPcp d
	         /* gk 3/11/2019 Added LOB and TIN expriration support: 
				IF the LOB changes from Medicare Advantage, we will need to fix the Hard coded value
				*/
	   WHERE d.LoadDate = @loadDate  
				/* only check that the TIN IS VALID */
	       --AND d.TIN IN (SELECT vp.TIN  FROM  adw.tvf_GetValidProviderTinsByDate(GETDATE())  vp) 
		  AND d.TIN in (SELECT  TIN --NPI, TIN, EffectiveDate, TermDate, LOB 
					   FROM adw.tvf_GetValidProviderTinsByDate(GETDATE()) 
						  WHERE LOB = 'Medicare Advantage'
							 AND ISNULL(TermDate, '1/1/2099') > GETDATE())					  
    ) src
WHERE ISNULL(src.PhoneNumber, '') <> ''    
ORDER BY aetSubscriberID, LoadDate
;

SELECT @InsertCount = COUNT(ID) 
FROM @OutputTbl;
