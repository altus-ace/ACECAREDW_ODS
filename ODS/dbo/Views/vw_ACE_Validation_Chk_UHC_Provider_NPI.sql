

CREATE VIEW [dbo].[vw_ACE_Validation_Chk_UHC_Provider_NPI]
AS
     SELECT DISTINCT
            RTRIM(PCP_NPI) AS PCP_NPI,
            RTRIM(PCP_First_name) AS PCP_FIRST_NAME,
            RTRIM(PCP_Last_name) AS PCP_LAST_NAME,
            RTRIM(PCP_PRACTICE_TIN) AS PCP_PRACTICE_TIN,
            RTRIM(PCP_PRACTICE_NAME) AS PCP_PRACTICE_NAME,
            ta.Name AS SF_AccountName,
		  ' ' as NPI_TYPE,
		  um.AUTO_ASSIGN
		  
     FROM vw_UHC_ActiveMembers um
          INNER JOIN tmpSalesforce_Account ta ON CAST(ta.Tax_id_number__C AS INT) = CAST(um.PCP_PRACTICE_TIN AS INT)
     WHERE CAST(pcp_NPI AS INT) IN
( Select Distinct PCP_NPI from (
    SELECT DISTINCT
           CAST(va.PCP_NPI AS INT) AS PCP_NPI
    FROM vw_UHC_ActiveMembers va --where pcp_npi='1114133394'
    EXCEPT
    SELECT CAST(Provider_NPI__c AS INT)
    FROM tmpsalesforce_contact tc ) as s 
    --except
  --  Select Cast(Group_NPI_number__c as int) from tmpSalesforce_Account -- where tc.status__C ='Active'
    
)
--order by PCP_PRACTICE_TIN;



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
               Bottom = 325
               Right = 332
            End
            DisplayFlags = 280
            TopColumn = 0
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
      Begin ColumnWidths = 12
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_ACE_Validation_Chk_UHC_Provider_NPI';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_ACE_Validation_Chk_UHC_Provider_NPI';

