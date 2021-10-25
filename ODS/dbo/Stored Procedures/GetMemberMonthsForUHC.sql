

CREATE PROCEDURE dbo.GetMemberMonthsForUHC --     [dbo].[GetMemberMonthsForUHC]1,'2020-11-17'
    @ClientKey INT, @DataDate DATE OUTPUT
AS


/* 
     Add All UHC Historical from 2017
	 Use load type P (Primary to ensure no duplicate record)
	 */

        ;WITH UHC_DATA AS  (
                SELECT  
                       t.A_LAST_UPDATE_DATE AS MemberMonth, 
                       CONVERT(INT, 1) AS ClientKey, 
                       'MEDICAID' AS LOB, 
                       t.UHC_SUBSCRIBER_ID AS ClientMemberKey, 
                       t.PCP_NPI AS PCP_NPI, 
                       t.PLAN_ID, 
                       t.CLASS_PLAN_ID AS PLANCODE, 
                       t.SUBGRP_ID, 
                       t.SUBGRP_NAME,
                       CASE
                           WHEN t.pcp_practice_tin = '752894111'
                           THEN '300491632'
                           ELSE CONVERT(INT, t.pcp_practice_tin)
                       END AS pcp_practice_tin, 
                       t.PCP_PRACTICE_NAME, 
                       t.MEMBER_FIRST_NAME, 
                       t.MEMBER_LAST_NAME, 
                       t.GENDER, 
                       t.AGE, 
                       t.DATE_OF_BIRTH, 
                       t.MEMBER_HOME_ADDRESS, 
                       t.MEMBER_HOME_ADDRESS2, 
                       t.MEMBER_HOME_CITY, 
                       t.MEMBER_HOME_STATE, 
                       t.MEMBER_HOME_ZIP, 
                       t.MEMBER_HOME_PHONE, 
                       '' [IPRO_ADMIT_RISK_SCORE], 
                       GETDATE() RUNDATE, 
                       SYSTEM_USER RUNBY, 
                       ROW_NUMBER() OVER(PARTITION BY t.UHC_SUBSCRIBER_ID,t.A_LAST_UPDATE_DATE 
                       ORDER BY t.A_LAST_UPDATE_DATE DESC) AS URN
                FROM acecaredw.dbo.Uhc_MembersByPcp t
				where t.LoadType='P'
			    and t.A_LAST_UPDATE_DATE=  @DataDate --'2020-11-17' --(select max(y.A_LAST_UPDATE_DATE) from acecaredw.dbo.Uhc_MembersByPcp y) /* to get latest data load for UHC**/ 
            ) 
	INSERT INTO dbo.tmpAllMemberMonths
     ([MemberMonth], 
      [ClientKey], 
      [LOB], 
      [ClientMemberKey], 
      [PCP_NPI], 
      [PLAN_ID], 
      [PLAN_CODE], 
      [SUBGRP_ID], 
      [SUBGRP_NAME], 
      [PCP_PRACTICE_TIN], 
      [PCP_PRACTICE_NAME], 
      [MEMBER_FIRST_NAME], 
      [MEMBER_LAST_NAME], 
      [GENDER], 
      [AGE], 
      [DATE_OF_BIRTH], 
      [MEMBER_HOME_ADDRESS], 
      [MEMBER_HOME_ADDRESS2], 
      [MEMBER_HOME_CITY], 
      [MEMBER_HOME_STATE], 
      [MEMBER_HOME_ZIP], 
      [MEMBER_HOME_PHONE], 
      [IPRO_ADMIT_RISK_SCORE], 
      [RunDate], 
      [RunBy]
     )
            SELECT DISTINCT 
                   k.MemberMonth, 
                   k.ClientKey, 
                   k.LOB, 
                   k.ClientMemberKey, 
				   k.PCP_NPI,
                   k.PLAN_ID, 
                   k.PLANCODE, 
                   k.SUBGRP_ID, 
                   k.SUBGRP_NAME, 
				   k.pcp_practice_tin,
                   k.PCP_PRACTICE_NAME, 
                   k.MEMBER_FIRST_NAME, 
                   k.MEMBER_LAST_NAME, 
                   k.GENDER, 
                   k.AGE, 
                   k.DATE_OF_BIRTH, 
                   k.MEMBER_HOME_ADDRESS, 
                   k.MEMBER_HOME_ADDRESS2, 
                   k.MEMBER_HOME_CITY, 
                   k.MEMBER_HOME_STATE, 
                   k.MEMBER_HOME_ZIP, 
                   k.MEMBER_HOME_PHONE, 
                   '' [IPRO_ADMIT_RISK_SCORE], 
                   GETDATE() RUNDATE, 
                   SYSTEM_USER RUNBY
				 
            FROM UHC_DATA k
            WHERE k.URN = 1;