CREATE TABLE [amd].[AceValidationRunSummary] (
    [skey]             INT           IDENTITY (1, 1) NOT NULL,
    [createdDate]      DATETIME      CONSTRAINT [DF__ValidDetls__creat__6501FCD8] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]        VARCHAR (100) CONSTRAINT [DF_ValidDetls__Creat__65F62111] DEFAULT (suser_sname()) NOT NULL,
    [TotalMemberCount] INT           NULL,
    [ClientKey]        INT           NULL,
    [LoadDate]         DATETIME      NULL,
    [AsOfDate]         DATETIME      CONSTRAINT [DF_Valsum__Creat__65F62113] DEFAULT (getdate()) NULL,
    [Active]           TINYINT       NULL,
    [TestCaseName]     VARCHAR (30)  NULL,
    PRIMARY KEY CLUSTERED ([skey] ASC)
);

