CREATE TABLE [ast].[MbrCreateExportProgramWC015] (
    [SKey]                 INT           IDENTITY (1, 1) NOT NULL,
    [DateOfBirth]          DATE          NOT NULL,
    [fifteenthBday]        DATE          NOT NULL,
    [FirstDayMonth]        DATE          NOT NULL,
    [LoadDate]             DATE          NOT NULL,
    [ClientKey]            INT           NOT NULL,
    [ClientMemberKey]      VARCHAR (50)  NOT NULL,
    [ProgramID]            INT           NULL,
    [CsExportLobName]      VARCHAR (20)  NOT NULL,
    [ExpProgramName]       VARCHAR (20)  NULL,
    [ExpEnrollDate]        DATE          NULL,
    [ExpCreateDate]        DATE          NULL,
    [ExpMemberID]          VARCHAR (255) NULL,
    [ExpEnrollEndDate]     DATE          NULL,
    [ExpProgramStatus]     VARCHAR (6)   NOT NULL,
    [ExpReasonDescription] VARCHAR (21)  NOT NULL,
    [ExpReferalType]       VARCHAR (8)   NOT NULL,
    PRIMARY KEY CLUSTERED ([SKey] ASC)
);

