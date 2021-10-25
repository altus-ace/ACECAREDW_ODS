CREATE TABLE [adw].[mbrCsPlanHistory] (
    [mbrCsPlanKey]      INT           IDENTITY (1, 1) NOT NULL,
    [MbrMemberKey]      INT           NOT NULL,
    [MbrLoadKey]        BIGINT        NOT NULL,
    [EffectiveDate]     DATE          NOT NULL,
    [ExpirationDate]    DATE          CONSTRAINT [DF_CsMbrPlanHistory_ExpirationDate] DEFAULT ('12/31/9999') NOT NULL,
    [MbrCsSubPlan]      VARCHAR (50)  NULL,
    [MbrCsSubPlanName]  VARCHAR (50)  NULL,
    [exported]          INT           CONSTRAINT [DF_CsMbrPlanHistory_Exported] DEFAULT ((0)) NOT NULL,
    [exportedDate]      DATE          CONSTRAINT [DF_CsMbrPlanHistory_ExportedDate] DEFAULT (CONVERT([date],'12/31/1980')) NOT NULL,
    [planHistoryStatus] TINYINT       CONSTRAINT [DF_CsMbrPlanHistory_PlanHistoryStatus] DEFAULT ((1)) NOT NULL,
    [LoadDate]          DATE          CONSTRAINT [DF_CsMbrPlanHistory_LoadDate] DEFAULT (getdate()) NOT NULL,
    [DataDate]          DATE          NOT NULL,
    [CreatedDate]       DATETIME2 (7) CONSTRAINT [DF_mbrCsPlanHistory_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]         VARCHAR (50)  CONSTRAINT [DF_mbrCsPlanHistory_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]   DATETIME2 (7) CONSTRAINT [DF_mbrCsPlanHistory_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]     VARCHAR (50)  CONSTRAINT [DF_mbrCsPlanHistory_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([mbrCsPlanKey] ASC),
    CONSTRAINT [CK_CsMbrPlanHistory_PlanHistoryStatus] CHECK ([planHistoryStatus]=(0) OR [planHistoryStatus]=(1)),
    CONSTRAINT [FK_mbrCsPlanHistory_MbrMember] FOREIGN KEY ([MbrMemberKey]) REFERENCES [adw].[MbrMember] ([mbrMemberKey])
);


GO
CREATE NONCLUSTERED INDEX [Ndx_MbrCsPlanHist_EffDateExpDate]
    ON [adw].[mbrCsPlanHistory]([EffectiveDate] ASC, [ExpirationDate] ASC)
    INCLUDE([MbrMemberKey], [mbrCsPlanKey], [MbrCsSubPlan], [MbrCsSubPlanName]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_mbrCsPlanHistory_6_989962603__K2_K4_K5_K6_K7_K1]
    ON [adw].[mbrCsPlanHistory]([MbrMemberKey] ASC, [EffectiveDate] ASC, [ExpirationDate] ASC, [MbrCsSubPlan] ASC, [MbrCsSubPlanName] ASC, [mbrCsPlanKey] ASC);


GO
CREATE NONCLUSTERED INDEX [ndx_AdwMbrCsPlanHist_PlnHistStatEffDateExpDate]
    ON [adw].[mbrCsPlanHistory]([planHistoryStatus] ASC, [EffectiveDate] ASC, [ExpirationDate] ASC)
    INCLUDE([mbrCsPlanKey], [MbrMemberKey], [MbrCsSubPlanName]);


GO
CREATE TRIGGER adw.[AU_MbrCsPlanHistory]
ON adw.MbrCsPlanHistory
AFTER UPDATE 
AS
   UPDATE adw.MbrCsPlanHistory
   SET [LastUpdatedDate] = SYSDATETIME()
	   ,[LastUpdatedBy] = SYSTEM_USER	
   FROM Inserted i
   WHERE adw.MbrCsPlanHistory.mbrCSPlanKey = i.mbrCSPlanKey
   ;
