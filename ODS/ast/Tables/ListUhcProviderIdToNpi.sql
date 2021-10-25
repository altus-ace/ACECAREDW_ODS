CREATE TABLE [ast].[ListUhcProviderIdToNpi] (
    [providerID] VARCHAR (20) NOT NULL,
    [LName]      VARCHAR (50) NULL,
    [FName]      VARCHAR (50) NULL,
    [NPI]        VARCHAR (20) NULL,
    [TIN]        VARCHAR (20) NULL,
    PRIMARY KEY CLUSTERED ([providerID] ASC)
);

