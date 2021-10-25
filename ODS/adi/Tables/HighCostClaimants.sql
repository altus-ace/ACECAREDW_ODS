CREATE TABLE [adi].[HighCostClaimants] (
    [HighCostClaimantssKey] INT           IDENTITY (1, 1) NOT NULL,
    [SubscriberId]          VARCHAR (50)  NULL,
    [ProspectiveRisk]       VARCHAR (10)  NULL,
    [PCPName]               VARCHAR (50)  NULL,
    [PrimaryDiagnoses]      VARCHAR (50)  NULL,
    [Admits]                INT           NULL,
    [ERVisits]              INT           NULL,
    [Iptnt]                 MONEY         NULL,
    [Optnt]                 MONEY         NULL,
    [Physn]                 MONEY         NULL,
    [Pharm]                 MONEY         NULL,
    [TotalNetPaid]          MONEY         NULL,
    [LastPCPVisit_AnyPCP]   DATE          NULL,
    [OrignalSrcFileName]    VARCHAR (100) NOT NULL,
    [SrcFileName]           VARCHAR (100) NOT NULL,
    [CreatedDate]           DATETIME2 (7) NOT NULL,
    [CreatedBy]             VARCHAR (50)  NOT NULL,
    [LastUpdatedDate]       DATETIME2 (7) NOT NULL,
    [LastUpdatedBy]         VARCHAR (50)  NOT NULL,
    PRIMARY KEY CLUSTERED ([HighCostClaimantssKey] ASC)
);

