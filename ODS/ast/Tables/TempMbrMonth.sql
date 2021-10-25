CREATE TABLE [ast].[TempMbrMonth] (
    [skey]            INT          IDENTITY (1, 1) NOT NULL,
    [Clientkey]       INT          NOT NULL,
    [ClientMemberKey] VARCHAR (50) NOT NULL,
    [minMbrMonth]     DATE         NULL,
    [minDay]          DATE         NULL,
    [maxDay]          DATE         NULL,
    PRIMARY KEY CLUSTERED ([skey] ASC)
);

