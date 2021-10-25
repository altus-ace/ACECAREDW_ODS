﻿CREATE TABLE [dbo].[UHC_QM_DC_HgbA1c] (
    [URN]                INT           IDENTITY (1, 1) NOT NULL,
    [MemberID]           VARCHAR (50)  NULL,
    [MemberFullName]     VARCHAR (100) NULL,
    [AssignedCC]         VARCHAR (50)  NULL,
    [AssessingCC]        VARCHAR (50)  NULL,
    [ManagerFullName]    VARCHAR (100) NULL,
    [LOBName]            VARCHAR (50)  NULL,
    [ProgramName]        VARCHAR (50)  NULL,
    [PlanName]           VARCHAR (50)  NULL,
    [DOD]                DATETIME      NULL,
    [DOB]                DATETIME      NULL,
    [CurrentLabValue]    VARCHAR (50)  NULL,
    [PrevLabValue]       VARCHAR (50)  NULL,
    [LastLabDate]        DATETIME      NULL,
    [CurrentLabDate]     DATETIME      NULL,
    [NormalLabValue]     VARCHAR (50)  NULL,
    [Filler1]            VARCHAR (50)  NULL,
    [A_LAST_UPDATE_DATE] DATETIME      DEFAULT (getdate()) NULL,
    [A_LAST_UPDATE_BY]   VARCHAR (50)  DEFAULT ('PKG Import') NULL,
    [A_LAST_UPDATE_FLAG] VARCHAR (1)   DEFAULT ('Y') NULL
);

