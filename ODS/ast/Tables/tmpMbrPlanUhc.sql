CREATE TABLE [ast].[tmpMbrPlanUhc] (
    [mbrStg2_MbrDataUrn]    INT          NULL,
    [plnProductPlan]        VARCHAR (20) NULL,
    [plnProductSubPlan]     VARCHAR (20) NULL,
    [plnProductSubPlanName] VARCHAR (50) NULL,
    [srcProductPlan]        VARCHAR (20) NULL,
    [srcProductSubPlan]     VARCHAR (20) NULL,
    [srcProductSubPlanName] VARCHAR (50) NULL,
    [AdiKey]                INT          NULL,
    [createdDate]           DATE         DEFAULT (getdate()) NULL,
    [CreatedBy]             VARCHAR (20) DEFAULT (suser_sname()) NULL
);

