
CREATE VIEW [adw].[vw_EXP_AH_ProgramEnrollment_NotQM]
AS 
    SELECT 
           m.ExpLobName				 AS Client_id,    
           m.ExpProgram_Name			 AS Program_Name, 
           m.ExpEnrollDate			 AS Enroll_date, 
           m.ExpCreateDate  			 AS Create_date, 
           m.ExpEnrollEndDate   		 AS Enroll_End_date, 
           m.ExpMemberID		  	 AS Member_id, 
           m.ExpProgramstatus		 AS PROGRAM_STATUS, 
           m.ExpReasonDescription		 AS REASON_DESCRIPTION,
           m.ExpReferalType 			 AS REFERAL_TYPE
    	   ,m.Exported, m.ExportedDate
    	   ,m.ExportAhsProgramsKey, m.ProgramID, m.ClientKey
    FROM adw.ExportAhsPrograms m
         JOIN lst.lstClinicalPrograms cp ON M.ProgramID = cp.lstAhsProgramsKey
    WHERE m.Exported = 0
	UNION 
	SELECT 
           m.ExpLobName				 AS Client_id,    
           m.ExpProgram_Name			 AS Program_Name, 
           m.ExpEnrollDate			 AS Enroll_date, 
           m.ExpCreateDate  			 AS Create_date, 
           m.ExpEnrollEndDate   		 AS Enroll_End_date, 
           m.ExpMemberID		  	 AS Member_id, 
           m.ExpProgramstatus		 AS PROGRAM_STATUS, 
           m.ExpReasonDescription		 AS REASON_DESCRIPTION,
           m.ExpReferalType 			 AS REFERAL_TYPE
    	   ,m.Exported, m.ExportedDate
    	   ,m.ExportAhsProgramsKey, m.ProgramID, m.ClientKey
    FROM ACDW_CLMS_AMGTX_MA.adw.ExportAhsPrograms m
         JOIN lst.lstClinicalPrograms cp ON M.ProgramID = cp.lstAhsProgramsKey
    WHERE m.Exported = 0
	UNION 
	SELECT 
           m.ExpLobName				 AS Client_id,    
           m.ExpProgram_Name			 AS Program_Name, 
           m.ExpEnrollDate			 AS Enroll_date, 
           m.ExpCreateDate  			 AS Create_date, 
           m.ExpEnrollEndDate   		 AS Enroll_End_date, 
           m.ExpMemberID		  	 AS Member_id, 
           m.ExpProgramstatus		 AS PROGRAM_STATUS, 
           m.ExpReasonDescription		 AS REASON_DESCRIPTION,
           m.ExpReferalType 			 AS REFERAL_TYPE
    	   ,m.Exported, m.ExportedDate
    	   ,m.ExportAhsProgramsKey, m.ProgramID, m.ClientKey
    FROM ACDW_CLMS_CIGNA_MA.adw.ExportAhsPrograms m
         JOIN lst.lstClinicalPrograms cp ON M.ProgramID = cp.lstAhsProgramsKey
    WHERE m.Exported = 0
	UNION 
	SELECT 
           m.ExpLobName				 AS Client_id,    
           m.ExpProgram_Name			 AS Program_Name, 
           m.ExpEnrollDate			 AS Enroll_date, 
           m.ExpCreateDate  			 AS Create_date, 
           m.ExpEnrollEndDate   		 AS Enroll_End_date, 
           m.ExpMemberID		  	 AS Member_id, 
           m.ExpProgramstatus		 AS PROGRAM_STATUS, 
           m.ExpReasonDescription		 AS REASON_DESCRIPTION,
           m.ExpReferalType 			 AS REFERAL_TYPE
    	   ,m.Exported, m.ExportedDate
    	   ,m.ExportAhsProgramsKey, m.ProgramID, m.ClientKey
    FROM ACDW_CLMS_WLC.adw.ExportAhsPrograms m
         JOIN lst.lstClinicalPrograms cp ON M.ProgramID = cp.lstAhsProgramsKey
    WHERE m.Exported = 0
