CREATE TABLE [dbo].[tmpWlcTermCsPlan] (
    [mbrCsPlanKey] INT          NOT NULL,
    [mbrMemberKey] INT          NOT NULL,
    [TERMDATE]     DATE         NULL,
    [BusinessRule] VARCHAR (20) NULL,
    PRIMARY KEY CLUSTERED ([mbrCsPlanKey] ASC)
);

