CREATE VIEW dbo.vw_RP_ActiveMemberProductWeight
AS
SELECT        CLIENT, PCP_PRACTICE_TIN, CASE WHEN PCP_PRACTICE_NAME = '' THEN PCP_LAST_NAME ELSE PCP_PRACTICE_NAME END AS PRACTICE_NAME, 
                         CASE WHEN subgrp_id = 'M_Adv' THEN 'MEDICARE ADVANTAGE' WHEN TRY_CONVERT(INT, subgrp_id) IN (100) THEN 'TX-STARPLUS' WHEN TRY_CONVERT(INT, subgrp_id) IN (3, 5, 20, 60, 62, 63, 64, 65, 66, 67, 68, 61) 
                         THEN 'TX-STAR' WHEN SUBGRP_ID IN ('D000') THEN 'TX-STAR' WHEN TRY_CONVERT(INT, subgrp_id) IN (309, 310, 311, 302, 303, 304, 301) THEN 'TX-CHIP' WHEN SUBGRP_ID IN ('D001') 
                         THEN 'TX-CHIP' END AS PRODUCT_NAME, COUNT(MEMBER_ID) AS MEMBERS, SUM(TIN_TIER) AS RVU_WEIGHT
FROM            dbo.vw_Client_ActiveMembers
GROUP BY CLIENT, PCP_PRACTICE_TIN, CASE WHEN PCP_PRACTICE_NAME = '' THEN PCP_LAST_NAME ELSE PCP_PRACTICE_NAME END, CASE WHEN subgrp_id = 'M_Adv' THEN 'MEDICARE ADVANTAGE' WHEN TRY_CONVERT(INT, 
                         subgrp_id) IN (100) THEN 'TX-STARPLUS' WHEN TRY_CONVERT(INT, subgrp_id) IN (3, 5, 20, 60, 62, 63, 64, 65, 66, 67, 68, 61) THEN 'TX-STAR' WHEN SUBGRP_ID IN ('D000') THEN 'TX-STAR' WHEN TRY_CONVERT(INT, 
                         subgrp_id) IN (309, 310, 311, 302, 303, 304, 301) THEN 'TX-CHIP' WHEN SUBGRP_ID IN ('D001') THEN 'TX-CHIP' END

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
         Begin Table = "vw_Client_ActiveMembers"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 348
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
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_RP_ActiveMemberProductWeight';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_RP_ActiveMemberProductWeight';

