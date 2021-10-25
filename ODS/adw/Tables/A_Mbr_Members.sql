CREATE TABLE [adw].[A_Mbr_Members] (
    [A_Member_MRN_ID]  INT           IDENTITY (1, 1) NOT NULL,
    [A_MSTR_MRN]       NUMERIC (15)  NOT NULL,
    [Client_Member_ID] VARCHAR (50)  NOT NULL,
    [A_Client_ID]      INT           NOT NULL,
    [Active]           TINYINT       CONSTRAINT [DF_A_Mbr_Members_Active] DEFAULT ((1)) NOT NULL,
    [CreatedDate]      DATETIME2 (7) CONSTRAINT [DF_A_Mbr_Members_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]        VARCHAR (50)  CONSTRAINT [DF_A_Mbr_Members_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]  DATETIME2 (7) CONSTRAINT [DF_A_Mbr_Members_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]    VARCHAR (50)  CONSTRAINT [DF_A_Mbr_Members_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([A_Member_MRN_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [_dta_index_A_Mbr_Members_6_721437644__K5_K3_K1]
    ON [adw].[A_Mbr_Members]([Active] ASC, [Client_Member_ID] ASC, [A_Member_MRN_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [_dta_index_A_Mbr_Members_6_721437644__K5_K3_K2]
    ON [adw].[A_Mbr_Members]([Active] ASC, [Client_Member_ID] ASC, [A_MSTR_MRN] ASC);


GO
CREATE STATISTICS [_dta_stat_721437644_5_1]
    ON [adw].[A_Mbr_Members]([Active], [A_Member_MRN_ID]);


GO
CREATE STATISTICS [_dta_stat_721437644_3_1_5]
    ON [adw].[A_Mbr_Members]([Client_Member_ID], [A_Member_MRN_ID], [Active]);

