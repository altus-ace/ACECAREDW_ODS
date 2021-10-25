CREATE VIEW dbo.vw_EMR_PCP_Info
AS
SELECT        TOP (100) PERCENT CASE WHEN (T2.EMR IS NULL) THEN ' ' ELSE upper(Rtrim(t2.EMR)) END AS EMR, UPPER(RTRIM(Acc)) AS PRACTICE_NAME, TNPI AS TOTAL_PCP, COUNT(MEMN) AS TOTAL_MEMBERS
FROM            (SELECT        t.tin, t.AN AS Acc, t.emr AS EMR, ua.MEMBER_ID, COUNT(t.NUM) AS TNPI, 1 AS MEMN
                          FROM            dbo.vw_UHC_ActiveMembers AS ua INNER JOIN
                                                        (SELECT        ta.Tax_ID_Number__c AS tin, ta.Name AS AN, ta.EMR__c AS emr, tc.Provider_NPI__c AS NPI, 1 AS NUM
                                                          FROM            dbo.tmpSalesforce_Account AS ta INNER JOIN
                                                                                    dbo.tmpSalesforce_Contact AS tc ON tc.AccountId = ta.Id
                                                          WHERE        (tc.Status__c IS NULL) AND (tc.Type__c IN ('PCP'))) AS t ON CAST(t.tin AS int) = CAST(ua.PCP_PRACTICE_TIN AS int)
                          GROUP BY t.tin, t.AN, t.emr, ua.MEMBER_ID) AS T2
GROUP BY EMR, tin, Acc, TNPI

UNION
SELECT        TOP (100) PERCENT CASE WHEN (T2.EMR IS NULL) THEN ' ' ELSE upper(Rtrim(t2.EMR)) END AS EMR, UPPER(RTRIM(Acc)) AS PRACTICE_NAME, TNPI AS TOTAL_PCP, COUNT(MEMN) AS TOTAL_MEMBERS
FROM            (SELECT        t.tin, t.AN AS Acc, t.emr AS EMR, ua.MEMBER_ID, COUNT(t.NUM) AS TNPI, 1 AS MEMN
                          FROM            dbo.vw_UHC_ActiveMembers AS ua INNER JOIN
                                                        (SELECT        ta.Tax_ID_Number__c AS tin, ta.Name AS AN, ta.EMR__c AS emr, tc.Provider_NPI__c AS NPI, 1 AS NUM
                                                          FROM            dbo.tmpSalesforce_Account AS ta INNER JOIN
                                                                                    dbo.tmpSalesforce_Contact AS tc ON tc.AccountId = ta.Id
                                                          WHERE        (tc.Status__c IN ('ACTIVE')) AND (tc.Type__c IN ('PCP'))) AS t ON CAST(t.tin AS int) = CAST(ua.PCP_PRACTICE_TIN AS int)
                          GROUP BY t.tin, t.AN, t.emr, ua.MEMBER_ID) AS T2
GROUP BY EMR, tin, Acc, TNPI


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
         Begin Table = "T2"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 224
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_EMR_PCP_Info';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_EMR_PCP_Info';

