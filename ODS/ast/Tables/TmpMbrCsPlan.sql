CREATE TABLE [ast].[TmpMbrCsPlan] (
    [Skey]        INT           IDENTITY (1, 1) NOT NULL,
    [CMK]         VARCHAR (50)  NULL,
    [CsPlanValue] VARCHAR (200) NULL,
    [SubGrpId]    VARCHAR (200) NULL,
    [EffDate]     DATE          NULL,
    [expDate]     DATE          DEFAULT ('12/31/2099') NULL,
    [CreatedDate] DATETIME      DEFAULT (getdate()) NULL,
    [CreatedUser] VARCHAR (50)  DEFAULT (suser_sname()) NULL,
    PRIMARY KEY CLUSTERED ([Skey] ASC)
);

