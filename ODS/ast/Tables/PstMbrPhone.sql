CREATE TABLE [ast].[PstMbrPhone] (
    [PstMbrPhoneKey]      INT           IDENTITY (1, 1) NOT NULL,
    [adiKey]              INT           NOT NULL,
    [AdiTableName]        VARCHAR (100) NOT NULL,
    [stgRowStatus]        VARCHAR (20)  NOT NULL,
    [LoadDate]            DATETIME      NOT NULL,
    [CreatedDate]         DATETIME      CONSTRAINT [DF_PstMbrPhone_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]           VARCHAR (50)  CONSTRAINT [DF_PstMbrPhone_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [PhoneType]           INT           NULL,
    [CarrierType]         INT           NULL,
    [PhoneNumber]         VARCHAR (30)  NULL,
    [IsPrimary]           TINYINT       CONSTRAINT [DF_MbrPhone_IsPrimary] DEFAULT ((0)) NULL,
    [transEffectiveDate]  DATE          NULL,
    [transExpirationDate] DATE          CONSTRAINT [DF_MbrPhoneExpirationDate] DEFAULT ('12/31/9999') NULL,
    [mbrMemberKey]        INT           NULL,
    [mbrPhoneKey]         INT           NULL,
    [mbrLoadHistoryKey]   INT           NULL,
    PRIMARY KEY CLUSTERED ([PstMbrPhoneKey] ASC),
    CONSTRAINT [CK_PstMbrPhone_stgRowStatus] CHECK ([stgRowStatus]='Exported' OR [stgRowStatus]='Valid' OR [stgRowStatus]='Loaded')
);

