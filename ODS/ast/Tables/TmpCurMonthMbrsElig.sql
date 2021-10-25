CREATE TABLE [ast].[TmpCurMonthMbrsElig] (
    [Skey]                       INT           NOT NULL,
    [CMK]                        VARCHAR (50)  NULL,
    [CsPlanValue]                VARCHAR (200) NULL,
    [SubGrpId]                   VARCHAR (200) NULL,
    [EffDate]                    DATE          NULL,
    [expDate]                    DATE          NULL,
    [A_ALT_MemberPlanHistory_ID] INT           NULL,
    [Benefit_Plan]               VARCHAR (150) NULL,
    [startDate]                  DATETIME2 (7) NULL,
    [StopDate]                   DATETIME2 (7) NULL,
    [planHistoryStatus]          INT           NULL
);

