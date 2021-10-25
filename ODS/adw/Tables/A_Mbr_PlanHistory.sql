CREATE TABLE [adw].[A_Mbr_PlanHistory] (
    [A_Member_Plan_History_ID] BIGINT                           IDENTITY (1, 1) NOT NULL,
    [A_Client_ID]              INT                              NOT NULL,
    [Client_Member_ID]         [adw].[Client_Member_Identifier] NOT NULL,
    [Benefit_Plan]             VARCHAR (150)                    NOT NULL,
    [SubGroup_ID]              VARCHAR (20)                     NOT NULL,
    [SubgrpName]               VARCHAR (150)                    NOT NULL,
    [startDate]                DATETIME2 (7)                    NOT NULL,
    [stopDate]                 DATETIME2 (7)                    NOT NULL,
    [planHistoryStatus]        INT                              NOT NULL,
    [loadDate]                 DATETIME2 (7)                    DEFAULT (getdate()) NOT NULL,
    [A_CREATED_DATE]           DATETIME                         DEFAULT (getdate()) NOT NULL,
    [A_CREATED_BY]             VARCHAR (150)                    DEFAULT (suser_sname()) NOT NULL,
    [A_UPDATED_DATE]           DATETIME                         DEFAULT (getdate()) NOT NULL,
    [A_UPDATED_BY]             VARCHAR (150)                    DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([A_Member_Plan_History_ID] ASC)
);

