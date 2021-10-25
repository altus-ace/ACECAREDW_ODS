
CREATE VIEW [adw].[vw_SSRS_ProviderGap]
as
    select * from [dbo].vw_SSRS_ProviderGap_UHC
    UNION
    select * from ACDW_CLMS_SHCN_MSSP.[adw].[vw_SSRS_ProviderGap]
