


CREATE view [adw].[vw_Exp_Ahs_MbrHighRiskProgram] 
AS 
    SELECT 
	     HiRisk.Client_ID
	   , HiRisk.PROGRAM_NAME
	   , HiRisk.ENROLL_DATE
	   , HiRisk.CREATE_DATE
	   , HiRisk.MEMBER_ID
	   , HiRisk.ENROLL_END_DATE
	   , HiRisk.PROGRAM_STATUS
	   , HiRisk.REASON_DESCRIPTION
	   , HiRisk.REFERAL_TYPE
	   , HiRisk.ClientKey
    FROM ACDW_CLMS_SHCN_MSSP.[adw].[vw_Exp_Ahs_MbrHighRiskProgram] HiRisk;
