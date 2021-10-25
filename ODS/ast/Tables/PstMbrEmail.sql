CREATE TABLE [ast].[PstMbrEmail] (
    [PstMbrEmailKey]      INT           IDENTITY (1, 1) NOT NULL,
    [adiKey]              INT           NOT NULL,
    [AdiTableName]        VARCHAR (100) NOT NULL,
    [stgRowStatus]        VARCHAR (20)  NOT NULL,
    [LoadDate]            DATETIME      NOT NULL,
    [CreatedDate]         DATETIME      CONSTRAINT [DF_PstMbrEmail_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]           VARCHAR (50)  CONSTRAINT [DF_PstMbrEmail_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [srcEmailAddress]     VARCHAR (100) NULL,
    [transEffectiveDate]  DATE          NULL,
    [transExpirationDate] DATE          CONSTRAINT [DF_PstMbrEmailExpirationDate] DEFAULT ('12/31/9999') NULL,
    [transEmailType]      INT           NULL,
    [transIsPrimary]      TINYINT       CONSTRAINT [DF_PstMbrEmail_IsPrimary] DEFAULT ((0)) NULL,
    [mbrMemberKey]        INT           NULL,
    [mbrEmailKey]         INT           NULL,
    [mbrLoadHistoryKey]   INT           NULL,
    PRIMARY KEY CLUSTERED ([PstMbrEmailKey] ASC),
    CONSTRAINT [CK_PstMbrEmail_stgRowStatus] CHECK ([stgRowStatus]='Exported' OR [stgRowStatus]='Valid' OR [stgRowStatus]='Loaded')
);

