CREATE VIEW [dbo].[vw_AH_Eligibility_Old]
AS
    /* 11/06/2017: GK converted over to use A_Alt_MemberPlanHistory */
    /* 11/18:GK Make view produce 1 row of export : Used rowNumber and inline view*/
    /* 11/20:GK Make export all valid eligiblity rows (stop date > Start date) */
    SELECT DISTINCT
            mph.Client_Member_ID AS [MEMBER_ID]
          , CASE
                WHEN tmb1.DESTINATION_VALUE IS NOT NULL
                THEN tmb1.DESTINATION_VALUE
                ELSE 'UHC'
            END AS LOB
          , mph.Benefit_Plan AS [BENEFIT PLAN]
          , 'E' AS [INTERNAL/EXTERNAL INDICATOR]
          , CONVERT(VARCHAR(10), mph.startDate) AS START_DATE -- All active members start on 1/1 end on 12/31: 
								-- This makes the plan a switch for Member Activity status  
          , CONVERT(VARCHAR(10), mph.stopDate) AS END_DATE
		/* this inline view is getting the latest eligibility for the member and alternative solution is to use order by to ensure the */
    FROM (SELECT mph.Client_Member_ID, mph.Benefit_Plan, mph.startDate, mph.stopDate
		  --, ROW_NUMBER() OVER (PARTITION BY mph.Client_Member_ID ORDER BY mph.startDate DESC) as aRowNum
		  FROM adw.A_ALT_MemberPlanHistory mph		
		  WHERE mph.startDate < mph.stopDate 
			 AND mph.planHistoryStatus = 1
		  ) mph		
		JOIN dbo.vw_AH_Membership MbrShip 
		  ON mph.Client_Member_ID = MbrShip.MEMBER_ID		
	/* this join never returns a value. It can be replaced, with the literal at the top with out decrease of quality */
	   LEFT JOIN (SELECT mb.UHC_SUBSCRIBER_ID, mb.LINE_OF_BUSINESS, mb.A_LAST_UPDATE_DATE
			     , ROW_NUMBER() OVER (PARTITION BY mb.UHC_SUBSCRIBER_ID ORDER BY mb.A_LAST_UPDATE_DATE DESC) AS aRN
				FROM dbo.UHC_Membership mb 
				) m ON mph.Client_Member_ID = m.UHC_SUBSCRIBER_ID
				    AND m.aRN = 1			 
        LEFT JOIN dbo.ALT_MAPPING_TABLES AS tmb1 ON tmb1.SOURCE_VALUE = m.LINE_OF_BUSINESS
			 AND tmb1.SOURCE = 'UHC'
			 AND tmb1.DESTINATION = 'ALTRUISTA'
                AND tmb1.TYPE = 'LINE OF BUSINESS'        
    WHERE mph.startDate < mph.stopDate    
    ;
