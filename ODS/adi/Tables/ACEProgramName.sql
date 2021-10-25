CREATE TABLE [adi].[ACEProgramName] (
    [ACEProgramNameKey] INT           IDENTITY (1, 1) NOT NULL,
    [loadDate]          DATE          NOT NULL,
    [DataDate]          DATE          NOT NULL,
    [OriginalFileName]  VARCHAR (100) NULL,
    [SrcFileName]       VARCHAR (100) NULL,
    [CreatedDate]       DATETIME2 (7) CONSTRAINT [DF_adiACEProgramName_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]         VARCHAR (50)  CONSTRAINT [DF_adiACEProgramName_CreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]   DATETIME2 (7) CONSTRAINT [DF_adiACEProgramName_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]     VARCHAR (50)  CONSTRAINT [DF_adiACEProgramName_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [LOB]               VARCHAR (100) NULL,
    [MemberID]          VARCHAR (100) NULL,
    [Program]           VARCHAR (100) NULL,
    [StartDate]         DATE          NULL,
    [EndDate]           DATE          NULL,
    [ProductSubgroup]   VARCHAR (100) NULL,
    [AceStatusCode]     TINYINT       CONSTRAINT [DF_AceProgramName_StatusCode] DEFAULT ((0)) NULL,
    PRIMARY KEY CLUSTERED ([ACEProgramNameKey] ASC)
);

