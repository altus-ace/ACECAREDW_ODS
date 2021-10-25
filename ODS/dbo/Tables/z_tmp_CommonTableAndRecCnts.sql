CREATE TABLE [dbo].[z_tmp_CommonTableAndRecCnts] (
    [URN]             INT          IDENTITY (1, 1) NOT NULL,
    [CatalogName]     VARCHAR (50) NULL,
    [TableName]       VARCHAR (50) NULL,
    [CntRecs]         INT          NULL,
    [TableCreateDate] DATETIME     NULL,
    [CreateDate]      DATETIME     DEFAULT (getdate()) NULL,
    [CreateBy]        VARCHAR (50) DEFAULT (suser_sname()) NULL
);

