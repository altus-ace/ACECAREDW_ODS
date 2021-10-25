CREATE TABLE [adw].[ZZ_A_MemberPlanHistory] (
    [urn]               BIGINT        IDENTITY (1, 1) NOT NULL,
    [member_ID]         INT           NOT NULL,
    [subgrp_ID]         VARCHAR (20)  NOT NULL,
    [subgrpName]        VARCHAR (150) NOT NULL,
    [startDate]         DATETIME2 (7) NOT NULL,
    [stopDate]          DATETIME2 (7) NOT NULL,
    [planHistoryStatus] INT           NOT NULL,
    [loadDate]          DATETIME2 (7) DEFAULT (getdate()) NOT NULL,
    [exported]          INT           DEFAULT ((0)) NOT NULL,
    [exportedDate]      DATETIME2 (7) DEFAULT (CONVERT([datetime2],'01/01/1980')) NOT NULL,
    [A_CREATED_DATE]    DATETIME      DEFAULT (getdate()) NULL,
    [A_CREATED_BY]      VARCHAR (150) DEFAULT (suser_sname()) NULL,
    [A_UPDATED_DATE]    DATETIME      DEFAULT (getdate()) NULL,
    [A_UPDATED_BY]      VARCHAR (150) DEFAULT (suser_sname()) NULL,
    PRIMARY KEY CLUSTERED ([urn] ASC)
);

