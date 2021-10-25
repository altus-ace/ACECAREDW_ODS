CREATE TABLE [adi].[MpulseMemberResponses] (
    [MpulseMemberResponsesKey] INT            IDENTITY (1, 1) NOT NULL,
    [OriginalFileName]         VARCHAR (100)  NOT NULL,
    [SrcFileName]              VARCHAR (100)  NOT NULL,
    [DataDate]                 DATE           NOT NULL,
    [CreatedDate]              DATE           CONSTRAINT [DF_adiMpulseMemberResponses_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                VARCHAR (50)   CONSTRAINT [DF_adiMpulseMemberResponses_CreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]          DATE           CONSTRAINT [DF_adiMpulseMemberResponses_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]            VARCHAR (50)   CONSTRAINT [DF_adiMpulseMemberResponses_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [CENTRAL_DATE_TIME]        DATETIME       NULL,
    [CLIENT_PATIENT_ID]        VARCHAR (50)   NULL,
    [CLIENT_ID]                VARCHAR (25)   NULL,
    [ACE_ID]                   NUMERIC (15)   NULL,
    [FIRST_NAME]               VARCHAR (50)   NULL,
    [LAST_NAME]                VARCHAR (50)   NULL,
    [PHONE_NUMBER]             VARCHAR (35)   NULL,
    [MESSAGE_RECEIVED]         NVARCHAR (MAX) NULL,
    [WORKFLOW_ID]              VARCHAR (20)   NULL,
    [WORKFLOW_NAME]            VARCHAR (50)   NULL,
    [Status]                   CHAR (1)       NULL,
    PRIMARY KEY CLUSTERED ([MpulseMemberResponsesKey] ASC)
);


GO

CREATE TRIGGER [adi].MpulseMemberResponsesAfterUpdateLastUpdatedDate
ON [adi].[MpulseMemberResponses]
AFTER UPDATE 
AS
    UPDATE [adi].[MpulseMemberResponses]
    SET LastUpdatedDate = SYSDATETIME()
	   , LastUpdatedBy = SYSTEM_USER
    FROM Inserted i
    WHERE [adi].[MpulseMemberResponses].MpulseMemberResponsesKey= i.MpulseMemberResponsesKey;
