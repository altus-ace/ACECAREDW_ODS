CREATE PROCEDURE [adw].[z_AcePdwMbrWlcMbrByPcp_04_0025_LoadPhone]
	@loadDate DATE,
	@InsertCount INT OUTPUT,
	@UpdateCount INT OUTPUT
AS    
    DECLARE @AdiTableName VARCHAR(50) = 'MbrWlcMbrByPcp';
    
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

    IF OBJECT_ID('dbo.tmpWlcPhoneLoad') IS NOT NULL 
        DROP TABLE dbo.tmpWlcPhoneLoad;
    CREATE TABLE dbo.tmpWlcPhoneLoad (mbrLoadHistoryKey INT, mbrMemberKey INT, MbrPhoneKey INT
        , adiPhone VARCHAR(30), adiDataDate DATE, phone VARCHAR(30), phoneTypeKey INT, CarrierType INT
	   ,  EffectiveDate DATE, NewExpirationDate DATE, LoadType CHAR(1));
   
    /* LOAD WORKING SET */
	   /* Home Phone */
    INSERT INTO dbo.tmpWlcPhoneLoad(
	   mbrLoadHistoryKey, mbrMemberKey, MbrPhoneKey
	   , adiPhone, phone ,phoneTypeKey, CarrierType, adiDataDate
	   , EffectiveDate, NewExpirationDate, LoadType)
    OUTPUT inserted.MbrPhoneKey, 1 INTO @OutputTbl(ID, OutputType)        
    SELECT DISTINCT lh.mbrLoadHistoryKey, mbr.MbrMemberKey, MbrPhone.mbrPhoneKey
        , adw.AceCleanPhoneNumber(AdiMbrs.PhoneNumber) adiHomePhone, MbrPhone.PhoneNumber
        , (SELECT lstPhoneTypeKey FROM lst.lstPhoneType WHERE lstPhoneType.PhoneTypeCode = 'H') AS PhoneTypeKey
	   , (SELECT lstPhoneCarrierTypeKey FROM lst.lstPhoneCarrierType WHERE lstPhoneCarrierType.PhoneCarrierTypeCode = 'NK') AS PhoneTypeKey, adiMbrs.DataDate AS adiDataDate
        , CASE WHEN lh.LoadType = 'P' THEN 
    		  /* get first day of month */
    	   	   CONVERT(DATE, DATEADD(DAY, (-1*DATEPART(day,GETDATE())+1), GETDATE())) 	   
    	   ELSE GETDATE() END AS effectiveDate 
        , '12/31/2099' AS NewExpirationDate, lh.LoadType
    FROM  adi.tvf_PdwSrc_Wlc_MemberByPcp( @LoadDate) AdiMbrs
        JOIN adw.MbrLoadHistory Lh ON AdiMbrs.mbrWlcMbrByPcpKey = lh.adiKey and lh.adiTableName = @adiTableName
        JOIN adw.MbrMember mbr ON AdiMbrs.SUB_ID = mbr.ClientMemberKey    
        LEFT JOIN adw.MbrPhone MbrPhone ON mbr.MbrMemberKey = MbrPhone.MbrMemberKey
    				AND GETDATE() BETWEEN MbrPhone.EffectiveDate AND MbrPhone.ExpirationDate
    				AND MbrPhone.PhoneType = (SELECT lp.lstPhoneTypeKey FROM lst.lstPhoneType lp WHERE lp.PhoneTypeCode = 'H') 				
    WHERE ISNULL(adiMbrs.PhoneNumber, '') <> ''
	   --AND p.MbrPhoneKey IS NULL;

	   /* Mobile Phone */
    INSERT INTO dbo.tmpWlcPhoneLoad(mbrLoadHistoryKey, mbrMemberKey, MbrPhoneKey, adiPhone, phone,phoneTypeKey, CarrierType, adiDataDate, EffectiveDate,NewExpirationDate, LoadType)
    OUTPUT inserted.MbrPhoneKey, 1 INTO @OutputTbl(ID,OutputType)       
    SELECT lh.mbrLoadHistoryKey, mbr.MbrMemberKey, MbrPhone.mbrPhoneKey
        , adw.AceCleanPhoneNumber(AdiMbrs.MOBILE_PHONE) adiPhone, MbrPhone.PhoneNumber
        , (SELECT lstPhoneTypeKey FROM lst.lstPhoneType WHERE lstPhoneType.PhoneTypeCode = 'M') AS PhoneTypeKey
	   , (SELECT lstPhoneCarrierTypeKey FROM lst.lstPhoneCarrierType WHERE lstPhoneCarrierType.PhoneCarrierTypeCode = 'NK') AS PhoneTypeKey, adiMbrs.DataDate AS adiDataDate
        , CASE WHEN lh.LoadType = 'P' THEN 
    		  /* get first day of month */
    	   	   CONVERT(DATE, DATEADD(DAY, (-1*DATEPART(day,GETDATE())+1), GETDATE())) 	   
    	   ELSE GETDATE() END AS effectiveDate 
        , '12/31/2099' AS NewExpirationDate, lh.LoadType
    FROM adi.tvf_PdwSrc_Wlc_MemberByPcp( @LoadDate) AdiMbrs
        JOIN adw.MbrLoadHistory Lh ON AdiMbrs.mbrWlcMbrByPcpKey = lh.adiKey AND lh.AdiTableName = @AdiTableName
        JOIN adw.MbrMember mbr ON AdiMbrs.SUB_ID = mbr.ClientMemberKey    
        LEFT JOIN adw.MbrPhone MbrPhone ON mbr.MbrMemberKey = MbrPhone.MbrMemberKey
    				AND GETDATE() BETWEEN MbrPhone.EffectiveDate AND MbrPhone.ExpirationDate
    				AND MbrPhone.PhoneType = (SELECT lp.lstPhoneTypeKey FROM lst.lstPhoneType lp WHERE lp.PhoneTypeCode = 'M') 				
    WHERE ISNULL(adiMbrs.MOBILE_PHONE, '') <> ''
	   --AND p.MbrPhoneKey IS NULL;
	   ;

	   /* Alternate Phone */
    INSERT INTO dbo.tmpWlcPhoneLoad(mbrLoadHistoryKey, mbrMemberKey, MbrPhoneKey, adiPhone, phone,phoneTypeKey, CarrierType, adiDataDate, EffectiveDate, NewExpirationDate, LoadType )
    OUTPUT inserted.MbrPhoneKey, 1 INTO @OutputTbl(ID, OutputType)       
    SELECT lh.mbrLoadHistoryKey, mbr.MbrMemberKey, mbrPhone.mbrPhoneKey
        , adw.AceCleanPhoneNumber(adiMbrs.ALT_PHONE) adiPhone, mbrPhone.PhoneNumber
        , (SELECT lstPhoneTypeKey FROM lst.lstPhoneType WHERE lstPhoneType.PhoneTypeCode = 'A') AS PhoneTypeKey
	   , (SELECT lstPhoneCarrierTypeKey FROM lst.lstPhoneCarrierType WHERE lstPhoneCarrierType.PhoneCarrierTypeCode = 'NK') AS PhoneTypeKey, adiMbrs.DataDate AS adiDataDate
        , CASE WHEN lh.LoadType = 'P' THEN 
    		  /* get first day of month */
    	   	   CONVERT(DATE, DATEADD(DAY, (-1*DATEPART(day,GETDATE())+1), GETDATE())) 	   
    	   ELSE GETDATE() END AS effectiveDate 
        , '12/31/2099' AS NewExpirationDate, lh.LoadType
    FROM adi.tvf_PdwSrc_Wlc_MemberByPcp( @LoadDate) AdiMbrs
        JOIN adw.MbrLoadHistory Lh ON adiMbrs.mbrWlcMbrByPcpKey = lh.adiKey AND lh.AdiTableName = @AdiTableName
        JOIN adw.MbrMember mbr ON adiMbrs.SUB_ID = mbr.ClientMemberKey    
        LEFT JOIN adw.MbrPhone MbrPhone ON mbr.MbrMemberKey = MbrPhone.mbrMemberKey
    				AND GETDATE() BETWEEN mbrPhone.EffectiveDate AND mbrPhone.ExpirationDate
    				AND mbrPhone.PhoneType = (SELECT lp.lstPhoneTypeKey FROM lst.lstPhoneType lp WHERE lp.PhoneTypeCode = 'A') 				
    WHERE ISNULL(adiMbrs.ALT_PHONE, '') <> ''
	   --AND p.MbrPhoneKey IS NULL;
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
        , p.effectiveDate
        , p.NewExpirationDate AS ExpirationDate
        , p.phoneTypeKey
	   , p.carrierTYpe
        , p.adiPhone
        , GETDATE() AS LoadDate
        , p.adiDataDate
    FROM dbo.tmpWlcPhoneLoad p
    WHERE p.MbrPhoneKey is null
        AND NOT (p.adiPhone = ''  or p.adiPhone Is null)
	   AND p.adiPhone <> ISNULL(p.phone, '')
		
    /* LOAD VERSION SET */
	   /* if phone key is null insert all as new */
        /* when there is a MbrPlanKey, terminate it and Insert New */
    IF OBJECT_ID('dbo.tmpWlcPhoneToVersion') IS NOT NULL 
	   DROP TABLE dbo.tmpWlcPhoneToVersion;
    CREATE TABLE dbo.tmpWlcPhoneToVersion (mbrPhoneKey INT);
    
    INSERT INTO dbo.tmpWlcPhoneToVersion(mbrPhoneKey)   
    OUTPUT inserted.mbrPhoneKey, 3 INTO @OutputTbl(ID, OutputType) 
    SELECT  p.MbrPhoneKey    
    FROM dbo.tmpWlcPhoneLoad p
    WHERE NOT p.MbrPhoneKey is null
        AND NOT (p.adiPhone = ''  or p.adiPhone Is null)
        /* is the phone data different? */
        AND p.adiPhone <> ISNULL(p.phone, '');
    
     /* TERM PRIOR RECORD: SET EFFECTIVE DATE = src.EffectiveDate */
    UPDATE adw.MbrPhone
	   SET ExpirationDate = DATEADD(day, -1, src.EffectiveDate)
    OUTPUT inserted.mbrPhoneKey, 4 INTO @OutputTbl(ID, OutputType)
    FROM adw.MbrPhone m
	   JOIN dbo.tmpWlcPhoneLoad AS src ON src.MbrPhoneKey = m.mbrPhoneKey
	   JOIN dbo.tmpWlcPhoneToVersion AS v ON src.MbrPhoneKey = v.mbrPhoneKey;

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
        , p.effectiveDate
        , p.NewExpirationDate AS ExpirationDate
        , p.phoneTypeKey
	   , p.CarrierType
        , p.adiPhone
        , GETDATE() AS LoadDate
        , p.adiDataDate
    FROM dbo.tmpWlcPhoneLoad p
	   JOIN dbo.tmpWlcPhoneToVersion v ON p.MbrPhoneKey = v.mbrPhoneKey
    WHERE NOT p.MbrPhoneKey is null
        AND NOT ISNULL(p.adiPhone, '') = ''  ;

	       
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
