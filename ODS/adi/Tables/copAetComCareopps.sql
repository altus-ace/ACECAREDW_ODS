CREATE TABLE [adi].[copAetComCareopps] (
    [copAetComCareOppsKey] INT           IDENTITY (1, 1) NOT NULL,
    [IndividualId]         VARCHAR (50)  NULL,
    [PatientId]            VARCHAR (50)  NULL,
    [PatientLastName]      VARCHAR (50)  NULL,
    [PatientFirstName]     VARCHAR (50)  NULL,
    [PatientMiddleName]    VARCHAR (50)  NULL,
    [DOB]                  DATE          NULL,
    [Numerator]            VARCHAR (10)  NULL,
    [NumeratorServiceDate] DATE          NULL,
    [MemberType]           VARCHAR (30)  NULL,
    [Measure_Number]       VARCHAR (20)  NULL,
    [loadDate]             DATE          NOT NULL,
    [DataDate]             DATE          NOT NULL,
    [OrignalSrcFileName]   VARCHAR (100) NOT NULL,
    [SrcFileName]          VARCHAR (100) NOT NULL,
    [CreatedDate]          DATETIME2 (7) CONSTRAINT [DF_CopAetComCareopps_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]            VARCHAR (50)  CONSTRAINT [DF_CopAetComCareopps_CreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]      DATETIME2 (7) CONSTRAINT [DF_CopAetComCareopps_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]        VARCHAR (50)  CONSTRAINT [DF_CopAetComCareopps_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([copAetComCareOppsKey] ASC)
);


GO
CREATE TRIGGER [adi].[TR_adiCopAetComCareOpps_AU]
    ON adi.copAetComCareopps
    FOR UPDATE
    AS
    BEGIN
	   IF @@rowcount = 0 
		RETURN
        SET NoCount ON
	   if exists(SELECT * FROM inserted)
		  UPDATE adi.copAetComCareopps
			 SET LastUpdatedDate = GETDATE()
    				,LastUpdatedBy  = system_user
	   	  FROM inserted i, copAetComCareopps a
		  WHERE i.copAetComCareOppsKey = a.copAetComCareOppsKey
    END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Aetna Measure ID, Used to map to QM Mapping Ace Measure ID', @level0type = N'SCHEMA', @level0name = N'adi', @level1type = N'TABLE', @level1name = N'copAetComCareopps', @level2type = N'COLUMN', @level2name = N'Measure_Number';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date of load batch', @level0type = N'SCHEMA', @level0name = N'adi', @level1type = N'TABLE', @level1name = N'copAetComCareopps', @level2type = N'COLUMN', @level2name = N'loadDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date of data origin', @level0type = N'SCHEMA', @level0name = N'adi', @level1type = N'TABLE', @level1name = N'copAetComCareopps', @level2type = N'COLUMN', @level2name = N'DataDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Original source filename', @level0type = N'SCHEMA', @level0name = N'adi', @level1type = N'TABLE', @level1name = N'copAetComCareopps', @level2type = N'COLUMN', @level2name = N'OrignalSrcFileName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Name of file data was loaded from', @level0type = N'SCHEMA', @level0name = N'adi', @level1type = N'TABLE', @level1name = N'copAetComCareopps', @level2type = N'COLUMN', @level2name = N'SrcFileName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date row was created', @level0type = N'SCHEMA', @level0name = N'adi', @level1type = N'TABLE', @level1name = N'copAetComCareopps', @level2type = N'COLUMN', @level2name = N'CreatedDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'User who created row', @level0type = N'SCHEMA', @level0name = N'adi', @level1type = N'TABLE', @level1name = N'copAetComCareopps', @level2type = N'COLUMN', @level2name = N'CreatedBy';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Last row Update data', @level0type = N'SCHEMA', @level0name = N'adi', @level1type = N'TABLE', @level1name = N'copAetComCareopps', @level2type = N'COLUMN', @level2name = N'LastUpdatedDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Last row update User', @level0type = N'SCHEMA', @level0name = N'adi', @level1type = N'TABLE', @level1name = N'copAetComCareopps', @level2type = N'COLUMN', @level2name = N'LastUpdatedBy';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N' Client Member ID', @level0type = N'SCHEMA', @level0name = N'adi', @level1type = N'TABLE', @level1name = N'copAetComCareopps', @level2type = N'COLUMN', @level2name = N'IndividualId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Client member patient ID', @level0type = N'SCHEMA', @level0name = N'adi', @level1type = N'TABLE', @level1name = N'copAetComCareopps', @level2type = N'COLUMN', @level2name = N'PatientId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Member Last Name', @level0type = N'SCHEMA', @level0name = N'adi', @level1type = N'TABLE', @level1name = N'copAetComCareopps', @level2type = N'COLUMN', @level2name = N'PatientLastName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Member First Name', @level0type = N'SCHEMA', @level0name = N'adi', @level1type = N'TABLE', @level1name = N'copAetComCareopps', @level2type = N'COLUMN', @level2name = N'PatientFirstName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Member Middle Name', @level0type = N'SCHEMA', @level0name = N'adi', @level1type = N'TABLE', @level1name = N'copAetComCareopps', @level2type = N'COLUMN', @level2name = N'PatientMiddleName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Member Date of Birth', @level0type = N'SCHEMA', @level0name = N'adi', @level1type = N'TABLE', @level1name = N'copAetComCareopps', @level2type = N'COLUMN', @level2name = N'DOB';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Numerator value', @level0type = N'SCHEMA', @level0name = N'adi', @level1type = N'TABLE', @level1name = N'copAetComCareopps', @level2type = N'COLUMN', @level2name = N'Numerator';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Last Service Date', @level0type = N'SCHEMA', @level0name = N'adi', @level1type = N'TABLE', @level1name = N'copAetComCareopps', @level2type = N'COLUMN', @level2name = N'NumeratorServiceDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Member enrollment type', @level0type = N'SCHEMA', @level0name = N'adi', @level1type = N'TABLE', @level1name = N'copAetComCareopps', @level2type = N'COLUMN', @level2name = N'MemberType';

