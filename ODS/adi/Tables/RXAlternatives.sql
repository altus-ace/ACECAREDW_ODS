CREATE TABLE [adi].[RXAlternatives] (
    [RXAletrnativesKey]    INT           IDENTITY (1, 1) NOT NULL,
    [loadDate]             DATE          NOT NULL,
    [DataDate]             DATE          NOT NULL,
    [SrcFileName]          VARCHAR (100) NULL,
    [CreatedDate]          DATETIME2 (7) CONSTRAINT [DF_adiUhcRXAlternatives_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]            VARCHAR (50)  CONSTRAINT [DF_adiUhcRXAlternatives_CreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]      DATETIME2 (7) CONSTRAINT [DF_adiUhcRXAlternatives_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]        VARCHAR (50)  CONSTRAINT [DF_adiUhcRXAlternatives_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [BrandName]            VARCHAR (50)  NULL,
    [AlternativesProducts] VARCHAR (500) NULL,
    [Client]               VARCHAR (100) NULL,
    [NDC Number]           VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([RXAletrnativesKey] ASC)
);

