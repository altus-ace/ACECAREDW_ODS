CREATE TABLE [adw].[A_ALT_MemberPlanHistory_Backup] (
    [A_ALT_MemberPlanHistory_ID] INT           IDENTITY (1, 1) NOT NULL,
    [Client_Member_ID]           VARCHAR (50)  NOT NULL,
    [A_Client_ID]                INT           NOT NULL,
    [Benefit_Plan]               VARCHAR (150) NOT NULL,
    [startDate]                  DATETIME2 (7) NOT NULL,
    [stopDate]                   DATETIME2 (7) NOT NULL,
    [planHistoryStatus]          INT           NOT NULL,
    [loadDate]                   DATETIME2 (7) DEFAULT (getdate()) NOT NULL,
    [exported]                   INT           DEFAULT ((0)) NOT NULL,
    [exportedDate]               DATETIME2 (7) DEFAULT (CONVERT([datetime2],'01/01/1980')) NOT NULL,
    [A_CREATED_DATE]             DATETIME      DEFAULT (getdate()) NOT NULL,
    [A_CREATED_BY]               VARCHAR (150) DEFAULT (suser_sname()) NOT NULL,
    [A_UPDATED_DATE]             DATETIME      DEFAULT (getdate()) NOT NULL,
    [A_UPDATED_BY]               VARCHAR (150) DEFAULT (suser_sname()) NOT NULL
);

