CREATE TABLE [ast].[Temp_QmResults_ForNonActiveMembers] (
    [skey]            INT          NOT NULL,
    [Clientkey]       INT          NOT NULL,
    [ClientMemberKey] VARCHAR (50) NOT NULL,
    [qmMsrId]         VARCHAR (25) NOT NULL,
    [minQmDate]       DATE         NULL,
    [MinDay]          DATE         NULL,
    [maxDay]          DATE         NULL,
    [minMbrMonth]     DATE         NULL,
    [aAction]         VARCHAR (6)  NOT NULL
);

