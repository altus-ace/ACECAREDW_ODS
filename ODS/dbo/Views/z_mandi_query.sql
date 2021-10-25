CREATE view dbo.z_mandi_query as (
	SELECT *
	FROM [adw].[fctProviderRoster]
	WHERE getdate() BETWEEN RowEffectiveDate AND RowExpirationDate
	AND ClientKey = 1
	AND IsActive = 1
--AND NPI = '1003273731'
)
