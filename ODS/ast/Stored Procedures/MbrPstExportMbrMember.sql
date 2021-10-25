
CREATE PROCEDURE ast.MbrPstExportMbrMember
AS 
    CREATE TABLE #OutputTbl (Action VARCHAR(20), MbrMemberKey INT, StagingKey INT);
    /* Upsert Members: Insert new rows, UPdate MRN where it is different */    
    MERGE adw.MbrMember trg
    USING (SELECT mbr.MbrMemberKey, stg.ClientSubscriberId, stg.ClientKey, stg.MstrMrnKey
			 , stg.MbrLoadHistoryKey, stg.LoadDate, stg.DataDate, stg.mbrStg2_MbrDataUrn
		  FROM ast.MbrStg2_MbrData stg
			 LEFT JOIN adw.MbrMember Mbr 
				ON stg.ClientSubscriberId = mbr.ClientMemberKey 
				    AND stg.ClientKey = mbr.ClientKey
		  WHERE stg.stgRowStatus in ('Valid')	   
			 AND NOT stg.AdiKey IS NULL -- Remove Term Existing Member rows, as they already have load history key
		  ) src
    ON trg.MbrMemberKey = src.MbrMemberKey  
    WHEN NOT MATCHED THEN
	   INSERT (ClientMemberKey, ClientKey, MstrMrnKey, MbrLoadKey, LoadDate, DataDate)
	   VALUES (src.ClientSubscriberId, src.ClientKey, src.MstrMrnKey, src.MbrLoadHistoryKey, src.LoadDate, Src.DataDate)
    WHEN MATCHED  AND trg.MstrMrnKey <> src.MstrMrnKey THEN -- MRN can be different, update it
	   UPDATE SET trg.MstrMrnKey = src.MstrMrnKey
    OUTPUT $action, inserted.MbrMemberKey, src.MbrStg2_MbrDataUrn
    INTO #OutputTbl
    ;
   
    MERGE ast.MbrStg2_MbrData trg
    USING (SELECT MbrMemberKey, StagingKey
		  FROM #OutputTbl 
		  WHERE Action = 'Insert'
		  )src
    ON trg.mbrStg2_MbrDataUrn= src.StagingKey
    WHEN MATCHED  THEN UPDATE
    SET trg.MbrMemberKey = src.MbrMemberKey
    ;
   	
    RETURN; 
    
