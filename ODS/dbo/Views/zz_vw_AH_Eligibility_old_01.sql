
CREATE VIEW [dbo].[zz_vw_AH_Eligibility_old_01]
AS
  

WITH cteLoadKeys(
     LOAD_KEY
   , LOAD_DATE)
     AS (
     SELECT
            ROW_NUMBER() OVER(ORDER BY m.A_LAST_UPDATE_DATE ASC) Load_Key
          , m.A_LAST_UPDATE_DATE LoadDate
     FROM dbo.UHC_MembersByPCP m
     GROUP BY
              m.A_LAST_UPDATE_DATE)    
    
    , cteMembersPlans
     AS (
     SELECT
            m.Uhc_subscriber_id AS Member_ID
          , CASE
                WHEN tmb1.DESTINATION_VALUE IS NOT NULL
                THEN tmb1.DESTINATION_VALUE
                ELSE 'UHC'
            END LOB
          , CASE
                WHEN TMB2.DESTINATION_VALUE IS NOT NULL
                THEN TMB2.DESTINATION_VALUE
                ELSE ' '
            END AS BENEFIT_PLAN
          , m.A_LAST_UPDATE_DATE
          , ld.LoadKey
          , ld.NextLoadKey
          , ld.NextLoadDate 
          , '2099-12-31' AS ifActive_EndDate          
          , ROW_NUMBER() OVER(PARTITION BY m.Uhc_subscriber_id ORDER BY m.A_LAST_UPDATE_DATE ASC) aForwardCurrIndex
          , (ROW_NUMBER() OVER(PARTITION BY m.Uhc_subscriber_id ORDER BY m.A_LAST_UPDATE_DATE ASC) - 1) aForwardPriorIndex
		, ROW_NUMBER() OVER(PARTITION BY m.Uhc_subscriber_id ORDER BY m.A_LAST_UPDATE_DATE DESC) aReverseCurrIndex
               --, m.MEMBER_TERM_DATE /* Removed as we will calculate term date specifically for the gap we are term-ing */
     FROM dbo.UHC_MembersByPCP m
          LEFT JOIN dbo.ALT_MAPPING_TABLES AS tmb2 ON tmb2.SOURCE_VALUE = m.SUBGRP_ID
                                                      AND tmb2.SOURCE = 'UHC'
                                                      AND tmb2.DESTINATION = 'ALTRUISTA'
                                                      AND tmb2.TYPE = 'PLAN CODE'
          LEFT JOIN DBO.UHC_MEMBERSHIP UM ON UM.UHC_SUBSCRIBER_ID = M.Uhc_subscriber_id
                                             AND m.A_LAST_UPDATE_DATE = um.A_LAST_UPDATE_DATE
          LEFT JOIN dbo.ALT_MAPPING_TABLES AS tmb1 ON tmb1.SOURCE_VALUE = UM.LINE_OF_BUSINESS
                                                      AND tmb1.SOURCE = 'UHC'
                                                      AND tmb1.DESTINATION = 'ALTRUISTA'
                                                      AND tmb1.TYPE = 'LINE OF BUSINESS'
          JOIN
     (
         SELECT
                cl.LOAD_KEY	  AS LoadKey
              , cl.LOAD_DATE	  AS LoadDate
              , nl.LOAD_KEY	  AS NextLoadKey
              , nl.LOAD_DATE	  AS NextLoadDate
         FROM cteLoadKeys cl
              LEFT JOIN cteLoadKeys nl ON cl.LOAD_KEY + 1 = nl.LOAD_KEY 
     ) AS ld ON m.A_LAST_UPDATE_DATE = ld.LoadDate
     WHERE m.MEMBER_TERM_DATE <> '2016-12-31'
           --AND m.UHC_SUBSCRIBER_ID = '113735113'--'100465069'		 		   
     ) 	
	, cteRankedMembers
     AS (	SELECT a.*
		FROM (SELECT b.*
			 , CASE WHEN b.Current_BenPlan <> ISNULL(b.Prior_BenPlan, -13) THEN 1 
		  	 	Else 0 END AS hasPlanChange
			 , CASE WHEN (b.Current_AnchorLoadKey - b.Prior_NextExpectedLoadKey) <> 0 THEN 1
		  	 		   ELSE 0 END AS hasPlanGap	 			 
		  FROM (
		  SELECT aMonth.Member_ID AS Member_ID
		  		   , aMonth.LOB AS LOB
				   /* if aBenPlan <> bBenPlan then plan change */
		  		   , aMonth.BENEFIT_PLAN Current_BenPlan				   
		  		   , pMonth.BENEFIT_PLAN Prior_BenPlan
		  		   , aMonth.A_LAST_UPDATE_DATE AS Current_LastUpdateDate
		  		   , pMonth.A_LAST_UPDATE_DATE AS Prior_LastUpdateDate
		  		   
				   , DATEADD(DAY, -1 * DAY(aMonth.A_Last_Update_date) + 1, aMonth.A_Last_Update_date) AS Current_Active_Month
				   , DATEADD(DAY, -1 * DAY(pMonth.A_Last_Update_date) + 1, pMonth.A_Last_Update_date) AS Prior_Active_Month
		  		   , aMonth.LoadKey		   AS Current_AnchorLoadKey
				   , pMonth.NextLoadKey	   AS Prior_NextExpectedLoadKey		  		   				   
				   , aMonth.NextLoadDate	   AS Current_NextExpectedLoadDate
				   , aMonth.ifActive_EndDate
				   /* debug codes */
				    , aMonth.aForwardCurrIndex	 AS Current_ForwardCurIndex	   , pMonth.aForwardCurrIndex	 AS Prior_ForwardCurIndex
				    , aMonth.aForwardPriorIndex	 AS Current_ForwardPriorIndex	   , pMonth.aForwardPriorIndex AS Prior_ForwarcdPriorIndex
				    , pMonth.LoadKey			 AS Prior_AnchorLoadKey				    
				    , aMonth.aReverseCurrIndex	 AS Current_ReverseCurIndex	    					 
				 /* Notes on Names:   aMonth is Anchor Month   and  pMonth is Prior Month 
				    Both contain a Actual next load date from the load dates cte computed at the top of the routine
				    with that info we can chech if pMonth.NextLoadKey = aMonth.Loadkey if not, there is a gap.*/
				 FROM cteMembersPlans AS aMonth					 
				      LEFT JOIN cteMembersPlans AS pMonth ON aMonth.Member_id = pMonth.Member_Id
				                                          AND aMonth.aForwardPriorIndex = pMonth.aForwardCurrIndex				 
		  ) AS b		  
	   ) a	   
	   WHERE (a.hasPlanChange = 1 or a.hasPlanGap = 1)  or a.Current_ReverseCurIndex = 1  -- this includes the last record in the stack, it is not interesting unless it is PC or HG

	)   

--    SELECT * FROM cteRankedMembers a Order by a.Current_ForwardCurIndex
    SELECT 
	   c.Member_id AS MEMBER_ID
          , c.lob AS LOB
          , c.Current_BenPlan AS [BENEFIT PLAN]
          , CONVERT(VARCHAR(10), c.current_active_month, 101) AS START_DATE
	--	, c.hasPlanChange ,c.HasPlanGap
          , CONVERT(VARCHAR(10), (CASE
                                    WHEN c.hasPlanChange = 0
                                           AND c.HasPlanGap = 0
                                      THEN c.ifActive_EndDate
							 WHEN ((c.HasPlanGap = 1) AND (c.Current_Active_Month = c.Prior_Active_Month))
								THEN DATEADD(DAY, -1*DAY(c.Current_NextExpectedLoadDate), c.Current_NextExpectedLoadDate)
							 WHEN ((c.HasPlanGap = 1) AND (c.Current_Active_Month <> c.Prior_Active_Month))
								THEN DATEADD(DAY, -1*DAY(c.Current_NextExpectedLoadDate), c.Current_NextExpectedLoadDate)--c.NextLoadDate
                                    ELSE c.Current_NextExpectedLoadDate
							 END), 120) AS END_DATE
          , 'E' AS [ INTERNAL/EXTERNAL INDICATOR]
		--, c.Current_ForwardCurIndex, c.Current_Active_Month
     FROM CteRankedMembers c        



GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 5340
         Width = 2085
         Width = 1500
         Width = 1500
         Width = 5040
         Width = 6495
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 2235
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1950
         GroupBy = 1350
         Filter = 1650
         Or = 3555
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'zz_vw_AH_Eligibility_old_01';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'zz_vw_AH_Eligibility_old_01';

