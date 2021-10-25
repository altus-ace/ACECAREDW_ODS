CREATE TABLE [adw].[FctProviderPracticePrimaryAddress] (
    [FctProviderPracticeAddressSkey] INT           IDENTITY (1, 1) NOT NULL,
    [SourceJobName]                  VARCHAR (50)  NULL,
    [LoadDate]                       DATE          DEFAULT (CONVERT([date],getdate())) NULL,
    [DataDate]                       DATE          DEFAULT (CONVERT([date],getdate())) NULL,
    [CreatedDate]                    DATETIME      DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                      VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]                DATE          DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]                  VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [TIN]                            VARCHAR (50)  NOT NULL,
    [TIN_NAME]                       VARCHAR (100) NOT NULL,
    [AddType]                        VARCHAR (20)  DEFAULT ('Primary') NULL,
    [PrimaryAddress]                 VARCHAR (50)  NULL,
    [PrimaryCity]                    VARCHAR (50)  NULL,
    [PrimaryState]                   VARCHAR (50)  NULL,
    [PrimaryZipcode]                 VARCHAR (50)  NULL,
    [PrimaryPOD]                     VARCHAR (50)  NULL,
    [PrimaryQuadrant]                VARCHAR (50)  NULL,
    [PrimaryAddressPhoneNumber]      VARCHAR (50)  NULL,
    [Fax]                            VARCHAR (50)  NULL
);

