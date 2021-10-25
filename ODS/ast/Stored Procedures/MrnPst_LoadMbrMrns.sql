CREATE PROCEDURE ast.MrnPst_LoadMbrMrns
AS 
    /* Purpose:	   
        1. finding members with MRNS already and return them to the stg table	 
        2. Insert New MRNS MRN for new members 
        Steps:
        a. get working set
    	   all members for a stage load who are in loaded or valid, and have no MRN
        b. get existing model mrn values
    	   working set with left Join to mbrMember on cmk
        c. update working set with new MRN where needed (still null)
        d. for all values that have MRN write as update back to stg table
        e. log to metadata
    */
    IF object_id('tempdb..#WrkStgMrn') is not null
	   drop table #WrkStgMrn
    CREATE TABLE #WrkStgMrn (mbrStg2_MbrDataUrn INT NOT NULL PRIMARY KEY
	   , ClientMemberKey VARCHAR(50)
	   , ClientKey INT 
	   , MrnMstrKey NUMERIC(15,0) 
	   ) ; 
    INSERT INTO #WrkStgMrn(mbrStg2_MbrDataUrn, ClientMemberKey, ClientKey, MrnMstrKey)
    SELECT m.mbrStg2_MbrDataUrn, m.ClientSubscriberId,  m.ClientKey, m.MstrMrnKey
    FROM ast.MbrStg2_MbrData m
    WHERE m.stgRowStatus in ('Loaded')
	   AND m.MstrMrnKey = -1;

    MERGE #WrkStgMrn trg
    USING (SELECT w.mbrStg2_MbrDataUrn, M.MstrMrnKey
		  FROM #WrkStgMrn w
			 LEFT JOIN adw.MbrMember M 
				ON w.ClientKey = M.ClientKey
				AND w.ClientMemberKey = m.ClientMemberKey
		  WHERE NOT M.mbrMemberKey is NULL) src
    ON trg.mbrStg2_MbrDataUrn = src.mbrStg2_MbrDataUrn
    WHEN MATCHED THEN UPDATE
	   set trg.MrnMstrKey = src.MstrMrnKey;
    

    /* add search for member in mrn using demographich fields */
    -- next month or for AetMa
    -- Log Updates count 

    /* do insert to mrn */
    DECLARE @InsertOutput Table (mrn NUMERIC(15,0), mbrStg2_MbrDataUrn INT );
    MERGE adw.[MstrMrn] trg
    USING (SELECT m.mbrFirstName, m.mbrLastName, m.mbrMiddleName
			 ,m.mbrDob, m.mbrGENDER, m.mbrMEDICARE_ID, m.mbrMEDICAID_NO        
			 ,m.adiKey, m.adiTableName, 1	AS isActive, CONVERT(DATE, GETDATE()) AS LoadDate
			 , m.DataDate, w.mbrStg2_MbrDataUrn
		  FROM ast.mbrStg2_MbrData m
			 JOIN #WrkStgMrn w 
				ON m.mbrStg2_MbrDataUrn = w.mbrStg2_MbrDataUrn
				    and w.MrnMstrKey = -1
		  ) src
    ON trg.LastName		   = src.mbrLastName
	   and  trg.FirstName  = src.mbrFirstName
	   and  trg.MiddleName = src.mbrMiddleName
	   and  trg.DateOfBirth = src.mbrDob
	   and  trg.Gender	   = src.mbrGENDER
    WHEN NOT MATCHED BY TARGET THEN 
	   INSERT ([FirstName],[LastName],[MiddleName],[DateOfBirth]
			 ,[Gender],[MedicareID],[MedicaidID]
			 ,[srcUrn],[srcTableName],[Active],[LoadDate],[DataDate])
	    VALUES (src.mbrFirstName, src.mbrLastName, src.mbrMiddleName,src.mbrDob
			 , src.mbrGENDER, src.mbrMEDICARE_ID, src.mbrMEDICAID_NO        
			 , src.adiKey, src.adiTableName, src.isActive, src.LoadDate
			 , src.DataDate)
	   OUTPUT inserted.MstrMrnKey, src.mbrStg2_MbrDataUrn
		  INTO @InsertOutput
	   ;
    /* update working set with MRN INserted */
    MERGE #wrkStgMrn trg 
    USING (SELECT mrn , mbrStg2_MbrDataUrn 
		  FROM @InsertOutput
		  ) src
    ON trg.mbrStg2_MbrDataUrn = src.mbrStg2_MbrDataUrn
    WHEN MATCHED THEN UPDATE
	   SET trg.MrnMstrKey = src.Mrn
    ;
    /* write the changes back to the stg table */
    MERGE ast.MbrStg2_MbrData trg
    USING( SELECT w.mbrStg2_MbrDataUrn, w.MrnMstrKey
		  FROM #WrkStgMrn w
		  WHERE w.MrnMstrKey <> -1 -- only write back updated mrns
		  ) src
    ON trg.mbrStg2_MbrDataUrn = src.mbrStg2_MbrDataUrn
    WHEN MATCHED THEN 
	   UPDATE SET trg.[MstrMrnKey] = src.MrnMstrKey
	   ;

    -- Log Insert count 
