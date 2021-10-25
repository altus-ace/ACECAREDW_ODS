﻿CREATE TABLE [dbo].[TmpAllMemberMonths] (
    [MemberMonth]           DATE          NULL,
    [CLientKey]             INT           NULL,
    [LOB]                   VARCHAR (MAX) NULL,
    [ClientMemberKey]       VARCHAR (MAX) NULL,
    [PCP_NPI]               VARCHAR (MAX) NULL,
    [PLAN_ID]               VARCHAR (MAX) NULL,
    [PLAN_CODE]             VARCHAR (MAX) NULL,
    [SUBGRP_ID]             VARCHAR (MAX) NULL,
    [SUBGRP_NAME]           VARCHAR (MAX) NULL,
    [PCP_PRACTICE_TIN]      VARCHAR (MAX) NULL,
    [PCP_PRACTICE_NAME]     VARCHAR (MAX) NULL,
    [MEMBER_FIRST_NAME]     VARCHAR (MAX) NULL,
    [MEMBER_LAST_NAME]      VARCHAR (MAX) NULL,
    [GENDER]                VARCHAR (MAX) NULL,
    [AGE]                   VARCHAR (MAX) NULL,
    [DATE_OF_BIRTH]         DATE          NULL,
    [MEMBER_HOME_ADDRESS]   VARCHAR (MAX) NULL,
    [MEMBER_HOME_ADDRESS2]  VARCHAR (MAX) NULL,
    [MEMBER_HOME_CITY]      VARCHAR (MAX) NULL,
    [MEMBER_HOME_STATE]     VARCHAR (MAX) NULL,
    [MEMBER_HOME_ZIP]       VARCHAR (MAX) NULL,
    [MEMBER_HOME_PHONE]     VARCHAR (MAX) NULL,
    [IPRO_ADMIT_RISK_SCORE] VARCHAR (MAX) NULL,
    [RunDate]               DATE          NULL,
    [RunBy]                 VARCHAR (MAX) NULL
);


GO
CREATE NONCLUSTERED INDEX [ndx_TmpAllMemberMonths_ClientKey]
    ON [dbo].[TmpAllMemberMonths]([CLientKey] ASC)
    INCLUDE([MemberMonth], [ClientMemberKey], [PLAN_CODE]);

