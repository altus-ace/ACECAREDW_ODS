CREATE TABLE [ast].[UhcTmpMbr] (
    [skey]        INT           IDENTITY (1, 1) NOT NULL,
    [createdDate] DATE          DEFAULT (getdate()) NULL,
    [CMK]         VARCHAR (50)  NOT NULL,
    [CsPlan]      VARCHAR (100) NULL,
    [csplanKey]   INT           NULL,
    [MbrPlan]     VARCHAR (100) NULL,
    [UhcSkey]     INT           NULL,
    PRIMARY KEY CLUSTERED ([skey] ASC)
);

