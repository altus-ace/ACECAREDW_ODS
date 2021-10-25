
CREATE VIEW [dbo].[zz_vw_AH_ProviderContractHeader_old_01]
AS
SELECT DISTINCT 
                         dbo.tmpSalesforce_Contact.Provider_NPI__c AS PROVIDER_ID, 'UHC' AS CLIENT_ID, ISNULL(dbo.tmpSalesforce_Contract_Information__c.Health_Plans__c, 'UHC') AS LOB, ISNULL(NULL, 
                         'Benefit plan test value') AS BENEFIT_PLAN, CASE WHEN dbo.tmpSalesforce_Contract_Information__c.Health_Plans__c IS NULL THEN ISNULL(NULL, 'Participation flag test value') 
                         ELSE 'PAR' END AS [PARTICIPATION FLAG], ISNULL(dbo.tmpSalesforce_Contract_Information__c.Effective_Date__c, '2017-01-01 00:00:00') AS EFFECTIVE_DATE, '12/31/2199' AS TERM_DATE, 
                         dbo.tmpSalesforce_Account.Tax_ID_Number__c AS TAX_ID, dbo.tmpSalesforce_Account.Type__c AS TYPE
FROM            dbo.tmpSalesforce_Contact LEFT OUTER JOIN
                         dbo.tmpSalesforce_Account ON dbo.tmpSalesforce_Contact.AccountId = dbo.tmpSalesforce_Account.Id LEFT OUTER JOIN
                         dbo.tmpSalesforce_Contract_Information__c ON dbo.tmpSalesforce_Account.Id = dbo.tmpSalesforce_Contract_Information__c.Account_Name__c AND 
                         dbo.tmpSalesforce_Contract_Information__c.Health_Plans__c IN ('UHC')
WHERE        (dbo.tmpSalesforce_Contact.Provider_NPI__c <> ' ') AND (dbo.tmpSalesforce_Contact.Type__c IN ('PCP', 'PA', 'NP', 'FNP', 'Allied Health', 'DDS', 'LPC', 'UHC PCP', 'SPECIALIST','Mid Level')) AND 
                         (dbo.tmpSalesforce_Account.In_network__c = '1') AND (dbo.tmpSalesforce_Contact.FirstName NOT LIKE '%TEST%') AND (dbo.tmpSalesforce_Contact.Provider_NPI__c IS NOT NULL)


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
         Begin Table = "tmpSalesforce_Contact"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 339
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tmpSalesforce_Account"
            Begin Extent = 
               Top = 6
               Left = 839
               Bottom = 136
               Right = 1147
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tmpSalesforce_Contract_Information__c"
            Begin Extent = 
               Top = 6
               Left = 377
               Bottom = 136
               Right = 573
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'zz_vw_AH_ProviderContractHeader_old_01';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'zz_vw_AH_ProviderContractHeader_old_01';

