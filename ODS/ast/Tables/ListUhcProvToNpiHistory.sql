CREATE TABLE [ast].[ListUhcProvToNpiHistory] (
    [npi]      VARCHAR (20) NOT NULL,
    [UhcPcpId] VARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([npi] ASC, [UhcPcpId] ASC)
);

