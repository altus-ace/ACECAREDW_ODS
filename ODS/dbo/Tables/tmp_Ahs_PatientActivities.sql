CREATE TABLE [dbo].[tmp_Ahs_PatientActivities] (
    [tmpAhsPatientActivitiesSKey] INT           IDENTITY (1, 1) NOT NULL,
    [ClientMemberKey]             VARCHAR (50)  NOT NULL,
    [CareActivityTypeName]        VARCHAR (100) NOT NULL,
    [ActivityOutcome]             VARCHAR (100) NULL,
    [ActivityPerformedDate]       DATETIME      NULL,
    [ActivityCreatedDate]         DATETIME      NULL,
    [OutcomeNotes]                VARCHAR (MAX) NULL,
    [VenueName]                   VARCHAR (100) NULL,
    [LOB]                         VARCHAR (50)  NULL,
    [ShcnMsspLoadStatus]          TINYINT       CONSTRAINT [DF_dboTmpAhsPatientAct] DEFAULT ((0)) NULL,
    [srcFileName]                 VARCHAR (100) NULL,
    [LoadDate]                    DATETIME      NULL,
    [CreatedDate]                 DATETIME      DEFAULT (getdate()) NULL,
    [CreatedBy]                   VARCHAR (100) DEFAULT (suser_sname()) NULL,
    PRIMARY KEY CLUSTERED ([tmpAhsPatientActivitiesSKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ndx_tmpAhsPatientActivities_ClientMemberKey_ActivityCreatedDate]
    ON [dbo].[tmp_Ahs_PatientActivities]([ClientMemberKey] ASC, [ActivityCreatedDate] ASC)
    INCLUDE([tmpAhsPatientActivitiesSKey], [CareActivityTypeName], [ActivityOutcome], [VenueName]);

