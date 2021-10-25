CREATE PROCEDURE [adw].[PdwMbr_05_LoadAddress]
    @LoadDate DATE ,
    @ClientKey INT,
	@InsertCount INT OUTPUT,
	@UpdateCount INT OUTPUT
AS

   declare @ExpirationDate DATE = '12/31/2099';
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

    IF OBJECT_ID('tempdb..#mbrAddress') IS NOT NULL 
        DROP TABLE #mbrAddress;
    CREATE TABLE #mbrAddress (mbrLoadHistoryKey INT, mbrMemberKey INT, MbrAddressKey INT
        , NewAddress1 VARCHAR(100), NewAddress2 VARCHAR(100), NewCity VARCHAR(65), NewState VARCHAR(25), NewAddressTypeKey INT
		  , NewZip VARCHAR(20), NewCounty VARCHAR(65), NewLoadDate DATE, NewDataDate DATE, NewEffective DATE, NewExpiration DATE
        , CurAddress1 VARCHAR(100), CurAddress2 VARCHAR(100), CurCity VARCHAR(65), CurState VARCHAR(25), CurAddressTypeKey INT
		  , CurZip VARCHAR(20), CurCounty VARCHAR(65), CurLoadDate DATE, CurDataDate DATE, CurEffective DATE, CurExpiration DATE
        );
        
    /* Insert Address */
    INSERT INTO #mbrAddress(mbrLoadHistoryKey, mbrMemberKey, MbrAddressKey
        , NewAddress1, NewAddress2, NewCity, NewState, NewAddressTypeKey, NewZip, NewCounty, NewLoadDate, NewDataDate, NewEffective, NewExpiration
        , CurAddress1, CurAddress2, CurCity, CurState, CurAddressTypeKey, CurZip, CurCounty, CurLoadDate, CurDataDate, CurEffective, CurExpiration)
    OUTPUT inserted.MbrAddressKey, 1 INTO @OutputTbl(ID, OutputType)    
    SELECT lh.mbrLoadHistoryKey, mbr.mbrMemberKey, a.MbrAddressKey
            , m.NewAdd1, m.NewAdd2, m.NewCity, m.NewState, m.lstAddressTypeKey, m.NewZip, '' NewCounty, m.LoadDate, m.DataDate
    			 , CASE WHEN (m.LoadType = 'P') 
       				THEN CONVERT(DATE, DATEADD(DAY, (-1*DATEPART(day,@LoadDate)+1), @LoadDate)) 
       				ELSE @LoadDate 
       				END as newEffectiveDate, @ExpirationDate AS newExpirationDate         
    		  , a.Address1, a.Address2, a.CITY, a.STATE, a.AddressTypeKey, a.ZIP, a.COUNTY, a.LoadDate, a.DataDate, a.EffectiveDate, a.ExpirationDate      
    FROM 
    (SELECT m.ClientMemberKey,m.SrcFileName,m.LoadType,m.LoadDate,m.DataDate,m.AdiTableName,m.AdiKey
        ,m.AddAddress1 NewAdd1, m.AddAddress2 NewAdd2,m.AddCity NewCity,m.AddState NewState,m.AddZip NewZip, t.lstAddressTypeKey
    FROM [ast].[MbrStg2_PhoneAddEmail] m
        JOIN lst.lstAddressType t ON m.lstAddressTypeKey = t.lstAddressTypeKey
			 and 'H' = t.AddressTypeCode
    WHERE ISNULL(m.AddAddress1, '') <> ''
	   AND m.LoadDate = @LoadDate
	   AND m.ClientKey = @ClientKey
	   AND m.stgRowStatus = 'Valid'
    UNION
    SELECT m.ClientMemberKey,m.SrcFileName,m.LoadType,m.LoadDate,m.DataDate,m.AdiTableName,m.AdiKey    
        ,m.AddAddress1 NewAdd1, m.AddAddress2 NewAdd2,m.AddCity NewCity,m.AddState NewState,m.AddZip NewZip, t.lstAddressTypeKey
    FROM [ast].[MbrStg2_PhoneAddEmail] m
        JOIN lst.lstAddressType t ON m.lstAddressTypeKey = t.lstAddressTypeKey
			 and 'M' = t.AddressTypeCode
    WHERE ISNULL(m.AddAddress1, '') <> ''       
	   AND m.LoadDate = @LoadDate
	   AND m.ClientKey = @ClientKey
	   AND m.stgRowStatus = 'Valid'
    UNION 
    SELECT m.ClientMemberKey,m.SrcFileName,m.LoadType,m.LoadDate,m.DataDate,m.AdiTableName,m.AdiKey    
        ,m.AddAddress1 NewAdd1, m.AddAddress2 NewAdd2,m.AddCity NewCity,m.AddState NewState,m.AddZip NewZip, t.lstAddressTypeKey
    FROM [ast].[MbrStg2_PhoneAddEmail] m
        JOIN lst.lstAddressType t ON m.lstAddressTypeKey = t.lstAddressTypeKey
			 and 'W' = t.AddressTypeCode
    WHERE ISNULL(m.[AddAddress1], '') <> ''
	   AND m.LoadDate = @LoadDate
	   AND m.ClientKey = @ClientKey
	   AND m.stgRowStatus = 'Valid'
	   )m
     JOIN adw.MbrLoadHistory Lh ON m.adiKey = lh.AdiKey AND m.AdiTableName = lh.AdiTableName
     JOIN adw.MbrMember mbr ON m.ClientMemberKey = mbr.ClientMemberKey    
     LEFT JOIN adw.MbrAddress a ON mbr.MbrMemberKey = a.MbrMemberKey
    			AND GETDATE() BETWEEN a.EffectiveDate AND a.ExpirationDate
    			AND a.AddressTypeKey = m.lstAddressTypeKey

    /* if Address key is null insert all as new */    
    INSERT INTO [adw].[MbrAddress]
               ([MbrMemberKey]
               ,[MbrLoadKey]
               ,[EffectiveDate],[ExpirationDate]
    			,AddressTypeKey
               ,[Address1],[Address2], [CITY], [STATE], [ZIP], [COUNTY]
               ,[LoadDate],[DataDate])
    OUTPUT inserted.MbrAddressKey, 2 INTO @OutputTbl(ID, OutputType)
    SELECT p.mbrMemberKey
        , p.mbrLoadHistoryKey
        , p.NewEffective, p.NewExpiration 
        , p.NewAddressTypeKey
        , p.NewAddress1, p.NewAddress2, p.NewCity, p.NewState, p.NewZip, p.NewCounty
        , GETDATE() AS LoadDate
        , p.NewDataDate    
    FROM #mbrAddress p
    WHERE p.MbrAddressKey is null
        AND ISNULL(p.NewAddress1, '') <> '';
    
    /* if MbrAddressKey is Not Null, and phone values are different, replace */
    /* when there is a MbrAddressKey, terminate it and Insert New */
    IF OBJECT_ID('tempdb..#mbrAddressToVersion') IS NOT NULL 
	   DROP TABLE #mbrAddressToVersion;
    CREATE TABLE #mbrAddressToVersion (mbrAddressKey INT);
    INSERT INTO #mbrAddressToVersion(mbrAddressKey)    
    OUTPUT inserted.MbrAddressKey, 3 INTO @OutputTbl(ID, OutputType)
    SELECT  p.MbrAddressKey
    FROM #mbrAddress p
    WHERE NOT p.MbrAddressKey is null
        AND NOT (p.NewAddress1 = ''  or p.NewAddress1 Is null)
        /* is the phone data different? */
        AND (  ISNULL(p.NewAddress1,'')	    <> ISNULL(p.CurAddress1,'')
		  OR ISNULL(p.NewAddress2,'')	    <> ISNULL(p.CurAddress2,'')
		  OR ISNULL(p.NewCity,'')	    <> ISNULL(p.CurCity,'')
		  OR ISNULL(p.NewState,'')	    <> ISNULL(p.CurState,'')
		  OR ISNULL(p.NewZip,'')		    <> ISNULL(p.CurZip,'')
		  OR ISNULL(p.NewCounty,'')	    <> ISNULL(p.CurCounty,''))
		  ;
    
     /* Updated current */
    UPDATE adw.MbrAddress
	   SET ExpirationDate = DATEADD(day, -1, src.NewEffective) /* one day less than new effective date */
    OUTPUT inserted.MbrAddressKey, 4 INTO @OutputTbl(ID, OutputType)
    FROM adw.MbrAddress m
	   JOIN #mbrAddress AS src ON src.MbrAddressKey = m.mbrAddressKey
	   JOIN #mbrAddressToVersion AS v ON src.MbrAddressKey = v.mbrAddressKey;

    /* insert new */
    INSERT INTO [adw].[MbrAddress]
               ([MbrMemberKey]
               ,[MbrLoadKey]
               ,[EffectiveDate],[ExpirationDate]
    			,AddressTypeKey
               ,[Address1],[Address2], [CITY], [STATE], [ZIP], [COUNTY]
               ,[LoadDate]
               ,[DataDate])
    OUTPUT inserted.MbrAddressKey, 5 INTO @OutputTbl(ID, OutputType)
    SELECT p.mbrMemberKey
        , p.mbrLoadHistoryKey
        , p.NewEffective , p.NewExpiration
        , p.NewAddressTypeKey
        , p.NewAddress1, p.NewAddress2, p.NewCity, p.NewState, p.NewZip, p.NewCounty
        , GETDATE() AS LoadDate
        , p.NewDataDate        
    FROM #mbrAddress p
    	   JOIN #mbrAddressToVersion v ON p.MbrAddressKey = v.mbrAddressKey
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


    SELECT m.mbrMemberKey, m.ClientMemberKey, a.mbrAddressKey, a.AddressTypeKey,a.Address1, a.LoadDate, a.CreatedDate
    FROM adw.MbrMember m
	   JOIN adw.MbrAddress a ON m.mbrMemberKey = a.MbrMemberKey
    where m.ClientKey = 3
    order by m.mbrMemberKey
