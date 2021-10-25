CREATE TABLE [ast].[tmpUhcMbrTermCsPlan] (
    [sKey]                       INT          IDENTITY (1, 1) NOT NULL,
    [createdDate]                DATETIME     DEFAULT (getdate()) NOT NULL,
    [createdBy]                  VARCHAR (20) DEFAULT (suser_sname()) NOT NULL,
    [A_ALT_MemberPlanHistory_ID] INT          NOT NULL,
    [ClientMemberkey]            VARCHAR (50) NOT NULL,
    [EffDate]                    DATE         NULL,
    [ExpDate]                    DATE         NULL,
    [SubGrpID]                   VARCHAR (20) NULL,
    [TargetCsPlan]               VARCHAR (20) NULL,
    [SrcTin]                     VARCHAR (12) NULL,
    [PrTin]                      VARCHAR (12) NULL
);

