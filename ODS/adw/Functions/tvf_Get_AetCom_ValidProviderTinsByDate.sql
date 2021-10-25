
CREATE FUNCTION [adw].[tvf_Get_AetCom_ValidProviderTinsByDate]
    (
    @EffectiveDate DATE)
RETURNS TABLE
AS RETURN
(   
    SELECT pr.NPI, pr.[TAX ID] AS TIN, pr.effective_date__C AS EffectiveDate, pr.TERM_date__C AS TermDate, pr.LOB
    From dbo.vw_Aetna_ProviderRoster AS pr
    WHERE lob IN('Commercial')
         AND term_date__C IS NULL
	   AND pr.effective_date__C <= @EffectiveDate
	   
)
