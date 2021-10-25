CREATE TABLE [dbo].[UHC_QM_AccessToCare] (
    [URN]                INT           IDENTITY (1, 1) NOT NULL,
    [PracticeID]         VARCHAR (50)  NULL,
    [ProviderID]         VARCHAR (50)  NULL,
    [MemberID]           VARCHAR (50)  NULL,
    [MemberFullName]     VARCHAR (100) NULL,
    [DOB]                DATETIME      NULL,
    [ApptCreateDate]     DATETIME      NULL,
    [ApptSeenDate]       DATETIME      NULL,
    [AccountName]        VARCHAR (100) NULL,
    [ReasonForVisit]     VARCHAR (100) NULL,
    [Event]              VARCHAR (50)  NULL,
    [ApptStatus]         VARCHAR (50)  NULL,
    [ApptCancelReason]   VARCHAR (80)  NULL,
    [PayerName]          VARCHAR (50)  NULL,
    [PolicyNumber]       VARCHAR (50)  NULL,
    [A_LAST_UPDATE_DATE] DATETIME      DEFAULT (getdate()) NULL,
    [A_LAST_UPDATE_BY]   VARCHAR (50)  DEFAULT ('PKG Import') NULL,
    [A_LAST_UPDATE_FLAG] VARCHAR (1)   DEFAULT ('Y') NULL
);

