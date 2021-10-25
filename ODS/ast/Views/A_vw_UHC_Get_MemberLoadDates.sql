
CREATE VIEW [ast].[A_vw_UHC_Get_MemberLoadDates]
AS
WITH cteLoadKeys(
     LOAD_KEY
   , LOAD_DATE
   , LoadType)
   AS (
     SELECT
            ROW_NUMBER() OVER(ORDER BY m.A_LAST_UPDATE_DATE ASC) Load_Key
          , m.A_LAST_UPDATE_DATE LoadDate
		, m.LoadType
     FROM dbo.UHC_MembersByPCP m
     GROUP BY
              m.A_LAST_UPDATE_DATE, m.loadType)    
SELECT *
FROM cteLoadKeys
