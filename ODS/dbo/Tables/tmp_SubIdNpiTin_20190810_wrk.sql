CREATE TABLE [dbo].[tmp_SubIdNpiTin_20190810_wrk] (
    [Subscriber_ID]             VARCHAR (50)  NOT NULL,
    [Sub_Group_ID]              VARCHAR (50)  NULL,
    [Date_of_Birth]             DATETIME2 (7) NULL,
    [Original_Effective_Date]   DATETIME2 (7) NULL,
    [Continuous_Effective_Date] DATETIME2 (7) NULL,
    [Current_Effective_Date]    DATETIME2 (7) NULL,
    [Current_Term_Date]         DATETIME2 (7) NULL,
    [NPI]                       VARCHAR (50)  NULL,
    [Tax_ID]                    VARCHAR (50)  NULL,
    CONSTRAINT [PK_tmp_SubIdNpiTin_20190810_wrk] PRIMARY KEY CLUSTERED ([Subscriber_ID] ASC)
);

