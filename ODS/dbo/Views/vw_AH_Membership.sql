









CREATE VIEW [dbo].[vw_AH_Membership]
AS
    /* OBJECTIVE: 
    	   1. current members from new model
	   2. termed members from both
	  */ 
      SELECT DISTINCT 
            UAM.MEMBER_ID
          , 'UHC' AS CLIENT_ID
          , UAM.MEDICAID_ID
          , REPLACE(RTRIM(UAM.MEMBER_FIRST_NAME), ',', ' ') AS MEMBER_FIRST_NAME
          , REPLACE(RTRIM(UAM.MEMBER_MI), ',', ' ') AS MEMBER_MI
          , REPLACE(RTRIM(UAM.MEMBER_LAST_NAME), ',', ' ') AS MEMBER_LAST_NAME
          , UAM.DATE_OF_BIRTH
          , UAM.GENDER AS MEMBER_GENDER
          , REPLACE(RTRIM(UAM.MEMBER_HOME_ADDRESS), ',', ' ')+' '+REPLACE(RTRIM(UAM.MEMBER_HOME_ADDRESS2), ',', ' ') AS HOME_ADDRESS
          , UAM.MEMBER_HOME_CITY AS HOME_CITY
          , UAM.MEMBER_HOME_STATE AS HOME_STATE
          , UAM.MEMBER_HOME_ZIP_C AS HOME_ZIPCODE
		/*GETTING PREFERRED ADDRESS TO MAILING ADDRESS*/
          , CASE WHEN PREADD.MEMBER_ADDRESS IS NULL 
		THEN REPLACE(RTRIM(UAM.MEMBER_HOME_ADDRESS), ',', ' ')+' '+REPLACE(RTRIM(UAM.MEMBER_HOME_ADDRESS2), ',', ' ') ELSE REPLACE(RTRIM(PREADD.MEMBER_ADDRESS), ',', ' ') END AS MAILING_ADDRESS
          , CASE WHEN PREADD.MEMBER_CITY IS NULL THEN UAM.MEMBER_HOME_CITY ELSE PREADD.MEMBER_CITY END AS MAILING_CITY
          , CASE WHEN PREADD.MEMBER_STATE IS NULL THEN UAM.MEMBER_HOME_STATE ELSE PREADD.MEMBER_STATE END  AS MAILING_STATE
          , CASE WHEN PREADD.MEMEBR_ZIP IS NULL THEN UAM.MEMBER_HOME_ZIP_C ELSE PREADD.MEMEBR_ZIP END   AS MAILING_ZIP
          , UAM.MEMBER_HOME_PHONE AS HOME_PHONE
          , UAM.MEMBER_MAIL_PHONE AS ADDITIONAL_PHONE
          , UAM.MEMBER_HOME_PHONE AS CELL_PHONE
		  ,UAM.LANG_CODE as LANGUAGE
  --        , ISNULL(NULL, 'TEST LANGUAGE') AS LANGUAGE
		  ,UAM.ETHNICITY as Ethnicity
   --       , ISNULL(NULL, 'Test ETHNICITY') AS Ethnicity
          , UAM.MEDICARE_ID
          , UAM.MEMBER_ORG_EFF_DATE
          , UAM.MEMBER_CONT_EFF_DATE
          , UAM.MEMBER_CUR_EFF_DATE
          , UAM.MEMBER_CUR_TERM_DATE
          , REPLACE(RTRIM(UAM.RESP_FIRST_NAME), ',', ' ') AS RESP_FIRST_NAME
          , REPLACE(RTRIM(UAM.RESP_LAST_NAME), ',', ' ') AS RESP_LAST_NAME
		, 'Responsible Party' AS RESP_RELATIONSHIP					   -- PlaceHolder for future data
          , REPLACE(RTRIM(UAM.RESP_ADDRESS), ',', ' ') AS RESP_ADDRESS
          , REPLACE(RTRIM(UAM.RESP_ADDRESS2), ',', ' ') AS RESP_ADDRESS2
          , UAM.RESP_CITY
          , UAM.RESP_STATE
          , UAM.RESP_ZIP
          , UAM.RESP_PHONE
          , UPPER(REPLACE(RTRIM(UAM.PRIMARY_RISK_FACTOR), ',', ' ')) AS PRIMARY_RISK_FACTOR
          , UAM.COUNT_OPEN_CARE_OPPS					
          , UAM.INP_ADMITS_LAST_12_MOS
          , UAM.LAST_INP_DISCHARGE
          , UAM.POST_DISCHARGE_FUP_VISIT
          , UAM.INP_FUP_WITHIN_7_DAYS
          , CONVERT(varchar(20),     UAM.ER_VISITS_LAST_12_MOS) ER_VISITS_LAST_12_MOS
          , UAM.LAST_ER_VISIT
          , UAM.POST_ER_FUP_VISIT
          , UAM.ER_FUP_WITHIN_7_DAYS
          , UAM.LAST_PCP_VISIT
          , REPLACE(RTRIM(UAM.LAST_PCP_PRACTICE_SEEN), ',', ' ') AS LAST_PCP_PRACTICE_SEEN
          , UAM.LAST_BH_VISIT
		, REPLACE(RTRIM(UAM.LAST_BH_PRACTICE_SEEN), ',', ' ') AS LAST_BH_PRACTICE_SEEN
          , REPLACE(RTRIM(UAM.TOTAL_COSTS_LAST_12_MOS), ',', '') AS TOTAL_COSTS_LAST_12_MOS
          , REPLACE(RTRIM(UAM.INP_COSTS_LAST_12_MOS), ',', '') AS INP_COSTS_LAST_12_MOS
          , REPLACE(RTRIM(UAM.ER_COSTS_LAST_12_MOS), ',', '') AS ER_COSTS_LAST_12_MOS
          , REPLACE(RTRIM(UAM.OUTP_COSTS_LAST_12_MOS), ',', '') AS OUTP_COSTS_LAST_12_MOS
          , REPLACE(RTRIM(UAM.PHARMACY_COSTS_LAST_12_MOS), ',', '') AS PHARMACY_COSTS_LAST_12_MOS
          , REPLACE(RTRIM(UAM.PRIMARY_CARE_COSTS_LAST_12_MOS), ',', '') AS PRIMARY_CARE_COSTS_LAST_12_MOS
          , REPLACE(RTRIM(UAM.BEHAVIORAL_COSTS_LAST_12_MOS), ',', '') AS BEHAVIORAL_COSTS_LAST_12_MOS
          , REPLACE(RTRIM(UAM.OTHER_OFFICE_COSTS_LAST_12_MOS), ',', '') AS OTHER_OFFICE_COSTS_LAST_12_MOS
          , '12/12/2099' AS NEXT_PREVENTATIVE_VISIT_DUE
		, '' AS EMAIL
		,ISNULL(NULL, 'TEST RACE') AS RACE
		, CONVERT(VARCHAR(15), UAM.Ace_ID) AS Ace_ID       
		,  '' AS Carrier_member_id
--  UAM.ER_VISITS_LAST_12_MOS
--, UAM.ER_FUP_WITHIN_7_DAYS
     FROM dbo.vw_UHC_ActiveMembers AS UAM
	LEFT JOIN (SELECT  PD.CLIENT_PATIENT_ID AS MEMBER_ID
				, REPLACE(REPLACE(PDD.ADDRESS_TEXT, CHAR(13), ''), CHAR(10), '') AS MEMBER_ADDRESS
				, REPLACE(REPLACE(PDD.CITY, CHAR(13), ''), CHAR(10), '') AS MEMBER_CITY
				, REPLACE(REPLACE(PDD.STATE, CHAR(13), ''), CHAR(10), '') AS MEMBER_STATE
				, REPLACE(REPLACE(PDD.ZIP , CHAR(13), ''), CHAR(10), '') AS MEMEBR_ZIP  
				,PDD.CREATED_ON       
				,PDD.UPDATED_ON    
		  FROM ahs_altus_prod.dbo.PATIENT_DETAILS AS PD
			 INNER JOIN ahs_altus_prod.dbo.[PATIENT_PREFERRED_ADDRESS] AS PDD 
			 ON PDD.PATIENT_ID = PD.PATIENT_ID and pdd.Deleted_on is null) AS PREADD ON PREADD.MEMBER_ID=UAM.MEMBER_ID
		
	--WHERE UAM.clientKey= 1
	--UNION set from new model of inactive members 
     UNION
     SELECT
            UTM.MEMBER_ID
          , 'UHC' AS CLIENT_ID
          , UTM.MEDICAID_ID
          , REPLACE(RTRIM(UTM.MEMBER_FIRST_NAME), ',', ' ') AS MEMBER_FIRST_NAME
          , REPLACE(RTRIM(UTM.MEMBER_MI), ',', ' ') AS MEMBER_MI
          , REPLACE(RTRIM(UTM.MEMBER_LAST_NAME), ',', ' ') AS MEMBER_LAST_NAME
          , UTM.DATE_OF_BIRTH
          , UTM.GENDER AS MEMBER_GENDER
          , REPLACE(RTRIM(UTM.MEMBER_HOME_ADDRESS), ',', ' ')+' '+REPLACE(RTRIM(UTM.MEMBER_HOME_ADDRESS2), ',', ' ') AS HOME_ADDRESS
          , UTM.MEMBER_HOME_CITY AS HOME_CITY
          , UTM.MEMBER_HOME_STATE AS HOME_STATE
          , UTM.MEMBER_HOME_ZIP_C AS HOME_ZIPCODE
          , REPLACE(RTRIM(UTM.MEMBER_HOME_ADDRESS), ',', ' ')+' '+REPLACE(RTRIM(UTM.MEMBER_HOME_ADDRESS2), ',', ' ') AS MAILING_ADDRESS
          , UTM.MEMBER_HOME_CITY AS MAILING_CITY
          , UTM.MEMBER_HOME_STATE AS MAILING_STATE
          , UTM.MEMBER_HOME_ZIP_C AS MAILING_ZIP
          , UTM.MEMBER_HOME_PHONE AS HOME_PHONE
          , UTM.MEMBER_BUS_PHONE AS ADDITIONAL_PHONE
          , UTM.MEMBER_HOME_PHONE AS CELL_PHONE
          , ISNULL(NULL, 'TEST LANGUAGE') AS LANGUAGE
          , ISNULL(NULL, 'Test ETHNICITY') AS Ethnicity
          , UTM.MEDICARE_ID
          , UTM.MEMBER_ORG_EFF_DATE
          , UTM.MEMBER_CONT_EFF_DATE
          , UTM.MEMBER_CUR_EFF_DATE
          , UTM.MEMBER_CUR_TERM_DATE
          , REPLACE(RTRIM(UTM.RESP_FIRST_NAME), ',', ' ') AS RESP_FIRST_NAME
          , REPLACE(RTRIM(UTM.RESP_LAST_NAME), ',', ' ') AS RESP_LAST_NAME
		, 'Responsible Party' AS RESP_RELATIONSHIP						  -- PlaceHolder for future data
          , REPLACE(RTRIM(UTM.RESP_ADDRESS), ',', ' ') AS RESP_ADDRESS
          , REPLACE(RTRIM(UTM.RESP_ADDRESS2), ',', ' ') AS RESP_ADDRESS2
          , UTM.RESP_CITY
          , UTM.RESP_STATE
          , UTM.RESP_ZIP
          , UTM.RESP_PHONE
          , UPPER(REPLACE(RTRIM(UTM.PRIMARY_RISK_FACTOR), ',', ' ')) AS PRIMARY_RISK_FACTOR
          , UTM.COUNT_OPEN_CARE_OPPS
          , UTM.INP_ADMITS_LAST_12_MOS
          , UTM.LAST_INP_DISCHARGE
          , UTM.POST_DISCHARGE_FUP_VISIT
          , UTM.INP_FUP_WITHIN_7_DAYS				 
          , UTM.ER_VISITS_LAST_12_MOS				 --UAM.ER_VISITS_LAST_12_MOS
          , UTM.LAST_ER_VISIT						 
          , UTM.POST_ER_FUP_VISIT					 
          , UTM.ER_FUP_WITHIN_7_DAYS				 --UAM.ER_FUP_WITHIN_7_DAYS
          , UTM.LAST_PCP_VISIT
          , REPLACE(RTRIM(UTM.LAST_PCP_PRACTICE_SEEN), ',', ' ') AS LAST_PCP_PRACTICE_SEEN
          , UTM.LAST_BH_VISIT
          , REPLACE(RTRIM(UTM.LAST_BH_PRACTICE_SEEN), ',', ' ') AS LAST_BH_PRACTICE_SEEN
          , REPLACE(RTRIM(UTM.TOTAL_COSTS_LAST_12_MOS), ',', '') AS TOTAL_COSTS_LAST_12_MOS
          , REPLACE(RTRIM(UTM.INP_COSTS_LAST_12_MOS), ',', '') AS INP_COSTS_LAST_12_MOS
          , REPLACE(RTRIM(UTM.ER_COSTS_LAST_12_MOS), ',', '') AS ER_COSTS_LAST_12_MOS
          , REPLACE(RTRIM(UTM.OUTP_COSTS_LAST_12_MOS), ',', '') AS OUTP_COSTS_LAST_12_MOS
          , REPLACE(RTRIM(UTM.PHARMACY_COSTS_LAST_12_MOS), ',', '') AS PHARMACY_COSTS_LAST_12_MOS
          , REPLACE(RTRIM(UTM.PRIMARY_CARE_COSTS_LAST_12_MOS), ',', '') AS PRIMARY_CARE_COSTS_LAST_12_MOS
          , REPLACE(RTRIM(UTM.BEHAVIORAL_COSTS_LAST_12_MOS), ',', '') AS BEHAVIORAL_COSTS_LAST_12_MOS
          , REPLACE(RTRIM(UTM.OTHER_OFFICE_COSTS_LAST_12_MOS), ',', '') AS OTHER_OFFICE_COSTS_LAST_12_MOS
          , '12/12/2099' AS NEXT_PREVENTATIVE_VISIT_DUE
		, RTRIM(LTRIM(UTM.MEMBER_EMAIL)) AS EMAIL
		,ISNULL(NULL, 'TEST RACE') AS RACE
		, '' ACE_ID
		, '' Carrier_member_id
     FROM dbo.vw_UHC_TermedMembers AS UTM;
	


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[43] 4[21] 2[18] 3) )"
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
         Top = -384
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
      Begin ColumnWidths = 51
         Width = 284
         Width = 1500
         Width = 1395
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 765
         Width = 2715
         Width = 1530
         Width = 1500
         Width = 1905
         Width = 3210
         Width = 2235
         Width = 7140
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
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2535
         Alias = 3360
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_AH_Membership';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_AH_Membership';

