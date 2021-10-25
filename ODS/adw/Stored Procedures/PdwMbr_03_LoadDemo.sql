CREATE PROCEDURE [adw].[PdwMbr_03_LoadDemo]
	@loadDate DATE ,
	@ClientKey INT ,
	@InsertCount INT OUTPUT,
	@UpdateCount INT OUTPUT
AS
	/* 6 POC Load Demo  */
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

    IF OBJECT_ID('tempdb..#mbrDemoLoad') IS NOT NULL 
        DROP TABLE #mbrDemoLoad;
    CREATE TABLE #mbrDemoLoad 
	   (ClientSubId VARCHAR(50), AdiKey INT, mbrLoadHistoryKey INT, mbrMemberKey INT, mbrDemographicKey INT, loadType CHAR(1)
        /* new values come from stg */
	   , newLName VARCHAR(100), newFName VARCHAR(100), newMName VARCHAR(100), newGender CHAR(5), newDob DATE
		  ,NewSSN VARCHAR(15), newMedicaidID VARCHAR(15), newMedicareId VARCHAR(15), NewHicn VARCHAR(50), NewMBI varchar(15)
		  , NewMbrInsuranceCardIdNum VARCHAR(20),NewEthnicity varchar(20), NewRace  varchar(20), NewPrimaryLanguage  varchar(20)
		  ,newDataDate Date, newLoadDate DATE, NewEffectiveDate DATE, NewExpriationDate DATE
	   /* current values come from member model */
        , curLastName VARCHAR(100), curFirstName VARCHAR(100), curMiddleName VARCHAR(100), curGender CHAR(5), curDob DATE
		  , curSSN VARCHAR(15), curMedicaidID VARCHAR(15), curMedicareID VARCHAR(15), curHicn VARCHAR(50), CurMbi VARCHAR(15)
		  , curmbrInsuranceCardIdNum VARCHAR(20), curEthnicity varchar(20), curRace VARCHAR(20), CurPrimaryLanguage varchar(20)
		  , curEffectiveDate DATE, curExpirationDate DATE, curDataDate DATE, curLoadDate DATE
        );
    
    INSERT INTO #mbrDemoLoad (
	   ClientSubId , AdiKey , mbrLoadHistoryKey , mbrMemberKey, mbrDemographicKey, loadType	 
	   , newLName, newFName, newMName, newGender, newDob
		  , NewSSN, newMedicaidID, newMedicareId, NewHicn, NewMBI	 
		  , NewMbrInsuranceCardIdNum, NewEthnicity, NewRace, NewPrimaryLanguage
		  , newDataDate, newLoadDate, NewEffectiveDate, NewExpriationDate
	   , curLastName, curFirstName, curMiddleName, curGender, curDob
		  , curSSN, curMedicaidID, curMedicareID, curHicn, CurMbi
		  , curMbrInsuranceCardIdNum, curEthnicity, curRace, CurPrimaryLanguage
		  , curEffectiveDate, curExpirationDate, curDataDate, curLoadDate)    
    OUTPUT inserted.mbrDemographicKey, 1 INTO @OutputTbl(ID, OutputType)        
    SELECT m.ClientSubscriberId , m.adiKey, lh.mbrLoadHistoryKey, mbr.MbrMemberKey, d.MbrDemographicKey, lh.LoadType
        , m.mbrLastName, m.mbrFirstName, m.mbrMiddleName, m.mbrGender, m.mbrDob
		  , m.MbrSSN, m.mbrMEDICAID_NO, m.mbrMEDICARE_ID, m.HICN, m.MBI
		  , m.mbrInsuranceCardIdNum, m.MbrEthnicity, m.MbrRace, m.MbrPrimaryLanguage
		  , m.LoadDate,  m.DataDate
		  , CASE WHEN lh.LoadType = 'P' THEN 
    			 /* get first day of month */
    	   			CONVERT(DATE, DATEADD(DAY, (-1*DATEPART(day,m.EffDate)+1), m.EffDate)) 	   
			 WHEN lh.LoadType = 'S' THEN 
				CONVERT(DATE, DATEADD(DAY, (-1*DATEPART(day,m.EffDate)+1), m.EffDate)) 	   
			-- wrong: this is if end of this month logic is used:	DATEADD(day, (-1 * DATEPART(day, DATEADD(month, 1, m.EffDate))), DATEADD(month, 1, m.EffDate))
    			 ELSE m.EffDate END AS NewEffectiveDate 	   
		  , '12/31/2099' NewExpirationDate
        , d.LastName, d.FirstName, d.MiddleName, d.Gender, d.DOB
		  , d.SSN, d.MedicaidID, d.MedicareID, '' Hicn, '' Mbi
		  , d.mbrInsuranceCardIdNum, d.Ethnicity, d.Race, d.PrimaryLanguage
		  , d.effectiveDate, d.expirationDate, d.DataDate, d.LoadDate
    FROM (SELECT s.ClientSubscriberID, s.adiKey, s.adiTableName, s.EffDate
			 , s.mbrLastName, s.mbrFirstName, s.mbrMiddleName, s.mbrGender, s.mbrDob, s.mbrMEDICAID_NO, s.mbrMEDICARE_ID, s.mbrInsuranceCardIdNum
			 , s.MbrSsn, s.HICN, s.MBI, s.MbrEthnicity, s.MbrRace, s.MbrPrimaryLanguage, s.LoadDate, s. DataDate
		  FROM (SELECT d.ClientSUbscriberID, d.AdiKey, d.adiTableName, d.LoadDate as EffDate
				    , d.mbrLastName, d.mbrFirstName, d.mbrMiddleName, d.mbrGender, d.mbrDob, d.mbrMEDICAID_NO, d.MbrMedicare_id, d.mbrInsuranceCardIdNum
				    , d.MbrSSN, d.HICN, d.MBI, d.MbrEthnicity, d.MbrRace, d.MbrPrimaryLanguage, d.LoadDate, d.DataDate
				, ROW_NUMBER() OVER (PARTITION BY d.ClientSubscriberID ORDER BY d.LoadDATE DESC) arn
				FROM ast.MbrStg2_MbrData d
				WHERE d.LoadDate = @LoadDate
				    AND d.CLientKey = @ClientKey
				    AND d.stgRowStatus = 'Valid') s
			 WHERE s.arn = 1
			 ) AS m
        JOIN adw.MbrLoadHistory Lh ON m.AdiKey = lh.AdiKey 
			 AND m.AdiTableName = lh.AdiTableName
        JOIN adw.MbrMember mbr ON m.ClientSubscriberId = mbr.ClientMemberKey
        LEFT JOIN adw.MbrDemographic d ON mbr.MbrMemberKey = d.MbrMemberKey
    				AND GETDATE() BETWEEN d.EffectiveDate AND d.ExpirationDate
   WHERE m.LoadDate = @LoadDate 	
    ;
    
    
    /* where demo key is null, insert */
    INSERT INTO [adw].[MbrDemographic]
           ([mbrMemberKey]
           ,[mbrLoadKey]
           ,[EffectiveDate]
           ,[ExpirationDate]
           ,[LastName]
           ,[FirstName]
           ,[MiddleName]
           ,[SSN]
           ,[Gender]
           ,[DOB]
           ,[MedicaidID]
           ,[MedicareID]
		 ,[mbrInsuranceCardIdNum]
           ,[Ethnicity]
           ,[Race]
           ,[PrimaryLanguage]
           ,[LoadDate]
           ,[DataDate]
           )
    OUTPUT inserted.mbrDemographicKey, 2 INTO @OutputTbl(ID, OutputType)
    SELECT m.mbrMemberKey, mbrLoadHistoryKey, m.NewEffectiveDate, m.NewExpriationDate
	   , m.NewLName, m.NewFName, m.NewMName, m.NewSSN, m.NewGender, m.NewDob, m.NewMedicaidID, m.NewMedicareId
	   , m.NewMbrInsuranceCardIdNum, m.NewEthnicity, m.NewRace, m.NewPrimaryLanguage
	   , GETDATE() AS LoadDate, m.NewDataDate AS DataDate
    FROM #mbrDemoLoad m
    WHERE m.mbrDemographicKey is null;
    
    /* Where Demo is not null, are the values of payload different from what is stored? */
    IF OBJECT_ID('tempdb..#mbrDemoUpdate') IS NOT NULL 
        DROP TABLE #mbrDemoUpdate;
    CREATE TABLE #mbrDemoUpdate (mbrDemographicKey INT, mbrMemberKey INT);
    
    INSERT INTO #mbrDemoUpdate (mbrDemographicKey, mbrMemberKey)
    OUTPUT inserted.mbrDemographicKey, 3 INTO @OutputTbl(ID, OutputType)
    SELECT m.mbrDemographicKey, m.mbrMemberKey
    FROM #mbrDemoLoad m
    WHERE ISNULL(m.mbrDemographicKey, '') <> ''
        AND (	ISNULL(m.NewLName,'')		   <> ISNULL(m.curLastName,'')
    		  OR ISNULL(m.NewFName,'')		   <> ISNULL(m.curFirstName,'')
    		  OR ISNULL(m.NewMName,'')		   <> ISNULL(m.curMiddleName,'')
		  OR ISNULL(m.NewSSN,'')			   <> ISNULL(m.curSSN,'')
		  OR ISNULL(m.NewGender,'')		   <> ISNULL(m.curGender,'')
    		  OR ISNULL(m.NewDob,'')			   <> ISNULL(m.curDob,'')
    		  OR ISNULL(m.NewMedicaidID,'')	   <> ISNULL(m.curMedicaidID,'')
		  OR ISNULL(m.NewMedicareId,'')	   <> ISNULL(m.curMedicareId,'')
		  OR ISNULL(m.NewmbrInsuranceCardIdNum,'') <> ISNULL(m.curmbrInsuranceCardIdNum,'')
    		  OR ISNULL(m.NewEthnicity,'')	   <> ISNULL(m.curEthnicity,'')
		  OR ISNULL(m.NewRace,'')		   <> ISNULL(m.curRace,'')
		  OR ISNULL(m.NewPrimaryLanguage,'')  <> ISNULL(m.CurPrimaryLanguage,'')
		   );
    
    /* For each of these, term the existing one (getdate() - 1) and insert new */
    Update adw.MbrDemographic 
        SET ExpirationDate = DATEADD(d,-1, l.NewEffectiveDate)
    OUTPUT inserted.mbrDemographicKey, 4 INTO @OutputTbl(ID, OutputType)
    FROM adw.MbrDemographic 
        JOIN #mbrDemoUpdate U ON adw.MbrDemographic.MbrDemographicKey = U.mbrDemographicKey
        JOIN #mbrDemoLoad L ON u.mbrDemographicKey = l.mbrDemographicKey;
    
        /* insert new record */ 
    INSERT INTO [adw].[MbrDemographic]
           ([MbrMemberKey]
           ,[MbrLoadKey]
           ,[EffectiveDate]
           ,[ExpirationDate]
           ,[LastName]
           ,[FirstName]
           ,[MiddleName]
           ,[SSN]
           ,[Gender]
           ,[DOB]
           ,[MedicaidID]
           ,[MedicareID]
		 , mbrInsuranceCardIdNum
           ,[Ethnicity]
           ,[Race]
           ,[PrimaryLanguage]    
           ,[LoadDate]
           ,[DataDate]
           )
    OUTPUT inserted.mbrDemographicKey, 5 INTO @OutputTbl(ID, OutputType)
    SELECT m.mbrMemberKey, m.mbrLoadHistoryKey, m.NewEffectiveDate, m.NewExpriationDate
	   , m.NewLName, m.NewFName, m.NewMName, m.NewSSN, m.NewGender, m.NewDob, m.NewMedicaidID, m.NewMedicareId
	   , m.NewMbrInsuranceCardIdNum, m.NewEthnicity, m.NewRace, m.NewPrimaryLanguage
	   , GETDATE() AS LoadDate, m.NewDataDate AS DataDate    
    FROM #mbrDemoLoad m
	   JOIN #mbrDemoUpdate u ON m.mbrMemberKey = u.mbrMemberKey

    
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
