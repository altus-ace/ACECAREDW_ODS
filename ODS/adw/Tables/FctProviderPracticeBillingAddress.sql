CREATE TABLE [adw].[FctProviderPracticeBillingAddress] (
    [FctProviderPracticeBillingSkey] INT           IDENTITY (1, 1) NOT NULL,
    [SourceJobName]                  VARCHAR (50)  NULL,
    [LoadDate]                       DATE          DEFAULT (CONVERT([date],getdate())) NULL,
    [DataDate]                       DATE          DEFAULT (CONVERT([date],getdate())) NULL,
    [CreatedDate]                    DATETIME      DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                      VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]                DATE          DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]                  VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    [TIN]                            VARCHAR (50)  NOT NULL,
    [TIN_NAME]                       VARCHAR (100) NOT NULL,
    [AddType]                        VARCHAR (20)  DEFAULT ('Billing') NULL,
    [BillingAddress]                 VARCHAR (100) NULL,
    [BillingCity]                    VARCHAR (50)  NULL,
    [BillingState]                   VARCHAR (50)  NULL,
    [BillingZipcode]                 VARCHAR (50)  NULL,
    [BillingPOD]                     VARCHAR (50)  NULL,
    [BillingAddressPhoneNumber]      VARCHAR (50)  NULL
);

