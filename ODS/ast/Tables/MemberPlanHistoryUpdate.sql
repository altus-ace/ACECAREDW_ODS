CREATE TABLE [ast].[MemberPlanHistoryUpdate] (
    [mph_URN]            INT           NOT NULL,
    [PlanChangeStopDate] DATETIME      NOT NULL,
    [PlanHistoryStatus]  INT           NOT NULL,
    [UPdateUser]         VARCHAR (150) NOT NULL,
    [A_CREATED_DATE]     DATETIME      DEFAULT (getdate()) NULL,
    [A_CREATED_BY]       VARCHAR (150) DEFAULT (suser_sname()) NULL,
    CONSTRAINT [PK_astMemberPlanHistoryUpdate_mph_URN] PRIMARY KEY CLUSTERED ([mph_URN] ASC),
    UNIQUE NONCLUSTERED ([mph_URN] ASC)
);

