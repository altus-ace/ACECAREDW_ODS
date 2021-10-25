/*
IF OBJECT_ID (N'adw.tvf_GetValidProviderTinsByDate') IS NOT NULL
    DROP FUNCTION adw.tvf_GetValidProviderTinsByDate
GO
*/
CREATE FUNCTION [adw].[tvf_GetValidProviderTinsByDate]
    (
    @EffectiveDate DATE)
RETURNS TABLE
AS RETURN
(
   --sELECT '' NPI, ''TIN, getdate() Effectivedate
    SELECT pr.NPI, pr.[TAX ID] AS TIN, pr.effective_date__C AS EffectiveDate, pr.TERM_date__C AS TermDate, pr.LOB
    From dbo.vw_Aetna_ProviderRoster AS pr
    WHERE pr.effective_date__C <= @EffectiveDate
	   
)
