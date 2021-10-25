


CREATE view
[dbo].[vw_current_UHC_CareOpps_old_01]
as



select a.MemberID,a.update_month ,
	   update_Year
		, max(a.[NameFirst]) as NameFirst
		,max([NameLast]) as  NameLast
        ,max([DOB]) as DOB
	    ,max([TIN_Num]) as TIN_Num
	    ,MAX([TIN_NAME]) AS TIN_NAME
	    ,max([ProviderID])as ProviderID
	    ,max([Provider_NPI]) as Provider_NPI
		,max([Prov_Last_Name]) as Prov_Last_Name
        ,max([Prov_First_Name]) as Prov_First_Name
		,max(ACE_MEMBER) as ACE_MEMBER
		,max(a.[AWC(Default)]) as 'AWC(Default)'
		, max(a.[CDC1 HbA1c<8%]) as 'CDC1 HbA1c<8%'
		, max(a.[PPC Postpartum Care]) as 'PPC Postpartum Care'
		, max(a.[PPC Prenatal Care]) as'PPC Prenatal Care'
		, max(a.[WC3456(Default)]) as'WC3456(Default)'
		, max(a.[BCS(Default)]) as 'BCS(Default)'
		, max(a.[CCS2(Default)]) as 'CCS2(Default)'
		, max(a.[FUH 7-Day Follow-Up]) as 'FUH 7-Day Follow-Up'
		,max(a.[WC015(6orMoreVisits)]) as 'WC015(6orMoreVisits)'
		
from (
SELECT distinct 
      [MemberID]
	  ,[NameFirst]
      ,[NameLast]
      ,[DOB]
	  ,[TIN_Num]
	  ,[TIN_NAME]
	  ,[ProviderID]
	  ,[Provider_NPI]
	  ,[Prov_Last_Name]
      ,[Prov_First_Name] 
	  ,case when Measure_Desc = 'Adolescent Well Care Visits' and Sub_Meas = '(Default)' then 1
			when Measure_Desc = 'Adolescent Well Care Visits' and not Sub_Meas = '(Default)' then 999
			else 0 end as 'AWC(Default)'
      ,case when Measure_Desc = 'Comprehensive Diabetes Care (Commercial/Medicaid)' and Sub_Meas = 'HbA1c Poor Control' then 1 
			when Measure_Desc = 'Comprehensive Diabetes Care (Commercial/Medicaid)' and not Sub_Meas = 'HbA1c Poor Control' then 999
			else 0 end as 'CDC1 HbA1c<8%'

      ,case when Measure_Desc = 'Prenatal and Postpartum Care' and Sub_Meas = 'Postpartum Care' then 1
			when Measure_Desc = 'Prenatal and Postpartum Care' and not (Sub_Meas = 'Postpartum Care' or Sub_Meas = 'Prenatal Care') then 999
			else 0 end as 'PPC Postpartum Care'
			
      ,case when Measure_Desc = 'Prenatal and Postpartum Care' and Sub_Meas = 'Prenatal Care' then 1
			when Measure_Desc = 'Prenatal and Postpartum Care' and not (Sub_Meas = 'Postpartum Care' or Sub_Meas = 'Prenatal Care')  then 999
			else 0 end as 'PPC Prenatal Care'

      ,case when Measure_Desc = 'Well Child Visits in the Third, Fourth, Fifth and Sixth Year of Life' and Sub_Meas = '(Default)' then 1 
			when Measure_Desc = 'Well Child Visits in the Third, Fourth, Fifth and Sixth Year of Life' and not Sub_Meas = '(Default)' then 999
			else 0 end as 'WC3456(Default)'
	  ,case when Measure_Desc = 'Breast Cancer Screening' and Sub_Meas = '(Default)' then 1 
			when Measure_Desc = 'Breast Cancer Screening' and not Sub_Meas = '(Default)' then 999
			else 0 end as 'BCS(Default)'
      ,case when Measure_Desc = 'Cervical Cancer Screening (Medicaid/Marketplace)' and Sub_Meas = '(Default)' then 1
			when Measure_Desc = 'Cervical Cancer Screening (Medicaid/Marketplace)' and not Sub_Meas = '(Default)' then 999
			else 0 end as 'CCS2(Default)'
      ,case when Measure_Desc = 'Follow-Up After Hospitalization for Mental Illness' and Sub_Meas = '7-Day Follow-Up' then 1 
			when Measure_Desc = 'Follow-Up After Hospitalization for Mental Illness' and not Sub_Meas = '7-Day Follow-Up' then 999
			else 0 end as 'FUH 7-Day Follow-Up'
     ,case when Measure_Desc = 'Well Child Visits in the First 15 Months of Life' and Sub_Meas = '6 or More Visits' then 1 
			when Measure_Desc = 'Well Child Visits in the First 15 Months of Life' and not Sub_Meas = '6 or More Visits' then 999
			else 0 end as 'WC015(6orMoreVisits)'
	  ,[A_LAST_UPDATE_FLAG]
	  ,month([A_LAST_UPDATE_DATE]) as update_month
	  ,year([A_LAST_UPDATE_DATE]) as update_Year
	  ,[A_LAST_UPDATE_DATE]
	  ,case when b.Member_id is null then 'NO' else 'YES' end as ACE_MEMBER
  FROM [ACECAREDW].[dbo].[UHC_CareOpps] a
  left join [ACECAREDW].[dbo].[vw_UHC_ActiveMembers] b on a.memberID = b.Member_id
  --WHERE a.A_LAST_UPDATE_FLAG = 'N'
  ) a
  group by a.MemberID,a.update_month,a.update_year
  




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
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 250
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_current_UHC_CareOpps_old_01';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_current_UHC_CareOpps_old_01';

