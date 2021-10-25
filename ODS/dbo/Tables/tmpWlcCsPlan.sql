CREATE TABLE [dbo].[tmpWlcCsPlan] (
    [mbrLoadHistoryKey]     INT          NULL,
    [mbrMemberKey]          INT          NULL,
    [mbrCsPlanKey]          INT          NULL,
    [NewEffectiveDate]      DATE         NULL,
    [NewExpirationDate]     DATE         NULL,
    [loadType]              CHAR (1)     NULL,
    [NewProductSubPlan]     VARCHAR (20) NULL,
    [NewProductSubPlanName] VARCHAR (50) NULL,
    [NewDataDate]           DATE         NULL,
    [CurProductSubPlan]     VARCHAR (20) NULL,
    [CurProductSubPlanName] VARCHAR (50) NULL
);

