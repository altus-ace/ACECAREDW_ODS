CREATE TABLE [dbo].[tmpWlcMbrMember] (
    [ClientMemberKey]      VARCHAR (50) NOT NULL,
    [ClientKey]            INT          NULL,
    [MstrMrnKey]           NUMERIC (15) NULL,
    [mbrLoadKey]           INT          NULL,
    [LoadDate]             DATE         NULL,
    [DataDate]             DATE         NULL,
    [ExistingMbrMemberKey] INT          NULL,
    PRIMARY KEY CLUSTERED ([ClientMemberKey] ASC)
);

