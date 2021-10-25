CREATE VIEW [dbo].[zz_vw_AH_ProviderAddress_old_01]
AS
     SELECT DISTINCT
            dbo.tmpSalesforce_Contact.Provider_NPI__c AS PROVIDER_ID,
            'UHC' AS CLIENT_ID,
            UPPER(dbo.tmpSalesforce_Location__c.Address_Type__c) AS [ADDRESS TYPE],
            UPPER(REPLACE(dbo.tmpSalesforce_Location__c.Address_1__c, ',', ' ')) AS [ADDRESS 1],
            UPPER(REPLACE(dbo.tmpSalesforce_Location__c.Address_2__c, ',', ' ')) AS [ADDRESS 2],
            UPPER(REPLACE(' ', ',', ' ')) AS [ADDRESS 3],
            UPPER(dbo.tmpSalesforce_Location__c.City__c) AS CITY,
            dbo.tmpSalesforce_Location__c.State__c AS [STATE],
            UPPER(REPLACE(dbo.tmpSalesforce_Location__c.County__c, 'COUNTY', '')) AS COUNTY,
            dbo.tmpSalesforce_Zip_Code__c.NAME AS ZIPCODE,
            dbo.tmpSalesforce_Location__c.Phone__c AS TELEPHONE,
            dbo.tmpSalesforce_Location__c.Fax__c AS FAX,
            dbo.tmpSalesforce_Location__c.Location_Email_Address__c AS [EMAIL ADDRESS],
            ' ' AS [EFFECTIVE DATE],
            ' ' AS [TERM DATE],
            CASE
                WHEN tap2.Patient_Type__c IS NOT NULL
                THEN 'Y'
                ELSE ' '
            END AS [ACCEPTING NEW PATIENTS Y/N?],
            'A' AS ADDRESS_ADDITIONAL_INFORMATION_2,
            CAST(STUFF(
(
    SELECT ';'+tm.Day_of_the_Week__c+' '+tm.Start_Hours__c+' - '+tm.End_Hours__c
    FROM dbo.tmpsalesforce_practice_hours__c tm
    WHERE tm.Location_Name__c = tm3.Location_Name__c FOR XML PATH('')
), 1, 1, '') AS VARCHAR(100)) AS 'OFFICE HOURS',
            tmpsalesforce_Zip_code__c.Quadrant__C AS POD,
            UPPER(dbo.tmpsalesforce_location__c.Patient_Gender_Limitation__c) AS AGE_SEEN,
            'TEST' AS 'WALK_IN',
            UPPER(dbo.tmpsalesforce_location__C.Location_Note__c) AS NOTE
     FROM dbo.tmpSalesforce_Contact
          LEFT JOIN dbo.tmpSalesforce_Location__c ON dbo.tmpSalesforce_Contact.Id = dbo.tmpSalesforce_Location__c.Provider_Name__c
          LEFT JOIN dbo.tmpSalesforce_Zip_Code__c ON dbo.tmpSalesforce_Zip_Code__c.Id = dbo.tmpSalesforce_Location__c.ZipCode_New__c
          LEFT JOIN dbo.tmpSalesforce_Account ON dbo.tmpSalesforce_Account.Id = dbo.tmpSalesforce_Contact.AccountId
          LEFT JOIN dbo.tmpSalesforce_Accepting_Patient_Type__c AS tap2 ON dbo.tmpSalesforce_Location__c.Id = tap2.Location_Name__c
          LEFT JOIN dbo.tmpsalesforce_practice_hours__c tm3 ON dbo.tmpSalesforce_Location__c.id = tm3.Location_Name__c
     WHERE(dbo.tmpSalesforce_Contact.Provider_NPI__c <> ' ') 

/*AND (dbo.tmpSalesforce_Location__c.Address_Type__c IS NOT NULL) */

          AND tmpsalesforce_Contact.Type__c IN('PCP', 'PA', 'NP', 'FNP', 'Allied Health', 'DDS', 'LPC', 'UHC PCP', 'SPECIALIST', 'Mid Level')
          AND (dbo.tmpSalesforce_Contact.Status__c in ('ACTIVE'))
          AND (dbo.tmpSalesforce_Account.In_network__c = '1')
          AND (dbo.tmpSalesforce_Contact.FirstName NOT LIKE '%TEST%')
          AND tmpsalesforce_Contact.Provider_NPI__c IS NOT NULL;

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[42] 4[20] 2[11] 3) )"
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
         Top = -576
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
      Begin ColumnWidths = 22
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'zz_vw_AH_ProviderAddress_old_01';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'zz_vw_AH_ProviderAddress_old_01';

