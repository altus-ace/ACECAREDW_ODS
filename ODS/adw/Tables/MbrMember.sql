CREATE TABLE [adw].[MbrMember] (
    [mbrMemberKey]    INT           IDENTITY (1, 1) NOT NULL,
    [ClientMemberKey] VARCHAR (20)  NOT NULL,
    [ClientKey]       INT           NOT NULL,
    [MstrMrnKey]      NUMERIC (15)  NOT NULL,
    [mbrLoadKey]      INT           NOT NULL,
    [LoadDate]        DATE          NOT NULL,
    [DataDate]        DATE          NOT NULL,
    [CreatedDate]     DATETIME2 (7) CONSTRAINT [DF_MbrMember_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       VARCHAR (50)  CONSTRAINT [DF_MbrMember_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate] DATETIME2 (7) CONSTRAINT [DF_MbrMember_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]   VARCHAR (50)  CONSTRAINT [DF_MbrMember_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([mbrMemberKey] ASC),
    CONSTRAINT [FK_MbrMember_Client] FOREIGN KEY ([ClientKey]) REFERENCES [lst].[List_Client] ([ClientKey]),
    CONSTRAINT [FK_MbrMember_MbrLoadHistory] FOREIGN KEY ([mbrLoadKey]) REFERENCES [adw].[MbrLoadHistory] ([mbrLoadHistoryKey])
);


GO
CREATE NONCLUSTERED INDEX [Ndx_MbrMember_ClientKey]
    ON [adw].[MbrMember]([ClientKey] ASC)
    INCLUDE([DataDate]);


GO
CREATE NONCLUSTERED INDEX [adwMbrMember_ClientMemberKey]
    ON [adw].[MbrMember]([ClientMemberKey] ASC)
    INCLUDE([mbrMemberKey]);


GO
CREATE NONCLUSTERED INDEX [ndx_MbrMember_CmkMbrKeyClientKeyMpi]
    ON [adw].[MbrMember]([ClientMemberKey] ASC, [mbrMemberKey] ASC, [ClientKey] ASC, [MstrMrnKey] ASC)
    INCLUDE([DataDate]);


GO
CREATE NONCLUSTERED INDEX [Ndx_MbrMember_ClientKeyMemberKeyClientMemberKeyMstrMrnKey]
    ON [adw].[MbrMember]([ClientKey] ASC, [mbrMemberKey] ASC, [ClientMemberKey] ASC, [MstrMrnKey] ASC)
    INCLUDE([DataDate]);


GO
CREATE NONCLUSTERED INDEX [Ndx_MbrMember_ClientMemberKeyClientKeyMstrMrnKey]
    ON [adw].[MbrMember]([ClientMemberKey] ASC, [ClientKey] ASC, [MstrMrnKey] ASC);


GO
CREATE NONCLUSTERED INDEX [ndx_AdwMbrMember_ClientKey]
    ON [adw].[MbrMember]([ClientKey] ASC)
    INCLUDE([mbrMemberKey], [ClientMemberKey], [LoadDate], [MstrMrnKey]);


GO

CREATE TRIGGER adw.[AU_MbrMember]
ON adw.MbrMember
AFTER UPDATE 
AS
   UPDATE adw.MbrMember
   SET [LastUpdatedDate] = SYSDATETIME()
	   ,[LastUpdatedBy] = SYSTEM_USER	
   FROM Inserted i
   WHERE adw.MbrMember.mbrMemberKey = i.mbrMemberKey
   ;
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'SKey,PKey Used as a FKey Reference', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'MbrMember', @level2type = N'COLUMN', @level2name = N'mbrMemberKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Client''s Member Identifier', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'MbrMember', @level2type = N'COLUMN', @level2name = N'ClientMemberKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Client Identifier', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'MbrMember', @level2type = N'COLUMN', @level2name = N'ClientKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Members MRN', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'MbrMember', @level2type = N'COLUMN', @level2name = N'MstrMrnKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date Loaded into Ace', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'MbrMember', @level2type = N'COLUMN', @level2name = N'LoadDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date Data was created by source', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'MbrMember', @level2type = N'COLUMN', @level2name = N'DataDate';

