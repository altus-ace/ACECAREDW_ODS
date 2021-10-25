
CREATE PROCEDURE [adw].[PdwMbr_29_TermCsPlan]
    @LoadDate Date,
      @ClientKey INT,
	@TermCount INT OUTPUT	
AS
    /* date to term member Plans */
    DECLARE @lLoadDate DATE = @LoadDate;
    DECLARE @lClientKey INT = @ClientKey;
    DECLARE @TermDate DATE = DATEADD(day, (-1* (DatePart(day, @lLoadDate ))),@lLoadDate);
    /* SET UP OUTPUT TABLES and CODES */
	   /* OutPutType: INT 
	   1 = working set insert 
	   2	= Insert New
	   3 = Version working Set
	   4 = Version Term
	   5 = version Insert
	   6 = Termed Member */
    DECLARE @OutPutType TABLE (OutputType TinyInt, Descrip VARCHAR(30));
    INSERT INTO @OutPutType (OutputType, Descrip)
    VALUES (1,'Working Set insert')
		 ,(2,'Insert New')
		 ,(3,'Version working Set')
		 ,(4,'Version Term')
		 ,(5, 'Version Insert')
		 ,(6, 'Termed Member');
    DECLARE @OutputTbl TABLE (ID INT, OutputType INT);
    /* Upate the cs plans not included in the input file: not found in input set */
    UPDATE adw.MbrCsPlanHistory
        SET ExpirationDate = s.ExpDate
    OUTPUT inserted.mbrCsPlanKey, 6 INTO @OutputTbl(ID, OutputType)    
    FROM adw.MbrCsPlanHistory
	   JOIN(SELECT p.mbrCsPlanKey, @TermDate ExpDate		  
		    FROM adw.mbrMember m
			 JOIN lst.List_Client c ON m.clientKey = c.ClientKey
				AND c.ClientKey = @lClientKey
		  	 JOIN adw.MbrCsPlanHistory p ON m.mbrMemberKey = p.mbrMemberKey
	   	  		 AND @lLoadDate BETWEEN p.EffectiveDate and p.ExpirationDate
		  	 LEFT JOIN (-- get the new plans
					   SELECT DISTINCT w.ClientSubscriberId, w.plnProductPlan, w.LoadDate
	   	  				  FROM ast.MbrStg2_MbrData w
		  				  WHERE w.LoadDate = @lLoadDate) w ON m.ClientMemberKey = w.ClientSubscriberId
			 WHERE w.ClientSubscriberId is null
		    ) s ON adw.MbrCsPlanHistory.mbrCsPlanKey = s.mbrCsPlanKey
		    ;
    /* Upate csPlans not valid after processing */    
    UPDATE MbrCs 
        SET MbrCs.ExpirationDate = s.ExpDate
    OUTPUT inserted.mbrCsPlanKey, 6 INTO @OutputTbl(ID, OutputType)    
    FROM adw.mbrCsPlanHistory MbrCs
    JOIN(SELECT DISTINCT Mbr.mbrMemberKey, @TermDate ExpDate
		  FROM ast.MbrStg2_MbrData ast						  
			 JOIN lst.List_Client c ON ast.ClientKey = c.ClientKey
				and c.ClientKey = @lClientKey
			 JOIN adw.MbrMember mbr 
				ON ast.ClientSubscriberId = mbr.ClientMemberKey  and ast.ClientKey = mbr.ClientKey
		  WHERE ast.LoadDate = @lLoadDate
			 and ast.ClientKey = @lClientKey
			and ast.stgRowStatus = 'Not Valid'
	   ) s 
	   ON MbrCs.mbrMemberKey =  s.MbrMemberKey
		  and @lLoadDate between MbrCs.EffectiveDate and MbrCs.ExpirationDate
		    ;

    SELECT @TermCount = COUNT(*) 
    FROM @OutputTbl o
	   JOIN @OutPutType t ON o.OutputType = t.OutputType
    WHERE o.OutputType = 6
    GROUP BY t.Descrip ;

