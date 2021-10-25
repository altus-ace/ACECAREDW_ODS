CREATE TABLE [adw].[A_ALT_MemberPlanHistoryBK] (
    [A_ALT_MemberPlanHistory_ID] INT                              IDENTITY (1, 1) NOT NULL,
    [Client_Member_ID]           [adw].[Client_Member_Identifier] NOT NULL,
    [A_Client_ID]                INT                              NOT NULL,
    [Benefit_Plan]               VARCHAR (150)                    NOT NULL,
    [startDate]                  DATETIME2 (7)                    NOT NULL,
    [stopDate]                   DATETIME2 (7)                    NOT NULL,
    [planHistoryStatus]          INT                              NOT NULL,
    [loadDate]                   DATETIME2 (7)                    NOT NULL,
    [exported]                   INT                              NOT NULL,
    [exportedDate]               DATETIME2 (7)                    NOT NULL,
    [A_CREATED_DATE]             DATETIME                         NOT NULL,
    [A_CREATED_BY]               VARCHAR (150)                    NOT NULL,
    [A_UPDATED_DATE]             DATETIME                         NOT NULL,
    [A_UPDATED_BY]               VARCHAR (150)                    NOT NULL
);

