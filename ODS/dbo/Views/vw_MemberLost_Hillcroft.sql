CREATE VIEW dbo.vw_MemberLost_Hillcroft
AS
SELECT        MEMBER_ID, MEMBER_FIRST_NAME, MEMBER_MI AS MEMBER_MIDDLE_NAME, MEMBER_LAST_NAME, SUBGRP_NAME AS MEMBER_PLAN, AGE, GENDER, CASE WHEN u.ipro_admit_risk_score IS NULL 
                         THEN ' ' ELSE U.IPRO_ADMIT_RISK_SCORE END AS UHC_RISK_SCORE, CASE WHEN u.Risk_Category_c IS NULL THEN ' ' ELSE U.RISK_CATEGORY_C END AS RISK_CATEGORY, 
                         CASE WHEN u.Primary_risk_factor IS NULL THEN ' ' ELSE U.PRIMARY_RISK_FACTOR END AS PRIMARY_RISK_FACTOR, MEMBER_STATUS, MEMBER_TERM_DATE
FROM            (SELECT        umPCP.UHC_SUBSCRIBER_ID AS MEMBER_ID, umPCP.MEMBER_FIRST_NAME, umPCP.MEMBER_MI, umPCP.MEMBER_LAST_NAME, umPCP.SUBGRP_NAME, umPCP.AGE, umPCP.GENDER, 
                                                    uM_1.IPRO_ADMIT_RISK_SCORE, dbo.sv_CalcRiskCategory(CONVERT(NUMERIC(10, 4), uM_1.IPRO_ADMIT_RISK_SCORE)) AS RISK_CATEGORY_C, uM_1.PRIMARY_RISK_FACTOR, 
                                                    umPCP.MEMBER_STATUS, umPCP.MEMBER_TERM_DATE
                          FROM            (SELECT        URN, MEMBER_FIRST_NAME, MEMBER_MI, MEMBER_LAST_NAME, UHC_SUBSCRIBER_ID, CLASS, PLAN_ID, PRODUCT_CODE, SUBGRP_ID, SUBGRP_NAME, MEDICARE_ID, 
                                                                              MEDICAID_ID, AGE, DATE_OF_BIRTH, GENDER, RELATIONSHIP_CODE, LANG_CODE, MEMBER_HOME_ADDRESS, MEMBER_HOME_ADDRESS2, MEMBER_HOME_CITY, 
                                                                              MEMBER_HOME_STATE, MEMBER_HOME_ZIP, MEMBER_HOME_PHONE, MEMBER_MAIL_ADDRESS, MEMBER_MAIL_ADDRESS2, MEMBER_MAIL_CITY, MEMBER_MAIL_STATE, 
                                                                              MEMBER_MAIL_ZIP, MEMBER_MAIL_PHONE, MEMBER_COUNTY_CODE, MEMBER_COUNTY, MEMBER_BUS_PHONE, DUAL_COV_FLAG, MEMBER_ORG_EFF_DATE, 
                                                                              MEMBER_CONT_EFF_DATE, MEMBER_CUR_EFF_DATE, MEMBER_CUR_TERM_DATE, CLASS_PLAN_ID, RESP_LAST_NAME, RESP_FIRST_NAME, RESP_ADDRESS, RESP_ADDRESS2, 
                                                                              RESP_CITY, RESP_STATE, RESP_ZIP, RESP_PHONE, BROKER_ID, PCP_UHC_ID, PCP_FIRST_NAME, PCP_LAST_NAME, PCP_MPIN, PCP_NPI, PCP_PROV_TYPE_ID, PCP_PROV_TYPE, 
                                                                              PCP_INDICATOR, CMG, PCP_PHONE, PCP_FAX, PCP_ADDRESS, PCP_ADDRESS2, PCP_CITY, PCP_STATE, PCP_ZIP, PCP_COUNTY, PCP_EFFECTIVE_DATE, PCP_TERM_DATE, 
                                                                              PCP_PRACTICE_TIN, PCP_GROUP_ID, PCP_PRACTICE_NAME, IND_PRACT_ID, IND_PRACT_NAME, RECERT_DATE, ETHNICITY, AUTO_ASSIGN, ASAP_ID, FEW_ID, LST_HRA_DATE, 
                                                                              NXT_HRA_DATE, HRA_ID, A_LAST_UPDATE_DATE, A_LAST_UPDATE_BY, A_LAST_UPDATE_FLAG, MEMBER_STATUS, MEMBER_TERM_DATE
                                                    FROM            dbo.UHC_MembersByPCP AS mpcp
                                                    WHERE        (A_LAST_UPDATE_DATE = '01-19-2017') AND (PCP_PRACTICE_TIN = '760537608')) AS umPCP LEFT OUTER JOIN
                                                        (SELECT        URN, ACE_MBR_ID, MEDICAID_ID, MEMBER_LAST_NAME, MEMBER_FIRST_NAME, DATE_OF_BIRTH, IPRO_ADMIT_RISK_SCORE, UHC_SUBSCRIBER_ID, UHC_UNIQUE_SYSTEM_ID,
                                                                                     MEMBER_ADDRESS, MEMBER_CITY, MEMBER_STATE, MEMBER_COUNTY, MEMBER_ZIP, MEMBER_PHONE, LINE_OF_BUSINESS, PLAN_CODE, PLAN_DESC, REGION_CODE, 
                                                                                    REGION_DESC, PCP_NAME, PCP_ADDRESS, PCP_CITY, PCP_STATE, PCP_COUNTY, PCP_ZIP, PCP_PRACTICE_TIN, PCP_PRACTICE_NAME, PRIMARY_RISK_FACTOR, 
                                                                                    TOTAL_COSTS_LAST_12_MOS, COUNT_OPEN_CARE_OPPS, INP_COSTS_LAST_12_MOS, ER_COSTS_LAST_12_MOS, OUTP_COSTS_LAST_12_MOS, 
                                                                                    PHARMACY_COSTS_LAST_12_MOS, PRIMARY_CARE_COSTS_LAST_12_MOS, BEHAVIORAL_COSTS_LAST_12_MOS, OTHER_OFFICE_COSTS_LAST_12_MOS, 
                                                                                    INP_ADMITS_LAST_12_MOS, LAST_INP_DISCHARGE, POST_DISCHARGE_FUP_VISIT, INP_FUP_WITHIN_7_DAYS, ER_VISITS_LAST_12_MOS, LAST_ER_VISIT, POST_ER_FUP_VISIT, 
                                                                                    ER_FUP_WITHIN_7_DAYS, LAST_PCP_VISIT, LAST_PCP_PRACTICE_SEEN, LAST_BH_VISIT, LAST_BH_PRACTICE_SEEN, MEMBER_MONTH_COUNT, FILE_GENERATION_DATE, 
                                                                                    REPORT_MONTH, A_LAST_UPDATE_DATE, A_LAST_UPDATE_BY, A_LAST_UPDATE_FLAG
                                                          FROM            dbo.UHC_Membership AS um
                                                          WHERE        (A_LAST_UPDATE_DATE = '01-19-2017')) AS uM_1 ON umPCP.UHC_SUBSCRIBER_ID = uM_1.UHC_SUBSCRIBER_ID) AS u
WHERE        (MEMBER_ID NOT IN
                             (SELECT DISTINCT MEMBER_ID
                               FROM            dbo.vw_UHC_ActiveMembers))

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
         Begin Table = "u"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 264
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
      Begin ColumnWidths = 13
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_MemberLost_Hillcroft';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_MemberLost_Hillcroft';

