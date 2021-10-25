CREATE TABLE [dbo].[DailyNotificationLog] (
    [NTFKey]      INT           IDENTITY (1, 1) NOT NULL,
    [LoadDate]    DATETIME      NULL,
    [RecordCount] INT           NULL,
    [Status]      VARCHAR (50)  NULL,
    [FileName]    VARCHAR (100) NULL,
    [NTFClient]   VARCHAR (50)  NULL
);

