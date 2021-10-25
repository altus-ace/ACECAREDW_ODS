CREATE TABLE [adw].[ExportAhsPrograms] (
    [ExportAhsProgramsKey] INT           IDENTITY (1, 1) NOT NULL,
    [CreatedDate]          DATE          CONSTRAINT [DF_ExportAhsPrograms_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]            VARCHAR (50)  CONSTRAINT [DF_ExportAhsPrograms_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]      DATE          CONSTRAINT [DF_ExportAhsPrograms_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]        VARCHAR (50)  CONSTRAINT [DF_ExportAhsPrograms_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [LoadDate]             DATE          NOT NULL,
    [Exported]             TINYINT       DEFAULT ((0)) NULL,
    [ExportedDate]         DATE          DEFAULT ('01/01/1900') NULL,
    [ClientKey]            INT           NOT NULL,
    [ClientMemberKey]      VARCHAR (50)  NOT NULL,
    [ProgramID]            INT           NOT NULL,
    [ExpLobName]           VARCHAR (50)  NULL,
    [ExpProgram_Name]      VARCHAR (100) NULL,
    [ExpEnrollDate]        DATE          NULL,
    [ExpCreateDate]        DATE          NULL,
    [ExpMemberID]          VARCHAR (50)  NULL,
    [ExpEnrollEndDate]     DATE          NULL,
    [ExpProgramstatus]     VARCHAR (50)  NULL,
    [ExpReasonDescription] VARCHAR (50)  NULL,
    [ExpReferalType]       VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([ExportAhsProgramsKey] ASC)
);


GO
CREATE TRIGGER [adw].[AU_adwExportAhsPrograms]
ON adw.ExportAhsPrograms
AFTER UPDATE 
AS
   UPDATE adw.ExportAhsPrograms
   SET [LastUpdatedDate] = SYSDATETIME()
	   ,[LastUpdatedBy] = SYSTEM_USER	
   FROM Inserted i
   WHERE adw.ExportAhsPrograms.ExportAhsProgramsKey = i.ExportAhsProgramsKey   
   ;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Stores data rows for Programs to enroll in AHS listed in the lst.lstClinicalPrograms table. Source for Export to AHS job.', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'ExportAhsPrograms';

