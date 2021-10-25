CREATE TABLE [dbo].[sysLog_MemberStatusSummaryByETL_Import] (
    [id]                INT           IDENTITY (1, 1) NOT NULL,
    [tableName]         VARCHAR (100) NULL,
    [ExistingCnt]       INT           NULL,
    [NewCnt]            INT           NULL,
    [TermedCnt]         INT           NULL,
    [ETL_batchDateTIME] DATETIME2 (3) NULL,
    [CREATED_BY]        VARCHAR (20)  NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);

