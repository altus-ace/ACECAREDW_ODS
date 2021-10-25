

CREATE VIEW [dbo].[vw_AH_IProInterface]
AS -- changed the gc_start_date to use format 101, and convert to varchar(10) so it exports mm/dd/yyyy
     SELECT MEMBER_ID, 
            'UHC' AS CLIENT_ID, 
            REPLACE(RTRIM(MEMBER_FIRST_NAME), ',', ' ') AS MEMBER_FIRST_NAME, 
            REPLACE(RTRIM(MEMBER_LAST_NAME), ',', ' ') AS MEMBER_LAST_NAME, 
            DATE_OF_BIRTH, 
            GENDER, 
            RISK_CATEGORY_C, 
            'Primary' AS RISK_TYPE, 
            IPRO_ADMIT_RISK_SCORE AS RISK_SCORE, 
            CONVERT(VARCHAR(10), DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0), 101) AS GC_START_DATE, 
			CONVERT(Varchar(10), '12/31/2099', 101) AS GC_END_DATE
        -- Bing made the change    CONVERT(DATE, '12/31/2099') AS GC_END_DATE
		
     FROM dbo.vw_UHC_ActiveMembers
     UNION
     SELECT MEMBER_ID, 
            'UHC' AS CLIENT_ID, 
            REPLACE(RTRIM(MEMBER_FIRST_NAME), ',', ' ') AS MEMBER_FIRST_NAME, 
            REPLACE(RTRIM(MEMBER_LAST_NAME), ',', ' ') AS MEMBER_LAST_NAME, 
            DATE_OF_BIRTH, 
            GENDER, 
            RISK_CATEGORY_C, 
            'Primary' AS RISK_TYPE, 
            IPRO_ADMIT_RISK_SCORE AS RISK_SCORE, 
            CONVERT(VARCHAR(10), DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0), 101) AS GC_START_DATE, 
            CONVERT(Varchar(10), '12/31/2099', 101) AS GC_END_DATE
     FROM dbo.vw_UHC_TermedMembers;


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[30] 2[11] 3) )"
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
      Begin ColumnWidths = 12
         Width = 284
         Width = 5025
         Width = 2730
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2430
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_AH_IProInterface';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_AH_IProInterface';

