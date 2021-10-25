

CREATE VIEW [dbo].[vw_QLK_PcpAccountLocations]
AS
     SELECT DISTINCT TOP (100) PERCENT dbo.tmpSalesforce_Account.Tax_ID_Number__c AS [TAX ID],
                                       dbo.tmpSalesforce_Account.Name AS [Account NAME],
                                       dbo.tmpSalesforce_Account_Locations__c.Location_Type__c AS [Address Type],
                                       dbo.tmpSalesforce_Account_Locations__c.Address_1__c+' '+dbo.tmpSalesforce_Account_Locations__c.Address_2__c AS [ACCOUNT ADDRESS],
                                       dbo.tmpSalesforce_Account_Locations__c.City__c AS [ACCOUNT CITY],
                                       dbo.tmpSalesforce_Account_Locations__c.State__c AS [ACCOUNT STATE],
                                       dbo.tmpSalesforce_Zip_Code__c.Name AS [ACCOUNT ZIPCODE],
                                       dbo.tmpSalesforce_Account_Locations__c.Phone__c AS [Account Location Phone],
                                       dbo.tmpSalesforce_Account_Locations__c.Alternate_Phone__c AS [Account Alternate Phone],
                                       dbo.tmpSalesforce_Zip_Code__c.Quadrant__c AS POD,
                                       CASE
                                           WHEN tmpSalesforce_Account_Locations__c.Monday_Open__c + tmpSalesforce_Account_Locations__c.Monday_Close__c + tmpSalesforce_Account_Locations__c.Tuesday_Open__c + tmpSalesforce_Account_Locations__c.Tuesday_Close__c + tmpSalesforce_Account_Locations__c.Wednesday_Open__c + tmpSalesforce_Account_Locations__c.Thrusday__c + tmpSalesforce_Account_Locations__c.Friday_Open__c + tmpSalesforce_Account_Locations__c.Saturday_Open__c + tmpSalesforce_Account_Locations__c.Sunday_Open__c = ' '
                                           THEN ' '
                                           ELSE tmpSalesforce_Account_Locations__c.Monday_Open__c+'-'+tmpSalesforce_Account_Locations__c.Monday_Close__c+' Monday'+';'+tmpSalesforce_Account_Locations__c.Tuesday_Open__c+'-'+tmpSalesforce_Account_Locations__c.Tuesday_Close__c+' Tuesday'+';'+tmpSalesforce_Account_Locations__c.Wednesday_Open__c+'-'+tmpSalesforce_Account_Locations__c.Wednesday_Close__c+' Wednesday'+';'+tmpSalesforce_Account_Locations__c.Thrusday__c+'-'+tmpSalesforce_Account_Locations__c.Thrusday_Close__c+' Thrusday'+';'+tmpSalesforce_Account_Locations__c.Friday_Open__c+'-'+tmpSalesforce_Account_Locations__c.Friday_Close__c+' Friday'+';'+tmpSalesforce_Account_Locations__c.Saturday_Open__c+'-'+tmpSalesforce_Account_Locations__c.Saturday_Close__c+' Saturday'+';'+tmpSalesforce_Account_Locations__c.Sunday_Open__c+'-'+tmpSalesforce_Account_Locations__c.Sunday_Close__c+' Sunday'+';'
                                       END AS ACC_OFFICE_HOURS,
                                       dbo.tmpSalesforce_Account_Locations__c.Medicaid_Capacity__c AS MEDICAIDCAPACITY,
                                       CI.Line_of_Business__c AS LINEOFBUSINESS,
                                       dbo.tmpSalesforce_Account.Group_NPI_Number__c AS GROUP_NPI,
                                       CASE
                                           WHEN dbo.tmpSalesforce_Account.Termination_with_cause__c IS NULL
                                           THEN ' '
                                           ELSE dbo.tmpSalesforce_Account.Termination_with_cause__c
                                       END AS 'ACCOUNT STATUS',
							    CI.Health_Plans__c as Client
     FROM dbo.tmpSalesforce_Account
          LEFT OUTER JOIN dbo.tmpSalesforce_Account_Locations__c ON dbo.tmpSalesforce_Account_Locations__c.Account_Name__c = dbo.tmpSalesforce_Account.Id
          LEFT OUTER JOIN dbo.tmpSalesforce_Contact ON dbo.tmpSalesforce_Contact.AccountId = dbo.tmpSalesforce_Account.Id
          LEFT OUTER JOIN dbo.tmpSalesforce_Zip_Code__c ON dbo.tmpSalesforce_Account_Locations__c.Zip_Code__c = dbo.tmpSalesforce_Zip_Code__c.Id
          LEFT OUTER JOIN dbo.tmpSalesforce_Contract_Information__c AS CI ON CI.Account_Name__c = dbo.tmpSalesforce_Account.Id
                                                                     --        AND CI.Health_Plans__c = 'UHC'
     WHERE(dbo.tmpSalesforce_Contact.Type__c IN('pcp'))
          AND (dbo.tmpSalesforce_Contact.LastName NOT IN('TEST', 'TESTLAST'))
		   AND (dbo.tmpSalesforce_Account.Name NOT IN('ACE TEST 1', 'TESTLAST'))
     AND (dbo.tmpSalesforce_Account.In_network__c = '1')
     ORDER BY 'TAX ID';



GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[25] 3) )"
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
         Begin Table = "tmpSalesforce_Account"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 346
            End
            DisplayFlags = 280
            TopColumn = 121
         End
         Begin Table = "tmpSalesforce_Account_Locations__c"
            Begin Extent = 
               Top = 6
               Left = 384
               Bottom = 136
               Right = 651
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tmpSalesforce_Contact"
            Begin Extent = 
               Top = 6
               Left = 689
               Bottom = 136
               Right = 990
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tmpSalesforce_Zip_Code__c"
            Begin Extent = 
               Top = 6
               Left = 1028
               Bottom = 136
               Right = 1240
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CI"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 234
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
      Begin Colum', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_QLK_PcpAccountLocations';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'nWidths = 11
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_QLK_PcpAccountLocations';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_QLK_PcpAccountLocations';

