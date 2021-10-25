CREATE TABLE [amd].[AceValidationDetails] (
    [skey]              INT           IDENTITY (1, 1) NOT NULL,
    [createdDate]       DATETIME      CONSTRAINT [DF__ValidDetls__createdDate] DEFAULT (getdate()) NULL,
    [CreatedBy]         VARCHAR (100) CONSTRAINT [DF_ValidDetls__CreatedBy] DEFAULT (suser_sname()) NULL,
    [srcTableName]      VARCHAR (100) NOT NULL,
    [SrcRowSkey]        INT           NOT NULL,
    [TestedColumnValue] VARCHAR (100) DEFAULT ('No Value') NULL,
    [TestCase]          VARCHAR (50)  NULL,
    [SummarySkey]       INT           NOT NULL,
    [TestResultStatus]  TINYINT       DEFAULT ((0)) NULL,
    PRIMARY KEY CLUSTERED ([skey] ASC)
);

