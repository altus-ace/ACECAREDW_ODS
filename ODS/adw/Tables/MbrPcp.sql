CREATE TABLE [adw].[MbrPcp] (
    [mbrPcpKey]        INT           IDENTITY (1, 1) NOT NULL,
    [mbrMemberKey]     INT           NOT NULL,
    [mbrLoadKey]       INT           NOT NULL,
    [EffectiveDate]    DATE          CONSTRAINT [DF_MbrPcpExpirationDate] DEFAULT ('12/31/9999') NOT NULL,
    [ExpirationDate]   DATE          NOT NULL,
    [NPI]              VARCHAR (10)  NOT NULL,
    [TIN]              VARCHAR (10)  NULL,
    [ClientEffective]  DATE          NULL,
    [ClientExpiration] DATE          NULL,
    [AutoAssigned]     VARCHAR (10)  NOT NULL,
    [LoadDate]         DATE          NOT NULL,
    [DataDate]         DATE          NOT NULL,
    [CreatedDate]      DATETIME2 (7) CONSTRAINT [DF_MbrPcp_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]        VARCHAR (50)  CONSTRAINT [DF_MbrPcp_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]  DATETIME2 (7) CONSTRAINT [DF_MbrPcp_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]    VARCHAR (50)  CONSTRAINT [DF_MbrPcp_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([mbrPcpKey] ASC),
    CONSTRAINT [FK_MbrPcp_MbrLoadHistory] FOREIGN KEY ([mbrLoadKey]) REFERENCES [adw].[MbrLoadHistory] ([mbrLoadHistoryKey]),
    CONSTRAINT [FK_MbrPcp_MbrMember] FOREIGN KEY ([mbrMemberKey]) REFERENCES [adw].[MbrMember] ([mbrMemberKey])
);


GO
CREATE NONCLUSTERED INDEX [Ndx_MbrPcp_ExpEffMbrKeyNpiTinPcpKey]
    ON [adw].[MbrPcp]([ExpirationDate] ASC, [mbrMemberKey] ASC, [EffectiveDate] ASC, [NPI] ASC, [TIN] ASC, [mbrPcpKey] ASC)
    INCLUDE([AutoAssigned]);


GO
CREATE NONCLUSTERED INDEX [ndx_MbrPcp_NpiTinEffDateExpDate]
    ON [adw].[MbrPcp]([NPI] ASC, [TIN] ASC, [EffectiveDate] ASC, [ExpirationDate] ASC)
    INCLUDE([mbrMemberKey]);


GO

CREATE TRIGGER adw.[AU_MbrPcp]
ON adw.MbrPcp
AFTER UPDATE 
AS
   UPDATE adw.MbrPcp
   SET [LastUpdatedDate] = SYSDATETIME()
	   ,[LastUpdatedBy] = SYSTEM_USER	
   FROM Inserted i
   WHERE adw.MbrPcp.mbrPcpKey = i.mbrPcpKey
   ;