CREATE TABLE [adw].[MbrLoadHistory] (
    [mbrLoadHistoryKey] INT           IDENTITY (1, 1) NOT NULL,
    [mbrMemberKey]      INT           NULL,
    [AdiTableName]      VARCHAR (100) NULL,
    [AdiKey]            INT           NULL,
    [LoadType]          CHAR (1)      CONSTRAINT [DF_MbrLoadHistory_LoadType] DEFAULT ('P') NOT NULL,
    [LoadDate]          DATE          NOT NULL,
    [DataDate]          DATE          NOT NULL,
    [CreatedDate]       DATETIME2 (7) CONSTRAINT [DF_MbrLoadHistory_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]         VARCHAR (50)  CONSTRAINT [DF_MbrLoadHistory_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]   DATETIME2 (7) CONSTRAINT [DF_MbrLoadHistory_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]     VARCHAR (50)  CONSTRAINT [DF_MbrLoadHistory_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([mbrLoadHistoryKey] ASC),
    CONSTRAINT [CK_MbrLoadHistory_LoadType] CHECK ([LoadType]='S' OR [LoadType]='P')
);


GO
CREATE NONCLUSTERED INDEX [ndx_AdwMbrLoadHistor_LoadDate]
    ON [adw].[MbrLoadHistory]([LoadDate] ASC)
    INCLUDE([mbrLoadHistoryKey]);


GO

CREATE TRIGGER adw.[AU_MbrLoadHistory]
ON adw.MbrLoadHistory
AFTER UPDATE 
AS
   UPDATE adw.MbrLoadHistory
   SET [LastUpdatedDate] = SYSDATETIME()
	   ,[LastUpdatedBy] = SYSTEM_USER	
   FROM Inserted i
   WHERE adw.MbrLoadHistory.mbrLoadHistoryKey = i.mbrLoadHistoryKey
   ;