CREATE TABLE [ast].[UhcMbrElig] (
    [SKey]        INT          IDENTITY (1, 1) NOT NULL,
    [CMK]         VARCHAR (50) NULL,
    [SubGrpID]    VARCHAR (20) NULL,
    [CsPlan]      VARCHAR (50) NULL,
    [prTin]       CHAR (10)    NULL,
    [MbrTin]      CHAR (10)    NULL,
    [MbrLoadDate] DATE         NULL,
    [StartDate]   DATE         NULL,
    [EndDate]     DATE         NULL,
    [Active]      TINYINT      DEFAULT ((1)) NULL,
    [createddate] DATE         DEFAULT (getdate()) NULL,
    [createdby]   VARCHAR (20) DEFAULT (suser_sname()) NULL,
    PRIMARY KEY CLUSTERED ([SKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ndx_AstUhcMbrElig_ActStartEnd]
    ON [ast].[UhcMbrElig]([Active] ASC, [StartDate] ASC, [EndDate] ASC);

