
CREATE PROCEDURE [adw].[z_AcePdwMbrWlcMbrByPcp_03_0025_LoadDemo]
	@loadDate DATE ,
	@InsertCount INT OUTPUT,
	@UpdateCount INT OUTPUT
AS
    DECLARE @AdiTableName VARCHAR(50) = 'MbrWlcMbrByPcp';
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

    IF OBJECT_ID('dbo.tmpWlcDemoLoad') IS NOT NULL 
        DROP TABLE dbo.tmpWlcDemoLoad;
    CREATE TABLE dbo.tmpWlcDemoLoad (WlcSubscriberId VARCHAR(50), mbrWlcMbrByPcpKey INT, mbrLoadHistoryKey INT, mbrMemberKey INT, mbrDemographicKey INT, loadType CHAR(1)
        , adiLName VARCHAR(100), adiFName VARCHAR(100), adiMName VARCHAR(100), adiGender CHAR(5), adiDob DATE, adiMedicaidID VARCHAR(15), adiMedicareId VARCHAR(15), adiDataDate Date, adiLoadDate DATE
        , mdLName VARCHAR(100), mdFName VARCHAR(100), mdMName VARCHAR(100), mdGender CHAR(5), mdDob DATE, mdMedicaidID VARCHAR(15), mdMedicareID VARCHAR(15)
        , EffectiveDate DATE
        );
    
    INSERT INTO dbo.tmpWlcDemoLoad (WlcSubscriberId, mbrWlcMbrByPcpKey, mbrLoadHistoryKey, mbrMemberKey, mbrDemographicKey,loadType
        , adiLName, adiFName, adiMName, adiGender, adiDob, adiMedicaidID, adiMedicareId, adiDataDate, adiLoadDate
        , mdLName, mdFName, mdMName, mdGender, mdDob, mdMedicaidID, mdMedicareID
        , EffectiveDate)    
    OUTPUT inserted.mbrDemographicKey, 1 INTO @OutputTbl(ID, OutputType)      
    SELECT DISTINCT AdiMbrs.SUB_ID , AdiMbrs.mbrWlcMbrByPcpKey, lh.mbrLoadHistoryKey, mbr.MbrMemberKey, d.MbrDemographicKey, lh.LoadType
        , AdiMbrs.LastName, AdiMbrs.FirstName, '' AS mbrMName, '' AS GENDER, AdiMbrs.BirthDate, AdiMbrs.MEDICAID_NO, '' AS MEDICARE_ID, AdiMbrs.DataDate, AdiMbrs.LoadDate
        , d.LastName, d.FirstName,d.MiddleName, d.Gender, d.DOB, d.MedicaidID, d.MedicareID    
        , CASE WHEN lh.LoadType = 'P' THEN 
    		  /* get first day of month */
    	   	   CONVERT(DATE, DATEADD(DAY, (-1*DATEPART(day,GETDATE())+1), GETDATE())) 	   
    	   ELSE GETDATE() END AS effectiveDate 	   	   
    FROM adi.tvf_PdwSrc_Wlc_MemberByPcp( @LoadDate) AdiMbrs
        JOIN adw.MbrLoadHistory Lh ON adiMbrs.mbrWlcMbrByPcpKey = lh.adiKey and lh.adiTableName = @adiTableName
        JOIN adw.MbrMember mbr ON adiMbrs.SUB_ID = mbr.ClientMemberKey
        LEFT JOIN (SELECT d.MbrDemographicKey, d.MbrMemberKey , d.LastName, d.FirstName,d.MiddleName, d.Gender, d.DOB, d.MedicaidID, d.MedicareID    
				FROM  adw.MbrDemographic d 
				    JOIN adw.MbrMember M on d.mbrMemberKey = m.mbrMemberKey and m.clientKey = 2
				WHERE GETDATE() BETWEEN d.EffectiveDate AND d.ExpirationDate	   ) d
				ON mbr.MbrMemberKey = d.MbrMemberKey
   WHERE adiMbrs.BestMemberRow = 1	
    ;

    /* where demo key is null, insert */
    INSERT INTO [adw].[MbrDemographic]
           ([MbrMemberKey]
           ,[MbrLoadKey]
           ,[EffectiveDate]
           ,[ExpirationDate]
           ,[LastName]
           ,[FirstName]
           ,[MiddleName]           
           ,[Gender]
           ,[DOB]
           ,[MedicaidID]
           ,[MedicareID]
           ,[LoadDate]
           ,[DataDate]
           )
    OUTPUT inserted.mbrDemographicKey, 2 INTO @OutputTbl(ID, OutputType)
    SELECT m.mbrMemberKey, mbrLoadHistoryKey, m.EffectiveDate, '12/31/2099' AS ExpirationDate
	   , m.adiLName, m.adiFName, m.adiMName, m.adiGender, m.adiDob, m.adiMedicaidID, m.adiMedicareId
	   , GETDATE() AS LoadDate, m.adiDataDate AS DataDate
    FROM dbo.tmpWlcDemoLoad m
    WHERE m.mbrDemographicKey is null;
    
    /* Where Demo is not null, are the values of payload different from what is stored? */
    IF OBJECT_ID('dbo.tmpWlcDemoUpdate') IS NOT NULL 
        DROP TABLE dbo.tmpWlcDemoUpdate;   --dbo.tmpWlcDemoLoad	   --dbo.tmpWlcDemoUpdate
    CREATE TABLE dbo.tmpWlcDemoUpdate (mbrDemographicKey INT, mbrMemberKey INT);
    
    INSERT INTO dbo.tmpWlcDemoUpdate (mbrDemographicKey, mbrMemberKey)
    OUTPUT inserted.mbrDemographicKey, 3 INTO @OutputTbl(ID, OutputType)
    SELECT m.mbrDemographicKey, m.mbrMemberKey
    FROM dbo.tmpWlcDemoLoad m
    WHERE ISNULL(m.mbrDemographicKey, '') <> ''
        AND (	UPPER(ISNULL(m.adiLName,'')	   ) <> UPPER (ISNULL(m.mdLName,'')	 )
    		  OR UPPER(ISNULL(m.adiFName,'')	   ) <> UPPER (ISNULL(m.mdFName,'')	 )
    		  OR UPPER(ISNULL(m.adiMName,'')	   ) <> UPPER (ISNULL(m.mdMName,'')	 )
		  OR UPPER(ISNULL(m.adiGender,'')	   ) <> UPPER (ISNULL(m.mdGender,'')	 )
    		  OR UPPER(ISNULL(m.adiDob,'')	   ) <> UPPER (ISNULL(m.mdDob,'')		 )
    		  OR UPPER(ISNULL(m.adiMedicaidID,'') ) <> UPPER (ISNULL(m.mdMedicaidID,'') )
    		  OR UPPER(ISNULL(m.adiMedicareId,'') ) <> UPPER (ISNULL(m.mdMedicareID,'')));
    
    /* For each of these, term the existing one (getdate() - 1) and insert new */
    Update adw.MbrDemographic 
        SET ExpirationDate = DATEADD(d,-1, l.EffectiveDate)
    OUTPUT inserted.mbrDemographicKey, 4 INTO @OutputTbl(ID, OutputType)
    FROM adw.MbrDemographic 
        JOIN dbo.tmpWlcDemoUpdate U ON adw.MbrDemographic.MbrDemographicKey = U.mbrDemographicKey
        JOIN dbo.tmpWlcDemoLoad L ON u.mbrDemographicKey = l.mbrDemographicKey;
    
    
    /* insert new record */ 
    INSERT INTO [adw].[MbrDemographic]
           ([MbrMemberKey]
           ,[MbrLoadKey]
           ,[EffectiveDate]
           ,[ExpirationDate]
           ,[LastName]
           ,[FirstName]
           ,[MiddleName]           
           ,[Gender]
           ,[DOB]
           ,[MedicaidID]
           ,[MedicareID]
           ,[LoadDate]
           ,[DataDate]
           )
    OUTPUT inserted.mbrDemographicKey, 5 INTO @OutputTbl(ID, OutputType)
    SELECT m.mbrMemberKey, mbrLoadHistoryKey, m.EffectiveDate, '12/31/2099' AS ExpirationDate
	   , m.adiLName, m.adiFName, m.adiMName, m.adiGender, m.adiDob, m.adiMedicaidID, m.adiMedicareId
	   , GETDATE() AS LoadDate, m.adiDataDate AS DataDate
    FROM dbo.tmpWlcDemoLoad m
	   JOIN dbo.tmpWlcDemoUpdate u ON m.mbrMemberKey = u.mbrMemberKey

    
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
