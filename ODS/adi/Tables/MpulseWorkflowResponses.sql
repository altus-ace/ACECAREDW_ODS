CREATE TABLE [adi].[MpulseWorkflowResponses] (
    [MPulseWorkflowResponsesKey] INT            IDENTITY (1, 1) NOT NULL,
    [OriginalFileName]           VARCHAR (100)  NOT NULL,
    [SrcFileName]                VARCHAR (100)  NOT NULL,
    [DataDate]                   DATE           NOT NULL,
    [CreatedDate]                DATE           CONSTRAINT [DF_adiMpulseWorkflowResponses_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                  VARCHAR (50)   CONSTRAINT [DF_adiMpulseWorkflowResponses_CreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]            DATE           CONSTRAINT [DF_adiMpulseWorkflowResponses_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]              VARCHAR (50)   CONSTRAINT [DF_adiMpulseWorkflowResponses_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [CENTRAL_DATE_TIME]          DATETIME       NULL,
    [CLIENT_PATIENT_ID]          VARCHAR (50)   NULL,
    [CLIENT_ID]                  VARCHAR (25)   NULL,
    [ACE_ID]                     VARCHAR (50)   NULL,
    [FIRST_NAME]                 VARCHAR (50)   NULL,
    [LAST_NAME]                  VARCHAR (50)   NULL,
    [PHONE_NUMBER]               VARCHAR (35)   NULL,
    [MESSAGE_RECEIVED]           NVARCHAR (MAX) NULL,
    [WORKFLOW_ID]                VARCHAR (20)   NULL,
    [WORKFLOW_NAME]              VARCHAR (MAX)  NULL,
    [Status]                     CHAR (1)       NULL,
    PRIMARY KEY CLUSTERED ([MPulseWorkflowResponsesKey] ASC)
);


GO

CREATE TRIGGER [adi].MpulseWorkflowResponsesAfterUpdateLastUpdatedDate
ON [adi].MpulseWorkflowResponses
AFTER UPDATE 
AS
    UPDATE [adi].MpulseWorkflowResponses
    SET LastUpdatedDate = SYSDATETIME()
	   , LastUpdatedBy = SYSTEM_USER
    FROM Inserted i
    WHERE [adi].MpulseWorkflowResponses.MPulseWorkflowResponsesKey = i.MPulseWorkflowResponsesKey;
