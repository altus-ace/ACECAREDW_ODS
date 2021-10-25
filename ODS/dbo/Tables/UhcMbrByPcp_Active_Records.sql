CREATE TABLE [dbo].[UhcMbrByPcp_Active_Records] (
    [urn]            INT  IDENTITY (1, 1) NOT NULL,
    [UhcMbrByPcpUrn] INT  NOT NULL,
    [LoadDate]       DATE NOT NULL,
    PRIMARY KEY CLUSTERED ([urn] ASC)
);

