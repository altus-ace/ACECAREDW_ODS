
CREATE FUNCTION [adw].[A_tvf_Etl_MBR_PlanHistory_byLoadDate](
	@dLoadDate DATE
	, @dPriorDate DATE
	, @dStopDate DATE	
	)
RETURNS TABLE
AS RETURN
(
 
    WITH cteMemPlanHist
     AS (
     SELECT
           c.A_Client_ID
          , m.UHC_Subscriber_id AS Client_Member_id
          , m.SUBGRP_ID          
          , 1 AS planHistoryStatus
          , RTRIM(mpToAlt.destination) AS Benefit_Plan
		, DATEADD(day, (-1*DATEPART(day, @dLoadDate)+1), @dLoadDate) AS StartDate	   
		, DATEADD(day, (-1*DATEPART(day, @dLoadDate)), @dLoadDate) AS PlanChangeStopDate
		, @dStopDate As StopDate	   
     FROM dbo.UHC_MembersByPCP m
	   JOIN adw.A_LIST_Clients c ON 1 = 1
        JOIN lst.ListAceMapping mpToAce ON m.SUBGRP_ID = mpToAce.Source  
		  AND mpToAce.IsActive = 1
		  AND mpToAce.MappingTypeKey = 1
		  AND mpToAce.ClientKey = 1
	   JOIN lst.ListAceMapping mpToAlt ON mpToAce.Destination = mpToAlt.Source
		  AND mpToAlt.IsActive = 1
		  AND mpToAlt.MappingTypeKey = 2
		  AND mpToAlt.ClientKey = 1
     WHERE m.A_LAST_UPDATE_DATE = @dLoadDate  
	)
	,
     cteAltMemPlanHist
     AS (

     SELECT a.A_ALT_MemberPlanHistory_ID
          , a.Client_Member_ID
          , a.A_Client_ID
          , RTRIM(a.Benefit_Plan) Benefit_Plan
          , a.startDate
          , a.stopDate
     FROM adw.A_ALT_MemberPlanHistory a
     WHERE @dPriorDate BETWEEN a.startDate AND a.stopDate
	   AND a.planHistoryStatus = 1 /* GK added: if this is omitted allows Inactive rows to appear active, causeing them to no be updated */
	)

     SELECT DISTINCT 
            mph.A_Client_ID
          , mph.Client_Member_ID
          , mph.Benefit_Plan
          , mph.startDate
          , mph.stopDate
		, aph.A_ALT_MemberPlanHistory_ID
          , aph.Benefit_Plan AS priorBenefitPlan
          , aph.startDate AS priorStartDate
          , aph.stopDate AS priorStopDate
		, PlanChangeStopDate
     FROM cteMemPlanHist mph		  
          LEFT JOIN cteAltMemPlanHist aph ON mph.A_client_ID = aph.A_Client_ID
                                             AND mph.Client_Member_ID = aph.Client_Member_ID
									AND @dPriorDate BETWEEN aph.startDate AND aph.stopDate
)

