CREATE TABLE [ast].[PstMbrMember] (
    [PstMbrMemberKey]    INT           IDENTITY (1, 1) NOT NULL,
    [adiKey]             INT           NOT NULL,
    [AdiTableName]       VARCHAR (100) NOT NULL,
    [stgRowStatus]       VARCHAR (20)  NOT NULL,
    [LoadDate]           DATETIME      NOT NULL,
    [CreatedDate]        DATETIME      CONSTRAINT [DF_PstMbrMember_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]          VARCHAR (50)  CONSTRAINT [DF_PstMbrMember_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [srcClientMemberKey] VARCHAR (50)  NULL,
    [transMstrMrnKey]    NUMERIC (15)  NULL,
    [transClientKey]     INT           NULL,
    [mbrMemberKey]       INT           NULL,
    [mbrLoadHistoryKey]  INT           NULL,
    PRIMARY KEY CLUSTERED ([PstMbrMemberKey] ASC),
    CONSTRAINT [CK_pstMbrMembers_stgRowStatus] CHECK ([stgRowStatus]='Exported' OR [stgRowStatus]='Valid' OR [stgRowStatus]='Loaded')
);

