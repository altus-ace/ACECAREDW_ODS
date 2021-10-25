CREATE PROCEDURE [adw].[PdwMbr_04_LoadPhone]
    @loadDate DATE , 
    @LoadType VARCHAR(1),
    @ClientKey INT, 
    @InsertCount INT OUTPUT,
    @UpdateCount INT OUTPUT
AS   
    DECLARE @ExpirationDate DATE = '12/31/2099';
    /* SET UP OUTPUT TABLE */
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

    IF OBJECT_ID('tempdb..#mbrPhoneLoad') IS NOT NULL 
        DROP TABLE #mbrPhoneLoad;
    CREATE TABLE #mbrPhoneLoad (mbrLoadHistoryKey INT, mbrMemberKey INT, MbrPhoneKey INT
        , curPhone VARCHAR(30), curPhoneType INT, curCarrierType INT, curEffectiveDate DATE, curExpirationDate DATE
	   , newPhone VARCHAR(30), newPhoneType INT, newCarrierType INT, newEffectiveDate DATE, newExpirationDate DATE
	   , LoadType CHAR(1), DataDate DATE, loadDate DATE);
   
    /* LOAD WORKING SET */
    INSERT INTO #mbrPhoneLoad(
	   mbrLoadHistoryKey, mbrMemberKey, MbrPhoneKey
		  , curPhone, curPhoneType, curCarrierType, curEffectiveDate, curExpirationDate 
		  , newPhone, newPhoneType, newCarrierType, newEffectiveDate, newExpirationDate 
		  , LoadType, DataDate, loadDate)	   
    OUTPUT inserted.MbrPhoneKey, 1 INTO @OutputTbl(ID, OutputType)  
    SELECT lh.mbrLoadHistoryKey, mbr.MbrMemberKey, p.mbrPhoneKey
           , p.PhoneNumber, p.PhoneType, p.CarrierType, p.EffectiveDate, p.ExpirationDate
	      , m.PhoneNum, m.lstPhoneTypeKey, (SELECT lstPhoneCarrierTypeKey FROM lst.lstPhoneCarrierType WHERE PhoneCarrierTypeCode = 'NK') NewCarrierType
   		 , CASE WHEN (m.LoadType = 'P') 
   			 THEN CONVERT(DATE, DATEADD(DAY, (-1*DATEPART(day,@LoadDate)+1), @LoadDate)) 
   			 ELSE @LoadDate 
   			 END as newEffectiveDate, @ExpirationDate AS newExpirationDate 
           , @LoadType, m.DataDate, m.LoadDate
       FROM (SELECT p.ClientMemberKey, p.SrcFileName,p.LoadType,p.LoadDate,p.DataDate,p.AdiTableName,p.AdiKey
   	   		,adw.AceCleanPhoneNumber(PhoneNumber) PhoneNum, pt.lstPhoneTypeKey   	       
		  FROM ast.MbrStg2_PhoneAddEmail p
   	   	   JOIN lst.lstPhoneType pt ON p.lstPhoneTypeKey = pt.lstPhoneTypeKey
   	       WHERE isNULL(adw.AceCleanPhoneNumber(PhoneNumber), '') <> ''
				AND p.LoadDate = @LoadDate
				AND p.ClientKey = @ClientKey
				AND p.stgRowStatus = 'Valid'
		  ) AS m
           LEFT JOIN adw.MbrLoadHistory Lh ON m.adiKey = lh.AdiKey AND m.AdiTableName = lh.AdiTableName
           JOIN adw.MbrMember mbr ON m.ClientMemberKey = mbr.ClientMemberKey    
           LEFT JOIN adw.MbrPhone p ON mbr.MbrMemberKey = p.MbrMemberKey
       				AND GETDATE() BETWEEN p.EffectiveDate AND p.ExpirationDate
       				AND p.PhoneType = m.lstPhoneTypeKey
       WHERE m.LoadDate = @loadDate	   
   	   AND ISNULL(m.PhoneNum, '') <> ''
	   ;
	
	/* INSERT NEW ROWS: WHERE MbrPhoneKey is null and PHONE NUMBER IS VALID */
    INSERT INTO [adw].[MbrPhone]
               ([MbrMemberKey]
               ,[MbrLoadKey]
               ,[EffectiveDate]
               ,[ExpirationDate]
               ,[PhoneType]
			,[CarrierType]
               ,[PhoneNumber]
               ,[LoadDate]
               ,[DataDate])		 
    OUTPUT inserted.mbrPhoneKey, 2 INTO @OutputTbl(ID, OutputType)
    SELECT p.mbrMemberKey
        , p.mbrLoadHistoryKey
        , p.NewEffectiveDate
        , p.NewExpirationDate AS ExpirationDate
        , p.newPhoneType
	   , p.NewcarrierTYpe
        , p.NewPhone
        , GETDATE() AS LoadDate
        , p.DataDate
    FROM #mbrPhoneLoad p
    WHERE p.MbrPhoneKey is null
        AND NOT (p.NewPhone = ''  or p.NewPhone Is null)	   
		
    /* LOAD VERSION SET */
	   /* if phone key is null insert all as new */
        /* when there is a MbrPlanKey, terminate it and Insert New */
    IF OBJECT_ID('tempdb..#mbrPhoneToVersion') IS NOT NULL 
	   DROP TABLE #mbrPhoneToVersion;
    CREATE TABLE #mbrPhoneToVersion (mbrPhoneKey INT);
    INSERT INTO #mbrPhoneToVersion(mbrPhoneKey)   
    OUTPUT inserted.mbrPhoneKey, 3 INTO @OutputTbl(ID, OutputType) 
    SELECT  p.MbrPhoneKey    
    FROM #mbrPhoneLoad p
    WHERE NOT p.MbrPhoneKey is null        
        /* is the phone data different? */
        AND (p.NewPhone <> ISNULL(p.curPhone, '')
		  OR p.newCarrierType <> IsNull(p.curCarrierType, '')
		  );
    
     /* TERM PRIOR RECORD: SET EFFECTIVE DATE = src.EffectiveDate */
    UPDATE adw.MbrPhone
	   SET ExpirationDate = DATEADD(day, -1, src.newEffectiveDate)
    OUTPUT inserted.mbrPhoneKey, 4 INTO @OutputTbl(ID, OutputType)
    FROM adw.MbrPhone m
	   JOIN #mbrPhoneLoad AS src ON src.MbrPhoneKey = m.MbrPhoneKey
	   JOIN #mbrPhoneToVersion AS v ON src.MbrPhoneKey = v.mbrPhoneKey;

    /* INSERT NEW RECORDS: */
    INSERT INTO [adw].[MbrPhone]
           ([MbrMemberKey]
           ,[MbrLoadKey]
           ,[EffectiveDate]
           ,[ExpirationDate]
           ,[PhoneType]
		 ,CarrierType
           ,[PhoneNumber]
           ,[LoadDate]
           ,[DataDate])
    OUTPUT inserted.mbrPhoneKey, 5 INTO @OutputTbl(ID,OutputType)

    SELECT p.mbrMemberKey
        , p.mbrLoadHistoryKey
        , p.NewEffectiveDate
        , p.NewExpirationDate AS ExpirationDate
        , p.NewphoneType
	   , p.newCarrierType
        , p.NewPhone
        , GETDATE() AS LoadDate
        , p.DataDate
    FROM #mbrPhoneLoad p
	   JOIN #mbrPhoneToVersion v ON p.MbrPhoneKey = v.mbrPhoneKey
    WHERE NOT p.MbrPhoneKey is null
        AND NOT ISNULL(p.newPhone, '') = ''  ;

	       
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
