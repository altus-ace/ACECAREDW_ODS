
CREATE PROCEDURE [ast].[GetMemberMrnFromMpi_UhcDbo]  
AS   

/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
/* load data into Staging Input Table */  

    TRUNCATE TABLE AceMpi.ast.MPI_SOURCETABLE ;
    
    MERGE AceMpi.ast.MPI_SOURCETABLE trg
    USING (SELECT m.UHC_SUBSCRIBER_ID AS ClientSubscriberId, 1 AS ClientKey,              
    	       m.MEMBER_LAST_NAME AS mbrLastName,  m.MEMBER_FIRST_NAME AS mbrFirstName, m.MEMBER_MI AS mbrMiddleName,              
    	       '' AS mbrSSN, m.GENDER mbrGENDER, m.DATE_OF_BIRTH mbrDob,          
    	       m.MEDICAID_ID AS  mbrMEDICAID_NO, m.MEDICARE_ID AS mbrMEDICARE_ID, '' AS HICN, '' AS MBI, '' AS AltMemberID1, '' AS AltMemberID2,              
    	       m.ETHNICITY_DESC AS mbrEthnicity, '' AS  mbrRace,  '' mbrPrimaryLanguage,          
    	       m.PCP_NPI AS prvNPI, m.PCP_PRACTICE_TIN AS prvTIN,  m.AUTO_ASSIGN prvAutoAssign, m.PCP_EFFECTIVE_DATE prvClientEffective, m.PCP_TERM_DATE prvClientExpiration,              
    	       m.plan_id AS plnProductPlan,  m.SUBGRP_ID AS plnProductSubPlan,  '' AS plnProductSubPlanName,  '' AS  plnMbrIsDualCoverage, '' AS plnClientPlanEffective,                 
    	       '' AS rspLastName, '' AS rspFirstName, '' AS rspAddress1, '' AS rspAddress2, '' AS rspCITY, '' AS rspSTATE, '' AS rspZIP, '' AS rspPhone,                 
    	       m.SrcFileName SrcFileName,                
    	       'dbo.Uhc_MemberByPcp' AS AdiTableName,          
    	       m.URN AdiKey,              
    	       CONVERT(DATE, GETDATE()) LoadDate,          
    	       A_Last_Update_Date DataDate,                 
    	       m.URN ExternalUniqueID      , 'TX' AS MemberState
    	   FROM aceCareDW.dbo.uhc_MembersByPcp m      
    	   WHERE m.A_Last_Update_Flag = 'Y'
		   AND	RESULT = 'Passed'
    	   ) src
    ON trg.ExternalUniqueID = src.ExternalUniqueID
        AND trg.LoadDate = src.LoadDate
    WHEN NOT MATCHED BY TARGET THEN 
        INSERT (ClientSubscriberId,  ClientKey,           
    	   mbrLastName,  mbrFirstName, mbrMiddleName,          
    	   mbrSSN, mbrGENDER, mbrDob,      
    	   mbrMEDICAID_NO, mbrMEDICARE_ID, HICN, MBI, AltMemberID1, AltMemberID2,          
    	   mbrEthnicity, mbrRace,  mbrPrimaryLanguage,      
    	   prvNPI, prvTIN,  prvAutoAssign, prvClientEffective, prvClientExpiration,          
    	   plnProductPlan,  plnProductSubPlan,  plnProductSubPlanName,  plnMbrIsDualCoverage, plnClientPlanEffective,             
    	   rspLastName, rspFirstName, rspAddress1, rspAddress2, rspCITY, rspSTATE, rspZIP, rspPhone,             
    	   SrcFileName,            
    	   AdiTableName,      
    	   AdiKey,          
    	   LoadDate,      
    	   DataDate,             
    	   ExternalUniqueID, MbrState )
        VALUES (src.ClientSubscriberId,  src.ClientKey,           
    	   src.mbrLastName,  src.mbrFirstName, src.mbrMiddleName,          
    	   src.mbrSSN, src.mbrGENDER, src.mbrDob,      
    	   src.mbrMEDICAID_NO, src.mbrMEDICARE_ID, src.HICN, src.MBI, src.AltMemberID1, src.AltMemberID2,          
    	   src.mbrEthnicity, src.mbrRace,  src.mbrPrimaryLanguage,      
    	   src.prvNPI, src.prvTIN,  src.prvAutoAssign, src.prvClientEffective, src.prvClientExpiration,          
    	   src.plnProductPlan,  src.plnProductSubPlan,  src.plnProductSubPlanName,  src.plnMbrIsDualCoverage, src.plnClientPlanEffective,             
    	   src.rspLastName, src.rspFirstName, src.rspAddress1, src.rspAddress2, src.rspCITY, src.rspSTATE, src.rspZIP, src.rspPhone,             
    	   src.SrcFileName,            
    	   src.AdiTableName,      
    	   src.AdiKey,          
    	   src.LoadDate,      
    	   src.DataDate,             
    	   src.ExternalUniqueID,
	   Src.MemberState)
    	   ;
    
    /* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
    /* Execute MPI Job */      
    
        -- Call MPI Execution SP
        EXECUTE AceMPI.[adw].[Load_MasterJob_MPI] ;
    
    /* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
    /* Get Result from Staging Output Table */
    
    
        BEGIN TRAN UpSertMbrMember
        MERGE adw.a_Mbr_Members trg
        USING (SELECT mpiOut.MstrMrn, mpiOut.ExternalUniqueID, MPcp.UHC_SUBSCRIBER_ID, Mpcp.A_LAST_UPDATE_DATE, MPcp.A_LAST_UPDATE_FLAG, mbr.Client_Member_ID, mbr.A_MSTR_MRN, mbr.A_Member_MRN_ID
    	   FROM AceMpi.ast.MPI_OutputTable mpiOut
    		  JOIN dbo.Uhc_MembersByPcp MPcp ON mpiOut.ExternalUniqueID = MPcp.URN
    		  LEFT JOIN adw.A_Mbr_Members MBR 
    			 ON MPcp.UHC_SUBSCRIBER_ID = MBR.Client_Member_ID
    			 and mbr.Active = 1
    	   ) src 
        ON trg.A_Member_MRN_ID = src.A_Member_MRN_ID
        WHEN NOT MATCHED BY Target THEN 
        INSERT ([A_MSTR_MRN],[Client_Member_ID],[A_Client_ID], [Active])    
            VALUES (src.MstrMrn, Src.Uhc_Subscriber_ID, 1, 1)
        WHEN MATCHED THEN UPDATE SET
            trg.A_MSTR_MRN = src.MstrMrn
            , trg.LastUPdatedDate = GETDATE()
            , trg.LastUpdatedBy = SYSTEM_USER
            ;
        commit TRAN UpSertMbrMember   -- commit TRAN UpSertMbrMember
