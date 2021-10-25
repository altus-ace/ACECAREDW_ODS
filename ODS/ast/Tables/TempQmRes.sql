CREATE TABLE [ast].[TempQmRes] (
    [skey]            INT          IDENTITY (1, 1) NOT NULL,
    [Clientkey]       INT          NOT NULL,
    [ClientMemberKey] VARCHAR (50) NOT NULL,
    [qmMsrId]         VARCHAR (25) NOT NULL,
    [minQmDate]       DATE         NULL,
    [MinDay]          DATE         NULL,
    [maxDay]          DATE         NULL,
    PRIMARY KEY CLUSTERED ([skey] ASC)
);

