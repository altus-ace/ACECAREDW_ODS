CREATE TABLE [adw].[MbrAddress] (
    [mbrAddressKey]   INT           IDENTITY (1, 1) NOT NULL,
    [MbrMemberKey]    INT           NOT NULL,
    [MbrLoadKey]      INT           NOT NULL,
    [EffectiveDate]   DATE          NOT NULL,
    [ExpirationDate]  DATE          CONSTRAINT [DF_MbrAddressExpirationDate] DEFAULT ('12/31/9999') NOT NULL,
    [AddressTypeKey]  INT           NOT NULL,
    [Address1]        VARCHAR (100) NULL,
    [Address2]        VARCHAR (100) NULL,
    [CITY]            VARCHAR (65)  NULL,
    [STATE]           CHAR (25)     NULL,
    [ZIP]             VARCHAR (20)  NULL,
    [COUNTY]          VARCHAR (65)  NULL,
    [LoadDate]        DATE          NOT NULL,
    [DataDate]        DATE          NOT NULL,
    [CreatedDate]     DATETIME2 (7) CONSTRAINT [DF_MbrAddress_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       VARCHAR (50)  CONSTRAINT [DF_MbrAddress_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate] DATETIME2 (7) CONSTRAINT [DF_MbrAddress_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]   VARCHAR (50)  CONSTRAINT [DF_MbrAddress_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([mbrAddressKey] ASC),
    CONSTRAINT [FK_MbrAddress_LstAddressType] FOREIGN KEY ([AddressTypeKey]) REFERENCES [lst].[lstAddressType] ([lstAddressTypeKey]),
    CONSTRAINT [FK_MbrAddress_MbrLoadHistory] FOREIGN KEY ([MbrLoadKey]) REFERENCES [adw].[MbrLoadHistory] ([mbrLoadHistoryKey]),
    CONSTRAINT [FK_MbrAddress_MbrMember] FOREIGN KEY ([MbrMemberKey]) REFERENCES [adw].[MbrMember] ([mbrMemberKey])
);


GO
CREATE NONCLUSTERED INDEX [Ndx_MbrAddress_EffExpAddressTypeAddressKey]
    ON [adw].[MbrAddress]([EffectiveDate] ASC, [AddressTypeKey] ASC, [ExpirationDate] ASC, [mbrAddressKey] ASC)
    INCLUDE([MbrMemberKey], [Address1], [Address2], [CITY], [STATE], [ZIP], [COUNTY]);


GO
CREATE NONCLUSTERED INDEX [Ndx_MbrAddress_MbrMbrKeyAddTyepEffDtExpDt]
    ON [adw].[MbrAddress]([MbrMemberKey] ASC, [AddressTypeKey] ASC, [EffectiveDate] ASC, [ExpirationDate] ASC)
    INCLUDE([mbrAddressKey], [Address1], [Address2], [CITY], [STATE], [ZIP]);


GO
CREATE NONCLUSTERED INDEX [ndx_MbrAdd_AddTypeKeyEffDateExpDate]
    ON [adw].[MbrAddress]([AddressTypeKey] ASC, [EffectiveDate] ASC, [ExpirationDate] ASC)
    INCLUDE([MbrMemberKey]);


GO

CREATE TRIGGER adw.[AU_adwMbrAddress]
ON adw.MbrAddress
AFTER UPDATE 
AS
   UPDATE adw.MbrAddress
   SET [LastUpdatedDate] = SYSDATETIME()
	   ,[LastUpdatedBy] = SYSTEM_USER	
   FROM Inserted i
   WHERE adw.MbrAddress.mbrAddressKey = i.mbrAddressKey
   ;
