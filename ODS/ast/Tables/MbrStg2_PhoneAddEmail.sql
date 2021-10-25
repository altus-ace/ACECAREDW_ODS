﻿CREATE TABLE [ast].[MbrStg2_PhoneAddEmail] (
    [mbrStg2_PhoneAddEmailUrn] INT           IDENTITY (1, 1) NOT NULL,
    [ClientMemberKey]          VARCHAR (50)  NULL,
    [SrcFileName]              VARCHAR (100) NULL,
    [LoadType]                 VARCHAR (5)   CONSTRAINT [DF_astMbrStg2_PhoneAddEmail_LoadType] DEFAULT ('P') NULL,
    [LoadDate]                 DATE          NULL,
    [DataDate]                 DATE          NULL,
    [AdiTableName]             VARCHAR (100) NULL,
    [AdiKey]                   INT           NULL,
    [lstPhoneTypeKey]          INT           NULL,
    [PhoneNumber]              VARCHAR (35)  NULL,
    [PhoneCarrierType]         INT           NULL,
    [PhoneIsPrimary]           TINYINT       NULL,
    [lstAddressTypeKey]        INT           NULL,
    [AddAddress1]              VARCHAR (100) NULL,
    [AddAddress2]              VARCHAR (100) NULL,
    [AddCity]                  VARCHAR (65)  NULL,
    [AddState]                 VARCHAR (25)  NULL,
    [AddZip]                   VARCHAR (20)  NULL,
    [AddCounty]                VARCHAR (65)  NULL,
    [lstEmailTypeKey]          INT           NULL,
    [EmailAddress]             VARCHAR (100) NULL,
    [EmailIsPrimary]           TINYINT       NULL,
    [stgRowStatus]             VARCHAR (20)  CONSTRAINT [DF_astMbrStg2_MbrPhnAdd_StgRowStatus] DEFAULT ('Not Valid') NOT NULL,
    [CreateDate]               DATETIME      CONSTRAINT [DF_MbrStg2_PhoneAddEmail_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreateBy]                 VARCHAR (50)  CONSTRAINT [DF_MbrStg2_PhoneAddEmail_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [ClientKey]                INT           DEFAULT ((9)) NOT NULL,
    [mbrEmailKey]              INT           DEFAULT ((-1)) NULL,
    PRIMARY KEY CLUSTERED ([mbrStg2_PhoneAddEmailUrn] ASC),
    CONSTRAINT [CK_mbrStg2_PhoneAddEmail_stgRowStatus] CHECK ([stgRowStatus]='Exported' OR [stgRowStatus]='Valid' OR [stgRowStatus]='Loaded' OR [stgRowStatus]='Not Valid' OR [stgRowStatus]='Dups')
);


GO
CREATE NONCLUSTERED INDEX [IX_MbrStg2_PhoneAddEmail_LoadDate_stgRowStatus_ClientKey]
    ON [ast].[MbrStg2_PhoneAddEmail]([LoadDate] ASC, [stgRowStatus] ASC, [ClientKey] ASC)
    INCLUDE([ClientMemberKey], [SrcFileName], [LoadType], [DataDate], [AdiTableName], [AdiKey], [lstAddressTypeKey], [AddAddress1], [AddAddress2], [AddCity], [AddState], [AddZip]);

