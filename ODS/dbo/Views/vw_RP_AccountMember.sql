



CREATE VIEW [dbo].[vw_RP_AccountMember]
AS

SELECT TOP (100) PERCENT DBO.VW_UHC_ACTIVEMEMBERS.PCP_PRACTICE_TIN,CASE
                             WHEN dbo.tmpSalesforce_Account.Name IS NULL
                             THEN 
					    RTRIM(UPPER(DBO.VW_UHC_ACTIVEMEMBERS.PCP_PRACTICE_NAME))
					    when DBO.VW_UHC_ACTIVEMEMBERS.PCP_PRACTICE_NAME ='' 
					    then UPPER(RTRIM(dbo.tmpSalesforce_Account.Name))
					    ELSE UPPER(RTRIM(dbo.tmpSalesforce_Account.Name))
                         END
					 AS AccountName,
                         RTRIM(dbo.vw_UHC_ActiveMembers.MEMBER_ID) AS MEMBER_ID,
                         RTRIM(dbo.vw_UHC_ActiveMembers.MEMBER_FIRST_NAME)+' '+RTRIM(dbo.vw_UHC_ActiveMembers.MEMBER_MI)+' '+RTRIM(dbo.vw_UHC_ActiveMembers.MEMBER_LAST_NAME) AS [MEMBER FULL NAME],
                         UPPER(RTRIM(dbo.tmpSalesforce_Account.Network_Contact__c)) AS [ACE NETWORK CONTACT]
FROM dbo.vw_UHC_ActiveMembers
     LEFT JOIN dbo.tmpSalesforce_Account ON CAST(dbo.vw_UHC_ActiveMembers.PCP_PRACTICE_TIN AS INT)
	 = CAST(dbo.tmpSalesforce_Account.Tax_ID_Number__c AS INT)
ORDER BY Accountname;





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
         Begin Table = "vw_UHC_ActiveMembers"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 332
            End
            DisplayFlags = 280
            TopColumn = 44
         End
         Begin Table = "tmpSalesforce_Account"
            Begin Extent = 
               Top = 6
               Left = 370
               Bottom = 136
               Right = 678
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
         Width = 3165
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_RP_AccountMember';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_RP_AccountMember';

