CREATE TABLE [adw].[MbrPhone] (
    [mbrPhoneKey]     INT           IDENTITY (1, 1) NOT NULL,
    [mbrMemberKey]    INT           NOT NULL,
    [mbrLoadKey]      INT           NOT NULL,
    [EffectiveDate]   DATE          NOT NULL,
    [ExpirationDate]  DATE          CONSTRAINT [DF_MbrPhoneExpirationDate] DEFAULT ('12/31/9999') NOT NULL,
    [PhoneType]       INT           NOT NULL,
    [CarrierType]     INT           NOT NULL,
    [PhoneNumber]     VARCHAR (30)  NULL,
    [IsPrimary]       TINYINT       CONSTRAINT [DF_MbrPhone_IsPrimary] DEFAULT ((0)) NOT NULL,
    [LoadDate]        DATE          NOT NULL,
    [DataDate]        DATE          NOT NULL,
    [CreatedDate]     DATETIME2 (7) CONSTRAINT [DF_MbrPhone_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       VARCHAR (50)  CONSTRAINT [DF_MbrPhone_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate] DATETIME2 (7) CONSTRAINT [DF_MbrPhone_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]   VARCHAR (50)  CONSTRAINT [DF_MbrPhone_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([mbrPhoneKey] ASC),
    CONSTRAINT [CK_MbrPhone_IsPrimary] CHECK ([IsPrimary]=(1) OR [IsPrimary]=(0)),
    CONSTRAINT [FK_MbrPhone_lstPhoneCarrierType] FOREIGN KEY ([CarrierType]) REFERENCES [lst].[lstPhoneCarrierType] ([lstPhoneCarrierTypeKey]),
    CONSTRAINT [FK_MbrPhone_lstPhoneType] FOREIGN KEY ([PhoneType]) REFERENCES [lst].[lstPhoneType] ([lstPhoneTypeKey]),
    CONSTRAINT [FK_MbrPhone_MbrLoadKey] FOREIGN KEY ([mbrLoadKey]) REFERENCES [adw].[MbrLoadHistory] ([mbrLoadHistoryKey]),
    CONSTRAINT [FK_MbrPhone_MbrMember] FOREIGN KEY ([mbrMemberKey]) REFERENCES [adw].[MbrMember] ([mbrMemberKey])
);


GO
CREATE NONCLUSTERED INDEX [Ndx_MbrPhone_MbrEffExpPhoneType]
    ON [adw].[MbrPhone]([mbrMemberKey] ASC, [ExpirationDate] DESC, [EffectiveDate] ASC, [PhoneType] ASC)
    INCLUDE([mbrPhoneKey], [PhoneNumber]);


GO
CREATE NONCLUSTERED INDEX [Ndx_MbrPhone_]
    ON [adw].[MbrPhone]([PhoneType] ASC, [mbrMemberKey] ASC, [EffectiveDate] ASC, [ExpirationDate] ASC)
    INCLUDE([mbrPhoneKey], [PhoneNumber]);


GO


CREATE TRIGGER adw.[AU_MbrPhone]
ON adw.MbrPhone
AFTER UPDATE 
AS
   UPDATE adw.MbrPhone
   SET [LastUpdatedDate] = SYSDATETIME()
	   ,[LastUpdatedBy] = SYSTEM_USER	
   FROM Inserted i
   WHERE adw.MbrPhone.mbrPhoneKey = i.mbrPhoneKey
   ;