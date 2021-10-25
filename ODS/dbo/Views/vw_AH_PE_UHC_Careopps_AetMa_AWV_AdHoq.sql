



create VIEW [dbo].[vw_AH_PE_UHC_Careopps_AetMa_AWV_AdHoq]
AS
(
/*
    GET ACTIVE_Members
    join QM That are active for those member
        filter for qm mapping
        filter Plan
        fiter Program

	   Set the List tables List_QM_MAPPING, lstCareOptToPlan lstMapCareOpToProgram to use the AceMasterData version for now. will switch back when the the changes are broad cast
	   CHANGED THE inline view for the careops to use the GetQmDate.MaxDate so the set is automatically only the latest load for the client
    */

    SELECT Client.CS_Export_LobName 
        , CONVERT(NVARCHAR(1000), CareOpToPrograms.DESTINATION_PROGRAM_NAME) PROGRAM_NAME
        , CONVERT(NVARCHAR, ActiveMembers.CLIENT_SUBSCRIBER_ID) AS MEMBER_ID
        , dateadd(day, -1*day(CONVERT(DATE, CareOp.CreateDate, 101))+1,CONVERT(DATE,CareOp.CreateDate, 101)) AS ENROLL_DATE 			 
        , CareOp.CreateDate AS CREATE_DATE
        /* EDIT: Changed Enroll_End_Date Per Business Need that it ends on last day of currrent year RA/GK*/
        , CASE WHEN (ActiveMembers.WCV_IsLess16Months = 1) THEN ActiveMembers.WCV_ProgEndDate
    				ELSE CONVERT(DATE, '12/31/' + convert(VARCHAR(4),YEar(GETDATE())), 101) 
    				END AS ENROLL_END_DATE 
        , 'ACTIVE' AS PROGRAM_STATUS
        , 'Enrolled in a Program' AS REASON_DESCRIPTION
        /*changing the referal type to UHC CareOpps instead of External- change request received form Dee and ICT*/
        , Client.ClientShortName  +  ' CareOpps' AS REFERAL_TYPE		
	   , Client.ClientKey
        --, CareOp.QM_ResultByMbr_HistoryKey, CareOp.QmMsrId, CareOp.QmCntCat, CareOp.QMDate, CareOp.QM_DESC
        --, CareOpToPlan.lstCareOpToPlanKey, CareOpToPlan.CsPlan, CareOpToPlan.EffectiveDate, CareOpToPlan.ExpirationDate        
    FROM (SELECT AM.CLIENT_SUBSCRIBER_ID, am.SUBGRP_ID, am.DATE_OF_BIRTH, am.CurMonthsOld
    	       , DATEADD(Month, 15, am.DATE_OF_BIRTH) as WCV_ProgEndDate
    	       , CASE WHEN (am.CurMonthsOld<=15) THEN 1 ELSE 0 END AS WCV_IsLess16Months    
    	       , csp.MbrCsSubPlanName    
    	   FROM [dbo].[tvf_Activemembers](GETDATE()) AM
    	       JOIN adw.mbrCsPlanHistory csp ON AM.mbrCsPlanKey = csp.mbrCsPlanKey        
    	   WHERE AM.clientkey = 3--<> 1
--    	   UNION
--    	   SELECT am.UHC_SUBSCRIBER_ID, am.SUBGRP_ID, am.DATE_OF_BIRTH, am.CurMonthsOld
--    	       , DATEADD(Month, 15, am.DATE_OF_BIRTH) as WCV_ProgEndDate
--    	       , CASE WHEN (am.CurMonthsOld<=15) THEN 1 ELSE 0 END AS WCV_IsLess16Months    
--    	       , SubGrpMap.Destination AS ProductSubCode
--    	   FROM dbo.vw_UHC_ActiveMembers am
--    	       JOIN lst.ListAceMapping AS SubGrpMap
--    	   	   ON am.SUBGRP_ID = SubGrpMap.source		  
--    			 AND SubGrpMap.MappingTypeKey = 2
--    			 AND SubGrpMap.clientkey = 1
        ) AS ActiveMembers
        JOIN (/* Care Ops  Removed for 2020: measure UHC_CDC_9 is inverted, the NUM must be used to create the CAre Ops programs */    		  
    		   SELECT cop.QM_ResultByMbr_HistoryKey, cop.ClientKey, cop.QmMsrId
    		  	, CASE WHEN (cop.QmCntCat = 'COP') THEN 'EXPCOP' END as QmCntCat
    		  	, cop.QMDate, cop.ClientMemberKey, cop.CreateDate, cop.QM_DESC
    		  	FROM (SELECT cop.QM_ResultByMbr_HistoryKey, cop.ClientKey, cop.QmMsrId, cop.QmCntCat
    		  		   , cop.QMDate , cop.ClientMemberKey, cop.CreateDate, QmMap.QM_DESC
    		  		   ,row_NUMBER() OVER (PARTITION BY cop.ClientMemberKey, cop.QmMsrID, cop.QmCntCat ORDER BY cop.[QMDate] DESC) arn
    		  		   FROM adw.QM_ResultByMember_History cop 
    		  			 JOIN AceMasterData.lst.LIST_QM_Mapping QmMap ON cop.QmMsrId = QmMap.QM AND QmMap.ACTIVE = 'Y'	 
    		  			  JOIN (SELECT MAX(qm.QmDate) MaxQmDate, DATEFROMPARTS(Year(Max(qm.QMDate)), 1, Month(MAX(qm.QmDate))) aQmDate , qm.ClientKey
    		  					FROM adw.QM_ResultByMember_History qm                
    		  					GROUP BY qm.ClientKey) AS GetQmDate  
    		  					ON cop.ClientKey = GetQmDate.ClientKey
    		  					    --AND cop.QmDate >= GetQmDate.aQmDate
							    AND cop.QmDate >= GetQmDate.MaxQmDate
    		  		   WHERE cop.QmCntCat = 'COP'
    		  			  AND cop.QmMsrId <> 'UHC_CDC_G_9'
    		  		   ) cop
    		  	WHERE cop.arn = 1			
    		  	)AS CareOp
    	   ON ActiveMembers.CLIENT_SUBSCRIBER_ID = CareOp.ClientMemberKey		  	
        JOIN lst.List_Client Client ON CareOp.ClientKey = Client.ClientKey    
        JOIN AceMasterData.lst.lstCareOpToPlan AS CareOpToPlan
    	   ON ActiveMembers.MbrCsSubPlanName = CareOpToPlan.CsPlan
    		  AND Client.ClientKey = CareOpToPlan.ClientKey 
		  AND CareOp.QmMsrId = CareOpToPlan.MeasureID 
    		  --AND CareOp.QM_DESC = CareOpToPlan.MeasureDesc 
    		  AND GETDATE() BETWEEN CareOpToPlan.EffectiveDate and CareOpToPlan.ExpirationDate
    --    JOIN dbo.ACE_MAP_CAREOPPS_PROGRAMS AS CareOpToPrograms
        JOIN AceMasterData.lst.lstMapCareoppsPrograms AS CareOpToPrograms
    	   ON   CareOpToPrograms.is_active = 1
    		  --AND CareOpToPlan.MeasureDesc = CareOpToPrograms.SOURCE_MEASURE_NAME 
    		  --AND CareOpToPlan.SubMeasure = CareOpToPrograms.SOURCE_SUB_MEASURE_NAME					
		  AND CareOp.QMDate BETWEEN CareOpToPrograms.EffectiveDate and CareOpToPrograms.ExpirationDate  --* Changed 11/03: GK to fix dup cop
		  AND CareOp.QmMsrId = CareOpToPrograms.ACE_PROG_ID
    		  AND CareOpToPrograms.DESTINATION = 'ALTRUISTA'	
    UNION
    SELECT DISTINCT [CLIENT_ID]
      ,[PROGRAM_NAME]
      ,[MEMBER_ID]
      ,[ENROLL_DATE]
      ,[CREATE_DATE]
      ,[ENROLL_END_DATE]
      ,[PROGRAM_STATUS]
      ,[REASON_DESCRIPTION]
      ,[REFERAL_TYPE]
	 , 3  AS ClientKey
    FROM [ACECAREDW].[dbo].[vw_AH_PE_AET_Careopps]
    where 2 =3
    UNION 
    SELECT co.CS_Export_LobName AS CLIENT_ID
       ,co.PROGRAM_NAME		  AS PROGRAM_NAME
       ,co.MEMBER_ID		  AS MEMBER_ID
	  ,co.ENROLL_DATE		  AS ENROLL_DATE
       ,co.CREATE_DATE       	  AS CREATE_DATE
       ,co.ENROLL_END_DATE	  AS ENROLL_END_DATE
       ,co.PROGRAM_STATUS	  AS PROGRAM_STATUS
       ,co.REASON_DESCRIPTION   AS REASON_DESCRIPTION
       ,co.REFERAL_TYPE		  AS REFERAL_TYPE
       ,co.ClientKey		  AS ClientKey
    FROM ACDW_CLMS_SHCN_MSSP.adw.vw_Exp_QmPrograms AS co
    where 2 = 3
)  
