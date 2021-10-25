CREATE TABLE [adw].[A_Mbr_Members_OldMrn] (
    [A_Member_MRN_ID]  INT           IDENTITY (1, 1) NOT NULL,
    [A_MSTR_MRN]       NUMERIC (15)  NOT NULL,
    [Client_Member_ID] VARCHAR (50)  NOT NULL,
    [A_Client_ID]      INT           NOT NULL,
    [Active]           TINYINT       NOT NULL,
    [CreatedDate]      DATETIME2 (7) NOT NULL,
    [CreatedBy]        VARCHAR (50)  NOT NULL,
    [LastUpdatedDate]  DATETIME2 (7) NOT NULL,
    [LastUpdatedBy]    VARCHAR (50)  NOT NULL,
    PRIMARY KEY CLUSTERED ([A_Member_MRN_ID] ASC)
);

