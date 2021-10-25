﻿



CREATE VIEW [abo].[vw_EXP_AH_MemberPCP] 
AS 
    SELECT -- UHC
	   CONVERT(NVARCHAR(255), RTRIM(mp.[MEMBER_ID])) AS MEMBER_ID, CONVERT(NVARCHAR(255), RTRIM(mp.[MEMBER_PCP])) AS MEMBER_PCP , 
	   CONVERT(NVARCHAR(255), RTRIM(mp.[PROVIDER_RELATIONSHIP_TYPE])) AS PROVIDER_RELATIONSHIP_TYPE, 
	   CONVERT(NVARCHAR(255), RTRIM(mp.[LOB])) AS LOB, 
	   CONVERT(NVARCHAR(255), RTRIM(mp.[PCP_EFFECTIVE_DATE])) AS PCP_EFFECTIVE_DATE,
	   CONVERT(NVARCHAR(255), RTRIM(mp.[PCP_TERM_DATE])) AS PCP_TERM_DATE, 
	   CONVERT(NVARCHAR(255), RTRIM(mp.[MEMBER_PCP_ADDITIONAL_INFORMATION_1])) AS MEMBER_PCP_ADDITIONAL_INFORMATION_1	   
    FROM ACECAREDW.dbo.vw_AH_MemberPCP mp
    UNION
    SELECT -- acecare members
	   CONVERT(NVARCHAR(255), RTRIM(mp.[MEMBER_ID])) AS MEMBER_ID, CONVERT(NVARCHAR(255), RTRIM(mp.[MEMBER_PCP])) AS MEMBER_PCP , 
	   CONVERT(NVARCHAR(255), RTRIM(mp.[PROVIDER_RELATIONSHIP_TYPE])) AS PROVIDER_RELATIONSHIP_TYPE, 
	   CONVERT(NVARCHAR(255), RTRIM(mp.[LOB])) AS LOB, 
	   CONVERT(NVARCHAR(255), RTRIM(mp.[PCP_EFFECTIVE_DATE])) AS PCP_EFFECTIVE_DATE,
	   CONVERT(NVARCHAR(255), RTRIM(mp.[PCP_TERM_DATE])) AS PCP_TERM_DATE, 
	   CONVERT(NVARCHAR(255), RTRIM(mp.[MEMBER_PCP_ADDITIONAL_INFORMATION_1])) AS MEMBER_PCP_ADDITIONAL_INFORMATION_1	   
    FROM ACECAREDW.dbo.vw_AH_WC_MemberPCP mp
	   join lst.List_Client l ON mp.LOB = l.CS_Export_LobName
    UNION
    SELECT -- MSSP
	   CONVERT(NVARCHAR(255), RTRIM(mp.[MEMBER_ID])) AS MEMBER_ID, CONVERT(NVARCHAR(255), RTRIM(mp.[MEMBER_PCP])) AS MEMBER_PCP , 
	   CONVERT(NVARCHAR(255), RTRIM(mp.[PROVIDER_RELATIONSHIP_TYPE])) AS PROVIDER_RELATIONSHIP_TYPE, 
	   CONVERT(NVARCHAR(255), RTRIM(mp.[LOB])) AS LOB, 
	   CONVERT(NVARCHAR(255), RTRIM(mp.[PCP_EFFECTIVE_DATE])) AS PCP_EFFECTIVE_DATE,
	   CONVERT(NVARCHAR(255), RTRIM(mp.[PCP_TERM_DATE])) AS PCP_TERM_DATE, 
	   CONVERT(NVARCHAR(255), RTRIM(mp.[MEMBER_PCP_ADDITIONAL_INFORMATION_1])) AS MEMBER_PCP_ADDITIONAL_INFORMATION_1	   
    FROM ACDW_CLMS_SHCN_MSSP.dbo.vw_EXP_AH_MemberPCP mp
        join lst.List_Client l ON mp.LOB = l.CS_Export_LobName    
--    UNION 
--    SELECT -- bcbs
--	   CONVERT(NVARCHAR(255), RTRIM(mp.[MEMBER_ID])) AS MEMBER_ID, CONVERT(NVARCHAR(255), RTRIM(mp.[MEMBER_PCP])) AS MEMBER_PCP , 
--	   CONVERT(NVARCHAR(255), RTRIM(mp.[PROVIDER_RELATIONSHIP_TYPE])) AS PROVIDER_RELATIONSHIP_TYPE, 
--	   CONVERT(NVARCHAR(255), RTRIM(mp.[LOB])) AS LOB, 
--	   CONVERT(NVARCHAR(255), RTRIM(mp.[PCP_EFFECTIVE_DATE])) AS PCP_EFFECTIVE_DATE,
--	   CONVERT(NVARCHAR(255), RTRIM(mp.[PCP_TERM_DATE])) AS PCP_TERM_DATE, 
--	   CONVERT(NVARCHAR(255), RTRIM(mp.[MEMBER_PCP_ADDITIONAL_INFORMATION_1])) AS MEMBER_PCP_ADDITIONAL_INFORMATION_1
--	   , l.ClientKey
--    FROM ACDW_CLMS_SHCN_BCBS.dbo.vw_EXP_AH_MemberPCP mp
--        join lst.List_Client l ON mp.LOB = l.CS_Export_LobName    
    ;
