CREATE TABLE [dbo].[tmpWlcPlan] (
    [mbrLoadHistoryKey]     INT          NULL,
    [mbrMemberKey]          INT          NULL,
    [mbrPlanKey]            INT          NULL,
    [NewEffectiveDate]      DATE         NULL,
    [NewExpirationDate]     DATE         NULL,
    [loadType]              CHAR (1)     NULL,
    [NewProductPlan]        VARCHAR (20) NULL,
    [NewProductSubPlan]     VARCHAR (20) NULL,
    [NewProductSubPlanName] VARCHAR (50) NULL,
    [NewMbrIsDualCoverage]  TINYINT      NULL,
    [NewDataDate]           DATE         NULL,
    [CurProductPlan]        VARCHAR (20) NULL,
    [CurProductSubPlan]     VARCHAR (20) NULL,
    [CurProductSubPlanName] VARCHAR (50) NULL,
    [CurMbrIsDualCoverage]  TINYINT      NULL
);

