CREATE PROCEDURE [adw].[PdwUhcMembers_UhcModel]@DataDate DATE
AS 
BEGIN 

    /* 
    Tasks: 
	   0. Prepare last UPdate flag on MembersBYPcp
	   1. get from adi into dbo.UhcMembersByPcp
	   2. update adi mbr load status column to 1, for all rows. 
	   3. Load Member summary from adi to dbo.uhcMembership, if the file exists. 
	   4. update from dbo.UhcMemberBYPcp with fx for Latest : ast.PstUhcUpdateDboMemberStatus 
	   5. Proc: Update CC ActiveMembers : cc. dbo.UhcUpdateCCActiveMembers
	   6. Proc: Update cc recall : cc. dbo.UhcUpdateCCMemberRecall
	   7. Proc: update acecaredw_test Member range: ACECAREDW_TEST.dbo.UhcUpdateMemberRange
	   8. Proc Get Mrn Values: ast.GetMemberMrnFromMpi_UhcDbo  adw.a_Mbr_Members trg
	   9. ETL PKG: load cs plan/mbrmember: RUN PACKAGE: ACECareDW-Integration: A_Int_Alt_PlanHistory_Primary.dtsx	   

    */

    BEGIN -- 0. Prepare last update flags
	    UPDATE p set p.A_LAST_UPDATE_FLAG = 'N'
		  FROM dbo.Uhc_MembersByPcp p
		  WHERE p.A_LAST_UPDATE_FLAG = 'L'

        UPDATE p set p.A_LAST_UPDATE_FLAG = 'L'
		  FROM dbo.Uhc_MembersByPcp p
		  WHERE p.A_LAST_UPDATE_FLAG = 'Y'
    END
    
    BEGIN/* 1. Get data from adi into dbo.UhcMembersByPcp */

	/*Load from adi*/
	EXECUTE ACDW_CLMS_UHC.ast.stg_01_pls_MembershipFromAdiToStaging @DataDate;
	   
	   /* 2. update adi load status */
	   UPDATE  a set a.Status = 1
		  FROM [ACDW_CLMS_UHC].[adi].[UHCMemberbyProvider] a
		  WHERE a.Status = 0;

    END
		 
    BEGIN -- GET MRN values and load to adw.A_Mbr_Members
	   -- 3. Proc Get Mrn Values: ast.GetMemberMrnFromMpi_UhcDbo  adw.a_Mbr_Members trg
	   EXEC ast.GetMemberMrnFromMpi_UhcDbo
    END
    
	BEGIN
    -- 4.  /*Load into MemberMonth Table*/
	EXECUTE [adw].[pdwMbr_32_Load_MemberMonth_UHC];

	/*Loading into the new FctConsolidated Table*/
	EXECUTE ACDW_CLMS_UHC.[adw].[pdw_Load_MonthlyRecordsIntoMemberMonthByMonth] @DataDate

	/*Load into Failed Membership*/
	EXECUTE ACDW_CLMS_UHC.[adw].[pdw_Load_FailedMembership]@DataDate

	END
    -- 5. 
    BEGIN
	   EXEC ast.PstUhcUpdateDboMemberStatus;
    END;

    BEGIN -- update cc tables, I think this is unneeded, but... 
	   --6.  Proc: Update CC ActiveMembers : dbo.UhcUpdateCCActiveMembers
	   EXEC cc.dbo.UhcUpdateCCActiveMembers;
	   -- 7. Proc: Update cc recall : dbo.UhcUpdateCCMemberRecall	   
	   EXEC cc.dbo.UhcUpdateCCMemberRecall;
    END

    BEGIN -- update acecaredw test member range (i think it is not needed, very old )
	   -- 8. Proc: update acecaredw_test Member range: ACECAREDW_TEST.dbo.UhcUpdateMemberRange
	   EXEC ACECAREDW_TEST.dbo.UhcUpdateMemberRange
    END
       
    
    SELECT a.Client_Member_ID, count(*)
    FROM adw.A_ALT_MemberPlanHistory a
	   JOIN (    SELECT Client_Member_ID
				From adw.A_Mbr_Members m
				where m.CreatedDate >'01/01/2021') b ON a.Client_Member_ID = b.Client_Member_ID
    GROUP BY a.Client_Member_ID 
    ORDER BY a.Client_Member_ID

    DECLARE @LoadDate DATE --= '04/27/2021'; -- what month process are we loading  Newly enrolled for
    SELECT @LoadDate  = MAX(m.A_LAST_UPDATE_DATE) FROM dbo.Uhc_MembersByPcp m	 
    
    -- 9. CS PLANS ETL PKG: load cs plan/mbrmember: RUN PACKAGE: ACECareDW-Integration: A_Int_Alt_PlanHistory_Primary.dtsx	   replaced
    BEGIN 	     
	   EXEC ast.PstUhcUpdateInsertAltPlanHistory @LoadDate;
    END
    
    -- 10 Create Programs not QM Fix the date of load date here:
    --DECLARE @LoadDate DATE = '12/18/2020'; -- what month process are we loading  Newly enrolled for
    EXECUTE ast.PdwCreateExportProgram_NewlyEnrolledUhc @LoadDate;
    EXECUTE ast.PdwCreateExportProgram_WC15Uhc		 @LoadDate;
    EXECUTE ast.PdwCreateExportProgram_PreNatalUhc	 @LoadDate;
    EXECUTE ast.PdwCreateExportProgram_Imm_0913_Adol_Uhc @LoadDate;

	/* GET NPI FROM PR or OLD data */
	-- don't run this from here, step through the code, it is not a well defined job 
	-- WE GET NPI from UHC DON't Use this any more
    --EXECUTE ast.PDW_UHC_UPdateNPI_FROM_RosterORHistory @LoadDate, '2020/11/17';

	


END;

