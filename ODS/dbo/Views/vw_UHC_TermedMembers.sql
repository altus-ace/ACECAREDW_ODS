


CREATE  VIEW [dbo].[vw_UHC_TermedMembers]

AS

/* Added   , umPCP.A_LAST_UPDATE_DATE to allow querying when a member termed. */
     SELECT
            umPCP.UHC_SUBSCRIBER_ID AS MEMBER_ID
          , umPCP.MEMBER_FIRST_NAME
          , umPCP.MEMBER_MI
          , umPCP.MEMBER_LAST_NAME
          , umPCP.UHC_SUBSCRIBER_ID
          , umPCP.PLAN_ID
          , umPCP.PRODUCT_CODE
          , umPCP.SUBGRP_ID
          , umPCP.SUBGRP_NAME
          , umPCP.MEDICAID_ID
          , umPCP.AGE
          , umPCP.DATE_OF_BIRTH
          , umPCP.GENDER
          , umPCP.LANG_CODE
          , umPCP.MEMBER_HOME_ADDRESS
          , umPCP.MEMBER_HOME_ADDRESS2
          , umPCP.MEMBER_HOME_CITY
          , umPCP.MEMBER_HOME_STATE
          , LEFT(umPCP.MEMBER_HOME_ZIP, 5) AS MEMBER_HOME_ZIP_C
          , umPCP.MEMBER_HOME_PHONE
          , umPCP.MEMBER_MAIL_ADDRESS
          , umPCP.MEMBER_MAIL_ADDRESS2
          , umPCP.MEMBER_MAIL_CITY
          , umPCP.MEMBER_MAIL_STATE
          , LEFT(umPCP.MEMBER_MAIL_ZIP, 5) AS MEMBER_MAIL_ZIP_C
          , umPCP.MEMBER_MAIL_PHONE
          , umPCP.MEMBER_COUNTY
          , umPCP.MEMBER_BUS_PHONE
          , umPCP.MEMBER_ORG_EFF_DATE
          , umPCP.MEMBER_CONT_EFF_DATE
          , umPCP.MEMBER_CUR_EFF_DATE
          , umPCP.MEMBER_CUR_TERM_DATE
          , umPCP.PCP_UHC_ID
          , umPCP.PCP_FIRST_NAME
          , umPCP.PCP_LAST_NAME
          , umPCP.PCP_NPI
          , umPCP.PCP_PHONE
          , umPCP.PCP_FAX
          , umPCP.PCP_ADDRESS
          , umPCP.PCP_ADDRESS2
          , umPCP.PCP_CITY
          , umPCP.PCP_STATE
          , LEFT(umPCP.PCP_ZIP, 5) AS PCP_ZIP_C
          , umPCP.PCP_EFFECTIVE_DATE
          , umPCP.PCP_TERM_DATE
          , umPCP.PCP_PRACTICE_TIN
          , umPCP.PCP_GROUP_ID
          , umPCP.PCP_PRACTICE_NAME
          , umPCP.AUTO_ASSIGN
          , umPCP.MEMBER_STATUS
          , umPCP.MEMBER_TERM_DATE
		,umPCP.MEMBER_EMAIL
          , uM_1.IPRO_ADMIT_RISK_SCORE
          ,dbo.sv_CalcRiskCategory_V2(uM_1.IPRO_ADMIT_RISK_SCORE) AS RISK_CATEGORY_C      
          , uM_1.LINE_OF_BUSINESS
          , uM_1.PLAN_CODE
          , uM_1.PLAN_DESC
          , uM_1.PRIMARY_RISK_FACTOR
          , uM_1.TOTAL_COSTS_LAST_12_MOS
          , uM_1.COUNT_OPEN_CARE_OPPS
          , uM_1.INP_COSTS_LAST_12_MOS
          , uM_1.ER_COSTS_LAST_12_MOS
          , uM_1.OUTP_COSTS_LAST_12_MOS
          , uM_1.PHARMACY_COSTS_LAST_12_MOS
          , uM_1.PRIMARY_CARE_COSTS_LAST_12_MOS
          , uM_1.BEHAVIORAL_COSTS_LAST_12_MOS
          , uM_1.OTHER_OFFICE_COSTS_LAST_12_MOS
          , uM_1.INP_ADMITS_LAST_12_MOS
          , uM_1.LAST_INP_DISCHARGE
          , uM_1.POST_DISCHARGE_FUP_VISIT
          , uM_1.INP_FUP_WITHIN_7_DAYS
          , uM_1.ER_VISITS_LAST_12_MOS
          , uM_1.LAST_ER_VISIT
          , uM_1.POST_ER_FUP_VISIT
          , uM_1.ER_FUP_WITHIN_7_DAYS
          , uM_1.LAST_PCP_VISIT
          , uM_1.LAST_PCP_PRACTICE_SEEN
          , uM_1.LAST_BH_VISIT
          , uM_1.LAST_BH_PRACTICE_SEEN
          , uM_1.MEMBER_MONTH_COUNT
          , umPCP.URN AS ACE_MemberByPCP_URN
          , uM_1.URN AS ACE_Membership_URN
          , CASE
                WHEN A.Pod IS NULL
                THEN 6
                ELSE A.Pod
            END AS MEMBER_POD_C
          , CASE
                WHEN A.Quadrant IS NULL
                THEN 'NOT DEFINED'
                ELSE A.Quadrant
            END AS MEMBER_POD_DESC
          , CASE
                WHEN B.Pod IS NULL
                THEN 6
                ELSE B.Pod
            END AS PCP_POD_C
          , CASE
                WHEN B.Quadrant IS NULL
                THEN 'NOT DEFINED'
                ELSE B.Quadrant
            END AS PCP_POD_DESC
          , uM_1.PCP_NAME
          , uM_1.UHC_UNIQUE_SYSTEM_ID
          , umPCP.Medicare_id
          , umPCP.RESP_LAST_NAME
          , umPCP.RESP_FIRST_NAME
          , umPCP.RESP_ADDRESS
          , umPCP.RESP_ADDRESS2
          , umPCP.RESP_CITY
          , umPCP.RESP_STATE
          , umPCP.RESP_ZIP
          , umPCP.RESP_PHONE
		, umPCP.A_LAST_UPDATE_DATE		
     FROM
     (
         SELECT
                *
         FROM
         (
             SELECT
                    URN
                  , MEMBER_FIRST_NAME
                  , MEMBER_MI
                  , MEMBER_LAST_NAME
                  , UHC_SUBSCRIBER_ID
                  , CLASS
                  , PLAN_ID
                  , PRODUCT_CODE
                  , SUBGRP_ID
                  , SUBGRP_NAME
                  , MEDICARE_ID
                  , MEDICAID_ID
                  , AGE
                  , DATE_OF_BIRTH
                  , GENDER
                  , RELATIONSHIP_CODE
                  , LANG_CODE
                  , MEMBER_HOME_ADDRESS
                  , MEMBER_HOME_ADDRESS2
                  , MEMBER_HOME_CITY
                  , MEMBER_HOME_STATE
                  , MEMBER_HOME_ZIP
                  , MEMBER_HOME_PHONE
                  , MEMBER_MAIL_ADDRESS
                  , MEMBER_MAIL_ADDRESS2
                  , MEMBER_MAIL_CITY
                  , MEMBER_MAIL_STATE
                  , MEMBER_MAIL_ZIP
                  , MEMBER_MAIL_PHONE
                  , MEMBER_COUNTY_CODE
                  , MEMBER_COUNTY
                  , MEMBER_BUS_PHONE
                  , DUAL_COV_FLAG
                  , MEMBER_ORG_EFF_DATE
                  , MEMBER_CONT_EFF_DATE
                  , MEMBER_CUR_EFF_DATE
                  , MEMBER_CUR_TERM_DATE
                  , CLASS_PLAN_ID
                  , RESP_LAST_NAME
                  , RESP_FIRST_NAME
                  , RESP_ADDRESS
                  , RESP_ADDRESS2
                  , RESP_CITY
                  , RESP_STATE
                  , RESP_ZIP
                  , RESP_PHONE
                  , BROKER_ID
                  , PCP_UHC_ID
                  , PCP_FIRST_NAME
                  , PCP_LAST_NAME
                  , PCP_MPIN
                  , PCP_NPI
                  , PCP_PROV_TYPE_ID
                  , PCP_PROV_TYPE
                  , PCP_INDICATOR
                  , CMG
                  , PCP_PHONE
                  , PCP_FAX
                  , PCP_ADDRESS
                  , PCP_ADDRESS2
                  , PCP_CITY
                  , PCP_STATE
                  , PCP_ZIP
                  , PCP_COUNTY
                  , PCP_EFFECTIVE_DATE
                  , PCP_TERM_DATE
                  , PCP_PRACTICE_TIN
                  , PCP_GROUP_ID
                  , PCP_PRACTICE_NAME
                  , IND_PRACT_ID
                  , IND_PRACT_NAME
                  , RECERT_DATE
                  , ETHNICITY
                  , AUTO_ASSIGN
                  , ASAP_ID
                  , FEW_ID
                  , LST_HRA_DATE
                  , NXT_HRA_DATE
                  , HRA_ID
                  , A_LAST_UPDATE_DATE
                  , A_LAST_UPDATE_BY
                  , A_LAST_UPDATE_FLAG
                  , MEMBER_STATUS
                  , MEMBER_TERM_DATE
			   ,MEMBER_EMAIL
                  , ROW_NUMBER() OVER(PARTITION BY mpcp.UHC_SUBSCRIBER_ID ORDER BY mpcp.a_Last_UPdate_Date DESC) AS aRow
             FROM dbo.UHC_MembersByPCP AS mpcp
		   /* have to pull both last run and prior run records */
             WHERE((A_LAST_UPDATE_FLAG = 'N') OR (mpcp.A_LAST_UPDATE_FLAG = 'L'))
         ) umRowNum
         WHERE umRowNum.aRow = 1
               AND umRowNum.MEMBER_STATUS = 'T'
     ) AS umPCP
     LEFT OUTER JOIN
     (
         SELECT
                URN
              , ACE_MBR_ID
              , MEDICAID_ID
              , MEMBER_LAST_NAME
              , MEMBER_FIRST_NAME
              , DATE_OF_BIRTH
              , IPRO_ADMIT_RISK_SCORE
              , UHC_SUBSCRIBER_ID
              , UHC_UNIQUE_SYSTEM_ID
              , MEMBER_ADDRESS
              , MEMBER_CITY
              , MEMBER_STATE
              , MEMBER_COUNTY
              , MEMBER_ZIP
              , MEMBER_PHONE
              , LINE_OF_BUSINESS
              , PLAN_CODE
              , PLAN_DESC
              , REGION_CODE
              , REGION_DESC
              , PCP_NAME
              , PCP_ADDRESS
              , PCP_CITY
              , PCP_STATE
              , PCP_COUNTY
              , PCP_ZIP
              , PCP_PRACTICE_TIN
              , PCP_PRACTICE_NAME
              , PRIMARY_RISK_FACTOR
              , TOTAL_COSTS_LAST_12_MOS
              , COUNT_OPEN_CARE_OPPS
              , INP_COSTS_LAST_12_MOS
              , ER_COSTS_LAST_12_MOS
              , OUTP_COSTS_LAST_12_MOS
              , PHARMACY_COSTS_LAST_12_MOS
              , PRIMARY_CARE_COSTS_LAST_12_MOS
              , BEHAVIORAL_COSTS_LAST_12_MOS
              , OTHER_OFFICE_COSTS_LAST_12_MOS
              , INP_ADMITS_LAST_12_MOS
              , LAST_INP_DISCHARGE
              , POST_DISCHARGE_FUP_VISIT
              , INP_FUP_WITHIN_7_DAYS
              , ER_VISITS_LAST_12_MOS
              , LAST_ER_VISIT
              , POST_ER_FUP_VISIT
              , ER_FUP_WITHIN_7_DAYS
              , LAST_PCP_VISIT
              , LAST_PCP_PRACTICE_SEEN
              , LAST_BH_VISIT
              , LAST_BH_PRACTICE_SEEN
              , MEMBER_MONTH_COUNT
              , FILE_GENERATION_DATE
              , REPORT_MONTH
              , A_LAST_UPDATE_DATE
              , A_LAST_UPDATE_BY
              , A_LAST_UPDATE_FLAG
         FROM dbo.UHC_Membership AS um
         WHERE(A_LAST_UPDATE_FLAG = 'Y')
     ) AS uM_1 ON umPCP.UHC_SUBSCRIBER_ID = uM_1.UHC_SUBSCRIBER_ID
     LEFT OUTER JOIN dbo.LIST_ZIPCODES AS A ON LEFT(umPCP.MEMBER_HOME_ZIP, 5) = A.ZipCode
     LEFT OUTER JOIN dbo.LIST_ZIPCODES AS B ON LEFT(umPCP.PCP_ZIP, 5) = B.ZipCode
     WHERE umPCP.MEMBER_STATUS = 'T';


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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_UHC_TermedMembers';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_UHC_TermedMembers';

