CREATE TABLE [dbo].[ApiUsers] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [Name]         VARCHAR (255) NOT NULL,
    [EamilAddress] VARCHAR (100) NULL,
    [ClientID]     VARCHAR (50)  NULL,
    [UserName]     VARCHAR (50)  NULL,
    [Password]     VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

