CREATE TABLE [dbo].[ACE_ETL_JobRowCounts] (
    [id]                   INT           IDENTITY (1, 1) NOT NULL,
    [PackageName]          VARCHAR (200) NULL,
    [InputSourceName]      VARCHAR (200) NULL,
    [InputCount]           INT           NULL,
    [DestinationName]      VARCHAR (200) NULL,
    [DestinationCount]     INT           NULL,
    [ErrorDestinationName] VARCHAR (200) NULL,
    [ErrorCount]           INT           NULL,
    [Created_Date]         DATETIME2 (7) DEFAULT (getdate()) NULL,
    [Created_By]           VARCHAR (200) DEFAULT (suser_sname()) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);

