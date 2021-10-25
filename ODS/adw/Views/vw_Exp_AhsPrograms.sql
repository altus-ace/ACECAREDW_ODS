CREATE VIEW [adw].[vw_Exp_AhsPrograms] 
AS 
    /* get from SHCN */
    SELECT   
	    programs.CS_Export_LobName
	  , programs.PROGRAM_NAME
	  , programs.ENROLL_DATE
	  , programs.CREATE_DATE
	  , programs.MEMBER_ID
	  , programs.ENROLL_END_DATE
	  , programs.PROGRAM_STATUS
	  , programs.REASON_DESCRIPTION
	  , programs.REFERAL_TYPE
	  , programs.ClientKey
    FROM ACDW_CLMS_SHCN_MSSP.[adw].vw_Exp_AhsPrograms AS programs;
	   
