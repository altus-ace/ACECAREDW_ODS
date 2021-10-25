CREATE VIEW dbo.[zz_vw_UHC_ActiveMembers_TS]
AS
SELECT        CAST(MEMBER_ID AS VARCHAR(15)) AS MEMBER_ID, CAST(MEMBER_FIRST_NAME AS VARCHAR(30)) AS MEMBER_FIRST_NAME, CAST(MEMBER_MI AS VARCHAR(5)) AS MEMBER_MI, 
                         CAST(MEMBER_LAST_NAME AS VARCHAR(30)) AS MEMBER_LAST_NAME, CAST(UHC_SUBSCRIBER_ID AS VARCHAR(15)) AS UHC_SUBSCRIBER_ID, CAST(PLAN_ID AS VARCHAR(15)) AS PLAN_ID, 
                         CAST(PRODUCT_CODE AS VARCHAR(15)) AS PRODUCT_CODE, CAST(SUBGRP_ID AS VARCHAR(15)) AS SUBGRP_ID, CAST(SUBGRP_NAME AS VARCHAR(30)) AS SUBGRP_NAME, 
                         CAST(MEDICAID_ID AS VARCHAR(15)) AS MEDICAID_ID, CAST(AGE AS VARCHAR(5)) AS AGE, CAST(DATE_OF_BIRTH AS VARCHAR(15)) AS DATE_OF_BIRTH, CAST(GENDER AS VARCHAR(15)) AS GENDER, 
                         CAST(LANG_CODE AS VARCHAR(15)) AS LANG_CODE, CAST(MEMBER_HOME_ADDRESS AS VARCHAR(30)) AS MEMBER_HOME_ADDRESS, CAST(MEMBER_HOME_ADDRESS2 AS VARCHAR(30)) 
                         AS MEMBER_HOME_ADDRESS2, CAST(MEMBER_HOME_CITY AS VARCHAR(30)) AS MEMBER_HOME_CITY, CAST(MEMBER_HOME_STATE AS VARCHAR(15)) AS MEMBER_HOME_STATE, 
                         CAST(MEMBER_HOME_ZIP_C AS VARCHAR(15)) AS MEMBER_HOME_ZIP_C, CAST(MEMBER_HOME_PHONE AS VARCHAR(15)) AS MEMBER_HOME_PHONE, CAST(MEMBER_BUS_PHONE AS VARCHAR(15)) 
                         AS MEMBER_BUS_PHONE, CAST(MEMBER_ORG_EFF_DATE AS VARCHAR(15)) AS MEMBER_ORG_EFF_DATE, CAST(MEMBER_CONT_EFF_DATE AS VARCHAR(15)) AS MEMBER_CONT_EFF_DATE, 
                         CAST(MEMBER_CUR_EFF_DATE AS VARCHAR(15)) AS MEMBER_CUR_EFF_DATE, CAST(MEMBER_CUR_TERM_DATE AS VARCHAR(15)) AS MEMBER_CUR_TERM_DATE, CAST(PCP_UHC_ID AS VARCHAR(15)) 
                         AS PCP_UHC_ID, CAST(PCP_FIRST_NAME AS VARCHAR(30)) AS PCP_FIRST_NAME, CAST(PCP_LAST_NAME AS VARCHAR(30)) AS PCP_LAST_NAME, CAST(PCP_NPI AS VARCHAR(15)) AS PCP_NPI, 
                         CAST(PCP_PHONE AS VARCHAR(15)) AS PCP_PHONE, CAST(PCP_FAX AS VARCHAR(15)) AS PCP_FAX, CAST(PCP_ADDRESS AS VARCHAR(30)) AS PCP_ADDRESS, CAST(PCP_ADDRESS2 AS VARCHAR(30)) 
                         AS PCP_ADDRESS2, CAST(PCP_CITY AS VARCHAR(30)) AS PCP_CITY, CAST(PCP_STATE AS VARCHAR(15)) AS PCP_STATE, CAST(PCP_ZIP_C AS VARCHAR(15)) AS PCP_ZIP_C, 
                         CAST(PCP_EFFECTIVE_DATE AS VARCHAR(15)) AS PCP_EFFECTIVE_DATE, CAST(PCP_TERM_DATE AS VARCHAR(15)) AS PCP_TERM_DATE, CAST(PCP_PRACTICE_TIN AS VARCHAR(15)) AS PCP_PRACTICE_TIN, 
                         CAST(PCP_GROUP_ID AS VARCHAR(15)) AS PCP_GROUP_ID, CAST(PCP_PRACTICE_NAME AS VARCHAR(30)) AS PCP_PRACTICE_NAME, CAST(AUTO_ASSIGN AS VARCHAR(15)) AS AUTO_ASSIGN, 
                         CAST(IPRO_ADMIT_RISK_SCORE AS VARCHAR(15)) AS IPRO_ADMIT_RISK_SCORE, CAST(RISK_CATEGORY_C AS VARCHAR(15)) AS RISK_CATEGORY_C, CAST(LINE_OF_BUSINESS AS VARCHAR(30)) 
                         AS LINE_OF_BUSINESS, CAST(PLAN_CODE AS VARCHAR(15)) AS PLAN_CODE, CAST(PLAN_DESC AS VARCHAR(30)) AS PLAN_DESC, CAST(PRIMARY_RISK_FACTOR AS VARCHAR(100)) 
                         AS PRIMARY_RISK_FACTOR, CAST(TOTAL_COSTS_LAST_12_MOS AS VARCHAR(15)) AS TOTAL_COSTS_LAST_12_MOS, CAST(COUNT_OPEN_CARE_OPPS AS VARCHAR(15)) AS COUNT_OPEN_CARE_OPPS, 
                         CAST(INP_COSTS_LAST_12_MOS AS VARCHAR(15)) AS INP_COSTS_LAST_12_MOS, CAST(ER_COSTS_LAST_12_MOS AS VARCHAR(15)) AS ER_COSTS_LAST_12_MOS, 
                         CAST(OUTP_COSTS_LAST_12_MOS AS VARCHAR(15)) AS OUTP_COSTS_LAST_12_MOS, CAST(PHARMACY_COSTS_LAST_12_MOS AS VARCHAR(15)) AS PHARMACY_COSTS_LAST_12_MOS, 
                         CAST(PRIMARY_CARE_COSTS_LAST_12_MOS AS VARCHAR(15)) AS PRIMARY_CARE_COSTS_LAST_12_MOS, CAST(BEHAVIORAL_COSTS_LAST_12_MOS AS VARCHAR(15)) 
                         AS BEHAVIORAL_COSTS_LAST_12_MOS, CAST(OTHER_OFFICE_COSTS_LAST_12_MOS AS VARCHAR(15)) AS OTHER_OFFICE_COSTS_LAST_12_MOS, CAST(INP_ADMITS_LAST_12_MOS AS VARCHAR(15)) 
                         AS INP_ADMITS_LAST_12_MOS, CAST(LAST_INP_DISCHARGE AS VARCHAR(15)) AS LAST_INP_DISCHARGE, CAST(POST_DISCHARGE_FUP_VISIT AS VARCHAR(15)) AS POST_DISCHARGE_FUP_VISIT, 
                         CAST(INP_FUP_WITHIN_7_DAYS AS VARCHAR(15)) AS INP_FUP_WITHIN_7_DAYS, CAST(ER_VISITS_LAST_12_MOS AS VARCHAR(15)) AS ER_VISITS_LAST_12_MOS, CAST(LAST_ER_VISIT AS VARCHAR(15)) 
                         AS LAST_ER_VISIT, CAST(POST_ER_FUP_VISIT AS VARCHAR(15)) AS POST_ER_FUP_VISIT, CAST(ER_FUP_WITHIN_7_DAYS AS VARCHAR(15)) AS ER_FUP_WITHIN_7_DAYS, 
                         CAST(LAST_PCP_VISIT AS VARCHAR(15)) AS LAST_PCP_VISIT, CAST(LAST_PCP_PRACTICE_SEEN AS VARCHAR(50)) AS LAST_PCP_PRACTICE_SEEN, CAST(LAST_BH_VISIT AS VARCHAR(15)) AS LAST_BH_VISIT, 
                         CAST(LAST_BH_PRACTICE_SEEN AS VARCHAR(50)) AS LAST_BH_PRACTICE_SEEN, CAST(MEMBER_MONTH_COUNT AS VARCHAR(15)) AS MEMBER_MONTH_COUNT, 
                         CAST(ACE_MemberByPCP_URN AS VARCHAR(15)) AS ACE_MemberByPCP_URN, CAST(ACE_Membership_URN AS VARCHAR(15)) AS ACE_Membership_URN, CAST(MEMBER_POD_C AS VARCHAR(5)) 
                         AS MEMBER_POD_C, CAST(MEMBER_POD_DESC AS VARCHAR(30)) AS MEMBER_POD_DESC, CAST(PCP_POD_C AS VARCHAR(5)) AS PCP_POD_C, CAST(PCP_POD_DESC AS VARCHAR(30)) AS PCP_POD_DESC, 
                         CAST(PCP_NAME AS VARCHAR(50)) AS PCP_NAME, CAST(UHC_UNIQUE_SYSTEM_ID AS VARCHAR(15)) AS UHC_UNIQUE_SYSTEM_ID
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
         Left = -1209
      End
      Begin Tables = 
         Begin Table = "vw_UHC_ActiveMembers"
            Begin Extent = 
               Top = 6
               Left = 1247
               Bottom = 314
               Right = 1541
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
      Begin ColumnWidths = 82
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
        ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'zz_vw_UHC_ActiveMembers_TS';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N' Width = 1500
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'zz_vw_UHC_ActiveMembers_TS';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'zz_vw_UHC_ActiveMembers_TS';

