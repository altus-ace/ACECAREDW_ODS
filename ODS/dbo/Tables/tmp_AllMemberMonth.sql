CREATE TABLE [dbo].[tmp_AllMemberMonth] (
    [SUBSCRIBER_ID]     VARCHAR (20)  NOT NULL,
    [PLAN_ID]           VARCHAR (15)  NULL,
    [PRODUCT_CODE]      VARCHAR (15)  NULL,
    [SUBGRP_ID]         VARCHAR (15)  NULL,
    [AUTO_ASSIGN]       VARCHAR (15)  NULL,
    [PCP_NPI]           VARCHAR (15)  NULL,
    [PCP_LAST_NAME]     VARCHAR (50)  NULL,
    [PCP_PRACTICE_TIN]  VARCHAR (15)  NULL,
    [PCP_PRACTICE_NAME] VARCHAR (100) NULL,
    [MBR_MTH]           INT           NULL,
    [MBR_YEAR]          INT           NULL
);

