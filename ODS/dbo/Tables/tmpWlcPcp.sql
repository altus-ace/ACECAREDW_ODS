CREATE TABLE [dbo].[tmpWlcPcp] (
    [mbrLoadHistoryKey]   INT          NULL,
    [MbrMemberKey]        INT          NULL,
    [mbrPcpKey]           INT          NULL,
    [loadType]            CHAR (1)     NULL,
    [NewEffectiveDate]    DATE         NULL,
    [NewExpirationDate]   DATE         NULL,
    [NewPcpNpi]           VARCHAR (10) NULL,
    [NewPcpTin]           VARCHAR (10) NULL,
    [NewAutoAssign]       VARCHAR (10) NULL,
    [NewClientEffective]  DATE         NULL,
    [NewClientExpiration] DATE         NULL,
    [NewDataDate]         DATE         NULL,
    [CurNpi]              VARCHAR (10) NULL,
    [CurTIN]              VARCHAR (10) NULL,
    [CurAutoAssign]       VARCHAR (10) NULL,
    [CurEffectiveDate]    DATE         NULL,
    [CurExpirationDate]   DATE         NULL,
    [CurClientEffective]  DATE         NULL,
    [CurClientExpiration] DATE         NULL,
    [CurDataDate]         DATE         NULL
);

