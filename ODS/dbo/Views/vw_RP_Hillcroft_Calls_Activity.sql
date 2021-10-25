CREATE VIEW dbo.vw_RP_Hillcroft_Calls_Activity
AS
SELECT DISTINCT 
                         UM.UHC_SUBSCRIBER_ID AS MEMBER_ID, UM.MEMBER_FIRST_NAME, UM.MEMBER_LAST_NAME, UM.DATE_OF_BIRTH, 
                         UM.MEMBER_HOME_ADDRESS + ' ' + UM.MEMBER_HOME_ADDRESS2 AS MEMBER_ADDRESS, UM.MEMBER_HOME_CITY, UM.MEMBER_HOME_STATE, UM.MEMBER_HOME_ZIP, 
                         UM.MEMBER_HOME_PHONE, VP.CREATE_DATE, VP.PROG_ID, VP.ASSIGN_TO, CT.CALL_DATE, CT.CALL_TYPE, CT.CALL_STATUS, RTRIM(CT.CALL_NOTE) AS CALL_NOTES, CT.URN
FROM            dbo.UHC_MembersByPCP AS UM LEFT OUTER JOIN
                         CC.dbo.vw_AllProgramMembers AS VP ON VP.MEMBER_ID = UM.UHC_SUBSCRIBER_ID LEFT OUTER JOIN
                         CC.dbo.CALL_TXN AS CT ON VP.MEMBER_ID = CT.MEMBER_ID AND VP.PROG_ID = CT.PROG_ID
WHERE        (UM.PCP_PRACTICE_TIN = '760537608')

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
         Begin Table = "UM"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 275
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "VP"
            Begin Extent = 
               Top = 6
               Left = 313
               Bottom = 136
               Right = 533
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CT"
            Begin Extent = 
               Top = 6
               Left = 571
               Bottom = 136
               Right = 762
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
      Begin ColumnWidths = 17
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_RP_Hillcroft_Calls_Activity';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_RP_Hillcroft_Calls_Activity';

