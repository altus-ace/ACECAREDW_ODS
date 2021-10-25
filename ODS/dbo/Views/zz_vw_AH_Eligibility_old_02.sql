


CREATE VIEW [dbo].[zz_vw_AH_Eligibility_old_02]
AS

/* Active Members*/

     SELECT DISTINCT
            am.MEMBER_ID
          , CASE
                WHEN tmb1.DESTINATION_VALUE IS NOT NULL
                THEN tmb1.DESTINATION_VALUE
                ELSE 'UHC'
            END AS LOB
          , CASE
                WHEN TMB2.DESTINATION_VALUE IS NOT NULL
                THEN TMB2.DESTINATION_VALUE
                ELSE ' '
            END AS [BENEFIT PLAN]
          , 'E' AS [ INTERNAL/EXTERNAL INDICATOR]
          , '01-01-2017' AS START_DATE -- All active members start on 1/1 end on 12/31: 
								-- This makes the plan a switch for Member Activity status  
          , '2099-12-31' AS END_DATE
         --   'A' RecordType
     FROM dbo.vw_UHC_ActiveMembers am
          LEFT JOIN dbo.ALT_MAPPING_TABLES AS tmb1 ON tmb1.SOURCE_VALUE = am.LINE_OF_BUSINESS
                                                      AND tmb1.SOURCE = 'UHC'
                                                      AND tmb1.DESTINATION = 'ALTRUISTA'
                                                      AND tmb1.TYPE = 'LINE OF BUSINESS'
          LEFT JOIN dbo.ALT_MAPPING_TABLES AS tmb2 ON tmb2.SOURCE_VALUE = am.SUBGRP_ID
                                                      AND tmb2.SOURCE = 'UHC'
                                                      AND tmb2.DESTINATION = 'ALTRUISTA'
                                                      AND tmb2.TYPE = 'PLAN CODE'
	  
     
	UNION
	
/*Termed Members*/

     SELECT DISTINCT
            utm.MEMBER_ID
          , CASE
                WHEN tmb1.DESTINATION_VALUE IS NOT NULL
                THEN tmb1.DESTINATION_VALUE
                ELSE 'UHC'
            END AS LOB
          , CASE
                WHEN TMB2.DESTINATION_VALUE IS NOT NULL
                THEN TMB2.DESTINATION_VALUE
                ELSE ' '
            END AS [BENEFIT PLAN]
          , 'E' AS [ INTERNAL/EXTERNAL INDICATOR]
          , '01/01/2017' AS START_DATE -- All Termed members start on 1/1 end on The termination date: 
								-- This makes the plan an Off switch for TERMED Member Activity status  
          , utm.MEMBER_TERM_DATE AS END_DATE
        --  'T' RecordType
     FROM dbo.vw_UHC_TermedMembers utm
          LEFT JOIN dbo.ALT_MAPPING_TABLES AS tmb1 ON tmb1.SOURCE_VALUE = utm.LINE_OF_BUSINESS
                                                      AND tmb1.SOURCE = 'UHC'
                                                      AND tmb1.DESTINATION = 'ALTRUISTA'
                                                      AND tmb1.TYPE = 'LINE OF BUSINESS'
          LEFT JOIN dbo.ALT_MAPPING_TABLES AS tmb2 ON tmb2.SOURCE_VALUE = utm.SUBGRP_ID
                                                      AND tmb2.SOURCE = 'UHC'
                                                      AND tmb2.DESTINATION = 'ALTRUISTA'
                                                      AND tmb2.TYPE = 'PLAN CODE'
     UNION
    
/* Plan change, old plan terms */

     SELECT DISTINCT
            UMP.MEMBER_ID
          , CASE
                WHEN tmb1.DESTINATION_VALUE IS NOT NULL
                THEN tmb1.DESTINATION_VALUE
                ELSE 'UHC'
            END AS LOB
          , UMP.[OLD_PLAN] AS [BENEFIT PLAN]
          , 'E' AS [INTERNAL/EXTERNAL INDICATOR]
          , UMP.[OLD_PLAN_START_DATE] AS [START_DATE]
          , UMP.[OLD_PLAN_END_DATE] AS [END_DATE]
		--, 'C' RecordType
     FROM vw_UHC_Members_PlanChange ump
          INNER JOIN DBO.UHC_Membership UM ON UM.UHC_SUBSCRIBER_ID = UMP.MEMBER_ID
          INNER JOIN dbo.ALT_MAPPING_TABLES AS tmb1 ON tmb1.SOURCE_VALUE = UM.LINE_OF_BUSINESS
                                                       AND tmb1.SOURCE = 'UHC'
                                                       AND tmb1.DESTINATION = 'ALTRUISTA'
                                                       AND tmb1.TYPE = 'LINE OF BUSINESS';
    


