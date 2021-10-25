

CREATE procedure [ast].[pstLoadExpAhsEligiblity] 
AS 
    INSERT INTO ast.pstExpAhsEligiblity (ClientKey, ClientMemberKey, MbrCsPlanKey, 
		  expMember_ID, expLOB, expBENEFIT_PLAN, expInt_Ext_Indicator, expStartDate, expStopDate
		  , AdiKey, AdiTableName)
    SELECT DISTINCT mph.ClientKey, mph.ClientMemberKey Cmk, mph.mbrCsPlanKey, mph.ClientMemberKey expMemberKey
          , CASE  WHEN tmb1.DESTINATION_VALUE IS NOT NULL  THEN tmb1.DESTINATION_VALUE  ELSE 'UHC' END AS expLOB
          , mph.MbrCsSubPlanName AS expBENEFIT_PLAN
          , 'E' AS expInt_ExtIndicator
          , CONVERT(VARCHAR(10), mph.EffectiveDate) AS expStartDate -- All active members start on 1/1 end on 12/31: 								
          , CONVERT(VARCHAR(10), mph.ExpirationDate) AS expEndDate  -- This makes the plan a switch for Member Activity status  
		, mph.mbrCsPlanKey AdiKey, mph.AdiTableName AdiTableName
		/* this inline view is getting the latest eligibility for the member and alternative solution is to use order by to ensure the */
    FROM (/* New */
		  SELECT mbr.ClientMemberKey, mbr.ClientKey, cs.mbrCsPlanKey
		    , cs.MbrCsSubPlanName , cs.EffectiveDate , cs.ExpirationDate
		    , cs.mbrCsPlanKey AdiKey, 'MbrCsPlanHistory' AdiTableName
		  FROM adw.MbrMember Mbr
		     JOIN adw.mbrCsPlanHistory Cs ON mbr.mbrMemberKey = cs.MbrMemberKey
		  WHERE mbr.ClientKey = 1
		     and cs.EffectiveDate < cs.ExpirationDate
		     and cs. planHistoryStatus =1 
		     and cs.LoadDate >= '12/01/2020'
		  UNION
		  /* history */
		  SELECT mph.Client_Member_ID ClientMemberKey, 1 ClientKey, mph.A_ALT_MemberPlanHistory_ID AS MbrCsPlanKey
		     , mph.Benefit_Plan, mph.startDate, mph.stopDate
			, mph.A_ALT_MemberPlanHistory_ID AS AdiKey, 'A_ALT_MemberPlanHistory' AdiTableName
		  	  --, ROW_NUMBER() OVER (PARTITION BY mph.Client_Member_ID ORDER BY mph.startDate DESC) as aRowNum
		  	  FROM adw.A_ALT_MemberPlanHistory mph		
		  	  WHERE mph.startDate < mph.stopDate 
		  		 AND mph.planHistoryStatus = 1
		  		 and mph.A_CREATED_DATE < '12/01/2020'
		  ) mph		
		--JOIN dbo.vw_AH_Membership MbrShip  		  ON mph.Client_Member_ID = MbrShip.MEMBER_ID		
	/* this join never returns a value. It can be replaced, with the literal at the top with out decrease of quality */
	   LEFT JOIN (SELECT mb.UHC_SUBSCRIBER_ID, mb.LINE_OF_BUSINESS, mb.A_LAST_UPDATE_DATE
			     , ROW_NUMBER() OVER (PARTITION BY mb.UHC_SUBSCRIBER_ID ORDER BY mb.A_LAST_UPDATE_DATE DESC) AS aRN
				FROM dbo.UHC_Membership mb 
				) m ON mph.ClientMemberKey = m.UHC_SUBSCRIBER_ID
				    AND m.aRN = 1			 
        LEFT JOIN dbo.ALT_MAPPING_TABLES AS tmb1 ON tmb1.SOURCE_VALUE = m.LINE_OF_BUSINESS
			 AND tmb1.SOURCE = 'UHC'
			 AND tmb1.DESTINATION = 'ALTRUISTA'
                AND tmb1.TYPE = 'LINE OF BUSINESS'        
    WHERE mph.EffectiveDate < mph.ExpirationDate
    ;
