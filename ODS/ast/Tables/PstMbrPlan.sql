CREATE TABLE [ast].[PstMbrPlan] (
    [PstMbrPlanKey]          INT           IDENTITY (1, 1) NOT NULL,
    [adiKey]                 INT           NOT NULL,
    [AdiTableName]           VARCHAR (100) NOT NULL,
    [stgRowStatus]           VARCHAR (20)  NOT NULL,
    [LoadDate]               DATETIME      NOT NULL,
    [CreatedDate]            DATETIME      CONSTRAINT [DF_PstMbrPlan_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]              VARCHAR (50)  CONSTRAINT [DF_PstMbrPlan_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [srcProductPlan]         VARCHAR (20)  NULL,
    [srcProductSubPlan]      VARCHAR (20)  NULL,
    [srcProductSubPlanName]  VARCHAR (50)  NULL,
    [srcMbrIsDualCoverage]   TINYINT       CONSTRAINT [DF_MbrPlanMbrIsDualCoverage] DEFAULT ((0)) NULL,
    [srcClientPlanEffective] DATE          NULL,
    [transEffectiveDate]     DATE          NULL,
    [transExpirationDate]    DATE          CONSTRAINT [DF_MbrPlanExpirationDate] DEFAULT ('12/31/9999') NULL,
    [mbrPlanKey]             INT           NULL,
    [mbrMemberKey]           INT           NULL,
    [mbrLoadHistoryKey]      INT           NULL,
    PRIMARY KEY CLUSTERED ([PstMbrPlanKey] ASC),
    CONSTRAINT [CK_PstMbrPlan_stgRowStatus] CHECK ([stgRowStatus]='Exported' OR [stgRowStatus]='Valid' OR [stgRowStatus]='Loaded')
);

