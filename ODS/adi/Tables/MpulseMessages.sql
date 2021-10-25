CREATE TABLE [adi].[MpulseMessages] (
    [MpulseMessagesKey] INT           IDENTITY (1, 1) NOT NULL,
    [OriginalFileName]  VARCHAR (100) NOT NULL,
    [SrcFileName]       VARCHAR (100) NOT NULL,
    [DataDate]          DATE          NOT NULL,
    [CreatedDate]       DATE          CONSTRAINT [DF_adiMpulseMessages_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]         VARCHAR (50)  CONSTRAINT [DF_adiMpulseMessages_CreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]   DATE          CONSTRAINT [DF_adiMpulseMessages_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]     VARCHAR (50)  CONSTRAINT [DF_adiMpulseMessages_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [CENTRAL_DATE_TIME] DATETIME      NULL,
    [CLIENT_PATIENT_ID] VARCHAR (50)  NULL,
    [CLIENT_ID]         VARCHAR (25)  NULL,
    [ACE_ID]            VARCHAR (50)  NULL,
    [FIRST_NAME]        VARCHAR (50)  NULL,
    [LAST_NAME]         VARCHAR (50)  NULL,
    [PHONE_NUMBER]      VARCHAR (35)  NULL,
    [Content]           VARCHAR (MAX) NULL,
    [WORKFLOW_ID]       VARCHAR (20)  NULL,
    [WORKFLOW_NAME]     VARCHAR (50)  NULL,
    [UserName]          VARCHAR (100) NULL,
    [Status]            CHAR (1)      NULL,
    PRIMARY KEY CLUSTERED ([MpulseMessagesKey] ASC)
);


GO

CREATE TRIGGER [adi].MpulseMessagesAfterUpdateLastUpdatedDate
ON [adi].MpulseMessages
AFTER UPDATE 
AS
    UPDATE [adi].MpulseMessages
    SET LastUpdatedDate = SYSDATETIME()
	   , LastUpdatedBy = SYSTEM_USER
    FROM Inserted i
    WHERE [adi].MpulseMessages.MpulseMessagesKey = i.MpulseMessagesKey;
