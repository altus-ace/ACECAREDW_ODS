CREATE TABLE [adw].[A_ALT_MemberPlanHistory] (
    [A_ALT_MemberPlanHistory_ID] INT                              IDENTITY (1, 1) NOT NULL,
    [Client_Member_ID]           [adw].[Client_Member_Identifier] NOT NULL,
    [A_Client_ID]                INT                              NOT NULL,
    [Benefit_Plan]               VARCHAR (150)                    NOT NULL,
    [startDate]                  DATETIME2 (7)                    NOT NULL,
    [stopDate]                   DATETIME2 (7)                    NOT NULL,
    [planHistoryStatus]          INT                              NOT NULL,
    [loadDate]                   DATETIME2 (7)                    DEFAULT (getdate()) NOT NULL,
    [exported]                   INT                              DEFAULT ((0)) NOT NULL,
    [exportedDate]               DATETIME2 (7)                    DEFAULT (CONVERT([datetime2],'01/01/1980')) NOT NULL,
    [A_CREATED_DATE]             DATETIME                         DEFAULT (getdate()) NOT NULL,
    [A_CREATED_BY]               VARCHAR (150)                    DEFAULT (suser_sname()) NOT NULL,
    [A_UPDATED_DATE]             DATETIME                         DEFAULT (getdate()) NOT NULL,
    [A_UPDATED_BY]               VARCHAR (150)                    DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([A_ALT_MemberPlanHistory_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_AdwAltPlanHist_PlnHstStatusStartDateStopDate]
    ON [adw].[A_ALT_MemberPlanHistory]([planHistoryStatus] ASC, [startDate] ASC, [stopDate] ASC)
    INCLUDE([A_ALT_MemberPlanHistory_ID], [Client_Member_ID], [A_Client_ID], [Benefit_Plan]);


GO
CREATE NONCLUSTERED INDEX [ndx_AaltMbrPlanHist_PlnHstStatStartStopCMk]
    ON [adw].[A_ALT_MemberPlanHistory]([planHistoryStatus] ASC, [startDate] ASC, [stopDate] ASC, [Client_Member_ID] ASC);


GO
CREATE STATISTICS [_dta_stat_111339461_2_5]
    ON [adw].[A_ALT_MemberPlanHistory]([Client_Member_ID], [startDate]);


GO
CREATE STATISTICS [_dta_stat_111339461_3_2_7_5]
    ON [adw].[A_ALT_MemberPlanHistory]([A_Client_ID], [Client_Member_ID], [planHistoryStatus], [startDate]);

