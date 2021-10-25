CREATE VIEW  dbo.vw_Exp_AH_PE_NewMembers_DEV  
As        
    SELECT -- Bcbs
	  m.Client_id, 
       m.Program_ID, 
       m.Program_Name, 
       m.Enroll_date, 
       m.Create_date, 
       m.Enroll_End_date, 
       m.Member_id, 
       m.PROGRAM_STATUS, 
       m.REASON_DESCRIPTION, 
       m.REFERAL_TYPE, 
       m.ClientKey
    FROM ACDW_CLMS_SHCN_BCBS.dbo.vw_Exp_AH_PE_NewMembers m;
    -- these all need to be implemented
--    UNION
--    SELECT  -- MSSP doesnt'work
--	   m.*
--    FROM ACDW_CLMS_SHCN_MSSP.dbo.vw_Exp_AH_PE_NewMembers m
--    UNION
--    SELECT -- UHC
--    SELECT -- AceCareDw members

