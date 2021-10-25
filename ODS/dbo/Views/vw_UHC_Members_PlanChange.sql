CREATE VIEW [dbo].[vw_UHC_Members_PlanChange]
AS
     
/****** Object:  View [dbo].[vw_UHC_ActiveMembers]    Script Date: 7/18/2017 12:27:46 PM ******/

     WITH RankedMembers(MemberID,
                        MemUrn,
                        PlanCode,
				  --  lob,
                        LastUpdateDate,
                        LastUPdateFlag,
                        aRank,
                        LinkdTo)
          AS (
          SELECT m.Member_ID,
                 m.URN, 

/*m.Plan_id, m.SUBGRP_ID, m.SUBGRP_NAME*/

                 m.PlanCode,
			--  m.lob,
                 m.A_LAST_UPDATE_DATE,
                 m.A_LAST_UPDATE_FLAG,
                 aRank,
                 aRank - 1 AS linkedTo
          FROM
          (
              SELECT m.UHC_SUBSCRIBER_ID AS Member_ID,
                     m.URN,
                     --, m.Plan_ID
                     --, m.SUBGRP_ID, m.SUBGRP_NAME 
                     m.A_LAST_UPDATE_DATE,
                     m.A_LAST_UPDATE_FLAG,
                     ROW_NUMBER() OVER(PARTITION BY m.UHC_SUBSCRIBER_ID ORDER BY m.A_LAST_UPDATE_DATE DESC) AS aRank,
				-- tmb1.DESTINATION_VALUE as lob,
                     mtbl.DESTINATION_VALUE PlanCode
              FROM dbo.UHC_MembersByPCP m
                   LEFT JOIN dbo.ALT_MAPPING_TABLES AS mtbl ON mtbl.SOURCE_VALUE = m.SUBGRP_ID
                                                               AND mtbl.SOURCE = 'UHC'
                                                               AND mtbl.DESTINATION = 'ALTRUISTA'
                                                               AND mtbl.TYPE = 'PLAN CODE'
			         ) AS m)
          SELECT P.MemberID AS MEMBER_ID, --pMemberId,
			--  p.lob as 'LINE_OF_BUSINESS',
                 p.MemUrn AS NEW_MEMBER_URN, -- pMemURN,
                 p.PlanCode AS NEW_PLAN, --pPlanCode,
                 DATEADD(DAY, -1*(DAY(P.LastUpdateDate)-1), P.LastUpdateDate) AS NEW_PLAN_START_DATE,
                 '12-31-2099' AS NEW_PLAN_END_DATE,
                 p.LastUpdateDate AS NEW_LAST_UPDATE_DATE, --pLastUpdateDate,
                 p.LastUPdateFlag AS NEW_LAST_UPDATE_FLAG, --pLastUpdateFlag,
                 p.aRank AS NEW_RANK,
                 c.MemUrn AS OLD_MEMBER_URN, --cMemUrn,
                 c.PlanCode AS OLD_PLAN, --cPlanCode,
                 '01-01-2017' AS OLD_PLAN_START_DATE,
                 DATEADD(DAY, -1*DAY(P.LastUpdateDate), P.LastUpdateDate) AS OLD_PLAN_END_DATE, 
                 c.LastUpdateDate AS OLD_LAST_UPDATE_DATE, --cLastUpdateDate,
                 c.LastUPdateFlag AS OLD_LAST_UPDATE_FLAG, --cLastUpdateFlag,
                 c.aRank AS OLD_Rank
          FROM RankedMembers P
               LEFT JOIN RankedMembers C ON p.aRank = c.LinkdTo
                                            AND p.MemberID = c.MemberID
          WHERE(p.planCode <> c.PlanCode);
     ---ORDER BY MEMBER_ID,
        --      NEW_Rank ASC;



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
         Begin Table = "OLD"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 311
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "NEW"
            Begin Extent = 
               Top = 6
               Left = 349
               Bottom = 136
               Right = 571
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_UHC_Members_PlanChange';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_UHC_Members_PlanChange';

