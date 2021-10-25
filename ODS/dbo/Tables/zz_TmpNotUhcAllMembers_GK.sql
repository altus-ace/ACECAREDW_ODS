CREATE TABLE [dbo].[zz_TmpNotUhcAllMembers_GK] (
    [URN]               INT           NOT NULL,
    [Client_Member_id]  VARCHAR (20)  NOT NULL,
    [MEMBER_LAST_NAME]  VARCHAR (100) NULL,
    [MEMBER_FIRST_NAME] VARCHAR (100) NULL,
    [GENDER]            CHAR (5)      NULL,
    [DATE_OF_BIRTH]     DATE          NULL,
    [SrcFileName]       VARCHAR (100) NOT NULL,
    [ClientKey]         INT           NOT NULL,
    [NEW_MSTRMRN]       NUMERIC (15)  NULL
);

