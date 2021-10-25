CREATE VIEW dbo.vw_QLK_PcpPrimaryLocations
AS
SELECT DISTINCT 
                         tmpsalesforce_account.Tax_ID_Number__c AS 'TAX ID', TMPSALESFORCE_CONTACT.PROVIDER_NPI__C AS 'NPI', TMPSALESFORCE_CONTACT.LASTNAME AS 'LAST NAME', 
                         TMPSALESFORCE_CONTACT.FIRSTNAME AS 'FIRST NAME', TMPSALESFORCE_CONTACT.TYPE__C AS 'PROVIDER TYPE', TMPSALESFORCE_ACCOUNT.NAME AS 'GROUP NAME', CAST(Stuff
                             ((SELECT        ',' + Speciality_Name_CAQH__c
                                 FROM            tmpSalesforce_Provider_Specialties__c tsl
                                 WHERE        tsl.Provider_Name__c = ts2.Provider_Name__c FOR XML Path('')), 1, 1, '') AS VARCHAR(100)) AS [SPECIALTY], CAST(Stuff
                             ((SELECT        ',' + Language_Name__c
                                 FROM            tmpSalesforce_Provider_Language_Spoken__c pl
                                 WHERE        pl.Provider_Name__c = pl2.Provider_Name__c FOR XML Path('')), 1, 1, '') AS VARCHAR(100)) AS [LANGUAGESSPOKEN], tm2.Patient_Gender_Limitation__c AS 'Age Seen', 
                         tm2.Location_Note__c AS 'Note', Rtrim(tm2.Address_1__c) + ',' + Rtrim(tm2.Address_2__c) AS 'ADDRESS', tm2.City__c AS 'City', tm2.state__c AS 'State', tmpSalesforce_Zip_Code__c.NAME AS 'ZIPCODE', 
                         tmpsalesforce_zip_code__c.Quadrant__c AS 'POD', tm2.Phone__c AS 'PCP primary location Phone', tm2.Phone2__c AS 'PCP Alternate Phone', 
                         tmpsalesforce_account.network_contact__c AS 'ACE NETWORK CONTACT', CAST(Stuff
                             ((SELECT        ',' + Day_of_the_Week__c + Start_Hours__c + End_Hours__c
                                 FROM            TMPSALESFORCE_PRACTICE_HOURS__C tm
                                 WHERE        tm.Location_Name__c = tm3.Location_Name__c FOR XML Path('')), 1, 1, '') AS VARCHAR(100)) AS 'OFFICE HOURS', CAST(Stuff
                             ((SELECT        ',' + Patient_Type__c
                                 FROM            tmpSalesforce_Accepting_Patient_Type__c AP2
                                 WHERE        AP2.Location_Name__c = APT.Location_Name__c FOR XML Path('')), 1, 1, '') AS VARCHAR(100)) AS 'ACCEPTING PATIENTS', 
                         tm2.Patient_Appointment_Phone__c AS 'PATIENT APPOINTMENT PHONE'
						 ,case when tmpSalesforce_Account.Termination_with_cause__c is null then ' ' else tmpSalesforce_Account.Termination_with_cause__c end AS 'PROVIDER STATUS'
FROM            TMPSALESFORCE_CONTACT LEFT JOIN
                         tmpSalesforce_Provider_Degree__c TD2 ON TD2.CONTACT__C = TMPSALESFORCE_CONTACT.ID LEFT JOIN
                         tmpSalesforce_Account ON TMPSALESFORCE_CONTACT.ACCOUNTID = tmpSalesforce_Account.ID AND tmpSalesforce_Account.IN_NETWORK__c = 1 LEFT JOIN
                         TMPSALESFORCE_LOCATION__C tm2 ON TMPSALESFORCE_CONTACT.ID = tm2.Provider_Name__c AND tm2.address_type__c = 'PRIMARY' LEFT JOIN
                         tmpSalesforce_Zip_Code__c ON tm2.ZipCode_New__c = tmpSalesforce_Zip_Code__c.ID LEFT JOIN
                         tmpSalesforce_Provider_Specialties__c ts2 ON tmpSalesforce_contact.id = ts2.Provider_Name__c AND ts2.Specialtiy_Type__c = 'Primary' LEFT JOIN
                         tmpSalesforce_Provider_Language_Spoken__c pl2 ON tmpSalesforce_contact.id = pl2.Provider_Name__c LEFT JOIN
                         TMPSALESFORCE_PRACTICE_HOURS__C tm3 ON tm2.id = tm3.Location_Name__c LEFT JOIN
                         tmpSalesforce_Accepting_Patient_Type__c APT ON APT.Location_Name__c = TM2.Id
WHERE       (dbo.tmpSalesforce_Contact.Type__c IN ('pcp')) AND (dbo.tmpSalesforce_Contact.LastName NOT IN ('ACETEST', 'TEST', 'TESTLAST')) AND 
                         (dbo.tmpSalesforce_Account.In_network__c = '1')

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
      Begin ColumnWidths = 19
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
         Width = 4560
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_QLK_PcpPrimaryLocations';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_QLK_PcpPrimaryLocations';

