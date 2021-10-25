CREATE TABLE [adw].[ListAbrLobToExclude] (
    [LstAbrLobToExcludeKey] INT           IDENTITY (1, 1) NOT NULL,
    [LobToExcludeName]      VARCHAR (100) NOT NULL,
    [EffectiveDate]         DATE          CONSTRAINT [Df_ListAbrLobToExcluded_EffectiveDate] DEFAULT (getdate()) NOT NULL,
    [ExpirationDate]        DATE          CONSTRAINT [Df_ListAbrLobToExcluded_ExpirationDate] DEFAULT ('12/31/2099') NOT NULL,
    [CreateDate]            DATETIME2 (7) CONSTRAINT [Df_ListAbrLobToExcluded_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreateBy]              VARCHAR (50)  CONSTRAINT [Df_ListAbrLobToExcluded_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]       DATETIME2 (7) CONSTRAINT [Df_ListAbrLobToExcluded_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]         VARCHAR (50)  CONSTRAINT [Df_ListAbrLobToExcluded_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([LstAbrLobToExcludeKey] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Abr= Ace Business Rule', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'ListAbrLobToExclude', @level2type = N'COLUMN', @level2name = N'LstAbrLobToExcludeKey';

