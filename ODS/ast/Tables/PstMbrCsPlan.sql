CREATE TABLE [ast].[PstMbrCsPlan] (
    [PstMbrCsPlanKey]       INT           IDENTITY (1, 1) NOT NULL,
    [adiKey]                INT           NOT NULL,
    [AdiTableName]          VARCHAR (100) NOT NULL,
    [stgRowStatus]          VARCHAR (20)  NOT NULL,
    [LoadDate]              DATETIME      NOT NULL,
    [CreatedDate]           DATETIME      CONSTRAINT [DF_PstMbrCsPlan_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]             VARCHAR (50)  CONSTRAINT [DF_PstMbrCsPlan_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [srcSubPlanCode]        VARCHAR (20)  NULL,
    [srcSubPlanName]        VARCHAR (20)  NULL,
    [transEffectiveDate]    DATE          NULL,
    [transExpirationDate]   DATE          CONSTRAINT [DF_CsMbrPlanHistory_ExpirationDate] DEFAULT ('12/31/9999') NULL,
    [transMbrCsSubPlan]     VARCHAR (20)  NULL,
    [transMbrCsSubPlanName] VARCHAR (50)  NULL,
    [MbrMemberKey]          INT           NULL,
    [mbrCsPlanKey]          INT           NULL,
    [mbrLoadHistoryKey]     INT           NULL,
    PRIMARY KEY CLUSTERED ([PstMbrCsPlanKey] ASC),
    CONSTRAINT [CK_PstMbrCsPlan_stgRowStatus] CHECK ([stgRowStatus]='Exported' OR [stgRowStatus]='Valid' OR [stgRowStatus]='Loaded')
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Client Plan Sub COde, IE the identifying detail Ace Maps to CS Plan', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'PstMbrCsPlan', @level2type = N'COLUMN', @level2name = N'transMbrCsSubPlan';

