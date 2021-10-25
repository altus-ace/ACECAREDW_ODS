CREATE TABLE [ast].[QmToProgCurGaps] (
    [QmToProgCurCapKey] INT           IDENTITY (1, 1) NOT NULL,
    [ClientMemberKey]   VARCHAR (50)  NULL,
    [QmMsrId]           VARCHAR (50)  NULL,
    [QmCntCat]          VARCHAR (5)   NULL,
    [Addressed]         INT           CONSTRAINT [df_qmToProg_Addressed] DEFAULT ((0)) NULL,
    [CalcQmCntCat]      VARCHAR (5)   NULL,
    [QmDate]            DATE          NULL,
    [RecStatus]         VARCHAR (1)   NULL,
    [RecStatusDate]     DATE          NULL,
    [SendFlg]           INT           DEFAULT ((0)) NULL,
    [Srckey]            INT           NULL,
    [SrcTableName]      VARCHAR (100) NULL,
    [ClientKey]         INT           NULL,
    [CreatedDate]       DATETIME      DEFAULT (getdate()) NOT NULL,
    [CreatedBy]         VARCHAR (50)  DEFAULT (suser_sname()) NULL,
    PRIMARY KEY CLUSTERED ([QmToProgCurCapKey] ASC)
);

