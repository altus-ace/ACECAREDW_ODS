CREATE TABLE [adw].[fctProviderRoster] (
    [fctProviderRosterSkey]  INT           IDENTITY (1, 1) NOT NULL,
    [SourceJobName]          VARCHAR (50)  NOT NULL,
    [LoadDate]               DATE          NOT NULL,
    [DataDate]               DATE          NOT NULL,
    [CreatedDate]            DATETIME      CONSTRAINT [DF_FctProvRoster_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]              VARCHAR (50)  CONSTRAINT [DF_FctProvRoster_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]        DATE          CONSTRAINT [DF_FctProvRoster_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]          VARCHAR (50)  CONSTRAINT [DF_FctProvRoster_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [IsActive]               BIT           CONSTRAINT [DF_FctProvRoster_IsActive] DEFAULT ((1)) NOT NULL,
    [RowEffectiveDate]       DATE          DEFAULT (CONVERT([date],getdate())) NOT NULL,
    [RowExpirationDate]      DATE          DEFAULT (CONVERT([date],'12/31/2099')) NOT NULL,
    [ClientKey]              INT           NOT NULL,
    [LOB]                    VARCHAR (50)  NULL,
    [ClientProviderID]       VARCHAR (50)  NULL,
    [NPI]                    VARCHAR (10)  NULL,
    [LastName]               VARCHAR (50)  NULL,
    [FirstName]              VARCHAR (50)  NULL,
    [Degree]                 VARCHAR (100) NULL,
    [TIN]                    VARCHAR (10)  NULL,
    [PrimarySpeciality]      VARCHAR (100) NULL,
    [Sub_Speciality]         VARCHAR (100) NULL,
    [GroupName]              VARCHAR (100) NULL,
    [EffectiveDate]          DATE          NULL,
    [ExpirationDate]         DATE          NULL,
    [PrimaryAddress]         VARCHAR (100) NULL,
    [PrimaryCity]            VARCHAR (35)  NULL,
    [PrimaryState]           VARCHAR (25)  NULL,
    [PrimaryZipcode]         VARCHAR (20)  NULL,
    [PrimaryPOD]             VARCHAR (50)  NULL,
    [PrimaryQuadrant]        VARCHAR (50)  NULL,
    [PrimaryAddressPhoneNum] VARCHAR (35)  NULL,
    [BillingAddress]         VARCHAR (100) NULL,
    [BillingCity]            VARCHAR (35)  NULL,
    [BillingState]           VARCHAR (25)  NULL,
    [BillingZipcode]         VARCHAR (20)  NULL,
    [BillingPOD]             VARCHAR (50)  NULL,
    [BillingAddressPhoneNum] VARCHAR (35)  NULL,
    [Comments]               VARCHAR (100) NULL,
    [HealthPlan]             VARCHAR (50)  NULL,
    [AccountType]            VARCHAR (50)  NULL,
    [NetworkContact]         VARCHAR (50)  NULL,
    [Chapter]                VARCHAR (50)  NULL,
    [ProviderType]           VARCHAR (20)  NULL,
    [AceProviderID]          VARCHAR (15)  NULL,
    [AceAccountID]           VARCHAR (15)  NULL,
    [Ethnicity]              VARCHAR (50)  NULL,
    [LanguagesSpoken]        VARCHAR (50)  NULL,
    [Provider_DOB]           DATE          NULL,
    [Provider_Gender]        CHAR (1)      NULL,
    [PrimaryCounty]          VARCHAR (25)  CONSTRAINT [DF_FctProvRoster_PrimaryCounty] DEFAULT ('Unknown') NULL,
    PRIMARY KEY CLUSTERED ([fctProviderRosterSkey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ndx_FctProviderRoster_NpiRwEffRwExp]
    ON [adw].[fctProviderRoster]([NPI] ASC, [RowEffectiveDate] ASC, [RowExpirationDate] ASC)
    INCLUDE([LastName], [FirstName], [PrimaryZipcode], [TIN]);


GO
CREATE NONCLUSTERED INDEX [IX_fctProviderRoster_RowEffectiveDate_RowExpirationDate]
    ON [adw].[fctProviderRoster]([RowEffectiveDate] ASC, [RowExpirationDate] ASC)
    INCLUDE([DataDate], [NPI], [LastName], [FirstName], [GroupName]);


GO
CREATE NONCLUSTERED INDEX [idx_FctProvRost_CLientKeyRwEffRwExEffDateExDate]
    ON [adw].[fctProviderRoster]([ClientKey] ASC, [RowEffectiveDate] ASC, [RowExpirationDate] ASC, [EffectiveDate] ASC, [ExpirationDate] ASC)
    INCLUDE([TIN]);


GO
CREATE NONCLUSTERED INDEX [idx_FctProviderRoster_ClientKeyTinRwEffRwExEffDateExDate]
    ON [adw].[fctProviderRoster]([ClientKey] ASC, [TIN] ASC, [RowEffectiveDate] ASC, [RowExpirationDate] ASC, [EffectiveDate] ASC, [ExpirationDate] ASC);


GO
CREATE STATISTICS [_dta_stat_1062398954_12_19]
    ON [adw].[fctProviderRoster]([ClientKey], [TIN]);


GO
CREATE STATISTICS [_dta_stat_1062398954_19_39_12]
    ON [adw].[fctProviderRoster]([TIN], [HealthPlan], [ClientKey]);


GO
CREATE STATISTICS [_dta_stat_1062398954_23_39_12_24_11]
    ON [adw].[fctProviderRoster]([EffectiveDate], [HealthPlan], [ClientKey], [ExpirationDate], [RowExpirationDate]);


GO
CREATE STATISTICS [_dta_stat_1062398954_19_23_39_12_24_11]
    ON [adw].[fctProviderRoster]([TIN], [EffectiveDate], [HealthPlan], [ClientKey], [ExpirationDate], [RowExpirationDate]);


GO
CREATE STATISTICS [_dta_stat_1062398954_12_39_10_23_24]
    ON [adw].[fctProviderRoster]([ClientKey], [HealthPlan], [RowEffectiveDate], [EffectiveDate], [ExpirationDate]);


GO
CREATE STATISTICS [_dta_stat_1062398954_10_19_12_39_23_24]
    ON [adw].[fctProviderRoster]([RowEffectiveDate], [TIN], [ClientKey], [HealthPlan], [EffectiveDate], [ExpirationDate]);


GO
CREATE STATISTICS [_dta_stat_1062398954_1_19_12_39]
    ON [adw].[fctProviderRoster]([fctProviderRosterSkey], [TIN], [ClientKey], [HealthPlan]);


GO
CREATE STATISTICS [_dta_stat_1062398954_39_12_10_1]
    ON [adw].[fctProviderRoster]([HealthPlan], [ClientKey], [RowEffectiveDate], [fctProviderRosterSkey]);


GO
CREATE STATISTICS [_dta_stat_1062398954_39_12_10_19_43]
    ON [adw].[fctProviderRoster]([HealthPlan], [ClientKey], [RowEffectiveDate], [TIN], [ProviderType]);


GO
CREATE STATISTICS [_dta_stat_1062398954_23_39_12_43_24_11]
    ON [adw].[fctProviderRoster]([EffectiveDate], [HealthPlan], [ClientKey], [ProviderType], [ExpirationDate], [RowExpirationDate]);


GO
CREATE STATISTICS [_dta_stat_1062398954_19_23_39_12_43_24_11_10]
    ON [adw].[fctProviderRoster]([TIN], [EffectiveDate], [HealthPlan], [ClientKey], [ProviderType], [ExpirationDate], [RowExpirationDate], [RowEffectiveDate]);


GO
CREATE STATISTICS [_dta_stat_1062398954_43_1_19_12_39_10_23_24]
    ON [adw].[fctProviderRoster]([ProviderType], [fctProviderRosterSkey], [TIN], [ClientKey], [HealthPlan], [RowEffectiveDate], [EffectiveDate], [ExpirationDate]);


GO
CREATE STATISTICS [_dta_stat_1062398954_19_39_12_10_1_23_24_11_43]
    ON [adw].[fctProviderRoster]([TIN], [HealthPlan], [ClientKey], [RowEffectiveDate], [fctProviderRosterSkey], [EffectiveDate], [ExpirationDate], [RowExpirationDate], [ProviderType]);

