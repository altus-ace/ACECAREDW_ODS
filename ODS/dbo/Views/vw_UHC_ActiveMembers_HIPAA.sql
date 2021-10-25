CREATE VIEW dbo.vw_UHC_ActiveMembers_HIPAA
AS
SELECT        MEMBER_ID, LEFT(MEMBER_LAST_NAME, 1) + '***' AS MEMBER_LAST_NAME_C, MEMBER_FIRST_NAME, MEMBER_MI, UHC_SUBSCRIBER_ID, PLAN_ID, PRODUCT_CODE, SUBGRP_ID, SUBGRP_NAME, 
                         MEDICAID_ID, AGE, DATE_OF_BIRTH, GENDER, LANG_CODE, LEFT(MEMBER_HOME_ADDRESS, 4) + '*****' AS MEMBER_HOME_ADDRESS_C, MEMBER_HOME_ADDRESS2, MEMBER_HOME_CITY, 
                         MEMBER_HOME_STATE, MEMBER_HOME_ZIP_C, MEMBER_HOME_PHONE, MEMBER_BUS_PHONE, MEMBER_ORG_EFF_DATE, MEMBER_CONT_EFF_DATE, MEMBER_CUR_EFF_DATE, 
                         MEMBER_CUR_TERM_DATE, PCP_UHC_ID, PCP_FIRST_NAME, PCP_LAST_NAME, PCP_NPI, PCP_PHONE, PCP_FAX, PCP_ADDRESS, PCP_ADDRESS2, PCP_CITY, PCP_STATE, PCP_ZIP_C, 
                         PCP_EFFECTIVE_DATE, PCP_TERM_DATE, PCP_PRACTICE_TIN, PCP_GROUP_ID, PCP_PRACTICE_NAME, AUTO_ASSIGN, IPRO_ADMIT_RISK_SCORE, RISK_CATEGORY_C, LINE_OF_BUSINESS, PLAN_CODE, 
                         PLAN_DESC, PRIMARY_RISK_FACTOR, TOTAL_COSTS_LAST_12_MOS, COUNT_OPEN_CARE_OPPS, INP_COSTS_LAST_12_MOS, ER_COSTS_LAST_12_MOS, OUTP_COSTS_LAST_12_MOS, 
                         PHARMACY_COSTS_LAST_12_MOS, PRIMARY_CARE_COSTS_LAST_12_MOS, BEHAVIORAL_COSTS_LAST_12_MOS, OTHER_OFFICE_COSTS_LAST_12_MOS, INP_ADMITS_LAST_12_MOS, 
                         LAST_INP_DISCHARGE, POST_DISCHARGE_FUP_VISIT, INP_FUP_WITHIN_7_DAYS, ER_VISITS_LAST_12_MOS, LAST_ER_VISIT, POST_ER_FUP_VISIT, ER_FUP_WITHIN_7_DAYS, LAST_PCP_VISIT, 
                         LAST_PCP_PRACTICE_SEEN, LAST_BH_VISIT, LAST_BH_PRACTICE_SEEN, MEMBER_MONTH_COUNT, ACE_MemberByPCP_URN, ACE_Membership_URN, MEMBER_POD_C, MEMBER_POD_DESC, 
                         PCP_POD_C, PCP_POD_DESC, PCP_NAME, UHC_UNIQUE_SYSTEM_ID
FROM            dbo.vw_UHC_ActiveMembers

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
               Bottom = 299
               Right = 332
            End
            DisplayFlags = 280
            TopColumn = 65
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 77
         Width = 284
         Width = 1935
         Width = 1980
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
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_UHC_ActiveMembers_HIPAA';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N' = 1500
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_UHC_ActiveMembers_HIPAA';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_UHC_ActiveMembers_HIPAA';

