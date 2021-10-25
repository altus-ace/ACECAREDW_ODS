

CREATE PROCEDURE [dbo].[Sp_vw_UHC_ProviderRoster_Tax_Id] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
DECLARE @TMP VARCHAR(max)
SET @TMP =' '
select @TMP = @TMP + ID + ', ' from (SELECT DISTINCT [TAX ID] AS ID FROM [vw_UHC_ProviderRoster])AS A

SELECT Rtrim(@TMP) AS TAX_ID


END




