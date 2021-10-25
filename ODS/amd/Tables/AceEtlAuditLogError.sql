CREATE TABLE [amd].[AceEtlAuditLogError] (
    [AceEtlAuditLogErrorLogKey] INT            IDENTITY (1, 1) NOT NULL,
    [ParamValues]               VARCHAR (1000) NULL,
    [CREATED_DATE]              DATETIME2 (7)  DEFAULT (CONVERT([datetime2],getdate())) NULL,
    [CREATEDBY]                 VARCHAR (50)   DEFAULT (suser_sname()) NULL,
    PRIMARY KEY CLUSTERED ([AceEtlAuditLogErrorLogKey] ASC)
);

