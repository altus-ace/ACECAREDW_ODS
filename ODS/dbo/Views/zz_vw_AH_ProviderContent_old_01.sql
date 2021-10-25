
CREATE VIEW [dbo].[zz_vw_AH_ProviderContent_old_01]
AS
SELECT DISTINCT 
                         tmpSalesforce_Contact.Provider_NPI__c AS [PROVIDER_ID], 'UHC' AS CLIENT_ID,tmpSalesforce_Contact.Provider_NPI__c AS [PROVIDER_NPI], UPPER(FirstName) + ' ' + UPPER(LastName) AS [PROVIDER_FULLNAME], 
                         tmpSalesforce_Contact.ACE_Provider_ID1__c + tmpSalesforce_Contact.ACE_Provider_ID2__c AS [ACE_PROVIDER_ID], tmpSalesforce_Contact.Type__c AS [PROVIDERTYPE], 
                         tmpSalesforce_Account.ACE_Acct_ID1__c + tmpSalesforce_Account.ACE_Acct_ID2__c AS [GROUP ID], REPLACE(UPPER(tmpSalesforce_Account.Name), ',', ' ') AS [AFFILIATED_GROUP_NAME], UPPER(FirstName) 
                         AS [FIRSTNAME], UPPER(Middle_Initial__c) AS [MIDDLENAME], UPPER(LastName) AS [LASTNAME], UPPER(CAST(Stuff
                             ((SELECT        ';' + Speciality_Name_CAQH__c
                                 FROM            tmpSalesforce_Provider_Specialties__c tsl
                                 WHERE        tsl.Provider_Name__c = ts2.Provider_Name__c FOR XML Path('')), 1, 1, '') AS VARCHAR(100))) AS [SPECIALTY], UPPER(CAST(Stuff
                             ((SELECT        ';' + Degree_Name__c
                                 FROM            tmpSalesforce_Provider_Degree__c td
                                 WHERE        td.Contact__c = td2.Contact__c FOR XML Path('')), 1, 1, '') AS VARCHAR(100))) AS DEGREE, UPPER(Provider_Ethnicity__c) AS [ETHNICITY], UPPER(CAST(Stuff
                             ((SELECT        ';' + Language_Name__c
                                 FROM            tmpSalesforce_Provider_Language_Spoken__c pl
                                 WHERE        pl.Provider_Name__c = pl2.Provider_Name__c FOR XML Path('')), 1, 1, '') AS VARCHAR(100))) AS [LANGUAGESSPOKEN], Date_of_Birth__c AS [PROVIDER_DATE_OF_BIRTH], 
                         Gender__c AS [PROVIDER_GENDER], TMPSALESFORCE_ACCOUNT.NETWORK_CONTACT__c AS ACE_NETWORK_CONTACT
FROM            tmpSalesforce_Contact LEFT OUTER JOIN
                         tmpSalesforce_Provider_Medical_License__c tm2 ON tmpSalesforce_contact.id = tm2.Provider_Name__c LEFT OUTER JOIN
                         tmpSalesforce_Account ON tmpSalesforce_Contact.AccountId = tmpSalesforce_Account.Id LEFT OUTER JOIN
                         tmpSalesforce_Provider_Degree__c td2 ON tmpSalesforce_contact.id = td2.Contact__c AND td2.Degree_Name__c <> '(OTHER)' AND td2.Degree_Name__c <> ' ' LEFT OUTER JOIN
                         tmpSalesforce_Provider_Specialties__c ts2 ON tmpSalesforce_contact.id = ts2.Provider_Name__c LEFT OUTER JOIN
                         tmpSalesforce_Provider_Language_Spoken__c pl2 ON tmpSalesforce_contact.id = pl2.Provider_Name__c LEFT OUTER JOIN
                         tmpSalesforce_Provider_DEA_License__c tdl2 ON tmpSalesforce_contact.id = tdl2.Provider_Name__c LEFT OUTER JOIN
                         tmpSalesforce_Provider_Hospital_Privilege__c thp2 ON tmpSalesforce_Contact.id = thp2.Provider_Name__c
WHERE        tmpsalesforce_Contact.Type__c IN ('PCP', 'PA', 'NP', 'FNP', 'Allied Health', 'DDS', 'LPC', 'UHC PCP', 'SPECIALIST','Mid Level') AND (dbo.tmpSalesforce_Account.In_network__c = '1') AND 
                         tmpSalesforce_Contact.FIRSTNAME NOT LIKE '%TEST%' AND tmpSalesforce_contact.Provider_NPI__C IS NOT NULL


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
      Begin ColumnWidths = 23
         Width = 284
         Width = 1500
         Width = 1500
         Width = 2805
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'zz_vw_AH_ProviderContent_old_01';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'zz_vw_AH_ProviderContent_old_01';

