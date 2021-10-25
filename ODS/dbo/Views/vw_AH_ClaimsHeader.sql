CREATE VIEW dbo.vw_AH_ClaimsHeader
AS
SELECT        'UHC' AS LOB, SUBSCRIBER_ID, MEDICAID_NO, CLAIM_NUMBER, PLACE_OF_SVC_CODE1, PLACE_OF_SVC_CODE2, PLACE_OF_SVC_CODE3, CATEGORY_OF_SVC, DATE_RECEIVED, DETAIL_SVC_DATE, 
                         SVC_TO_DATE, SVC_PROV_NPI, 
                         DIAG1 + ',' + DIAG2 + ',' + DIAG3 + ',' + DIAG4 + ',' + DIAG5 + ',' + DIAG6 + ',' + DIAG7 + ',' + DIAG8 + ',' + DIAG9 + ',' + DIAG10 + ',' + DIAG11 + ',' + DIAG12 + ',' + DIAG13 + ',' + DIAG14 + ',' + DIAG15 + ',' + DIAG16 + ','
                          + DIAG17 + ',' + DIAG18 + ',' + DIAG19 + ',' + DIAG20 + + ',' + DIAG21 + ',' + DIAG22 + ',' + DIAG23 + ',' + DIAG24 + ',' + DIAG25 AS Diagnosis_codes, LINE_NUMBER, SUB_LINE_CODE, 
                         ICD_PRIM_DIAG AS [Diagnosis_CODE_Version(ICD 9/ICD 10)], BILL_TYPE, ADMIT_SOURCE_CODE AS ADMISSION_TYPE, CLAIM_STATUS, '' AS HOLD_CODE, TOTAL_BILLED_AMT, 
                         BILLED_AMT AS AMOUNT_PAID, CASE WHEN CLAIM_STATUS = 'A' THEN CAST(TOTAL_BILLED_AMT AS decimal) + CAST(BILLED_AMT AS decimal) ELSE CAST(TOTAL_BILLED_AMT AS DECIMAL) 
                         END AS BALANCE_DUE
FROM            dbo.UHC_Claims
WHERE        (CLAIM_NUMBER NOT IN
                             (SELECT DISTINCT CLAIM_NUMBER
                               FROM            dbo.UHC_Claims AS UHC_Claims_1
                               WHERE        (SUB_LINE_CODE = 'R') AND (LINE_NUMBER = '1'))) AND (LINE_NUMBER = '1')

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
         Begin Table = "UHC_Claims"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 290
               Right = 363
            End
            DisplayFlags = 280
            TopColumn = 172
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_AH_ClaimsHeader';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_AH_ClaimsHeader';

