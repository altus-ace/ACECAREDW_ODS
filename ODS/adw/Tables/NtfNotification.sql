CREATE TABLE [adw].[NtfNotification] (
    [CreatedDate]          DATETIME2 (7)  CONSTRAINT [DF_NtfNotificationG_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]            VARCHAR (50)   CONSTRAINT [DF_NtfNotificationG_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]      DATETIME2 (7)  CONSTRAINT [DF_NtfNotificationG_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]        VARCHAR (50)   CONSTRAINT [DF_NtfNotificationG_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [LoadDate]             DATE           NOT NULL,
    [DataDate]             DATE           NOT NULL,
    [ntfNotificationKey]   INT            IDENTITY (1, 1) NOT NULL,
    [ClientKey]            INT            NULL,
    [NtfSource]            VARCHAR (10)   NULL,
    [ClientMemberKey]      VARCHAR (50)   NULL,
    [ntfEventType]         VARCHAR (20)   NOT NULL,
    [NtfPatientType]       VARCHAR (20)   NULL,
    [CaseType]             VARCHAR (20)   NULL,
    [AdmitDateTime]        DATETIME       NULL,
    [ActualDischargeDate]  DATE           CONSTRAINT [DF_NtfActualDischargeDate] DEFAULT ('1900-01-01') NULL,
    [DischargeDisposition] VARCHAR (1000) NULL,
    [ChiefComplaint]       VARCHAR (1000) NULL,
    [DiagnosisDesc]        VARCHAR (1000) NULL,
    [DiagnosisCode]        VARCHAR (100)  NULL,
    [AdmitHospital]        VARCHAR (100)  NULL,
    [AceFollowUpDueDate]   DATE           CONSTRAINT [DF_NtfAceFollowUpDueDate] DEFAULT ('1900-01-01') NULL,
    [Exported]             TINYINT        CONSTRAINT [DF_NtfNotificationG_Exported] DEFAULT ((0)) NOT NULL,
    [ExportedDate]         DATETIME2 (7)  CONSTRAINT [DF_ntf_ExportedDate] DEFAULT (NULL) NULL,
    [AdiKey]               INT            NULL,
    [SrcFileName]          VARCHAR (100)  NULL,
    [AceID]                NUMERIC (15)   NULL,
    [DrgCode]              VARCHAR (20)   DEFAULT ('') NULL,
    [DschrgInferredInd]    BIT            DEFAULT ((0)) NULL,
    [DschrgInferredDate]   DATE           CONSTRAINT [DF_DschrgInferredDate] DEFAULT ('') NULL,
    PRIMARY KEY CLUSTERED ([ntfNotificationKey] ASC),
    CONSTRAINT [FK_NtfNotificationG_Client] FOREIGN KEY ([ClientKey]) REFERENCES [lst].[List_Client] ([ClientKey])
);


GO
CREATE NONCLUSTERED INDEX [IX_NtfNotification_Exported]
    ON [adw].[NtfNotification]([Exported] ASC);


GO


CREATE TRIGGER [adw].[AU_NtfNotification]
ON [adw].[NtfNotification]
AFTER UPDATE 
AS
   UPDATE adw.NtfNotification
   SET [LastUpdatedDate] = SYSDATETIME()
	   ,[LastUpdatedBy] = SYSTEM_USER	
   FROM Inserted i
   WHERE adw.NtfNotification.ntfNotificationKey = i.ntfNotificationKey
   ;
