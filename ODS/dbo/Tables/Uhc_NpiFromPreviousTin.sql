CREATE TABLE [dbo].[Uhc_NpiFromPreviousTin] (
    [skey]                INT          IDENTITY (1, 1) NOT NULL,
    [Uhc_TableKey]        INT          NOT NULL,
    [loadDate]            DATE         NULL,
    [UHC_SUBSCRIBER_ID]   VARCHAR (50) NOT NULL,
    [PCP_PRACTICE_TIN]    VARCHAR (11) NULL,
    [Best_Old_TIN]        VARCHAR (12) NULL,
    [BEST_OLD_NPI]        VARCHAR (12) NULL,
    [BEST_OLD_NPI_SrcKey] INT          NULL,
    [CreatedBy]           VARCHAR (20) DEFAULT (suser_sname()) NOT NULL,
    [CreatedDate]         DATETIME     DEFAULT (getdate()) NOT NULL,
    [Status_NewBatch]     TINYINT      DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([skey] ASC)
);

