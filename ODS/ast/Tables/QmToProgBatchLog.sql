﻿CREATE TABLE [ast].[QmToProgBatchLog] (
    [LogKey]          INT          IDENTITY (1, 1) NOT NULL,
    [ClientMemberKey] VARCHAR (50) NULL,
    [QmMsrId]         VARCHAR (50) NULL,
    [QmCntCat]        VARCHAR (5)  NULL,
    [QmDate]          DATE         NULL,
    [RecStatus]       VARCHAR (1)  NULL,
    [EventDate]       DATETIME     DEFAULT (getdate()) NULL,
    [CreatedDate]     DATETIME     DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       VARCHAR (50) DEFAULT (suser_sname()) NULL,
    PRIMARY KEY CLUSTERED ([LogKey] ASC)
);

