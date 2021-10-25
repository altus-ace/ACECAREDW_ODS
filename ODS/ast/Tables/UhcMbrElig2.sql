CREATE TABLE [ast].[UhcMbrElig2] (
    [SKey]        INT          IDENTITY (1, 1) NOT NULL,
    [CMK]         VARCHAR (50) NULL,
    [SubGrpID]    VARCHAR (20) NULL,
    [CsPlan]      VARCHAR (50) NULL,
    [prTin]       CHAR (10)    NULL,
    [MbrTin]      CHAR (10)    NULL,
    [MbrLoadDate] DATE         NULL,
    [StartDate]   DATE         NULL,
    [EndDate]     DATE         NULL,
    [Active]      TINYINT      NULL,
    [createddate] DATE         NULL,
    [createdby]   VARCHAR (20) NULL
);

