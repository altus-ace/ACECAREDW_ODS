
-- =============================================
-- Author:		GKuhfeldt
-- Create date: 10/9/2017
-- Description:	Get a set of eligiblity data (member plan enrolment) for a specific load date.
--				To be used in a Integration package as a source. Any other use is not ok.
-- =============================================
CREATE FUNCTION [ast].[ACE_tvf_INT_UHC_GetCurrentEligiblityData]
(	
	-- Add the parameters for the function here
	@dForDate DATE
	, @dStopDate DATE	
	, @dPriorDate DATE
)
RETURNS TABLE 
AS
RETURN 
(

WITH cteMemberInfo
     AS (
     SELECT
            m.Uhc_subscriber_id AS Member_ID
          , CASE
                WHEN tmb1.DESTINATION_VALUE IS NOT NULL
                THEN tmb1.DESTINATION_VALUE
                ELSE 'UHC'
            END LOB
		, map.Destination AS Benefit_Plan
          , m.A_LAST_UPDATE_DATE
		, CONVERT(VARCHAR(255), RTRIM(CONVERT(NVARCHAR(255), m.SUBGRP_ID))) AS SUBGRP_ID
		, CONVERT(VARCHAR(255), RTRIM(CONVERT(NVARCHAR(255), m.SUBGRP_NAME))) AS SUBGRP_NAME
     FROM dbo.UHC_MembersByPCP m        
		LEFT JOIN (SELECT amp.Source, amp.Destination
				    FROM lst.listAceMapping amp
				    WHERE amp.MappingTypeKey = 1
					   AND amp.ClientKey = 1
					   AND amp.IsActive = 1) map ON m.PLAN_ID = map.Source 
          LEFT JOIN DBO.UHC_MEMBERSHIP UM ON UM.UHC_SUBSCRIBER_ID = M.Uhc_subscriber_id
                                             AND m.A_LAST_UPDATE_DATE = um.A_LAST_UPDATE_DATE
          LEFT JOIN dbo.ALT_MAPPING_TABLES AS tmb1 ON tmb1.SOURCE_VALUE = UM.LINE_OF_BUSINESS
                                                      AND tmb1.SOURCE = 'UHC'
                                                      AND tmb1.DESTINATION = 'ALTRUISTA'
                                                      AND tmb1.TYPE = 'LINE OF BUSINESS')  
	, cteMemberPlanHist
	   AS ( SELECT mph.A_Member_Plan_History_ID as MPH_PKey, mph.Client_Member_ID, mph.startDate, mph.stopDate
				, mph.Benefit_Plan AS priorBENEFIT_PLAN
			FROM adw.A_Mbr_PlanHistory mph)
				
    SELECT c.Member_ID, c.LOB, c.A_LAST_UPDATE_DATE, c.SUBGRP_ID, c.SUBGRP_NAME, c.BENEFIT_PLAN
	   , mph.MPH_PKey	
	   , mph.priorBENEFIT_PLAN 
	   , mph.startDate  AS priorStartDate
	   , mph.stopDate	AS priorStopDate	 
	   , @dForDate AS LoadDate
	   , DATEADD(day, (-1*DATEPART(day, @dForDate)+1), @dForDate) AS StartDate	   
	   , DATEADD(day, (-1*DATEPART(day, @dForDate)), @dForDate) AS PlanChangeStopDate
	   , @dStopDate As StopDate	   
	   , 1 AS planHistoryStatus 
    FROM cteMemberInfo c
	   LEFT JOIN cteMemberPlanHist mph ON c.Member_id = mph.Client_Member_ID		  
		  AND @dForDAte BETWEEN mph.startDate AND mph.stopDate  		  
    WHERE c.A_LAST_UPDATE_DATE = @dForDate        
	
)
