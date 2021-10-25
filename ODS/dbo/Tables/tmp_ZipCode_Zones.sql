CREATE TABLE [dbo].[tmp_ZipCode_Zones] (
    [zipCodes]        VARCHAR (20) NOT NULL,
    [zone]            VARCHAR (20) NOT NULL,
    [srcFileName]     VARCHAR (37) NOT NULL,
    [CreatedDate]     DATETIME     NULL,
    [CreatedBy]       VARCHAR (50) NULL,
    [LastUpdatedDate] DATETIME     NULL,
    [LastUpdatedBy]   VARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([zipCodes] ASC, [zone] ASC)
);

