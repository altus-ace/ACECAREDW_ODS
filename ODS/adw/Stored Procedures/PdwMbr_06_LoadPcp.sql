CREATE PROCEDURE [adw].[PdwMbr_06_LoadPcp]
    @LoadDate DATE  ,
    @ClientKey INT,
	@InsertCount INT OUTPUT,
	@UpdateCount INT OUTPUT
AS
    DECLARE @ExpirationDate DATE = '12/31/2099';
    DECLARE @provDefaultTermDate DATE = '12/31/2099';
    DECLARE @AutoAssign CHAR(4) = 'UNKN'
    /* SET UP OUTPUT TABLE AND TYPES */
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
    
    IF OBJECT_ID('tempdb..#mbrPcp') IS NOT NULL 
        DROP TABLE #mbrPcp;
    CREATE TABLE #mbrPcp (mbrLoadHistoryKey INT, MbrMemberKey INT, mbrPcpKey INT, loadType CHAR(1)
    		  , NewEffectiveDate DATE, NewExpirationDate DATE, NewNpi  VARCHAR(10), NewTin VARCHAR(10), NewAutoAssign VARCHAR(10)
			 , NewClientEffective DATE, NewClientExpiration DATE, NewLoadDate DATE, NewDataDate DATE   
    		  , CurEffectiveDate DATE, CurExpirationDate DATE, CurNpi  VARCHAR(10), CurTin VARCHAR(10), CurAutoAssign VARCHAR(10)
			 , CurClientEffective DATE, CurClientExpiration DATE, CurLoadDate DATE, CurDataDate DATE   );
    
 
    /* LOAD WORKING SET */
    INSERT INTO #mbrPcp (mbrLoadHistoryKey, mbrMemberKey, mbrPcpKey, loadType
	   , NewEffectiveDate , NewExpirationDate , NewNpi  , NewTin , NewAutoAssign 
	   , NewClientEffective , NewClientExpiration, NewLoadDate , NewDataDate 
	   , CurEffectiveDate, CurExpirationDate, CurNpi , CurTin, CurAutoAssign
	   , CurClientEffective, CurClientExpiration, CurLoadDate, CurDataDate)
    OUTPUT inserted.mbrPcpKey, 1 INTO @OutputTbl(ID, OutputType)   
    SELECT lh.mbrLoadHistoryKey, mbr.mbrMemberKey, p.mbrPcpKey, lh.LoadType		  		   
		   , CASE WHEN (m.LoadType = 'P') 
       				THEN CONVERT(DATE, DATEADD(DAY, (-1*DATEPART(day,@LoadDate)+1), @LoadDate)) 
       				ELSE @LoadDate 
       				END as newEffectiveDate, @ExpirationDate AS newExpirationDate        
			  , m.prvNPI, m.prvTin, m.prvAutoAssign
			  , m.prvClientEffective,  m.prvClientExpiration, m.loadDate, m.datadate
		  , p.EffectiveDate, p.ExpirationDate, p.NPI AS NewPcpNpi, p.TIN, p.AutoAssigned
		  , p.ClientEffective, p.ClientExpiration, p.loadDate, p.datadate
	   FROM (SELECT s.ClientSubscriberId, s.AdiKey, s.AdiTableName, s.prvNpi, s.prvTin, s.prvAutoAssign
			 , s.prvClientEffective, s.prvClientExpiration, s.LoadDate, s. DataDate, s.LoadType
			 FROM (SELECT d.ClientSubscriberId, d.adiKey, d.AdiTableName, d.LoadType      
				, adi.udf_CleanMemberNpiValue(d.prvNPI) as prvNPI, d.prvTIN, d.prvAutoAssign, d.prvClientEffective, d.prvClientExpiration
				, d.LoadDate , d.DataDate
				, ROW_NUMBER() OVER (PARTITION BY d.ClientSubscriberId ORDER BY d.LoadDATE DESC) arn				
				FROM ast.MbrStg2_MbrData d
				WHERE d.LoadDate = @LoadDate
				    AND d.CLientKey = @ClientKey
				    AND d.stgRowStatus = 'Valid'
				)  s
			 WHERE s.arn = 1					
			 ) AS m
		  JOIN adw.MbrLoadHistory Lh ON m.AdiKey = lh.AdiKey
				    AND m.AdiTableName = lh.AdiTableName
		  JOIN adw.MbrMember mbr ON m.ClientSubscriberId = mbr.ClientMemberKey
		  LEFT JOIN adw.MbrPcp p ON mbr.mbrMemberKey = p.mbrMemberKey
			 		AND GETDATE() BETWEEN p.EffectiveDate AND p.ExpirationDate		  		  
	   WHERE m.LoadDate = @LoadDate		  
		  ;

    /* INSERT NEW MEMBER PCP	   */
    INSERT INTO [adw].[MbrPcp]
           ([mbrMemberKey]            ,[MbrLoadKey]
           ,[EffectiveDate]           ,[ExpirationDate]
           ,[NPI]		, TIN             ,[AutoAssigned]
		 ,[ClientEffective]		   , ClientExpiration
           ,[LoadDate]                ,[DataDate]
           )
    OUTPUT inserted.mbrPcpKey, 2 INTO @OutputTbl(ID, OutputType)
    SELECT MbrMemberKey, mbrLoadHistoryKey
	   , NewEffectiveDate, NewExpirationDate	   
	   , NewNpi, NewTin, NewAutoAssign
	   , NewClientEffective, NewClientExpiration
	   , GETDATE() AS LoadDate, NewDataDate
    FROM #mbrPcp m
    WHERE m.mbrPcpKey is NULL;

    /* SET UP VERSIONING OF RECORDS THAT ARE UPDATED */
	   /* if mbrPcpKey Is not null, insert row */
	   /* when there is a MbrPcpKey, terminate it and Insert New */
    IF OBJECT_ID('tempdb..#mbrPcpToVersion') IS NOT NULL 
	   DROP TABLE #mbrPcpToVersion;
    CREATE TABLE #mbrPcpToVersion (mbrPcpKey INT);
    
    INSERT INTO #mbrPcpToVersion(mbrPcpKey)
    OUTPUT inserted.mbrPcpKey, 3 INTO @OutputTbl(ID, OutputType)
    SELECT src.mbrPcpKey
    FROM #mbrPcp AS src
    WHERE NOT src.mbrPcpKey is Null
	   and (  ISNULL(src.CurNpi, '') 				<> ISNULL(src.NewNpi,'')		 
		  OR ISNULL(src.CurTin, '') 				<> ISNULL(src.NewTin,'') 
		  OR ISNULL(src.CurAutoAssign, '') 		<> ISNULL(src.NewAutoAssign,'')
		  OR ISNULL(src.CurClientEffective, '') 	<> ISNULL(src.CurClientEffective,'')
		  OR ISNULL(src.CurClientExpiration, '') 	<> ISNULL(src.CurClientExpiration,'')
		  );					    
	
      /* TERM PRIOR ROW: SET EXPRIATON DATE = src.NewExpirationDate */
    UPDATE adw.MbrPcp
	   SET ExpirationDate = DATEADD(day, -1, src.NewEffectiveDate)/* calc a day 1 less than new effective */
    OUTPUT inserted.mbrPcpKey, 4 INTO @OutputTbl(ID, OutputType)
    FROM adw.mbrPcp m
	   JOIN #mbrPcp AS src ON src.mbrPcpKey = m.mbrPcpKey
	   JOIN #mbrPcpToVersion AS v ON src.mbrPcpKey = v.mbrPcpKey;

	   /* INSERT REPLACEMENT: If mbrPcpKey is null, insert row */
    INSERT INTO [adw].[MbrPcp]
           (mbrMemberKey             ,[MbrLoadKey]
           ,[EffectiveDate]           ,[ExpirationDate]           
           ,[NPI]	    , TIN         ,[AutoAssigned]
		 ,ClientEffective		   ,ClientExpiration
           ,[LoadDate]                ,[DataDate]
           )
    OUTPUT inserted.mbrPcpKey, 5 INTO @OutputTbl(ID, OutputType)
    SELECT MbrMemberKey, mbrLoadHistoryKey
	   , NewEffectiveDate, NewExpirationDate	   
	   , NewNpi, NewTIN, NewAutoAssign
	   , NewClientEffective, NewClientExpiration
	   , GETDATE() AS LoadDate, NewDataDate
    FROM #mbrPcp m
	   JOIN #mbrPcpToVersion v ON m.mbrPcpKey = v.mbrPcpKey
    WHERE NOT m.mbrPcpKey is NULL;

        
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
