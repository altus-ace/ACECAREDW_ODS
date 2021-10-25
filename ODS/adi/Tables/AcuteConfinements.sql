CREATE TABLE [adi].[AcuteConfinements] (
    [AcuteConfinementsKey] INT            IDENTITY (1, 1) NOT NULL,
    [ProviderName]         VARCHAR (200)  NULL,
    [Admissions]           VARCHAR (20)   NULL,
    [Days]                 FLOAT (53)     NULL,
    [TotalPaid]            MONEY          NULL,
    [Admits]               DECIMAL (5, 2) NULL,
    [OrignalSrcFileName]   VARCHAR (100)  NOT NULL,
    [SrcFileName]          VARCHAR (100)  NOT NULL,
    [CreatedDate]          DATETIME2 (7)  NOT NULL,
    [CreatedBy]            VARCHAR (50)   NOT NULL,
    [LastUpdatedDate]      DATETIME2 (7)  NOT NULL,
    [LastUpdatedBy]        VARCHAR (50)   NOT NULL,
    PRIMARY KEY CLUSTERED ([AcuteConfinementsKey] ASC)
);

