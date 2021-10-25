
CREATE PROCEDURE [adw].[z_AcePdwMbrWlcMbrByPcp_27_0025_TermPcp]
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
    IF OBJECT_ID('dbo.tmpWlcTermPcp') IS NOT NULL 
        DROP TABLE dbo.tmpWlcTermPcp;    	   
    CREATE TABLE dbo.tmpWlcTermPcp (mbrPcpKey INT NOT NULL PRIMARY KEY, mbrMemberKey INT NOT NULL, TERMDATE DATE, BusinessRule VARCHAR(20));

    /* load terms for members excluded from the adi load:  MbrNotInAdi */
    INSERT INTO dbo.tmpWlcTermPcp (mbrPcpKey, mbrMemberKey, TermDate, BusinessRule)
    SELECT DISTINCT Pcp.mbrPcpKey, Pcp.mbrMemberKey, MbrPcpToTerm.ExpDate, 'MbrNotInAdi' BusinessRule
    FROM adw.MbrPcp Pcp
	   JOIN adw.MbrMember m 
		  ON Pcp.mbrMemberKey = m.mbrMemberKey 
			 AND m.ClientKey = 2 
	   JOIN(SELECT p.mbrPcpKey, @TermDate ExpDate, CurAdiMbr.Sub_ID		  
			 FROM adw.mbrMember m
		  		JOIN adw.MbrPcp p ON m.mbrMemberKey = p.mbrMemberKey
	   	  		    AND @LoadDate BETWEEN p.EffectiveDate and p.ExpirationDate
				    AND m.ClientKey = 2
		  		LEFT JOIN (SELECT DISTINCT w.Sub_ID, w.BenePlan
	   	  			   	    FROM adi.tvf_PdwSrc_Wlc_MemberByPcp(@LoadDate) w
						    WHERE w.BestMemberRow = 1 
						 ) CurAdiMbr 
					 ON m.ClientMemberKey = CurAdiMbr.Sub_ID
				WHERE CurAdiMbr.Sub_ID is null
		    ) MbrPcpToTerm ON Pcp.mbrPcpKey = MbrPcpToTerm.mbrPcpKey
		    WHERE MbrPcpToTerm.Sub_ID is null
		    ;
    /* load terms for members whose pcp has gone out of contract: PcpNotInContract */
    INSERT INTO dbo.tmpWlcTermPcp (mbrPcpKey, mbrMemberKey, TermDate, BusinessRule)
    SELECT DISTINCT Pcp.mbrPcpKey, Pcp.mbrMemberKey, PcpContractToTerm.ExpDate, 'PcpNotInContract' BusinessRule
    FROM adw.MbrPcp Pcp
	   JOIN adw.MbrMember m 
		  ON Pcp.mbrMemberKey = m.mbrMemberKey 
		  AND m.ClientKey = 2 	
	   JOIN ( SELECT p.mbrPcpKey, @TermDate ExpDate	, CurPcpContract.NPI	  
			 FROM adw.mbrMember m
		  		JOIN adw.MbrPcp p ON m.mbrMemberKey = p.mbrMemberKey
	   	  		    AND @LoadDate BETWEEN p.EffectiveDate and p.ExpirationDate
				    AND m.ClientKey = 2
		  		LEFT JOIN (SELECT DISTINCT pr.Npi, Pr.effectiveDate, pr.ExpirationDate, @TermDate ExpDate
	   	  			   	    FROM [adw].[MbrWlcProviderLookup] PR 
							 --WHERE PR.HealthPlan = 'WellCare'  --made changes to reflect the new PR
								--AND PR.providerType in ('PCP')
								--AND getDate() BETWEEN pr.EffectiveDate and pr.ExpirationDate
							 ) CurPcpContract 
				     ON p.NPI = CurPcpContract.NPI			
				) PcpContractToTerm ON PCP.mbrPcpKey = PcpContractToTerm.mbrPcpKey  
    WHERE @LoadDate between pcp.EffectiveDate and Pcp.ExpirationDate	  
	   and PcpContractToTerm.npi is null
		    ;

        
    /*
    BEGIN TRY
	   BEGIN TRAN TermWlcMbrs
	   */
	   UPDATE adw.MbrPcp
	       SET ExpirationDate = term.TermDate
	   OUTPUT inserted.mbrPcpKey, 6 INTO @OutputTbl(ID, OutputType)
	   FROM dbo.tmpWLcTermPcp term
	   WHERE adw.MbrPcp.MbrPcpKey = term.mbrPcpKey;
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
