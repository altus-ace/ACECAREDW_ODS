CREATE VIEW dbo.[vw_List_ACEAccountPods]
AS

SELECT DISTINCT TMPSALESFORCE_ACCOUNT.NAME as AccountName
,TMPSALESFORCE_ACCOUNT.TAX_ID_NUMBER__C as AccountTIN
,tmpSalesforce_Account.In_network__c as InNetwork
,TMPSALESFORCE_ACCOUNT.type__c AS AccountType
,Stuff(( Select ','+ QUADRANT__C from (SELECT DISTINCT TMPSALESFORCE_ACCOUNT.TAX_ID_NUMBER__C
											,tmpSalesforce_Zip_Code__c.Name
											,tmpSalesforce_Zip_Code__c.Quadrant__c
												FROM tmpsalesforce_Account 
												LEFT OUTER JOIN
												tmpSalesforce_Account_Locations__c ON
												tmpSalesforce_Account.ID=tmpSalesforce_Account_Locations__c.Account_Name__c
												LEFT OUTER JOIN 
												tmpSalesforce_Zip_Code__c ON
												tmpSalesforce_Zip_Code__c.id=TMPSALESFORCE_ACCOUNT_LOCATIONS__C.Zip_Code__c AND tmpSalesforce_Zip_Code__c.Name <>' ') AS TEMPTABLE 
												WHERE TEMPTABLE.Tax_ID_Number__c=TB2.Tax_ID_Number__c
												For XML Path('')),1,1,'')  As Pod
FROM tmpsalesforce_Account						
LEFT OUTER JOIN
	tmpSalesforce_Account_Locations__c ON
	tmpSalesforce_Account.Id=tmpSalesforce_Account_Locations__c.Account_Name__c
LEFT OUTER JOIN
	(SELECT DISTINCT TMPSALESFORCE_ACCOUNT.TAX_ID_NUMBER__C
	,tmpSalesforce_Zip_Code__c.Name
	,tmpSalesforce_Zip_Code__c.Quadrant__c
	FROM tmpsalesforce_Account 
LEFT OUTER JOIN
	tmpSalesforce_Account_Locations__c ON
	tmpSalesforce_Account.ID=tmpSalesforce_Account_Locations__c.Account_Name__c
LEFT OUTER JOIN  
	tmpSalesforce_Zip_Code__c ON
	tmpSalesforce_Zip_Code__c.id=TMPSALESFORCE_ACCOUNT_LOCATIONS__C.Zip_Code__c AND tmpSalesforce_Zip_Code__c.Name <>' ') AS TB2 ON
	TB2.TAX_ID_NUMBER__C=TMPSALESFORCE_aCCOUNT.TAX_ID_NUMBER__C
--LEFT OUTER JOIN 
	--tmpSalesforce_Contact ON 
	--tmpSalesforce_Contact.Id = tmpSalesforce_Account.ID
	--AND TMPSALESFORCE_CONTACT.Type__c IN( 'PCP','NP','PA') 
	WHERE TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c IS NOT NULL and tmpsalesforce_account.Type__c not in ('specialist','ancillary')
	


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
      Begin ColumnWidths = 9
         Width = 284
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_List_ACEAccountPods';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_List_ACEAccountPods';

