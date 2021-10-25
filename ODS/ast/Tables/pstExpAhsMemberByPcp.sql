CREATE TABLE [ast].[pstExpAhsMemberByPcp] (
    [pstExpAhsMemberByPcpKey]     INT           IDENTITY (1, 1) NOT NULL,
    [CreatedDate]                 DATETIME      DEFAULT (getdate()) NULL,
    [CreatedBy]                   VARCHAR (50)  DEFAULT (suser_sname()) NULL,
    [AdiTableName]                VARCHAR (100) NULL,
    [AdiKey]                      INT           NOT NULL,
    [RowStatus]                   TINYINT       DEFAULT ((0)) NOT NULL,
    [ClientKey]                   INT           DEFAULT ((0)) NOT NULL,
    [ClientMemberKey]             VARCHAR (50)  NULL,
    [expMember_ID]                VARCHAR (50)  NULL,
    [expMemberPcpNpi]             VARCHAR (20)  NULL,
    [ExpProviderRelationshipType] VARCHAR (50)  NULL,
    [expLOB]                      VARCHAR (50)  NULL,
    [expPcpEffectiveDate]         DATE          NULL,
    [expPcpTermDateDate]          DATE          NULL,
    [expMemPcpAddInfo]            VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([pstExpAhsMemberByPcpKey] ASC)
);

