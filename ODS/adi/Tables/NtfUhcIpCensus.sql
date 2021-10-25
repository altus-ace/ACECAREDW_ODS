CREATE TABLE [adi].[NtfUhcIpCensus] (
    [ntfUhcIPCensusKey]        INT            IDENTITY (1, 1) NOT NULL,
    [LOB]                      VARCHAR (10)   NULL,
    [PatientName]              VARCHAR (100)  NULL,
    [RosterSubgroup]           VARCHAR (50)   NULL,
    [PatientIdentifier]        VARCHAR (50)   NULL,
    [IndvID]                   VARCHAR (20)   NULL,
    [Alt_ID]                   VARCHAR (20)   NULL,
    [PatientBirthDate]         DATE           NULL,
    [PatientGender]            VARCHAR (3)    NULL,
    [PrimaryLanguage]          VARCHAR (50)   NULL,
    [Address]                  VARCHAR (255)  NULL,
    [City]                     VARCHAR (65)   NULL,
    [State]                    VARCHAR (25)   NULL,
    [Zip]                      VARCHAR (15)   NULL,
    [ContactPhoneNumber]       VARCHAR (25)   NULL,
    [AlternativePhoneNumber]   VARCHAR (25)   NULL,
    [HospitalState]            VARCHAR (10)   NULL,
    [ProviderIdentifiedMPIN]   VARCHAR (14)   NULL,
    [HospitalName]             VARCHAR (100)  NULL,
    [AttendingPhysicianIdMPIN] VARCHAR (15)   NULL,
    [AttendingPhysicianName]   VARCHAR (100)  NULL,
    [PrimaryCarePhysicianName] VARCHAR (100)  NULL,
    [AdmissionDate]            DATE           NULL,
    [DischargeDate]            DATE           NULL,
    [AdmissionDateReported]    DATE           NULL,
    [DateDcReported]           DATE           NULL,
    [PrimaryDiagnosisCode]     VARCHAR (10)   NULL,
    [PrimaryDiagnosisDesc]     VARCHAR (255)  NULL,
    [TypeOfFacility]           VARCHAR (10)   NULL,
    [DispositionDesc]          VARCHAR (255)  NULL,
    [CaseStatus]               VARCHAR (10)   NULL,
    [ReAdmissionDays]          VARCHAR (5)    NULL,
    [LengthOfStay]             INT            NULL,
    [RpmScore]                 NUMERIC (4, 3) NULL,
    [RstScore]                 VARCHAR (5)    NULL,
    [IdDate]                   DATE           NULL,
    [PrimaryCarePhysicianNPI]  VARCHAR (10)   NULL,
    [PatientCardID]            VARCHAR (50)   NULL,
    [LoadDate]                 DATE           NOT NULL,
    [DataDate]                 DATE           NOT NULL,
    [SrcFileName]              VARCHAR (100)  NOT NULL,
    [CreatedDate]              DATETIME       CONSTRAINT [DF_astNtfUchIpCensus_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                VARCHAR (50)   CONSTRAINT [DF_astNtfUchIpCensus_CreatedBY] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]          DATETIME       CONSTRAINT [DF_astNtfUchIpCensus_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]            VARCHAR (50)   CONSTRAINT [DF_astNtfUchIpCensus_LastUpdatedBY] DEFAULT (suser_sname()) NOT NULL,
    [AHRQ_Diagnosis_Category]  VARCHAR (50)   NULL,
    [ACSC_HPC]                 VARCHAR (50)   NULL,
    [HAI_POA]                  VARCHAR (50)   NULL,
    [RowStatus]                INT            CONSTRAINT [DF_astNtfUhcIpCensus_RowStatus] DEFAULT ((0)) NOT NULL,
    PRIMARY KEY CLUSTERED ([ntfUhcIPCensusKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_NtfUhcIpCensus_SrcFileName]
    ON [adi].[NtfUhcIpCensus]([SrcFileName] ASC);


GO

CREATE TRIGGER [adi].[TR_adiNtfUhcIpCensus_AU]
    ON [adi].NtfUhcIpCensus
    FOR UPDATE
    AS
    BEGIN
	   IF @@rowcount = 0 
		RETURN
        SET NoCount ON
	   if exists(SELECT * FROM inserted)
		  UPDATE adi.NtfUhcIpCensus
			 SET LastUpdatedDate = GETDATE()
    				,LastUpdatedBy  = system_user
	   	  FROM inserted i, NtfUhcIpCensus a
		  WHERE i.ntfUhcIPCensusKey = a.ntfUhcIPCensusKey
    END
