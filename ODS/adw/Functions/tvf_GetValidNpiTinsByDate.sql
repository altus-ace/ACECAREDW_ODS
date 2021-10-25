CREATE FUNCTION adw.tvf_GetValidNpiTinsByDate(@EffectiveDate DATE)
RETURNS TABLE
AS RETURN
(
    SELECT NPI, [TAX ID] AS TIN, effective_date__C AS Effective_Date
    From dbo.vw_Aetna_ProviderRoster
    WHERE effective_date__C <= @EffectiveDate
)
