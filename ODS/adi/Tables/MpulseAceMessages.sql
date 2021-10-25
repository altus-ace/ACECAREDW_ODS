CREATE TABLE [adi].[MpulseAceMessages] (
    [MpulseAceMessagesKey] INT           IDENTITY (1, 1) NOT NULL,
    [OriginalFileName]     VARCHAR (100) NOT NULL,
    [SrcFileName]          VARCHAR (100) NOT NULL,
    [DataDate]             DATE          NOT NULL,
    [CreatedDate]          DATE          CONSTRAINT [DF_adiMpulseAceMessages_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]            VARCHAR (50)  CONSTRAINT [DF_adiMpulseAceMessages_CreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]      DATE          CONSTRAINT [DF_adiMpulseAceMessages_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]        VARCHAR (50)  CONSTRAINT [DF_adiMpulseAceMessages_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [CLIENT_PATIENT_ID]    VARCHAR (50)  NULL,
    [CLIENT_ID]            VARCHAR (10)  NULL,
    [ACE_ID]               NUMERIC (15)  NULL,
    [FIRST_NAME]           VARCHAR (50)  NULL,
    [LAST_NAME]            VARCHAR (50)  NULL,
    [PHONE_NUMBER]         VARCHAR (35)  NULL,
    [UserName]             VARCHAR (100) NULL,
    [WORKFLOW_ID]          VARCHAR (20)  NULL,
    [WORKFLOW_NAME]        VARCHAR (50)  NULL,
    [Content]              VARCHAR (MAX) NULL,
    [CENTRAL_DATE_TIME]    DATETIME      NULL,
    [Status]               CHAR (1)      NULL,
    PRIMARY KEY CLUSTERED ([MpulseAceMessagesKey] ASC)
);


GO

CREATE TRIGGER [adi].MpulseAceMessagesAfterUpdateLastUpdatedDate
ON [adi].MpulseAceMessages
AFTER UPDATE 
AS
    UPDATE [adi].MpulseAceMessages
    SET LastUpdatedDate = SYSDATETIME()
	   , LastUpdatedBy = SYSTEM_USER
    FROM Inserted i
    WHERE [adi].MpulseAceMessages.MpulseAceMessagesKey = i.MpulseAceMessagesKey;
