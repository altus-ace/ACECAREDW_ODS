/****** Script for SelectTopNRows command from SSMS  ******/
CREATE view vw_Quality_DS
as
SELECT [URN]
      ,[Context]
      ,[TIN_Num]
      ,[TIN_Name]
	  ,b.PCP_PRACTICE_TIN
	  ,c.[PRACTICE NAME]
	  ,b.PCP_NPI
	  ,d.[PROVIDER TYPE]
      ,d.[LAST NAME]
      ,d.[FIRST NAME]
      ,[Measure_Desc]
      ,[Sub_Meas]
      ,concat([Measure_Desc],': ',[Sub_Meas]) as FULL_QM_NAME
	  ,[ProviderID]
      ,[MemberID]
      ,[UniversalMemberId]
      ,[MedicaidID]
      ,[DOB]
      ,[Gender]
      ,[Age]
      ,[NameFirst]
      ,[NameLast]
      ,[Member_Address_1]
      ,[Member_Address_2]
      ,[Member_City]
      ,[Member_State]
      ,[Member_ZipCode]
      ,[Member_Phone]
      ,[Provider_NPI]
      ,[Prov_Last_Name]
      ,[Prov_First_Name]
      ,[Provider_Address_1]
      ,[Provider_Address_2]
      ,[Provider_City]
      ,[Provider_State]
      ,[Provider_ZipCode]
      ,[Provider_Phone]
      ,[Provider_County]
      ,[Through_Date]
      ,[TINMaxVisit]
      ,[A_LAST_UPDATE_DATE]
      ,[A_LAST_UPDATE_BY]
      ,[A_LAST_UPDATE_FLAG]
  FROM [ACECAREDW].[dbo].[UHC_CareOpps] a 
  join acecaredw_dev.dbo.M_MEMBER_ENR b on a.MemberID = b.SUBSCRIBER_ID and month(a.[A_LAST_UPDATE_DATE]) = b.mbr_mth and year(a.[A_LAST_UPDATE_DATE]) = b.mbr_year
  left join (SELECT distinct cast([TAX ID] as int) as [TAX ID]
      ,[PRACTICE NAME]
    
  FROM [ACECAREDW].[dbo].[vw_NetworkRoster]) c on b.PCP_PRACTICE_TIN = c.[TAX ID]
	  

  left join 
  (
  SELECT distinct  cast([NPI] as int) as NPI
      ,[PROVIDER TYPE]
      ,[LAST NAME]
      ,[FIRST NAME]
     
  FROM [ACECAREDW].[dbo].[vw_NetworkRoster]) d on b.PCP_NPI = d.NPI
 -- where cast(a.TIN_Num as int) <> cast(b.PCP_PRACTICE_TIN as int)

