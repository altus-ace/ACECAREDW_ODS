CREATE TABLE [dbo].[tmp_MbrAttritionSummaryIncTerms] (
    [URN]           INT          IDENTITY (1000, 1) NOT NULL,
    [MBR_YEAR]      INT          NULL,
    [MBR_MTH]       INT          NULL,
    [SUBSCRIBER_ID] VARCHAR (20) NOT NULL,
    [LOB_ID]        VARCHAR (20) NULL,
    [AUTO_ASSIGN]   VARCHAR (20) NULL,
    [TYPE]          VARCHAR (1)  NULL,
    [LOADDATE]      DATE         DEFAULT (sysdatetime()) NULL,
    [LOADEDBY]      VARCHAR (50) DEFAULT (suser_sname()) NULL
);

