CREATE TABLE [adw].[ExportAhsEligiblity] (
    [pstExpAhsEligiblityKey] INT           IDENTITY (1, 1) NOT NULL,
    [CreatedDate]            DATETIME      DEFAULT (getdate()) NULL,
    [CreatedBy]              VARCHAR (50)  DEFAULT (suser_sname()) NULL,
    [lastUpdatedDate]        DATETIME      DEFAULT (getdate()) NULL,
    [LastUpdatedBy]          VARCHAR (50)  DEFAULT (suser_sname()) NULL,
    [AdiTableName]           VARCHAR (100) NULL,
    [AdiKey]                 INT           NOT NULL,
    [LoadDate]               DATE          NOT NULL,
    [ExportStatus]           TINYINT       DEFAULT ((0)) NOT NULL,
    [ExportDate]             DATETIME      DEFAULT ('01/01/1900') NOT NULL,
    [ClientKey]              INT           DEFAULT ((0)) NOT NULL,
    [ClientMemberKey]        VARCHAR (50)  NULL,
    [MbrCsPlanKey]           INT           NULL,
    [expMember_ID]           VARCHAR (50)  NULL,
    [expLOB]                 VARCHAR (50)  NULL,
    [expBENEFIT_PLAN]        VARCHAR (100) NULL,
    [expInt_Ext_Indicator]   VARCHAR (150) NULL,
    [expStartDate]           DATE          NULL,
    [expStopDate]            DATE          NULL,
    PRIMARY KEY CLUSTERED ([pstExpAhsEligiblityKey] ASC)
);

