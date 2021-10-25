CREATE TABLE [dbo].[lstState] (
    [lstStateKey]      INT           NOT NULL,
    [StateName]        VARCHAR (50)  NOT NULL,
    [StateAbreviation] CHAR (2)      NULL,
    [SourceUrn]        VARCHAR (100) NULL,
    [SourcePageName]   VARCHAR (100) NULL,
    [SrcFileName]      VARCHAR (100) NOT NULL,
    [CreatedDate]      DATETIME2 (7) CONSTRAINT [DF_LstPhoneCarrierType_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]        VARCHAR (50)  CONSTRAINT [DF_LstPhoneCarrierType_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]  DATETIME2 (7) CONSTRAINT [DF_LstPhoneCarrierType_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]    VARCHAR (50)  CONSTRAINT [DF_LstPhoneCarrierType_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([lstStateKey] ASC)
);

