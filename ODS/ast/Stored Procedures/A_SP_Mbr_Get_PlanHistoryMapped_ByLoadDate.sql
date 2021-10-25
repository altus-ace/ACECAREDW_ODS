CREATE PROCEDURE [ast].[A_SP_Mbr_Get_PlanHistoryMapped_ByLoadDate]
    @LoadDate DATE 
    , @PriorLoadDate DATE
    , @DefStopDate DATE = '12/31/2099'
AS 
    IF (@LoadDate is null) OR (@LoadDate < CONVERT(DATETIME, '01/01/2017', 101))
	   BEGIN
		  RAISERROR('Invalid parameter: Load Date cannot be NULL or Less than 1/1/2017', 18, 0)
		  RETURN
	   END;

    IF (@PriorLoadDate is null) OR (@PriorLoadDate < CONVERT(DATETIME, '12/31/2016', 101))
	   BEGIN
		  RAISERROR('Invalid parameter: Prior Load Date cannot be NULL or Less than 12/31/2016', 18, 0)
		  RETURN
	   END;
	   
    SELECT PlanHist.MPH_PKey, PlanHist.Client_Member_ID, PlanHist.startDate, PlanHist.stopDate        
	   , DATEADD(day, (-1*DATEPART(day, @loaddate)), @loaddate) as termDate
    FROM (SELECT mph.A_Member_Plan_History_ID as MPH_PKey, mph.Client_Member_ID, mph.startDate, mph.stopDate
			 , mph.BENEFIT_PLAN
		  FROM adw.A_Mbr_PlanHistory mph             
		  WHERE @LoadDate BETWEEN mph.startDate  AND mph.stopDate
		  ) AS PlanHist
	   LEFT JOIN (SELECT CurLoad.Member_ID, CurLoad.BENEFIT_PLAN
				FROM  ast.ACE_tvf_INT_UHC_GetCurrentEligiblityData (@LoadDate, @DefStopDate, @PriorLoadDate) as CurLoad
				) AS curLoad
		  ON PlanHist.Client_Member_ID = curLoad.Member_ID
				AND PlanHist.BENEFIT_PLAN = curLoad.BENEFIT_PLAN
    WHERE curLoad.Member_ID is null



