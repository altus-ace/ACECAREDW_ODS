CREATE PROCEDURE ast.MbrPstExportMbrLoadHistory
AS 
    DECLARE @OutputTbl TABLE (Action VARCHAR(20), LoadHistoryKey INT, StagingKey INT);	   
    
    /* insert into adw load history */
    MERGE adw.MbrLoadHistory trg
    USING(  SELECT stg.AdiTableName, stg.AdiKey, stg.LoadDate, stg.DataDate, stg.LoadType, stg.mbrStg2_MbrDataUrn	
			 , loadHist.mbrLoadHistoryKey
		  FROM ast.MbrStg2_MbrData stg
			 LEFT JOIN adw.MbrLoadHistory LoadHist 
				ON stg.AdiTableName = LoadHist.AdiTableName 
				    AND stg.AdiKey = LoadHist.AdiKey
		  WHERE stg.stgRowStatus in ('Valid')
			 AND LoadHist.mbrLoadHistoryKey is null
			 AND NOT stg.AdiKey IS NULL -- Remove Term Existing Member rows, as they already have load history key
			 ) src
    ON trg.MbrLoadHistoryKey = src.mbrLoadHistoryKey
    WHEN NOT MATCHED THEN 
    INSERT ([AdiTableName],[AdiKey],[LoadDate],[DataDate], loadType           )     
    VALUES (src.adiTableName, src.AdiKey, src.LoadDate, src.DataDate, src.LoadType)
    OUTPUT  $action, inserted.mbrLoadHistoryKey, src.mbrStg2_MbrDataUrn
    ;
    
    /* update staging table with new Load History Key */
    MERGE ast.MbrStg2_MbrData TRG
    USING (SELECT LoadHistoryKey, StagingKey
		  FROM @OutputTbl 
		  WHERE ACTION = 'Insert'
		  ) src
    ON trg.mbrStg2_MbrDataUrn = src.StagingKey
    WHEN MATCHED THEN UPDATE
    SET TRG.MbrLoadHistoryKey = src.LoadHistoryKey
    ;
    
    /*    
    SELECT COUNT(Insertkey) 
    FROM @OutputTbl o;
    */
    RETURN;
