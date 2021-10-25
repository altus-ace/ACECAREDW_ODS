CREATE TABLE [dbo].[TmpValidationResults] (
    [clientkey]              INT          NULL,
    [loaddate]               DATE         NULL,
    [asOfDate]               DATE         NULL,
    [createdDate]            DATE         NULL,
    [TestCaseName]           VARCHAR (50) NULL,
    [TotalMemberCount]       INT          NULL,
    [DetailPassCount]        INT          NULL,
    [DetailFailCount]        INT          NULL,
    [DetailTotalCount]       INT          NULL,
    [DetailPassFailChecksum] TINYINT      NULL,
    [SummaryDetailChecksum]  TINYINT      NULL
);

