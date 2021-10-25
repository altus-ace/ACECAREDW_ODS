CREATE TABLE [adw].[MbrDemographic] (
    [mbrDemographicKey]     INT           IDENTITY (1, 1) NOT NULL,
    [mbrMemberKey]          INT           NOT NULL,
    [mbrLoadKey]            INT           NOT NULL,
    [EffectiveDate]         DATE          NOT NULL,
    [ExpirationDate]        DATE          CONSTRAINT [DF_MbrDemographicExpirationDate] DEFAULT ('12/31/9999') NOT NULL,
    [LastName]              VARCHAR (100) NULL,
    [FirstName]             VARCHAR (100) NULL,
    [MiddleName]            VARCHAR (100) NULL,
    [SSN]                   VARCHAR (15)  NULL,
    [Gender]                CHAR (5)      NULL,
    [DOB]                   DATE          NULL,
    [mbrInsuranceCardIdNum] VARCHAR (20)  NULL,
    [MedicaidID]            VARCHAR (15)  NULL,
    [HICN]                  VARCHAR (11)  NULL,
    [MBI]                   VARCHAR (11)  NULL,
    [MedicareID]            VARCHAR (15)  NULL,
    [Ethnicity]             VARCHAR (20)  NULL,
    [Race]                  VARCHAR (20)  NULL,
    [PrimaryLanguage]       VARCHAR (20)  NULL,
    [LoadDate]              DATE          NOT NULL,
    [DataDate]              DATE          NOT NULL,
    [CreatedDate]           DATETIME2 (7) CONSTRAINT [DF_MbrDemographic_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]             VARCHAR (50)  CONSTRAINT [DF_MbrDemographic_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]       DATETIME2 (7) CONSTRAINT [DF_MbrDemographic_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]         VARCHAR (50)  CONSTRAINT [DF_MbrDemographic_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([mbrDemographicKey] ASC),
    CONSTRAINT [FK_MbrDemographic_MbrLoadHistory] FOREIGN KEY ([mbrLoadKey]) REFERENCES [adw].[MbrLoadHistory] ([mbrLoadHistoryKey]),
    CONSTRAINT [FK_MbrDemographic_MbrMember] FOREIGN KEY ([mbrMemberKey]) REFERENCES [adw].[MbrMember] ([mbrMemberKey])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [adwMbrDemographic_MbrMemberKeyEffDateExpDate]
    ON [adw].[MbrDemographic]([mbrMemberKey] ASC, [EffectiveDate] ASC, [ExpirationDate] ASC)
    INCLUDE([mbrDemographicKey], [LastName], [FirstName], [MiddleName], [SSN], [Gender], [DOB], [MedicaidID], [MedicareID], [Ethnicity], [Race], [PrimaryLanguage], [LoadDate], [DataDate]);


GO
CREATE NONCLUSTERED INDEX [Ndx_MbrDemoExEffMbrKeyDemoKey]
    ON [adw].[MbrDemographic]([ExpirationDate] ASC, [mbrMemberKey] ASC, [EffectiveDate] ASC, [mbrDemographicKey] ASC)
    INCLUDE([LastName], [FirstName], [MiddleName], [Gender], [DOB], [MedicaidID], [MedicareID], [Ethnicity], [Race], [PrimaryLanguage]);


GO

CREATE TRIGGER adw.[AU_adwMbrDemographic]
ON adw.MbrDemographic
AFTER UPDATE 
AS
   UPDATE adw.MbrDemographic
   SET [LastUpdatedDate] = SYSDATETIME()
	   ,[LastUpdatedBy] = SYSTEM_USER	
   FROM Inserted i
   WHERE adw.MbrDemographic.mbrDemographicKey = i.mbrDemographicKey
   ;
