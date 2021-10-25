CREATE TABLE [ast].[AHS_ExportLoadLog_Input] (
    [aUrn]             INT            IDENTITY (10000, 1) NOT NULL,
    [LoadDate]         VARCHAR (20)   NULL,
    [cntExpectedFiles] VARCHAR (10)   NULL,
    [cntLoadedFiles]   VARCHAR (10)   NULL,
    [MissingFiles]     VARCHAR (5000) NULL,
    [LoadedFileName]   VARCHAR (150)  NULL,
    [cntTotal]         VARCHAR (10)   NULL,
    [cntLoad]          VARCHAR (10)   NULL,
    [cntUpdate]        VARCHAR (10)   NULL,
    [cntError]         VARCHAR (10)   NULL,
    [createdBy]        VARCHAR (50)   DEFAULT (suser_sname()) NULL,
    [createdDate]      DATETIME2 (7)  DEFAULT (CONVERT([datetime2],getdate())) NULL,
    [MovedToDwMd_Date] DATETIME2 (7)  NULL,
    PRIMARY KEY CLUSTERED ([aUrn] ASC)
);

