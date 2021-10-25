CREATE TABLE [ast].[PstMbrPcp] (
    [PstMbrPcpKey]        INT           IDENTITY (1, 1) NOT NULL,
    [adiKey]              INT           NOT NULL,
    [AdiTableName]        VARCHAR (100) NOT NULL,
    [stgRowStatus]        VARCHAR (20)  NOT NULL,
    [LoadDate]            DATETIME      NOT NULL,
    [CreatedDate]         DATETIME      CONSTRAINT [DF_PstMbrPcp_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]           VARCHAR (50)  CONSTRAINT [DF_PstMbrPcp_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [srcNPI]              VARCHAR (10)  NOT NULL,
    [srcTIN]              VARCHAR (10)  NULL,
    [srcClientEffective]  DATE          NULL,
    [srcClientExpiration] DATE          NULL,
    [srcAutoAssigned]     VARCHAR (10)  NOT NULL,
    [transNPI]            VARCHAR (10)  NOT NULL,
    [transTIN]            VARCHAR (10)  NULL,
    [transEffectiveDate]  DATE          CONSTRAINT [DF_MbrPcpExpirationDate] DEFAULT ('12/31/9999') NOT NULL,
    [transExpirationDate] DATE          NOT NULL,
    [mbrMemberKey]        INT           NULL,
    [mbrPcpKey]           INT           NULL,
    [mbrLoadHistoryKey]   INT           NULL,
    PRIMARY KEY CLUSTERED ([PstMbrPcpKey] ASC),
    CONSTRAINT [CK_PstMbrPcp_stgRowStatus] CHECK ([stgRowStatus]='Exported' OR [stgRowStatus]='Valid' OR [stgRowStatus]='Loaded')
);

