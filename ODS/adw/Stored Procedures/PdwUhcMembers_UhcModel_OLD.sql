
CREATE PROCEDURE [adw].[PdwUhcMembers_UhcModel_OLD]
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
	   INSERT INTO [dbo].[Uhc_MembersByPcp](
    		  MEMBER_FIRST_NAME				  
    		  , MEMBER_LAST_NAME			  
    		  , UHC_SUBSCRIBER_ID			  
    		  , MEDICAID_ID				  
    		  , MEDICARE_ID				  
    		  , age						  
    		  , DATE_OF_BIRTH				  
    		  , GENDER					  
    		  , LANG_CODE					  
    		  , MEMBER_HOME_ADDRESS			  
    		  , MEMBER_HOME_ADDRESS2			  
    		  , MEMBER_HOME_CITY			  
    		  , MEMBER_HOME_STATE			  
		  , MEMBER_HOME_ZIP				  
    		  , MEMBER_HOME_PHONE			  
    		  , MEMBER_BUS_PHONE			  
    		  , SUBGRP_ID					  
    		  , SUBGRP_NAME				  
    		  , MEMBER_ORG_EFF_DATE			  
    		  , MEMBER_CONT_EFF_DATE			  
    		  , MEMBER_CUR_EFF_DATE			  
    		  , PCP_UHC_ID					  
    		  , PCP_FIRST_NAME				  
    		  , PCP_LAST_NAME				  
    		  , PCP_PHONE					  
    		  , PCP_ADDRESS				  
    		  , PCP_ADDRESS2				  
    		  , PCP_CITY					  
    		  , PCP_STATE					  
    		  , PCP_ZIP					  
    		  , PCP_EFFECTIVE_DATE			  
    		  , PCP_TERM_DATE				  
    		  , PCP_PRACTICE_TIN			  
    		  , PCP_PRACTICE_NAME			  
    		  , ETHNICITY					  
    		  , AUTO_ASSIGN				  
    		  , A_LAST_UPDATE_DATE			  
    		  , A_LAST_UPDATE_BY			  
    		  , A_LAST_UPDATE_FLAG	
		  , MEMBER_STATUS
		  , MEMBER_TERM_DATE		  
    		  , LoadType					  
    		  , SrcFileName				  
    		  )							  
        SELECT 
		    a.MEMB_FIRST_NAME
    		  , a.MEMB_LAST_NAME
    		  , a.SUBSCRIBER_ID
    		  , a.MEDICAID_NO
    		  , a.MEDICARE_NO
    		  , a.AGE
    		  , a.DATE_OF_BIRTH
    		  , a.MEMB_GENDER
    		  , a.MEMB_LANGUAGE
    		  , a.MEMB_ADDRESS_LINE_1
    		  , a.MEMB_ADDRESS_LINE_2
    		  , a.MEMB_CITY
    		  , a.MEMB_STATE
    		  , a.MEMB_ZIP
    		  , a.HOME_PHONE_NUMBER
    		  , a.BUS_PHONE_NUMBER
    		  , a.PLAN_CODE AS PlanCode_SgrpID
    		  , PlanMapLob.Destination SubGrpName
    		  , a.ORIGINAL_EFFECTIVE_DATE
    		  , a.CONT_EFFECTIVE_DATE
    		  , a.CURRENT_EFFECTIVE_DATE
    		  , a.PROVIDER_ID
    		  , a.PROV_FNAME
    		  , a.PROV_LNAME
    		  , a.PROV_PHONE
    		  , a.PROV_ADDRESS_LINE_1
    		  , a.PROV_ADDRESS_LINE_2
    		  , a.PROV_CITY
    		  , a.PROV_STATE
    		  , a.PROV_ZIP
    		  , a.PCP_EFFECTIVE_DATE
    		  , a.PCP_TERM_DATE
    		  , a.IRS_TAX_ID
    		  , a.PAYEE_NAME
    		  , a.MEMB_ETHNICITY
    		  , a.AUTO_ASSIGNED
    		  , CONVERT(date, a.CreatedDate) As ALastUpdateDate
    		  , a.CreatedBy
    		  , 'Y'		   AS UpdateFlag
		  , 'E'		   AS MbrStatus
		  , '2199-12-31'  AS MbrTermDate
    		  , 'P'		   AS LoadType
    		  , a.SrcFileName 	  
        FROM adi.mbrUhcMbrByProvider a
		  LEFT JOIN (SELECT am.lstAceMappingKey, am.MappingTypeKey, am.Source, am.Destination 
			 		FROM lst.ListAceMapping am 
					WHERE am.clientKey =1 
				        AND am.MappingTypeKey = 16 
				        AND IsActive = 1) PlanMapLob ON a.LINE_OF_BUSINESS = PlanMapLob.Source
        WHERE a.MbrLoadStatus = 0	   
	   ;
	   
	   /* 2. update adi load status */
	   UPDATE  a set a.MbrLoadStatus = 1
		  FROM adi.mbrUhcMbrByProvider a
		  WHERE a.MbrLoadStatus = 0;

    END
    
    -- 3.  Member SUmmary : not implemented at this time

    -- 4. 
    BEGIN
	   EXEC ast.PstUhcUpdateDboMemberStatus;
    END;

    BEGIN -- update cc tables, I think this is unneeded, but... 
	   --5.  Proc: Update CC ActiveMembers : dbo.UhcUpdateCCActiveMembers
	   EXEC cc.dbo.UhcUpdateCCActiveMembers;
	   -- 6. Proc: Update cc recall : dbo.UhcUpdateCCMemberRecall	   
	   EXEC cc.dbo.UhcUpdateCCMemberRecall;
    END

    BEGIN -- update acecaredw test member range (i think it is not needed, very old )
	   -- 7. Proc: update acecaredw_test Member range: ACECAREDW_TEST.dbo.UhcUpdateMemberRange
	   EXEC ACECAREDW_TEST.dbo.UhcUpdateMemberRange
    END
    
    BEGIN -- GET MRN values and load to adw.A_Mbr_Members
	   -- 8. Proc Get Mrn Values: ast.GetMemberMrnFromMpi_UhcDbo  adw.a_Mbr_Members trg
	   EXEC ast.GetMemberMrnFromMpi_UhcDbo
    END
    
    
    SELECT a.Client_Member_ID, count(*)
    FROM adw.A_ALT_MemberPlanHistory a
	   JOIN (    SELECT Client_Member_ID
				From adw.A_Mbr_Members m
				where m.CreatedDate >'01/01/2021') b ON a.Client_Member_ID = b.Client_Member_ID
    GROUP BY a.Client_Member_ID 
    ORDER BY a.Client_Member_ID

    
    -- 9. ETL PKG: load cs plan/mbrmember: RUN PACKAGE: ACECareDW-Integration: A_Int_Alt_PlanHistory_Primary.dtsx	   
    -- go run the pkg.
    --9.1  --   ast.PDW_UHC_AhsPlansToTermFromProviderRoster--  term ahs plans from PRoviderROster state.
    --9.2	  --  Ast.PDW_UHC_UPdateNPI_FROM_RosterORHistory   fix missing NPIs where possible

    -- 10 Create Programs not QM Fix the date of load date here:
    DECLARE @LoadDate DATE = '12/18/2020'; -- what month process are we loading  Newly enrolled for
    EXECUTE ast.PdwCreateExportProgram_NewlyEnrolledUhc @LoadDate;
    EXECUTE ast.PdwCreateExportProgram_WC15Uhc		 @LoadDate;
    EXECUTE ast.PdwCreateExportProgram_PreNatalUhc	 @LoadDate;

	/* GET NPI FROM PR or OLD data */
	-- don't run this from here, step through the code, it is not a well defined job 
    EXECUTE ast.PDW_UHC_UPdateNPI_FROM_RosterORHistory @LoadDate, '2020/11/17';

	--Load into MemberMonth Table
	DECLARE @ClientKey INT
	EXECUTE [adw].[pdwMbr_32_Load_MemberMonth_UHC] @LoadDate, @ClientKey;


END;
