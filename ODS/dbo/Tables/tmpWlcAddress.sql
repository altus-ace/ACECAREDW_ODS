CREATE TABLE [dbo].[tmpWlcAddress] (
    [mbrLoadHistoryKey] INT           NULL,
    [mbrMemberKey]      INT           NULL,
    [MbrAddressKey]     INT           NULL,
    [adiAddress1]       VARCHAR (100) NULL,
    [adiAddress2]       VARCHAR (100) NULL,
    [adiCity]           VARCHAR (65)  NULL,
    [adiState]          VARCHAR (25)  NULL,
    [adiZip]            VARCHAR (20)  NULL,
    [adiCounty]         VARCHAR (65)  NULL,
    [adiLoadDate]       DATE          NULL,
    [adiDataDate]       DATE          NULL,
    [CurAddress1]       VARCHAR (100) NULL,
    [CurAddress2]       VARCHAR (100) NULL,
    [CurCity]           VARCHAR (65)  NULL,
    [CurState]          VARCHAR (25)  NULL,
    [CurZip]            VARCHAR (20)  NULL,
    [CurCounty]         VARCHAR (65)  NULL,
    [CurLoadDate]       DATE          NULL,
    [CurDataDate]       DATE          NULL,
    [AddressTypeKey]    INT           NULL,
    [NewExpirationDate] DATE          NULL
);

