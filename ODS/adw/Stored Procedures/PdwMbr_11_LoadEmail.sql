

CREATE PROCEDURE [adw].[PdwMbr_11_LoadEmail]
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

    IF OBJECT_ID('tempdb..#mbrEmail') IS NOT NULL 
        DROP TABLE #mbrEmail;
    CREATE TABLE #mbrEmail (mbrLoadHistoryKey INT, mbrMemberKey INT, MbrEmailKey INT
        , NewEmailType int NULL,NewEmailAddress varchar(100) NULL,	NewIsPrimary tinyint NULL
		  ,NewEffectiveDate date NOT NULL, NewExpirationDate date NOT NULL, NewLoadDate date NOT NULL, NewDataDate date NOT NULL
	   , CurEmailType int NULL,CurEmailAddress varchar(100) NULL,	  CurIsPrimary tinyint NULL
		  ,CurEffectiveDate date NULL, CurExpirationDate date NULL, CurLoadDate date NULL, CurDataDate date NULL
        );

            
    /* Insert Email */
    INSERT INTO #mbrEmail(mbrLoadHistoryKey, mbrMemberKey, MbrEmailKey
        , NewEmailType ,NewEmailAddress ,NewIsPrimary,NewEffectiveDate , NewExpirationDate , NewLoadDate , NewDataDate 
	   , CurEmailType ,CurEmailAddress ,CurIsPrimary,CurEffectiveDate , CurExpirationDate , CurLoadDate , CurDataDate )
    OUTPUT inserted.MbrEmailKey, 1 INTO @OutputTbl(ID, OutputType)    
    SELECT lh.MbrLoadHistoryKey, Mbr.MbrMemberKey, CurEmail.MbrEmailKey
	   , stg.lstEmailTypeKey, stg.EmailAddress, stg.EmailIsPrimary, CONVERT(DATE, DATEADD(DAY, (-1*DATEPART(day,@LoadDate)+1), @LoadDate))  AS NewEffectiveDate
			 , @ExpirationDate AS newExpirationDate, Stg.LoadDate, stg.DataDate
	   , CurEmail.EmailType, CurEmail.EmailAddress, CurEmail.IsPrimary, CurEmail.EffectiveDate
			 , curEmail.ExpirationDate, curEmail.LoadDate, curEmail.DataDate    
    FROm ast.MbrStg2_PhoneAddEmail stg
	   JOIN lst.lstEmailType EmailType ON stg.lstEmailTypeKey = EMailType.lstEmailTypeKey
	   LEFT JOIN adw.MbrLoadHistory Lh ON stg.adiKey = lh.AdiKey AND stg.AdiTableName = lh.AdiTableName
	   JOIN adw.MbrMember mbr ON stg.ClientMemberKey = mbr.ClientMemberKey    
	   LEFT JOIN adw.MbrEmail CurEmail ON mbr.MbrMemberKey = CurEmail.MbrMemberKey
    			AND GETDATE() BETWEEN CurEmail.EffectiveDate AND CurEmail.ExpirationDate
			AND stg.lstEmailTypeKey =  CurEmail.EmailType
    WHERE ISNULL(stg.EmailAddress, '') <> '' AND stg.EmailAddress <> ',' and stg.EmailAddress <> ',1' AND stg.EmailAddress like '%@%'
		  AND stg.LoadDate = @LoadDate
		  AND stg.ClientKey = @ClientKey
		  AND stg.stgRowStatus = 'Valid'
    ;
    
    /* if EMAIL key is null insert all as new */    
    INSERT INTO [adw].MbrEmail
               ([MbrMemberKey]
               ,[MbrLoadKey]
               ,[EffectiveDate],[ExpirationDate]
    			,EmailType
               ,EmailAddress, IsPrimary
               ,[LoadDate],[DataDate])
    OUTPUT inserted.mbrEmailKey, 2 INTO @OutputTbl(ID, OutputType)
    SELECT p.mbrMemberKey
        , p.mbrLoadHistoryKey
        , p.NewEffectiveDate, p.NewExpirationDate 
        , p.NewEmailType
        , p.NewEmailAddress, p.NewIsPrimary
        , GETDATE() AS LoadDate
        , p.NewDataDate    
    FROM #mbrEmail p
    WHERE p.MbrEmailKey is null
        AND ISNULL(p.NewEmailAddress, '') <> '';
    
    /* if MbrAddressKey is Not Null, and phone values are different, replace */
    /* when there is a MbrAddressKey, terminate it and Insert New */
    IF OBJECT_ID('tempdb..#mbrEmailToVersion') IS NOT NULL 
	   DROP TABLE #mbrEmailToVersion;
    CREATE TABLE #mbrEmailToVersion (mbrEmailKey INT);
    INSERT INTO #mbrEmailToVersion(mbrEmailKey)    
    OUTPUT inserted.MbrEmailKey, 3 INTO @OutputTbl(ID, OutputType)
    SELECT  p.MbrEmailKey
    FROM #mbrEmail p
    WHERE NOT p.MbrEmailKey is null
        AND NOT (p.NewEmailAddress = ''  or p.NewEmailAddress iS null)
        /* is the phone data different? */
        AND (  ISNULL(p.NewEmailAddress,'')	    <> ISNULL(p.CurEmailAddress,'')
		  OR ISNULL(p.NewIsPrimary,'')	    <> ISNULL(p.CurIsPrimary,'')
		  OR ISNULL(p.NewEmailType,'')	    <> ISNULL(p.CurEmailType,'')
		  )
		  ;
    
     /* Updated current */
    UPDATE adw.MbrEmail
	   SET ExpirationDate = DATEADD(day, -1, src.NewEffectiveDate) /* one day less than new effective date */
    OUTPUT inserted.MbrEmailKey, 4 INTO @OutputTbl(ID, OutputType)
    FROM adw.MbrEmail m
	   JOIN #mbrEmail AS src ON src.MbrEmailKey = m.mbrEmailKey
	   JOIN #mbrEmailToVersion AS v ON src.MbrEmailKey = v.mbrEmailKey;

    /* insert new */
    INSERT INTO [adw].[MbrEmail]
               ([MbrMemberKey]
               ,[MbrLoadKey]
               ,[EffectiveDate],[ExpirationDate]
    			,EmailType
               ,EmailAddress, IsPrimary
               ,[LoadDate]
               ,[DataDate])
    OUTPUT inserted.MbrEmailKey, 5 INTO @OutputTbl(ID, OutputType)
    SELECT p.mbrMemberKey
        , p.mbrLoadHistoryKey
        , p.NewEffectiveDate , p.NewExpirationDate
        , p.NewEmailType
        , p.NewEmailAddress, p.NewIsPrimary
        , GETDATE() AS LoadDate
        , p.NewDataDate        
    FROM #mbrEmail p
    	   JOIN #mbrEmailToVersion v ON p.MbrEmailKey = v.mbrEmailKey
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
    
