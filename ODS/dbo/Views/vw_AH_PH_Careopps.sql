

/****** Script for SelectTopNRows command from SSMS  ******/

CREATE view [dbo].[vw_AH_PH_Careopps]
As
SELECT Distinct [CLIENT_ID]
      ,CONVERT(nvarchar(50),[MEMBER_ID]) AS MEMBER_ID
      ,[OPPURTUNITY]
      ,[MEASURE_CODE]
      ,[MEASURE_CATEGORY]
      ,[STATUS]
      ,[DATE_IDENTIFIED]
      ,[MEASURE_VERSION]
  FROM [ACECAREDW].[dbo].[vw_AH_PH_AET_careopps]
  union
  SELECT distinct [Client_id]
      ,convert(nvarchar(50),[MEMBER_ID]) as MEMBER_ID
      ,[OPPURTUNITY]
      ,[MEASURE_CODE]
      ,[MEASURE_CATEGORY]
      ,[STATUS]
      ,[DATE_IDENTIFIED]
      ,[MEASURE_VERSION]
  FROM [ACECAREDW].[dbo].[vw_AH_PH_WLC_careopps]
  union
    SELECT distinct [Client_id]
      ,convert(nvarchar(50),[MEMBER_ID]) as MEMBER_ID
      ,[OPPURTUNITY]
      ,[MEASURE_CODE]
      ,[MEASURE_CATEGORY]
      ,[STATUS]
      ,[DATE_IDENTIFIED]
      ,[MEASURE_VERSION]
  FROM [ACECAREDW].[dbo].[vw_AH_PH_UHC_careopps]

