


CREATE VIEW [dbo].[yy_vw_ACE_Validation_Chk_UHC_Account_TIN]
AS
    /* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	   converted to use Provider Roster from network roster.
	  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*/
     SELECT DISTINCT 
            y.*, 
            c.GroupName AS [PRACTICE NAME], 
            c.AccountType AS ProviderType, 
            c.STATUS
     FROM
     (
         SELECT x.*, 
                COUNT(uhc_subscriber_id) AS Mbr_Count
         FROM
         (
             SELECT DISTINCT 
                    PCP_PRACTICE_TIN
             FROM dbo.uhc_membersbypcp
             WHERE A_LAST_UPDATE_FLAG = 'Y'
             EXCEPT
             SELECT DISTINCT 
                    PCP_PRACTICE_TIN
             --FROM dbo.vw_activemembers
		   FROM dbo.vw_UHC_ActiveMembers
             --WHERE client = 'UHC'
             EXCEPT
		   SELECT TIN 
		   FROM dbo.vw_AllClient_ProviderRoster PR			 
		   WHERE pr.CalcClientKey = 1
			 AND GetDate() BETWEEN EffectiveDate and ExpirationDate
			 AND  pr.providerType in ('PCP')
             -- SELECT [TAX ID]--, [PRACTICE NAME] -- converted to Provider Roster
             -- FROM dbo.vw_NetworkRoster
             -- WHERE client = 'UHC'
             --       AND STATUS = 'ACTIVE'
         ) AS x
         LEFT JOIN dbo.Uhc_MembersByPcp b ON b.PCP_PRACTICE_TIN = x.PCP_PRACTICE_TIN
                                                       AND b.A_LAST_UPDATE_FLAG = 'Y'
         GROUP BY b.PCP_PRACTICE_TIN, 
                  x.PCP_PRACTICE_TIN
     ) AS y
     --LEFT JOIN dbo.vw_NetworkRoster c ON c.[tax id] = y.[PCP_PRACTICE_TIN] and c.LOB = 'UHC' ;
	LEFT JOIN dbo.vw_AllClient_ProviderRoster c 
	   ON c.TIN = y.[PCP_PRACTICE_TIN] 
		  AND c.CalcClientKey = 1
		  AND  c.providerType in ('PCP')
		  AND GetDate() BETWEEN c.EffectiveDate and c.ExpirationDate ;

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
         Top = -192
         Left = 0
      End
      Begin Tables = 
         Begin Table = "vw_UHC_ActiveMembers"
            Begin Extent = 
               Top = 198
               Left = 38
               Bottom = 328
               Right = 332
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
         Width = 3255
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'yy_vw_ACE_Validation_Chk_UHC_Account_TIN';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'yy_vw_ACE_Validation_Chk_UHC_Account_TIN';

