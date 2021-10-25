CREATE TABLE [adw].[MstrMrn] (
    [MstrMrnKey]      NUMERIC (15)  IDENTITY (150000000000001, 1) NOT NULL,
    [FirstName]       VARCHAR (100) NULL,
    [LastName]        VARCHAR (100) NULL,
    [MiddleName]      VARCHAR (100) NULL,
    [DateOfBirth]     DATE          NULL,
    [Gender]          CHAR (1)      NULL,
    [MedicareID]      VARCHAR (15)  NULL,
    [MedicaidID]      VARCHAR (15)  NULL,
    [MbrSSN]          VARCHAR (9)   NULL,
    [srcUrn]          VARCHAR (50)  NOT NULL,
    [srcTableName]    VARCHAR (50)  NOT NULL,
    [Active]          TINYINT       CONSTRAINT [DF_MstrMrn_Active] DEFAULT ((1)) NOT NULL,
    [MergeToMrn]      NUMERIC (15)  CONSTRAINT [DF_MstrMrn_MergeToMrn] DEFAULT ((0)) NOT NULL,
    [LoadDate]        DATE          NOT NULL,
    [DataDate]        DATE          NOT NULL,
    [CreatedDate]     DATETIME2 (7) CONSTRAINT [DF_MstrMrn_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       VARCHAR (50)  CONSTRAINT [DF_MstrMrn_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate] DATETIME2 (7) CONSTRAINT [DF_MstrMrn_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]   VARCHAR (50)  CONSTRAINT [DF_MstrMrn_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [MstrMrnKey1]     NUMERIC (15)  NULL,
    PRIMARY KEY CLUSTERED ([MstrMrnKey] ASC),
    CONSTRAINT [CK_MstrMrn_Active] CHECK ([Active]=(1) OR [Active]=(0))
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Skey, MRN medical Record number ', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'MstrMrn', @level2type = N'COLUMN', @level2name = N'MstrMrnKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The latest value of First Name', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'MstrMrn', @level2type = N'COLUMN', @level2name = N'FirstName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The latest value of Last Name', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'MstrMrn', @level2type = N'COLUMN', @level2name = N'LastName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The latest value of Middle Name', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'MstrMrn', @level2type = N'COLUMN', @level2name = N'MiddleName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The latest value of Date of Birth', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'MstrMrn', @level2type = N'COLUMN', @level2name = N'DateOfBirth';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The latest value of Gender', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'MstrMrn', @level2type = N'COLUMN', @level2name = N'Gender';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The latest value of MedicareID', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'MstrMrn', @level2type = N'COLUMN', @level2name = N'MedicareID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The latest value of MedicaidID', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'MstrMrn', @level2type = N'COLUMN', @level2name = N'MedicaidID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'URN of the adi Member source row', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'MstrMrn', @level2type = N'COLUMN', @level2name = N'srcUrn';

