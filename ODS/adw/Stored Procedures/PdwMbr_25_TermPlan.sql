
CREATE PROCEDURE [adw].[PdwMbr_25_TermPlan]
    @LoadDate DATE ,
    @ClientKey INT,
	@TermCount INT OUTPUT	
	--SELECT * FROM adi.MbrAetMbrByPcp order by loaddate desc
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
    /* update the plans that are no longer found in data set: Not included in input file */
    UPDATE MbrPlan 
        SET MbrPlan.ExpirationDate = s.ExpDate
    OUTPUT inserted.mbrPlanKey, 6 INTO @OutputTbl(ID, OutputType)    
    FROM adw.MbrPlan MbrPlan
	   JOIN(SELECT p.mbrPlanKey, @TermDate ExpDate
				FROM adw.mbrMember m
				    -- limit to members for loading client
				    JOIN lst.List_Client c ON m.ClientKey = c.ClientKey
					   AND c.ClientKey = @lClientKey
		  		    JOIN -- get set of plans currently effective
					   adw.MbrPlan p ON m.mbrMemberKey = p.mbrMemberKey
	   	  			   AND @lLoadDate BETWEEN p.EffectiveDate and p.ExpirationDate
		  		    LEFT JOIN (-- get set of New(loading) mbr plans						     
							SELECT DISTINCT s.ClientSubscriberId, s.plnProductSubPlan
	   	  						FROM ast.MbrStg2_MbrData s						  
								    JOIN lst.List_Client c ON s.ClientKey = c.ClientKey
									   and c.ClientKey = @lClientKey
								WHERE LoadDate = @lLoadDate) w ON m.ClientMemberKey = w.ClientSubscriberId
				    WHERE w.ClientSubscriberId is null					   
		    ) s ON MbrPlan.mbrPlanKey = s.mbrPlanKey
		    ;

    /* update the plans that are now invalid, included in file, but not valid after processing */        
    UPDATE MbrPlan 
        SET MbrPlan.ExpirationDate = s.ExpDate
    OUTPUT inserted.mbrPlanKey, 6 INTO @OutputTbl(ID, OutputType)    
    FROM adw.MbrPlan MbrPlan
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
		    ON MbrPlan.mbrMemberKey =  s.MbrMemberKey
			 and @lLoadDate between MbrPlan.EffectiveDate and MbrPlan.ExpirationDate
		    ;
    
    SELECT @TermCount = COUNT(*) 
    FROM @OutputTbl o
	   JOIN @OutPutType t ON o.OutputType = t.OutputType
    WHERE o.OutputType = 6
    GROUP BY t.Descrip ;

