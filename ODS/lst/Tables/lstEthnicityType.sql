CREATE TABLE [lst].[lstEthnicityType] (
    [lstEthnicityTypeKey] INT           NOT NULL,
    [EthnicityTypeName]   VARCHAR (50)  NOT NULL,
    [EthnicityTypeCode]   VARCHAR (10)  NULL,
    [LoadDate]            DATE          NOT NULL,
    [DataDate]            DATE          NOT NULL,
    [CreatedDate]         DATETIME2 (7) CONSTRAINT [DF_LstEthnicityType_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]           VARCHAR (50)  NOT NULL,
    [LastUpdatedDate]     DATETIME2 (7) CONSTRAINT [DF_LstEthnicityType_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]       VARCHAR (50)  NOT NULL,
    [SrcFileName]         VARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([lstEthnicityTypeKey] ASC)
);

