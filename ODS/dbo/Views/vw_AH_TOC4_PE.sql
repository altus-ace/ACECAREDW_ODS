



CREATE view [dbo].[vw_AH_TOC4_PE]
as


SELECT     
     c.PROG_ID
     , CONVERT(DATE, GETDATE(), 101) AS CREATE_DATE
     , system_user AS [CREATE_BY]
     , CONVERT(DATE, GETDATE(), 101) AS ASSIGN_DATE
     , 'SIYANOYE' AS ASSIGN_TO
     , 'ACTIVE' AS [PROG_MEMBER_STATUS]
     , [PROG_MEMBER_NOTE]
     , [APPT_STATUS]
     , [APPT_DATE]
     , C.MEMBER_ID
     , C.MEMBER_FIRST_NAME
     , C.MEMBER_LAST_NAME
     , C.DATE_OF_BIRTH
     , AM.[IPRO_ADMIT_RISK_SCORE]
     , AM.[PLAN_DESC]
     , [REGION_DESC]
     , AM.[PRIMARY_RISK_FACTOR]
     , AM.[COUNT_OPEN_CARE_OPPS]
     , AM.[LAST_INP_DISCHARGE]
     , AM.[LAST_ER_VISIT]
     , AM.[LAST_PCP_VISIT]
     , AM.[LAST_BH_VISIT]
     , AM.[TOTAL_COSTS_LAST_12_MOS]
     , '2017-08-01' AS DUE0
     , '2017-11-01' AS DUE1
     , '2018-02-01' AS DUE2
     , DUE3
     , [APPT_DATE1]
     , [APPT_DATE2]
     , [APPT_DATE3]
     , [APPT_DATE4]
     , CONVERT(DATE, GETDATE(), 101) AS [LST_UPDATE_DATE]
     , system_user AS [LST_UPDATE_BY]	
FROM cc.dbo.p14 c
     JOIN dbo.vw_UHC_ActiveMembers am ON c.MEMBER_ID = am.UHC_SUBSCRIBER_ID
/* this was used for the initail load, but all future loads will include all possible members who have ever been a HRC 
WHERE c.CREATE_DATE > '08/01/2017';
*/
;
