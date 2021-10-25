﻿CREATE TABLE [adw].[MbrRespParty] (
    [mbrRespPartyKey] INT           IDENTITY (1, 1) NOT NULL,
    [mbrMemberKey]    INT           NOT NULL,
    [mbrLoadKey]      INT           NOT NULL,
    [EffectiveDate]   DATE          NOT NULL,
    [ExpirationDate]  DATE          CONSTRAINT [DF_MbrRespPartyExpirationDate] DEFAULT ('12/31/9999') NOT NULL,
    [LastName]        VARCHAR (100) NULL,
    [FirstName]       VARCHAR (100) NULL,
    [Address1]        VARCHAR (100) NULL,
    [Address2]        VARCHAR (100) NULL,
    [CITY]            VARCHAR (65)  NULL,
    [STATE]           VARCHAR (25)  NULL,
    [ZIP]             VARCHAR (20)  NULL,
    [Phone]           VARCHAR (30)  NULL,
    [LoadDate]        DATE          NOT NULL,
    [DataDate]        DATE          NOT NULL,
    [CreatedDate]     DATETIME2 (7) CONSTRAINT [DF_MbrRespParty_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       VARCHAR (50)  NOT NULL,
    [LastUpdatedDate] DATETIME2 (7) CONSTRAINT [DF_MbrRespParty_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]   VARCHAR (50)  NOT NULL,
    PRIMARY KEY CLUSTERED ([mbrRespPartyKey] ASC),
    CONSTRAINT [FK_RespParty_MbrMember] FOREIGN KEY ([mbrMemberKey]) REFERENCES [adw].[MbrMember] ([mbrMemberKey])
);


GO
CREATE NONCLUSTERED INDEX [Ndx_MbrRespParty_MbrMemberKeyEffDateExpDate]
    ON [adw].[MbrRespParty]([mbrMemberKey] ASC, [EffectiveDate] ASC, [ExpirationDate] ASC)
    INCLUDE([mbrRespPartyKey], [LastName], [FirstName], [Address1], [Address2], [CITY], [STATE], [ZIP], [Phone]);


GO
CREATE NONCLUSTERED INDEX [Ndx_MbrRespParty_EffDateExpDate]
    ON [adw].[MbrRespParty]([EffectiveDate] ASC, [ExpirationDate] ASC)
    INCLUDE([mbrMemberKey], [LastName], [FirstName], [Address1], [Address2], [CITY], [STATE], [ZIP], [Phone]);


GO

CREATE TRIGGER adw.[AU_MbrRespParty]
ON adw.MbrRespParty
AFTER UPDATE 
AS
   UPDATE adw.MbrRespParty
   SET [LastUpdatedDate] = SYSDATETIME()
	   ,[LastUpdatedBy] = SYSTEM_USER	
   FROM Inserted i
   WHERE adw.MbrRespParty.MbrRespPartyKEy= i.mbrRespPartyKey
   ;
