﻿CREATE TABLE [ast].[AhsExpElig_MbrCsPlanInfo] (
    [Skey]              INT          IDENTITY (1, 1) NOT NULL,
    [createdDate]       DATE         DEFAULT (getdate()) NOT NULL,
    [createdBy]         VARCHAR (50) DEFAULT (suser_sname()) NOT NULL,
    [ClientKey]         INT          NOT NULL,
    [CMK]               VARCHAR (50) NOT NULL,
    [CsPlanName]        VARCHAR (50) NOT NULL,
    [CsPlanEffDate]     DATE         NOT NULL,
    [CsPlanExpDate]     DATE         NOT NULL,
    [FctMbrRwEffDate]   DATE         NOT NULL,
    [FctMbr_Skey]       INT          NOT NULL,
    [mbrCsPlanDim_SKey] INT          NOT NULL,
    PRIMARY KEY CLUSTERED ([Skey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ndx_AstAhxExpElig_MbrCsPlanInfo]
    ON [ast].[AhsExpElig_MbrCsPlanInfo]([CsPlanEffDate] ASC, [CsPlanExpDate] ASC)
    INCLUDE([CMK], [CsPlanName], [FctMbr_Skey]);

