﻿CREATE TABLE [adw].[fctProviderRoster_DevPR] (
    [fctProviderRosterSkey]  INT           IDENTITY (1, 1) NOT NULL,
    [SourceJobName]          VARCHAR (50)  NOT NULL,
    [LoadDate]               DATE          NOT NULL,
    [DataDate]               DATE          NOT NULL,
    [CreatedDate]            DATETIME      CONSTRAINT [DF_astFctProvRoster_DevPR_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]              VARCHAR (50)  CONSTRAINT [DF_astFctProvRoster_DevPR_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]        DATE          CONSTRAINT [DF_astFctProvRoster_DevPR_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]          VARCHAR (50)  CONSTRAINT [DF_astFctProvRoster_DevPR_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [IsActive]               BIT           CONSTRAINT [DF_astFctProvRoster_DevPR_IsActive] DEFAULT ((1)) NOT NULL,
    [RowEffectiveDate]       DATE          DEFAULT (CONVERT([date],getdate())) NOT NULL,
    [RowExpirationDate]      DATE          DEFAULT (CONVERT([date],'12/31/2099')) NOT NULL,
    [TinClientKey]           INT           DEFAULT ((0)) NOT NULL,
    [TinLob]                 VARCHAR (50)  DEFAULT ('Unknown') NOT NULL,
    [TinHealthPlan]          VARCHAR (50)  DEFAULT ('Unknown') NOT NULL,
    [TinHpEffDate]           DATE          DEFAULT ('01/01/1900') NOT NULL,
    [TinHpExpDate]           DATE          DEFAULT ('01/01/1900') NOT NULL,
    [PrvdrTin]               VARCHAR (12)  DEFAULT ('00000000') NOT NULL,
    [PrvdrClientKey]         INT           DEFAULT ((0)) NOT NULL,
    [PrvdrLOB]               VARCHAR (50)  DEFAULT ('Unknown') NOT NULL,
    [PrvdrHealthPlan]        VARCHAR (50)  DEFAULT ('Unknown') NOT NULL,
    [PrvdrHpEffDate]         DATE          DEFAULT ('01/01/1900') NOT NULL,
    [PrvdrHpExpDate]         DATE          DEFAULT ('01/01/1900') NOT NULL,
    [ClientProviderID]       VARCHAR (50)  NULL,
    [ClientKey]              INT           NOT NULL,
    [NPI]                    VARCHAR (10)  NULL,
    [TIN]                    VARCHAR (10)  NULL,
    [LastName]               VARCHAR (50)  NULL,
    [FirstName]              VARCHAR (50)  NULL,
    [Degree]                 VARCHAR (100) NULL,
    [PrimarySpeciality]      VARCHAR (100) NULL,
    [Sub_Speciality]         VARCHAR (100) NULL,
    [GroupName]              VARCHAR (100) NULL,
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
    [PrimaryCounty]          VARCHAR (25)  CONSTRAINT [DF_astFctProvRoster_DevPR_PrimaryCounty] DEFAULT ('Unknown') NULL,
    PRIMARY KEY CLUSTERED ([fctProviderRosterSkey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ndx_fPrvRstr_IsActiveClientKeyRwEffRwExp]
    ON [adw].[fctProviderRoster_DevPR]([IsActive] ASC, [ClientKey] ASC, [RowEffectiveDate] ASC, [RowExpirationDate] ASC)
    INCLUDE([PrvdrLOB], [PrvdrHealthPlan], [PrvdrHpEffDate], [PrvdrHpExpDate], [NPI], [TIN], [GroupName]);


GO
CREATE NONCLUSTERED INDEX [fctPR_devPr_IsActiveClientkeyRwEffRwExp]
    ON [adw].[fctProviderRoster_DevPR]([IsActive] ASC, [ClientKey] ASC, [RowEffectiveDate] ASC, [RowExpirationDate] ASC)
    INCLUDE([fctProviderRosterSkey], [LastUpdatedDate], [TinLob], [TinHealthPlan], [TinHpEffDate], [TinHpExpDate], [PrvdrLOB], [PrvdrHealthPlan], [PrvdrHpEffDate], [PrvdrHpExpDate], [ClientProviderID], [NPI], [TIN], [LastName], [FirstName], [PrimarySpeciality], [Sub_Speciality], [GroupName], [AccountType], [NetworkContact], [Chapter], [ProviderType], [PrimaryCounty]);


GO
CREATE NONCLUSTERED INDEX [ndx_ProvRostCLientKeyRowEffRowExp]
    ON [adw].[fctProviderRoster_DevPR]([ClientKey] ASC, [RowEffectiveDate] ASC, [RowExpirationDate] ASC)
    INCLUDE([PrvdrLOB], [PrvdrHealthPlan], [PrvdrHpEffDate], [PrvdrHpExpDate], [NPI], [TIN], [GroupName], [AccountType]);

