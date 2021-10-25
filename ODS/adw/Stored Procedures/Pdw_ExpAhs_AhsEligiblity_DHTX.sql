﻿
CREATE PROCEDURE [adw].[Pdw_ExpAhs_AhsEligiblity_DHTX]
AS 
BEGIN
	/* objective 
		1. get all dates available for membership, 
		2. then load all member month records from fct membership into working talbe
		3. then pivot member months into a record for eacm member, plan and continous date range
		4. export to the adw table for persistant storage 
		*/
	DECLARE @FirstMemberMonth DATE = '01/01/2020';  /* this is the first month that has valid data, earlier data is not REAL */
	DECLARE @ClientKey INT = 11;
	BEGIN
	/* clear working tables */
	
	TRUNCATE TABLE ast.DatesToProcess_AhsExpElig;
	TRUNCATE TABLE ast.AhsExpElig_MbrCsPlanInfo;
	TRUNCATE TABLE ast.AhsExpEligiblity;
	/* PREP */	
	INSERT INTO ast.DatesToProcess_AhsExpElig (ClientKey, LoadDate, FirstDayOfMonth, LastDayOfMonth)
	SELECT @ClientKey, mbr.LoadDate, FirstDay.dDate, LastDay.dDate
	FROM (SELECT lh.LoadDate
		   FROM adw.MbrMember mbr
			 JOIN adw.MbrLoadHistory lh ON mbr.mbrLoadKey = lh.mbrLoadHistoryKey
		   WHERE Mbr.ClientKey = @ClientKey
			 and lh.LoadDate >= @FirstMemberMonth 
		   GROUP BY lh.LoadDate		   
		   ) mbr
	    JOIN acdw_clms_shcn_mssp.adw.dimDate dDate ON mbr.loadDate = dDate.dDate
	    JOIN acdw_clms_shcn_mssp.adw.dimDate FirstDay 
			ON dDate.dYear = firstDay.dYear 
				and dDate.dMonth = firstDay.dMonth 
				and FirstDay.dDay = 1
	    JOIN acdw_clms_shcn_mssp.adw.dimDate LastDay 
			ON dDate.dYear = lastDay.dYear 
				and dDate.dMonth = lastDay.dMonth 
				and LastDay.dDay = (SELECT Max(d.dDay)
								 FROM acdw_clms_shcn_mssp.adw.dimDate d
								 WHERE d.dYear = Year(mbr.LoadDate)
									and d.dMonth = Month(Mbr.LoadDate))
	ORDER BY mbr.LoadDate asc
	END;
	-- SELECT * FROM ast.DatesToProcess_AhsExpElig

	DECLARE @LoadDate DATE;
	SELECT @LoadDate = MAX(lh.LoadDate)	
	FROM adw.MbrMember mbr
	   JOIN adw.MbrLoadHistory lh ON mbr.mbrLoadKey = lh.mbrLoadHistoryKey
	where Mbr.ClientKey = @ClientKey
	
	DECLARE @iBuildWorkingSet smallint;
	DECLARE @BatchLoadDate DATE;
	DECLARE @StartDate DATE;
	DECLARE @StopDate DATE;
	SELECT @iBuildWorkingSet = COUNT(*) FROm ast.DatesToProcess_AhsExpElig P1 WHERE P1.status_Load = 0
	--select * from ast.DatesToProcess_AhsExpElig
	   SELECT @iBuildWorkingSet 

	/* GET DATA */
	/*		build working dataset 1 row per member per month from fctMbrshp */
	WHILE @iBuildWorkingSet > 0 
	BEGIN 
	    SELECT TOP 1 @batchLoadDate = b.LoadDate, @startDate = b.FirstDayOfMonth, @StopDate = b.LastDayOfMonth
	    FROM ast.DatesToProcess_AhsExpElig b
		WHERE b.status_load = 0
		ORDER BY b.loadDate asc
	 
	   BEGIN -- 1 row per member per month,
	 
		  INSERT INTO ast.AhsExpElig_MbrCsPlanInfo (ClientKey, CMK, CsPlanName, CsPlanEffDate, CsPlanExpDate, FctMbrRwEffDate, FctMbr_Skey, mbrCsPlanDim_SKey)        
		  SELECT lc.ClientKey, mbr.ClientMemberKey, CsPlan.MbrCsSubPlanName, DatesToProcess.FirstDayOfMonth, DatesToProcess.LastDayOfMonth, mbr.LoadDate, CsPlan.mbrCsPlanKey, CsPlan.mbrCsPlanKey
		  FROM [adw].mbrMember mbr	   
			 JOIN  ast.DatesToProcess_AhsExpElig DatesToProcess ON DatesToProcess.LoadDate= @BatchLoadDate
			 INNER JOIN lst.[List_Client] lc ON lc.ClientKey = mbr.ClientKey                             
			 INNER JOIN [adw].mbrCsPlanHistory CsPlan
				ON CsPlan.EffectiveDate < CsPlan.ExpirationDate	 
				    AND CsPlan.mbrMemberKey = mbr.mbrMemberKey
		  WHERE mbr.ClientKey = @ClientKey
			 and @BatchLoadDate between CsPlan.EffectiveDate and CsPlan.ExpirationDate
			 and csPlan.planHistoryStatus = 1 -- is active
		END    	 
		BEGIN
			UPDATE b set b.status_load = 1
				--SELECT *
			FROM ast.DatesToProcess_AhsExpElig b
		    WHERE b.LoadDate = @BatchLoadDate;
		END;
	
		SELECT @iBuildWorkingSet = COUNT(*) FROM ast.DatesToProcess_AhsExpElig P1 WHERE P1.status_load = 0;   
	END

	--SELECT * from ast.DatesToProcess_AhsExpElig 
	--SELECT * from ast.AhsExpElig_MbrCsPlanInfo 


	DECLARE @iCalcWorkingSet smallint;	
	SELECT @iCalcWorkingSet = COUNT(*) FROm ast.DatesToProcess_AhsExpElig P1 WHERE P1.status_CalcElig = 0
	
	--SELECT @iCalcWorkingSet 
	/* Calc Elig */
	WHILE @iCalcWorkingSet > 0 
	BEGIN 
	    SELECT TOP 1 @batchLoadDate = b.LoadDate, @startDate = b.FirstDayOfMonth, @StopDate = b.LastDayOfMonth
	    FROM ast.DatesToProcess_AhsExpElig b
		WHERE b.status_CalcElig = 0
		ORDER BY b.loadDate asc
	    
	    BEGIN 
			/* insert new Mbr Plan combinations  THIS IS WHERE THE LAST SET IS NULL (it is not found in ast tble)*/
	        INSERT INTO ast.AhsExpEligiblity (ClientMemberKey, ClientKey, fctMembershipKey, Exp_MEMBER_ID, Exp_LOB, [Exp_BENEFIT PLAN],
					[Exp_INTERNAL/EXTERNAL INDICATOR],[Exp_START_DATE] ,[Exp_END_DATE], StgRowStatus, LoadDate )			
			SELECT MbrCsPlan.cmk, @ClientKey, mbrCsPlan.FctMbr_Skey,  mbrCsPlan.CMK, Client.CS_Export_LobName, MbrCsPlan.CsPlanName, 
				'E', MbrCsPlan.CsPlanEffDate, MbrCsPlan.CsPlanExpDate, 'Loaded', @LoadDate
			 FROM  ast.AhsExpElig_MbrCsPlanInfo MbrCsPlan
			 	JOIN lst.List_Client client ON @ClientKey = Client.ClientKey
				LEFT JOIN ast.AhsExpEligiblity LastSet 
			 		ON MbrCsPlan.cmk = LastSet.ClientMemberKey								--- must be same member
			 		AND MbrCsPlan.csPlanName = LastSet.[Exp_BENEFIT PLAN]					--- must be same plan
			 		AND DATEADD(day, -1, MbrCsPlan.CsPlanEffDate) = LastSet.[Exp_END_DATE]--- must bump last record end into new start (they must be continous, else add new)
			 WHERE @BatchLoadDate between MbrCsPlan.CsPlanEffDate and MbrCsPlan.CsPlanExpDate
				    AND LastSet.AhsExpEligibilityKey IS NULL				
			 GROUP BY MbrCsPlan.cmk, mbrCsPlan.FctMbr_Skey, mbrCsPlan.CMK, Client.CS_Export_LobName, MbrCsPlan.CsPlanName, 
			     MbrCsPlan.CsPlanEffDate, MbrCsPlan.CsPlanExpDate;
		END   
		BEGIN /* Update end date where the new row matches an existing row on mbr and plan and the dates but up */
			UPDATE LastSet SET LastSet.[Exp_END_DATE] =  MbrCsPlan.CsPlanExpDate      
			--SELECT MbrCsPlan.cmk, MbrCsPlan.CsPlanName, MbrCsPlan.FctMbrRwEffDate
			FROM  ast.AhsExpElig_MbrCsPlanInfo MbrCsPlan
				JOIN lst.List_Client client ON @ClientKey = Client.ClientKey
				LEFT JOIN ast.AhsExpEligiblity LastSet 
					ON MbrCsPlan.cmk = LastSet.ClientMemberKey								--- must be same member
					AND MbrCsPlan.csPlanName = LastSet.[Exp_BENEFIT PLAN]					--- must be same plan
					AND DATEADD(day, -1, MbrCsPlan.CsPlanEffDate) = LastSet.[Exp_END_DATE]--- must bump last record end into new start (they must be continous, else add new)
			WHERE @BatchLoadDate between MbrCsPlan.CsPlanEffDate and MbrCsPlan.CsPlanExpDate
			AND NOT LastSet.AhsExpEligibilityKey IS NULL
			and LastSet.StgRowStatus = 'Loaded'
		END
		BEGIN
			UPDATE b set b.status_CalcElig = 1
				--SELECT *
			FROM ast.DatesToProcess_AhsExpElig b
		    WHERE b.LoadDate = @BatchLoadDate;
		END;
	
		SELECT @iCalcWorkingSet = COUNT(*) FROM ast.DatesToProcess_AhsExpElig P1 WHERE P1.status_CalcElig = 0;   
	
	END

	--SELECT * from ast.DatesToProcess_AhsExpElig 
	--SELECT * from ast.AhsExpElig_MbrCsPlanInfo 
	--SELECT * FROM ast.AhsExpEligiblity e   ORDER BY e.ClientMemberKey, e.Exp_START_DATE asc
	
	/* Transform in stging */
	-- 1 finalized and set end date to 12/31/2099 
	DECLARE @MaxEndDate DATE 
	SELECT @MaxEndDate = MAX(ast.Exp_END_DATE)
	FROM ast.AhsExpEligiblity ast
	WHERE ast.StgRowStatus = 'Loaded'
	
	UPDATE ast SET ast.Exp_END_DATE = '12/31/2099'
	   --SELECT *
	FROM ast.AhsExpEligiblity ast
	WHERE ast.StgRowStatus = 'Loaded'
	   AND ast.Exp_END_DATE = @MaxEndDate 
	/* validate the records in staging */
	
	/*xport to Adw */
    INSERT INTO adw.AhsExpEligiblity (CreatedDate, CreatedBy, LastUpdatedDate, LastUpdatedBy, ClientMemberKey, ClientKey
	   , fctMembershipKey, Exp_MEMBER_ID, Exp_LOB, [Exp_BENEFIT PLAN], [Exp_INTERNAL/EXTERNAL INDICATOR],Exp_START_DATE, Exp_END_DATE, LoadDate)	
    SELECT e.CreatedDate, e.CreatedBy, e.LastUpdatedDate, e.LastUpdatedBy, e.ClientMemberKey, e.ClientKey, 
       e.fctMembershipKey, e.Exp_MEMBER_ID, e.Exp_LOB, e.[Exp_BENEFIT PLAN], e.[Exp_INTERNAL/EXTERNAL INDICATOR], e.Exp_START_DATE, e.Exp_END_DATE, e.LoadDate
    FROM ast.AhsExpEligiblity e;

END;