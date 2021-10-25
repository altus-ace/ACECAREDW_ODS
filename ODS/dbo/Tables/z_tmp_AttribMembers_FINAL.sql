CREATE TABLE [dbo].[z_tmp_AttribMembers_FINAL] (
    [URN]               INT           IDENTITY (1, 1) NOT NULL,
    [SourceJob]         VARCHAR (50)  NULL,
    [adiKey]            INT           NULL,
    [ClientMemberKey]   VARCHAR (50)  NULL,
    [ClientKey]         INT           NULL,
    [AttribNPI]         VARCHAR (20)  NULL,
    [EffYr]             INT           NULL,
    [EffMth]            INT           NULL,
    [EffYYYYMM]         INT           NULL,
    [AttribAcctType]    VARCHAR (20)  NULL,
    [AttribChapter]     VARCHAR (50)  NULL,
    [CreateDate]        DATE          DEFAULT (getdate()) NULL,
    [CreateBy]          VARCHAR (50)  DEFAULT (suser_sname()) NULL,
    [NPIName]           VARCHAR (100) NULL,
    [ClientName]        VARCHAR (30)  NULL,
    [EffectiveAsOfDate] DATE          NULL
);

