


CREATE VIEW [dbo].[vw_RP_Provider_Practice_Email_Fax_Phone]
AS
    
     SELECT DISTINCT
            UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c, ' ')) AS 'TAX ID',
            UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.NAME, ' ')) AS 'PRACTICE_NAME',
            UPPER(ISNULL(tmpSalesforce_Account_Locations__c.PHONE__C, ' ')) AS 'PRACTICE_PHONE',
            UPPER(ISNULL(tmpSalesforce_Account_Locations__c.Fax__c, ' ')) AS 'PRACTICE_FAX',
            UPPER(ISNULL(tmpSalesforce_Account_Locations__c.Location_Email__c, ' ')) AS 'PRACTICE_EMAIL',
            UPPER(ISNULL(TMPSALESFORCE_CONTACT.PROVIDER_NPI__C, ' ')) AS 'PROVIDER_NPI',
            UPPER(ISNULL(TMPSALESFORCE_CONTACT.LASTNAME, ' ')) AS 'LAST_NAME',
            UPPER(ISNULL(TMPSALESFORCE_CONTACT.FIRSTNAME, ' ')) AS 'FIRST_NAME',
            UPPER(ISNULL(TMPSALESFORCE_CONTACT.PHONE, ' ')) AS 'PROVIDER_PHONE',
            UPPER(ISNULL(TMPSALESFORCE_CONTACT.FAX, ' ')) AS 'PROVIDER_FAX',
            UPPER(ISNULL(TMPSALESFORCE_CONTACT.MobilePhone, ' ')) AS 'PROVIDER_MOBILE',
            UPPER(ISNULL(TMPSALESFORCE_CONTACT.Email, ' ')) AS 'PROVIDER_EMAIL',
            UPPER(ISNULL(tmpSalesforce_Additional_Contact__c.Title__c, ' ')) AS 'TITLE',
            UPPER(ISNULL(tmpSalesforce_Additional_Contact__c.Name, ' ')) AS 'OFFICE_MANAGER_NAME',
            UPPER(ISNULL(tmpSalesforce_Additional_Contact__c.Phone_Number__C, ' ')) AS 'OFFICE_MANAGER_PHONE_NUMBER',
            UPPER(ISNULL(tmpSalesforce_Additional_Contact__c.EMAIL__c, ' ')) AS 'OFFICE_MANAGER_EMAIL',
            UPPER(ISNULL(tmpSalesforce_Additional_Contact__c.FAX__C, ' ')) AS 'OFFICE_MANAGER_FAX',
		  UPPER(ISNULL(tmpSalesforce_Zip_Code__c.[Quadrant__c],'')) as 'PRIMARY_LOCATION_OFFICE_POD',
		   UPPER(ISNULL(tmpSalesforce_Account_Locations__c.County__C, ' ')) AS 'PRACTICE_COUNTY',
		  UPPER(ISNULL(tC.[Health_Plans__c],'')) as 'CONTRACTED_LOB'
     FROM tmpSalesforce_Account
          LEFT JOIN TMPSALESFORCE_CONTACT ON TMPSALESFORCE_CONTACT.ACCOUNTID = tmpSalesforce_Account.ID
		INNER join tmpSalesforce_Contract_Information__c tc on tc.[Account_Name__c]=tmpSalesforce_Account.id
          LEFT JOIN tmpSalesforce_Additional_Contact__c ON tmpSalesforce_Additional_Contact__c.Account_Name__c = tmpSalesforce_Account.ID    
								 AND tmpSalesforce_Additional_Contact__c.Title__c LIKE 'OFFICE%'
          INNER JOIN tmpSalesforce_Account_Locations__c ON tmpSalesforce_Account_Locations__c.Account_Name__c = tmpSalesforce_Account.ID
                                                           AND tmpSalesforce_Account_Locations__c.Location_Type__c = 'PRIMARY'
	    INNER join tmpSalesforce_Zip_Code__c on tmpSalesforce_Zip_Code__c.ID=tmpSalesforce_Account_Locations__c.[Zip_Code__c]
     WHERE tmpSalesforce_Contact.Status__c = 'ACTIVE'
           AND LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST')
          AND tmpSalesforce_Contact.Type__C IN('PCP')
     AND tmpsalesforce_Account.in_Network__c = '1'




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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_RP_Provider_Practice_Email_Fax_Phone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_RP_Provider_Practice_Email_Fax_Phone';

