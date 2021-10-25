
CREATE PROCEDURE [adw].[z_AcePdwMbrWlcMbrByPcp_29_0025_TermCsPlan]
    @LoadDate Date,
	@TermCount INT OUTPUT	
AS
--BRIT: V1:  Changes to PR
    /* date to term member Plans */
    DECLARE @TermDate DATE = DATEADD(day, (-1* (DatePart(day, @LoadDate ))),@loadDate);
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

     /* create tmp */
    IF OBJECT_ID('dbo.tmpWlcTermCsPlan') IS NOT NULL 
        DROP TABLE dbo.tmpWlcTermCsPlan;
    CREATE TABLE dbo.tmpWlcTermCsPlan (mbrCsPlanKey INT NOT NULL PRIMARY KEY, mbrMemberKey INT NOT NULL, TERMDATE DATE, BusinessRule VARCHAR(20));
    
    INSERT INTO dbo.tmpWlcTermCsPlan (mbrCsPlanKey, mbrMemberKey, TermDate, BusinessRule )
    SELECT DISTINCT csp.MbrCsPlanKey, csp.MbrMemberKey, MbrPcpToTerm.ExpDate, 'MbrNotInAdi' BusinessRule
    FROM adw.MbrCsPlanHistory csp
	    JOIN adw.MbrMember m ON csp.mbrMemberKey = m.mbrMemberKey 
		  and m.ClientKey = 2 -- limit to only client 2 mbrs
	   JOIN(SELECT p.mbrCsPlanKey, @TermDate ExpDate, CurAdiMbr.Sub_Id		  
		    FROM adw.mbrMember m
		  	 JOIN adw.MbrCsPlanHistory p ON m.mbrMemberKey = p.mbrMemberKey
	   	  		 AND @LoadDate BETWEEN p.EffectiveDate and p.ExpirationDate
		  	 LEFT JOIN (SELECT DISTINCT w.Sub_ID, w.BenePlan
	   	  			    FROM adi.tvf_PdwSrc_Wlc_MemberByPcp (@loadDate) w
		  				  WHERE w.BestMemberRow = 1) CurAdiMbr 
					ON m.ClientMemberKey = CurAdiMbr.Sub_ID		    
		    ) MbrPcpToTerm ON csp.mbrCsPlanKey = MbrPcpToTerm.mbrCsPlanKey
		    WHERE MbrPcpToTerm.Sub_ID is null
		    ;
    
    INSERT INTO dbo.tmpWlcTermCsPlan (mbrCsPlanKey, mbrMemberKey, TermDate, BusinessRule)
    SELECT DISTINCT csp.mbrCsPlanKey, csp.mbrMemberKey, PcpContractToTerm.ExpDate, 'PcpNotInContract' BusinessRule
    FROM adw.MbrCsPlanHistory csp
	   JOIN adw.MbrMember m 
		  ON csp.mbrMemberKey = m.mbrMemberKey 
		  AND m.ClientKey = 2 	
	   JOIN ( SELECT p.mbrPcpKey, m.mbrMemberKey, @TermDate ExpDate	, CurPcpContract.NPI	  
			 FROM adw.mbrMember m
		  		JOIN adw.MbrPcp p ON m.mbrMemberKey = p.mbrMemberKey
	   	  		    AND @LoadDate BETWEEN p.EffectiveDate and p.ExpirationDate
				    AND m.ClientKey = 2
		  		LEFT JOIN (SELECT DISTINCT pr.Npi, Pr.effectiveDate, pr.ExpirationDate, @TermDate ExpDate
	   	  			   	    FROM [adw].[MbrWlcProviderLookup] PR 
							 --WHERE PR.HealthPlan = 'WellCare'
								--AND pr.providerType in ('PCP')
								--AND getDate() BETWEEN pr.EffectiveDate and pr.ExpirationDate
							 ) CurPcpContract 
				     ON p.NPI = CurPcpContract.NPI			
				) PcpContractToTerm ON csp.mbrMemberKey = PcpContractToTerm.mbrMemberKey  
    WHERE @LoadDate between csp.EffectiveDate and csp.ExpirationDate	  
	   and PcpContractToTerm.npi is null
		    ;

    /*
    BEGIN TRY
	   BEGIN TRAN TermWlcMbrs
	   */
	   UPDATE adw.MbrCsPlanHistory
        SET ExpirationDate = term.TermDate
	   OUTPUT inserted.mbrCsPlanKey, 6 INTO @OutputTbl(ID, OutputType)
	   FROM dbo.tmpWlcTermCsPlan term
	   WHERE adw.mbrCsPlanHistory.mbrCsPlanKey = term.mbrCsPlanKey;
	   /*
	   COMMIT TRAN TermWlcMbrs
    END TRY
    BEGIN CATCH
	   --- write to log 
	   -- capture error values
	   ROLLBACK TRAN TermWlcMbrs
    END CATCH;
      */
    
    SELECT @TermCount = COUNT(*) 
    FROM @OutputTbl o
	   JOIN @OutPutType t ON o.OutputType = t.OutputType
    WHERE o.OutputType = 6
    GROUP BY t.Descrip ;
