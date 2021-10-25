CREATE TABLE [dbo].[z_CreateAetnaMAMembers] (
    [URN]             INT          IDENTITY (1, 1) NOT NULL,
    [adiKey]          INT          NULL,
    [ClientMemberKey] VARCHAR (50) NULL,
    [ClientKey]       INT          NULL,
    [EffDate]         DATE         NULL,
    [LoadDate]        DATE         NULL,
    [ActiveFlg]       INT          DEFAULT ((1)) NULL,
    [InsertRunId]     VARCHAR (10) NULL,
    [UpdateRunId]     VARCHAR (10) NULL,
    [CreateDate]      DATE         DEFAULT (getdate()) NULL,
    [CreateBy]        VARCHAR (50) DEFAULT (suser_sname()) NULL
);

