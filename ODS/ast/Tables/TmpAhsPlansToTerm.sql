CREATE TABLE [ast].[TmpAhsPlansToTerm] (
    [A_ALT_MemberPlanHistory_ID] INT                              NOT NULL,
    [Client_Member_ID]           [adw].[Client_Member_Identifier] NOT NULL,
    [startDate]                  DATETIME2 (7)                    NOT NULL,
    [stopDate]                   DATETIME2 (7)                    NOT NULL,
    [planHistoryStatus]          INT                              NOT NULL,
    [NewTermDate]                DATE                             NULL,
    [UpdateStatus]               TINYINT                          DEFAULT ((0)) NOT NULL,
    [createdDate]                DATE                             DEFAULT (getdate()) NULL,
    [CreatedBy]                  VARCHAR (20)                     DEFAULT (suser_sname()) NULL,
    PRIMARY KEY CLUSTERED ([A_ALT_MemberPlanHistory_ID] ASC)
);

