
CREATE PROCEDURE [adw].[z_AcePdwMbrWlcMbrByPcp_05_0025_LoadAddress]
    @LoadDate DATE ,
	@InsertCount INT OUTPUT,
	@UpdateCount INT OUTPUT
AS
    DECLARE @AdiTableName VARCHAR(50) = 'MbrWlcMbrByPcp';    
   /* 10 POC Load Address */
    /* OutPutType: INT 
	   1 = working set insert 
	   2	= Insert New
	   3 = Version working Set
	   4 = Version Term
	   5 = version Insert */
    DECLARE @OutPutType TABLE (OutputType TinyInt, Descrip VARCHAR(30));
    INSERT INTO @OutPutType (OutputType, Descrip)
    VALUES (1,'Working Set insert')
		 ,(2,'Insert New')
		 ,(3,'Version working Set')
		 ,(4,'Version Term')
		 ,(5, 'Version Insert');
    DECLARE @OutputTbl TABLE (ID INT, OutputType INT);
	
    IF OBJECT_ID('dbo.tmpWlcAddress') IS NOT NULL 
        DROP TABLE dbo.tmpWlcAddress;
    CREATE TABLE dbo.tmpWlcAddress (mbrLoadHistoryKey INT, mbrMemberKey INT, MbrAddressKey INT
        , adiAddress1 VARCHAR(100), adiAddress2 VARCHAR(100), adiCity VARCHAR(65), adiState VARCHAR(25)
		  , adiZip VARCHAR(20), adiCounty VARCHAR(65), adiLoadDate DATE, adiDataDate DATE
        , CurAddress1 VARCHAR(100), CurAddress2 VARCHAR(100), CurCity VARCHAR(65), CurState VARCHAR(25)
		  , CurZip VARCHAR(20), CurCounty VARCHAR(65), CurLoadDate DATE, CurDataDate DATE
        , AddressTypeKey INT,  NewExpirationDate DATE);
        
    /* Insert Address */
    INSERT INTO dbo.tmpWlcAddress(mbrLoadHistoryKey, mbrMemberKey, MbrAddressKey
        , adiAddress1, adiAddress2, adiCity, adiState, adiZip, adiCounty, adiLoadDate, adiDataDate
        , CurAddress1, CurAddress2, CurCity, CurState, CurZip, CurCounty, CurLoadDate, CurDataDate
        , AddressTypeKey, NewExpirationDate)
    OUTPUT inserted.MbrAddressKey, 1 INTO @OutputTbl(ID, OutputType)    
    SELECT DISTINCT lh.mbrLoadHistoryKey, mbr.MbrMemberKey, p.mbrAddressKey
        , AdiMbrs.Address, '' AS address2, AdiMbrs.City, AdiMbrs.State
		  , AdiMbrs.Zip, AdiMbrs.County, AdiMbrs.LoadDate, AdiMbrs.DataDate
        , p.Address1, p.Address2, p.CITY, p.STATE, p.ZIP, p.COUNTY, p.LoadDate, p.DataDate
        ,  addMap.MappedTypeKey AS AddressTypeKey, '2099/12/31' AS NewExpirationDate    
    FROM adi.tvf_PdwSrc_Wlc_MemberByPcp( @LoadDate) AdiMbrs
        JOIN adw.MbrLoadHistory Lh ON AdiMbrs.mbrWlcMbrByPcpKey = lh.adiKey and lh.adiTableName = @adiTableName
        JOIN adw.MbrMember mbr ON AdiMbrs.SUB_ID = mbr.ClientMemberKey    
			AND mbr.ClientKey = 2	   
		JOIN (SELECT source, Destination MappedTypeKey, ClientKey 
				FROM lst.ListAceMapping 
				WHERE isActive = 1  and MappingTypeKey = 6 ) AS addMap 
				ON AdiMbrs.Address_TYPE = addMap.Source
					AND addMap.ClientKey = mbr.ClientKey    
        LEFT JOIN adw.MbrAddress p ON mbr.MbrMemberKey = p.MbrMemberKey
    				AND GETDATE() BETWEEN p.EffectiveDate AND p.ExpirationDate
					AND p.AddressTypeKey = addMap.MappedTypeKey	
    --WHERE p.mbrAddressKey is NULL;

    /* Insert Mailing address */				
    /* mailing address included in above set */

    /* if Address key is null insert all as new */
    
    INSERT INTO [adw].[MbrAddress]
               ([MbrMemberKey]
               ,[MbrLoadKey]
               ,[EffectiveDate]
               ,[ExpirationDate]
    			,AddressTypeKey
               ,[Address1],[Address2], [CITY], [STATE], [ZIP], [COUNTY]
               ,[LoadDate]
               ,[DataDate])
    OUTPUT inserted.MbrAddressKey, 2 INTO @OutputTbl(ID, OutputType)
    SELECT p.mbrMemberKey
        , p.mbrLoadHistoryKey
        , p.adiDataDate AS effectiveDate
        , p.NewExpirationDate AS ExpirationDate
        , p.AddressTypeKey
        , p.adiAddress1, p.adiAddress2, p.adiCity, p.adiState, p.adiZip, p.adiCounty
        , GETDATE() AS LoadDate
        , p.adiDataDate
        --, p.NewAddress1, p.NewAddress2, p.NewCity, p.NewState, p.NewZip, p.NewCounty, p.NewLoadDate, p.NewDataDate        
    FROM dbo.tmpWlcAddress p
    WHERE p.MbrAddressKey is null
        AND ISNULL(p.adiAddress1, '') <> '';
    
    /* if MbrAddressKey is Not Null, and phone values are different, replace */

    /* when there is a MbrPlanKey, terminate it and Insert New */
    IF OBJECT_ID('dbo.tmpWlcAddressToVersion') IS NOT NULL 
	   DROP TABLE dbo.tmpWlcAddressToVersion;
    CREATE TABLE dbo.tmpWlcAddressToVersion (mbrAddressKey INT);
    INSERT INTO dbo.tmpWlcAddressToVersion(mbrAddressKey)    
    OUTPUT inserted.MbrAddressKey, 3 INTO @OutputTbl(ID, OutputType)
    SELECT  p.MbrAddressKey
    FROM dbo.tmpWlcAddress p
    WHERE NOT p.MbrAddressKey is null
        AND NOT (p.adiAddress1 = ''  or p.adiAddress1 Is null)
        /* is the phone data different? */
        AND (  ISNULL(p.adiAddress1,'')	    <> ISNULL(p.CurAddress1,'')
		  OR ISNULL(p.adiAddress2,'')	    <> ISNULL(p.CurAddress2,'')
		  OR ISNULL(p.adiCity,'')	    <> ISNULL(p.CurCity,'')
		  OR ISNULL(p.adiState,'')	    <> ISNULL(p.CurState,'')
		  OR ISNULL(p.adiZip,'')		    <> ISNULL(p.CurZip,'')
		  OR ISNULL(p.adiCounty,'')	    <> ISNULL(p.CurCounty,''))
		  ;
    
     /* Updated current */
    UPDATE adw.MbrAddress
	   SET ExpirationDate = DATEADD(day, -1, src.adiDataDate) /* one day less than new effective date */
    OUTPUT inserted.MbrAddressKey, 4 INTO @OutputTbl(ID, OutputType)
    FROM adw.MbrAddress m
	   JOIN dbo.tmpWlcAddress AS src ON src.MbrAddressKey = m.mbrAddressKey
	   JOIN dbo.tmpWlcAddressToVersion AS v ON src.MbrAddressKey = v.mbrAddressKey;

    /* insert new */
    INSERT INTO [adw].[MbrAddress]
               ([MbrMemberKey]
               ,[MbrLoadKey]
               ,[EffectiveDate]
               ,[ExpirationDate]
    			,AddressTypeKey
               ,[Address1],[Address2], [CITY], [STATE], [ZIP], [COUNTY]
               ,[LoadDate]
               ,[DataDate])
    OUTPUT inserted.MbrAddressKey, 5 INTO @OutputTbl(ID, OutputType)
    SELECT p.mbrMemberKey
        , p.mbrLoadHistoryKey
        , p.adiDataDate AS effectiveDate
        , p.NewExpirationDate AS ExpirationDate
        , p.AddressTypeKey
        , p.adiAddress1, p.adiAddress2, p.adiCity, p.adiState, p.adiZip, p.adiCounty
        , GETDATE() AS LoadDate
        , p.adiDataDate
        --, p.NewAddress1, p.NewAddress2, p.NewCity, p.NewState, p.NewZip, p.NewCounty, p.NewLoadDate, p.NewDataDate        
    FROM dbo.tmpWlcAddress p
    	   JOIN dbo.tmpWlcAddressToVersion v ON p.MbrAddressKey = v.mbrAddressKey
    ;
    
    SELECT @InsertCount = COUNT(*) 
    FROM @OutputTbl o
	   JOIN @OutPutType t ON o.OutputType = t.OutputType
    WHERE o.OutputType = 2 
    GROUP BY t.Descrip ;
    
    SELECT @UpdateCount = COUNT(*) 
    FROM @OutputTbl o
	   JOIN @OutPutType t ON o.OutputType = t.OutputType
    WHERE o.OutputType = 5
    GROUP BY t.Descrip ;
    RETURN;
