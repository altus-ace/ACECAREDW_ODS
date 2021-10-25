CREATE TABLE [adw].[MbrEmail] (
    [mbrEmailKey]     INT           IDENTITY (1, 1) NOT NULL,
    [mbrMemberKey]    INT           NOT NULL,
    [mbrLoadKey]      INT           NOT NULL,
    [EffectiveDate]   DATE          NOT NULL,
    [ExpirationDate]  DATE          CONSTRAINT [DF_MbrEmailExpirationDate] DEFAULT ('12/31/9999') NOT NULL,
    [EmailType]       INT           NOT NULL,
    [EmailAddress]    VARCHAR (100) NOT NULL,
    [IsPrimary]       TINYINT       CONSTRAINT [DF_MbrEmail_IsPrimary] DEFAULT ((0)) NOT NULL,
    [LoadDate]        DATE          NOT NULL,
    [DataDate]        DATE          NOT NULL,
    [CreatedDate]     DATETIME2 (7) CONSTRAINT [DF_MbrEmail_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       VARCHAR (50)  CONSTRAINT [DF_MbrEmail_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate] DATETIME2 (7) CONSTRAINT [DF_MbrEmail_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]   VARCHAR (50)  CONSTRAINT [DF_MbrEmail_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([mbrEmailKey] ASC),
    CONSTRAINT [CK_MbrEmail_IsPrimary] CHECK ([IsPrimary]=(1) OR [IsPrimary]=(0)),
    CONSTRAINT [FK_MbrEmail_lstEmailType] FOREIGN KEY ([EmailType]) REFERENCES [lst].[lstEmailType] ([lstEmailTypeKey]),
    CONSTRAINT [FK_MbrEmail_MbrLoadKey] FOREIGN KEY ([mbrLoadKey]) REFERENCES [adw].[MbrLoadHistory] ([mbrLoadHistoryKey]),
    CONSTRAINT [FK_MbrEmail_MbrMember] FOREIGN KEY ([mbrMemberKey]) REFERENCES [adw].[MbrMember] ([mbrMemberKey])
);


GO

CREATE TRIGGER adw.[AU_MbrEmail]
ON adw.MbrEmail
AFTER UPDATE 
AS
   UPDATE adw.MbrEmail
   SET [LastUpdatedDate] = SYSDATETIME()
	   ,[LastUpdatedBy] = SYSTEM_USER	
   FROM Inserted i
   WHERE adw.MbrEmail.mbrEmailKey = i.mbrEmailKey
   ;