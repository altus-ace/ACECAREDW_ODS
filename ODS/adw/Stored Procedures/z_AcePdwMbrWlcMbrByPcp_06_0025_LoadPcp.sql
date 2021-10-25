
CREATE PROCEDURE [adw].[z_AcePdwMbrWlcMbrByPcp_06_0025_LoadPcp]
    @LoadDate DATE  ,
	@InsertCount INT OUTPUT,
	@UpdateCount INT OUTPUT
AS
    DECLARE @newExprirationDate DATE = '12/31/2099';
    DECLARE @provDefaultTermDate DATE = '12/31/2099';
    DECLARE @AutoAssign CHAR(4) = 'UNKN'
    DECLARE @AdiTableName VARCHAR(50) = 'MbrWlcMbrByPcp';    
    
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
    
    IF OBJECT_ID('dbo.tmpWlcPcp') IS NOT NULL 
        DROP TABLE dbo.tmpWlcPcp;
    CREATE TABLE dbo.tmpWlcPcp (mbrLoadHistoryKey INT, MbrMemberKey INT, mbrPcpKey INT, loadType CHAR(1)
    		  , NewEffectiveDate DATE
    		  , NewExpirationDate DATE    		  
    		  , NewPcpNpi  VARCHAR(10), NewPcpTin  VARCHAR(10), NewAutoAssign VARCHAR(10)
		  , NewClientEffective DATE, NewClientExpiration DATE
		  , NewDataDate DATE    		  
    		  , CurNpi VARCHAR(10), CurTIN VARCHAR(10), CurAutoAssign VARCHAR(10), CurEffectiveDate Date, CurExpirationDate DATE
		  , CurClientEffective DATE, CurClientExpiration DATE
		  , CurDataDate DATE);

    /* LOAD WORKING SET */
    INSERT INTO dbo.tmpWlcPcp (mbrLoadHistoryKey, mbrMemberKey, mbrPcpKey, loadType
			 , NewEffectiveDate
			 , NewExpirationDate			 
			 , NewPcpNpi, NewPcpTin, NewAutoAssign
			 , NewClientEffective, NewClientExpiration
			 , NewDataDate			 
			 , CurNpi, CurTin, CurAutoAssign, CurEffectiveDate, CurExpirationDate
			 , CurClientEffective, CurClientExpiration
			 , CurDataDate)
    OUTPUT inserted.mbrPcpKey, 1 INTO @OutputTbl(ID, OutputType)
   
    SELECT DISTINCT lh.mbrLoadHistoryKey, mbr.MbrMemberKey, p.mbrPcpKey, lh.LoadType		  		   
		  , AdiMbrs.EffDate
		  ,  @newExprirationDate AS NewExpirationDate		  
		  , pl.NPI AS NewPcpNpi, pl.TIN AS NewPcpTin, @AutoAssign AS NewAutoAssign
		  , AdiMbrs.EffDate NewClientEffective, @provDefaultTermDate AS NewClientExpiration
		  , AdiMbrs.DataDate AS NewDataDate
		  , p.NPI as CurNpi, p.TIN AS CurTin, p.AutoAssigned AS CurAutoAssign, p.EffectiveDate, p.ExpirationDate
		  , p.ClientEffective AS curClientEffective, p.ClientExpiration AS CurClientExpiration
		  , p.DataDate AS CurDataDate
	   FROM adi.tvf_PdwSrc_Wlc_MemberByPcp( @LoadDate) AdiMbrs
		  JOIN lst.lstPlanMapping PlanMap ON AdiMbrs.BenePLAN = PlanMap.SourceValue
					   AND PlanMap.ClientKey = 2 
					   AND PlanMap.TargetSystem = 'ACDW' /* map for ACDW */
					   AND @loadDate BETWEEN PlanMap.EffectiveDate and PlanMap.ExpirationDate
		  JOIN lst.lstPlanMapping CsPlanMap ON adiMbrs.BenePLAN = CsPlanMap .SourceValue
					   AND CsPlanMap .ClientKey = 2 
					   AND CsPlanMap .TargetSystem = 'CS_AHS'
					   AND @LoadDate between CsPlanMap .EffectiveDate and CsPlanMap .ExpirationDate					   		
		  LEFT JOIN adw.MbrLoadHistory Lh ON AdiMbrs.mbrWlcMbrByPcpKey = lh.adiKey and lh.adiTableName = @adiTableName		  --mbr.MbrLoadKey = lh.MbrLoadHistoryKey
		  JOIN adw.MbrMember mbr ON AdiMbrs.Sub_ID = mbr.ClientMemberKey		  		  
		  JOIN adw.MbrWlcProviderLookup pl ON AdiMbrs.Prov_id = pl.Prov_id  
			  AND @loaddate <= pl.Term_Date
		  LEFT JOIN (SELECT p.NPI, p.TIN, p.AutoAssigned, p.EffectiveDate, p.ExpirationDate
					   , p.ClientEffective, p.ClientExpiration, p.DataDate, p.mbrPcpKey, p.MbrMemberKey
				    FROM adw.MbrPcp p 
					   JOIN adw.mbrMember m ON p.MbrMemberKey = m.MbrMemberKey 
				    WHERE m.ClientKey = 2
			 		  AND GETDATE() BETWEEN p.EffectiveDate AND p.ExpirationDate
					)p ON mbr.mbrMemberKey = p.mbrMemberKey		  
	   WHERE  ISNULL(adiMbrs.BenePLAN, '') <> ''
		  AND adiMbrs.BestMemberRow =1
		  ;

    /* INSERT NEW MEMBER PCP	     if mbrPcpKey Is not null, insert row */
    INSERT INTO [adw].[MbrPcp]
           ([mbrMemberKey]            ,[MbrLoadKey]
           ,[EffectiveDate]           ,[ExpirationDate]
           ,[NPI]		             ,[AutoAssigned]
		 , TIN 
		 ,[ClientEffective]		   , ClientExpiration
           ,[LoadDate]                ,[DataDate]
           )
    OUTPUT inserted.mbrPcpKey, 2 INTO @OutputTbl(ID, OutputType)
    SELECT MbrMemberKey, mbrLoadHistoryKey
	   , NewEffectiveDate, NewExpirationDate	   
	   , NewPcpNpi, NewAutoAssign
	   , NewPcpTin
	   , NewClientEffective, NewClientExpiration
	   , GETDATE() AS LoadDate, NewDataDate
    FROM dbo.tmpWlcPcp m
    WHERE m.mbrPcpKey is NULL;

    /* VERSION Records to be Updated: */
	/* IF the MbrPcpKey is not null, terminate it and Insert New */
    IF OBJECT_ID('dbo.tmpWlcPcpToVersion') IS NOT NULL 
	   DROP TABLE dbo.tmpWlcPcpToVersion;
    CREATE TABLE dbo.tmpWlcPcpToVersion (mbrPcpKey INT);
        
    INSERT INTO dbo.tmpWlcPcpToVersion(mbrPcpKey)
    OUTPUT inserted.mbrPcpKey, 3 INTO @OutputTbl(ID, OutputType)
    SELECT src.mbrPcpKey
    FROM dbo.tmpWlcPcp AS src
    WHERE NOT src.mbrPcpKey is Null
	   and (  ISNULL(src.CurNpi, '') 				<> ISNULL(src.NewPcpNpi,'')		  
		  OR ISNULL(src.CurTin, '') 				<> ISNULL(src.NewPcpTin,'')		
		  OR ISNULL(src.CurAutoAssign, '') 		<> ISNULL(src.NewAutoAssign,'')
		  OR ISNULL(src.CurClientEffective, '') 	<> ISNULL(src.CurClientEffective,'')
		  OR ISNULL(src.CurClientExpiration, '') 	<> ISNULL(src.CurClientExpiration,'')
		  );					    
	   
      
    
      /* TERM PRIOR ROW: SET EXPRIATON DATE = src.NewExpirationDate */
    UPDATE adw.MbrPcp
	   SET ExpirationDate =DATEADD(day, -1, src.NewEffectiveDate)/* calc a day 1 less than new effective */   
    OUTPUT inserted.mbrPcpKey, 4 INTO @OutputTbl(ID, OutputType)
    FROM adw.mbrPcp m
	   JOIN dbo.tmpWlcPcp AS src ON src.mbrPcpKey = m.mbrPcpKey
	   JOIN dbo.tmpWlcPcpToVersion AS v ON src.mbrPcpKey = v.mbrPcpKey;

	   /* INSERT REPLACEMENT: If mbrPcpKey is null, insert row */
    INSERT INTO [adw].[MbrPcp]
           (mbrMemberKey             ,[MbrLoadKey]
           ,[EffectiveDate]           ,[ExpirationDate]           
           ,[NPI]		             ,[AutoAssigned]
		 , TIN 
		 ,ClientEffective		   ,ClientExpiration
           ,[LoadDate]                ,[DataDate]
           )
    OUTPUT inserted.mbrPcpKey, 5 INTO @OutputTbl(ID, OutputType)
    SELECT MbrMemberKey, mbrLoadHistoryKey
	   , NewEffectiveDate, NewExpirationDate	   
	   , NewPcpNpi, NewAutoAssign
	   , NewPcpTin
	   , NewClientEffective, NewClientExpiration
	   , GETDATE() AS LoadDate, NewDataDate
    FROM dbo.tmpWlcPcp m
	   JOIN dbo.tmpWlcPcpToVersion v ON m.mbrPcpKey = v.mbrPcpKey
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
