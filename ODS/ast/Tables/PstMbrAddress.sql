CREATE TABLE [ast].[PstMbrAddress] (
    [PstMbrAddressKey]    INT           IDENTITY (1, 1) NOT NULL,
    [adiKey]              INT           NOT NULL,
    [AdiTableName]        VARCHAR (100) NOT NULL,
    [stgRowStatus]        VARCHAR (20)  NOT NULL,
    [LoadDate]            DATETIME      NOT NULL,
    [CreatedDate]         DATETIME      CONSTRAINT [DF_PstMbrAddress_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]           VARCHAR (50)  CONSTRAINT [DF_PstMbrAddress_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [srcAddress1]         VARCHAR (100) NULL,
    [srcAddress2]         VARCHAR (100) NULL,
    [srcCITY]             VARCHAR (65)  NULL,
    [srcSTATE]            CHAR (25)     NULL,
    [srcZIP]              VARCHAR (20)  NULL,
    [srcCOUNTY]           VARCHAR (65)  NULL,
    [transEffectiveDate]  DATE          NULL,
    [transExpirationDate] DATE          CONSTRAINT [DF_PstMbrAddressExpirationDate] DEFAULT ('12/31/9999') NULL,
    [transAddressTypeKey] INT           NULL,
    [mbrMemberKey]        INT           NULL,
    [mbrAddressKey]       INT           NULL,
    [mbrLoadHistoryKey]   INT           NULL,
    PRIMARY KEY CLUSTERED ([PstMbrAddressKey] ASC),
    CONSTRAINT [CK_PstMbrAddress_stgRowStatus] CHECK ([stgRowStatus]='Exported' OR [stgRowStatus]='Valid' OR [stgRowStatus]='Loaded')
);

