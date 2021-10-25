CREATE TABLE [adw].[MbrPlan] (
    [mbrPlanKey]           INT           IDENTITY (1, 1) NOT NULL,
    [mbrMemberKey]         INT           NOT NULL,
    [mbrLoadKey]           INT           NOT NULL,
    [EffectiveDate]        DATE          NOT NULL,
    [ExpirationDate]       DATE          CONSTRAINT [DF_MbrPlanExpirationDate] DEFAULT ('12/31/9999') NOT NULL,
    [ProductPlan]          VARCHAR (100) NULL,
    [ProductSubPlan]       VARCHAR (100) NULL,
    [ProductSubPlanName]   VARCHAR (100) NULL,
    [MbrIsDualCoverage]    TINYINT       CONSTRAINT [DF_MbrPlanMbrIsDualCoverage] DEFAULT ((-1)) NOT NULL,
    [DualEligiblityStatus] CHAR (2)      DEFAULT ((99)) NOT NULL,
    [ClientPlanEffective]  DATE          NULL,
    [LoadDate]             DATE          NOT NULL,
    [DataDate]             DATE          NOT NULL,
    [CreatedDate]          DATETIME2 (7) CONSTRAINT [DF_MbrPlan_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]            VARCHAR (50)  CONSTRAINT [DF_MbrPlan_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]      DATETIME2 (7) CONSTRAINT [DF_MbrPlan_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]        VARCHAR (50)  CONSTRAINT [DF_MbrPlan_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([mbrPlanKey] ASC),
    CONSTRAINT [CK_MbrPlanMbrIsDualCoverage] CHECK ([MbrIsDualCoverage]=(0) OR [MbrIsDualCoverage]=(1) OR [MbrIsDualCoverage]=(-1)),
    CONSTRAINT [FK_MbrPlan_MbrLoadHistory] FOREIGN KEY ([mbrLoadKey]) REFERENCES [adw].[MbrLoadHistory] ([mbrLoadHistoryKey]),
    CONSTRAINT [FK_MbrPlan_MbrMember] FOREIGN KEY ([mbrMemberKey]) REFERENCES [adw].[MbrMember] ([mbrMemberKey])
);


GO
CREATE NONCLUSTERED INDEX [Ndx_MbrPlan_EffDateExpDate]
    ON [adw].[MbrPlan]([EffectiveDate] ASC, [ExpirationDate] ASC)
    INCLUDE([mbrMemberKey], [mbrPlanKey], [ProductPlan], [ProductSubPlan], [ProductSubPlanName]);


GO
CREATE NONCLUSTERED INDEX [ndx_MbrPlan_MbrMbrKeyEffDateExpDate]
    ON [adw].[MbrPlan]([mbrMemberKey] ASC, [EffectiveDate] ASC, [ExpirationDate] ASC);


GO

CREATE TRIGGER adw.[AU_MbrPlan]
ON adw.MbrPlan
AFTER UPDATE 
AS
   UPDATE adw.MbrPlan
   SET [LastUpdatedDate] = SYSDATETIME()
	   ,[LastUpdatedBy] = SYSTEM_USER	
   FROM Inserted i
   WHERE adw.MbrPlan.mbrPlanKey = i.mbrPlanKey
   ;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Yes (1)/No (0) / Unknown(-1)', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'MbrPlan', @level2type = N'COLUMN', @level2name = N'MbrIsDualCoverage';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The CMS Dual Eligiblity Codes domain', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'MbrPlan', @level2type = N'COLUMN', @level2name = N'DualEligiblityStatus';

