CREATE TABLE [dbo].[tmpWlcMbrLoadHist] (
    [AdiTableName]          VARCHAR (100) NULL,
    [AdiKey]                INT           NULL,
    [LoadDate]              DATE          NULL,
    [DataDate]              DATE          NULL,
    [loadType]              CHAR (1)      NULL,
    [tmpWlcMbrLoadHistSKey] INT           IDENTITY (1, 1) NOT NULL,
    PRIMARY KEY CLUSTERED ([tmpWlcMbrLoadHistSKey] ASC)
);

