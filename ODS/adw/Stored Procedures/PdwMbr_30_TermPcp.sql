

CREATE PROCEDURE [adw].[PdwMbr_30_TermPcp]
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

    /* update the PCP rows not found in the input set: excluded by exception */
    UPDATE adw.MbrPcp
        SET ExpirationDate = s.ExpDate
    OUTPUT inserted.mbrPcpKey, 6 INTO @OutputTbl(ID, OutputType)    
    FROM adw.MbrPcp
	   JOIN(SELECT p.mbrPcpKey, @TermDate ExpDate		  
		    FROM adw.mbrMember m
			 JOIN lst.List_Client c ON m.clientKey = c.ClientKey
				AND c.ClientKey = @lClientKey
		  	 JOIN adw.MbrPcp p ON m.mbrMemberKey = p.mbrMemberKey
	   	  		 AND @lLoadDate BETWEEN p.EffectiveDate and p.ExpirationDate
		  	 LEFT JOIN (-- get the new plans
					   SELECT DISTINCT w.ClientSubscriberId, w.plnProductPlan, w.LoadDate
	   	  				  FROM ast.MbrStg2_MbrData w
		  				  WHERE w.LoadDate = @lLoadDate) w ON m.ClientMemberKey = w.ClientSubscriberId
			 WHERE w.ClientSubscriberId is null
		    ) s ON adw.MbrPcp.mbrPcpKey = s.mbrPcpkey
		    ;
    /* Update the rows not valid after processing: excluded by Invalidation */    
    UPDATE adw.MbrPcp
        SET ExpirationDate = s.ExpDate
    OUTPUT inserted.mbrPcpKey, 6 INTO @OutputTbl(ID, OutputType)    
    FROM adw.MbrPcp MbrPcp
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
	   ON MbrPcp.mbrMemberKey =  s.MbrMemberKey
		  and @lLoadDate between MbrPcp.EffectiveDate and MbrPcp.ExpirationDate

    SELECT @TermCount = COUNT(*) 
    FROM @OutputTbl o
	   JOIN @OutPutType t ON o.OutputType = t.OutputType
    WHERE o.OutputType = 6
    GROUP BY t.Descrip ;
