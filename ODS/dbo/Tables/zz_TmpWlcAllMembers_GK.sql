CREATE TABLE [dbo].[zz_TmpWlcAllMembers_GK] (
    [mbrMemberKey]      INT           NOT NULL,
    [CLientMemberKey]   VARCHAR (20)  NOT NULL,
    [MEMBER_LAST_NAME]  VARCHAR (100) NULL,
    [MEMBER_FIRST_NAME] VARCHAR (100) NULL,
    [GENDER]            CHAR (5)      NULL,
    [DATE_OF_BIRTH]     DATE          NULL,
    [SrcFileName]       VARCHAR (16)  NOT NULL,
    [ClientKey]         INT           NOT NULL,
    [Ace_ID]            NUMERIC (15)  NOT NULL,
    [NEW_MSTRMRN]       NUMERIC (15)  NULL
);

