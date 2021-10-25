CREATE  PROCEDURE ast.pdwExpAhsEligibility_Master ( @LoadDate Date)
AS 
begin 
    
    --SELECT ae.ClientMemberKey, ae.expStartDate, ae.expStopDate, ae.expBENEFIT_PLAN
    --FROM ast.pstExpAhsEligiblity ae    
    --WHERE ae.RowStatus =0
    --use this to validate outcome
    /*
    SELECT ae.RowStatus, count(*)
    FROM ast.pstExpAhsEligiblity ae
    group by ae.RowStatus     
    */

-- 00 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
-- prepare the area
    truncate table ast.pstExpAhsEligiblity
-- Load the starting data 
    execute ast.pstLoadExpAhsEligiblity; -- task 2

-- 0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
-- set new to 1 as a default, all others 0
--0. update if new set rowStatus = 1: keep
    --SELECT ae.pstExpAhsEligiblityKey
    update ae set ae.RowStatus = 1
    FROM ast.pstExpAhsEligiblity ae
    WHERE (ae.AdiTableName = 'MbrCsPlanHistory') -- new
-- 1 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
-- NO plan change: invalidate new
-- 1.a. update old set rowstatus - 1
	   --SELECT ae.*
	   UPDATE ae SET ae.RowStatus = 1
	   FROM ast.pstExpAhsEligiblity ae 
	       JOIN (SELECT ae.ClientMemberKey NewCmk, ae.expStartDate Newstart, ae.expStopDate NewStop, ae.expBENEFIT_PLAN NewBen, ae.pstExpAhsEligiblityKey NewKey, o.*     
	   		  FROM ast.pstExpAhsEligiblity ae    
	   		  JOIN (SELECT ae.ClientMemberKey, ae.expStartDate, ae.expStopDate, ae.expBENEFIT_PLAN, ae.pstExpAhsEligiblityKey oldKey
	   				FROM ast.pstExpAhsEligiblity ae    
	   				WHERE (ae.AdiTableName <> 'MbrCsPlanHistory') --old
	   			 ) o ON ae.ClientMemberKey = o.ClientMemberKey
	   				and ae.expStopDate = o.expStopDate
	   				and ae.expBENEFIT_PLAN = o.expBENEFIT_PLAN
	   	   WHERE (ae.AdiTableName = 'MbrCsPlanHistory') -- new
	       ) src ON ae.pstExpAhsEligiblityKey = src.oldKey
-- 1.b. update new set rowstutus = 10
	   --SELECT ae.*
	   update ae SET ae.rowStatus = 10
	   FROM ast.pstExpAhsEligiblity ae 
	       JOIN (SELECT ae.ClientMemberKey NewCmk, ae.expStartDate Newstart, ae.expStopDate NewStop, ae.expBENEFIT_PLAN NewBen, ae.pstExpAhsEligiblityKey NewKey, o.*     
	   		  FROM ast.pstExpAhsEligiblity ae    
	   		  JOIN (SELECT ae.ClientMemberKey, ae.expStartDate, ae.expStopDate, ae.expBENEFIT_PLAN, ae.pstExpAhsEligiblityKey oldKey
	   				FROM ast.pstExpAhsEligiblity ae    
	   				WHERE (ae.AdiTableName <> 'MbrCsPlanHistory') --old
	   			 ) o ON ae.ClientMemberKey = o.ClientMemberKey
	   				and ae.expStopDate = o.expStopDate
	   				and ae.expBENEFIT_PLAN = o.expBENEFIT_PLAN
	   	   WHERE (ae.AdiTableName = 'MbrCsPlanHistory') -- new
	       ) src ON ae.pstExpAhsEligiblityKey = src.NewKey
-- 2. XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--   Plan Change: Old gets termed  new starts 12/1  New compared to old
	   IF OBJECT_ID('tempdb..#tmpOldNewPlanCHange') IS NOT NULL DROP TABLE  #tmpOldNewPlanCHange 
	   		
        SELECT ae.ClientMemberKey NewCmk, ae.expStartDate Newstart, ae.expStopDate NewStop, ae.expBENEFIT_PLAN NewBen, ae.pstExpAhsEligiblityKey NewKey, o.*     
	   INTO #tmpOldNewPlanChange
        FROM ast.pstExpAhsEligiblity ae    
    		JOIN (SELECT ae.ClientMemberKey oldCmk, ae.expStartDate OldStart, ae.expStopDate OldStop, ae.expBENEFIT_PLAN OldBen, ae.pstExpAhsEligiblityKey oldKey
      				   FROM ast.pstExpAhsEligiblity ae    
    	 		   WHERE (ae.AdiTableName <> 'MbrCsPlanHistory') -- old
      				    ) o ON ae.ClientMemberKey = o.oldCmk
    		and ae.expStopDate = o.OldStop
    		and ae.expBENEFIT_PLAN <> o.OldBen
	   WHERE (ae.AdiTableName = 'MbrCsPlanHistory') -- new
-- 2.a. old gets termed
        --SELECT ae.RowStatus ,1 , ae.ExpStopDate , DATEADD(day, -1, src.Newstart) newStop, src.*        	   
	   UPDATE ae SET ae.RowStatus = 1, ae.expStopDate = DATEADD(day, -1, src.Newstart) -- newStop
        FROM ast.pstExpAhsEligiblity ae
    	   JOIN #tmpOldNewPlanChange src
    			 ON ae.pstExpAhsEligiblityKey = src.oldKey
-- 2.b. New set status code =1 
        --SELECT ae.RowStatus ,1 , src.*        	   
	   UPDATE ae SET ae.RowStatus = 1
        FROM ast.pstExpAhsEligiblity ae
    	   JOIN #tmpOldNewPlanChange src
    			 ON ae.pstExpAhsEligiblityKey = src.NewKey
-- 3. XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
-- Check:  are there any new left in zero status: there should not be
    /* 
    SELECT distinct ae.AdiTableName
    FROM ast.pstExpAhsEligiblity ae    
    WHERE ae.RowStatus =0        
    
    */
-- 4. XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
-- Old not part effective in transition period (12/1/2020)
-- 4. Update old set RowStatus = 1: the New records for the same plan are just new data.
    --SELECT ae.ClientMemberKey oCmk, ae.expStartDate oStart, ae.expStopDate oStop, ae.expBENEFIT_PLAN oBen
    UPDATE ae SET ae.RowStatus = 1
    FROM ast.pstExpAhsEligiblity ae    	  
    WHERE (ae.AdiTableName <> 'MbrCsPlanHistory') -- OLD
	   AND ae.expStopDate < '12/31/2099'
	   AND ae.RowStatus = 0
-- 5. XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
-- term these: IN Old not in New, term last day of new last month
    --SELECT ae.pstExpAhsEligiblityKey, src.*
    UPDATE ae SET ae.expStopDate = src.NewOldStopDate, ae.rowStatus = 1
    FROM ast.pstExpAhsEligiblity ae
	   JOIN (SELECT '11/30/2020' NewOldStopDate, o.oldCmk, o.OldStart, o.oldStop, o.OldBen, o.OldKey     	   	   
			 FROM ast.pstExpAhsEligiblity ae    
    				RIGHT JOIN (SELECT ae.ClientMemberKey oldCmk, ae.expStartDate OldStart, ae.expStopDate OldStop, ae.expBENEFIT_PLAN OldBen, ae.pstExpAhsEligiblityKey oldKey
      				   	   FROM ast.pstExpAhsEligiblity ae    
    	 					   WHERE (ae.AdiTableName <> 'MbrCsPlanHistory') -- old
							 and ae.RowStatus = 0
						  ) o ON ae.ClientMemberKey = o.oldCmk				    
    							 and ae.expBENEFIT_PLAN <> o.OldBen
							 and ae.expStopDate = o.OldStop
							 --and ae.RowStatus = 1 -- new
							 and (ae.AdiTableName = 'MbrCsPlanHistory') -- old
				WHERE ae.ClientMemberKey is null    -- THESE ARE TERMS 
	   --ORDER BY o.oldCmk , o.OldStart
		  ) src
		  ON ae.pstExpAhsEligiblityKey = src.OldKey;
-- 10  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
-- ARe there dupes in the valid records?
    Declare @startDateDups int;
    Declare @stopDateDups INT;
    
    -- this should become an error raise 
    
    --SELECT ae.clientMEmberKey, ae.expStartDate, COUNT(*)
    SELECT @startDateDups = COUNT(*) 
	   FROM ast.pstExpAhsEligiblity ae
	   WHERE ae.RowStatus = 1
	   GROUP BY ae.clientMEmberKey, ae.expStartDate
	   having count(*) > 1

    --SELECT ae.clientMEmberKey, ae.expStopDate, COUNT(*)
    SELECT @stopDateDups = COUNT(*)
	   FROM ast.pstExpAhsEligiblity ae
	   WHERE ae.RowStatus = 1
	   GROUP BY ae.clientMEmberKey, ae.expStopDate
	   having count(*) > 1
    
    SELECT @startDateDups , @stopDateDups

    /* export to adw  */
    MERGE adw.ExportAhsEligiblity TRG
    USING(SELECT ae.pstExpAhsEligiblityKey,  ae.AdiTableName, ae.AdiKey, 
		  @LoadDate LoadDate,
		  0 Exported, ae.ClientKey, ae.ClientMemberKey, ae.MbrCsPlanKey, 
		  ae.expMember_ID, ae.expLOB, ae.expBENEFIT_PLAN, ae.expInt_Ext_Indicator, ae.expStartDate, ae.expStopDate
		  FROM ast.pstExpAhsEligiblity ae
		  WHERE ae.RowStatus = 1 -- for export
		  ) SRC
    ON TRG.ClientMemberKey = SRC.ClientMemberKey
	   AND TRG.LOADDATE = SRC.LOADDATE
	   AND TRG.ExportStatus = 0		-- has not been exported
    WHEN MATCHED THEN UPDATE 
	   SET          
       TRG.AdiTableName 				    = SRC.AdiTableName 
       , TRG.AdiKey 				    = SRC.AdiKey               
       , TRG.ClientKey 				    = SRC.ClientKey        
       , TRG.MbrCsPlanKey 			    = SRC.MbrCsPlanKey 
       , TRG.expMember_ID 			    = SRC.expMember_ID 
       , TRG.expLOB 				    = SRC.expLOB 
       , TRG.expBENEFIT_PLAN 			    = SRC.expBENEFIT_PLAN 
       , TRG.expInt_Ext_Indicator 		    = SRC.expInt_Ext_Indicator 
       , TRG.expStartDate 			    = SRC.expStartDate 
       , TRG.expStopDate				    = SRC.expStopDate
    WHEN NOT MATCHED THEN 
	   INSERT  (AdiTableName, AdiKey, LoadDate, ExportStatus, ClientKey, ClientMemberKey, MbrCsPlanKey, 
		  	   expMember_ID, expLOB, expBENEFIT_PLAN, expInt_Ext_Indicator, expStartDate, expStopDate)
	   VALUES (SRC.AdiTableName, SRC.AdiKey, SRC.LoadDate, SRC.Exported, SRC.ClientKey, SRC.ClientMemberKey, SRC.MbrCsPlanKey, 
			 SRC.expMember_ID, SRC.expLOB, SRC.expBENEFIT_PLAN, SRC.expInt_Ext_Indicator, SRC.expStartDate, SRC.expStopDate)
    ;
    /* read to export to target table */

END

;
