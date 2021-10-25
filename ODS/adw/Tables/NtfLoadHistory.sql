CREATE TABLE [adw].[NtfLoadHistory] (
    [ntfLoadHistoryKey]    INT           IDENTITY (1, 1) NOT NULL,
    [ntfNotificationKey]   INT           NULL,
    [UhcNtfIPDischargeKey] INT           NULL,
    [UhcNtfErDischargeKey] INT           NULL,
    [LoadDate]             DATE          NOT NULL,
    [DataDate]             DATE          NOT NULL,
    [CreatedDate]          DATETIME2 (7) CONSTRAINT [DF_NtfLoadHistory_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]            VARCHAR (50)  CONSTRAINT [DF_NtfLoadHistory_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]      DATETIME2 (7) CONSTRAINT [DF_NtfLoadHistory_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]        VARCHAR (50)  CONSTRAINT [DF_NtfLoadHistory_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([ntfLoadHistoryKey] ASC)
);


GO

CREATE TRIGGER [adw].[TR_adwNtfLoadHistory_AU]
    ON [adw].NtfLoadHistory
    FOR UPDATE
    AS
    BEGIN
	   IF @@rowcount = 0 
		RETURN
        SET NoCount ON
	   if exists(SELECT * FROM inserted)
		  UPDATE adw.NtfLoadHistory
			 SET LastUpdatedDate = GETDATE()
    				,LastUpdatedBy  = system_user
	   	  FROM inserted i, NtfLoadHistory a
		  WHERE i.ntfLoadHistoryKey = a.ntfLoadHistoryKey
    END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PKey SKey', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'NtfLoadHistory', @level2type = N'COLUMN', @level2name = N'ntfLoadHistoryKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fk to NtfNotification, Not null if row is in Entity Table', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'NtfLoadHistory', @level2type = N'COLUMN', @level2name = N'ntfNotificationKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Source Key, Data Lineage Key', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'NtfLoadHistory', @level2type = N'COLUMN', @level2name = N'UhcNtfIPDischargeKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Source Key, Data Lineage Key', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'NtfLoadHistory', @level2type = N'COLUMN', @level2name = N'UhcNtfErDischargeKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'What day was this data loaded', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'NtfLoadHistory', @level2type = N'COLUMN', @level2name = N'LoadDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'What is the effective date of this data', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'NtfLoadHistory', @level2type = N'COLUMN', @level2name = N'DataDate';

