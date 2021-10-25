CREATE TABLE [adi].[MPulseOptOuts] (
    [MpulseOptOutKey]  INT           IDENTITY (1, 1) NOT NULL,
    [OriginalFileName] VARCHAR (100) NOT NULL,
    [SrcFileName]      VARCHAR (100) NOT NULL,
    [DataDate]         DATE          NOT NULL,
    [CreatedDate]      DATE          CONSTRAINT [DF_adiMpulseOptOuts_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]        VARCHAR (50)  CONSTRAINT [DF_adiMpulseOptOuts_CreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]  DATE          CONSTRAINT [DF_adiMpulseOptOuts_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]    VARCHAR (50)  CONSTRAINT [DF_adiMpulseOptOuts_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [OptOut_Date_Time] DATETIME      NULL,
    [ClientMemberKey]  VARCHAR (50)  NULL,
    [ClientKey]        VARCHAR (25)  NULL,
    [Ace_ID]           VARCHAR (50)  NULL,
    [FirstName]        VARCHAR (50)  NULL,
    [LastName]         VARCHAR (50)  NULL,
    [PhoneNumber]      VARCHAR (35)  NULL,
    [Status]           CHAR (1)      NULL,
    PRIMARY KEY CLUSTERED ([MpulseOptOutKey] ASC)
);


GO
CREATE TRIGGER [adi].MPulseOptOutsAfterUpdateLastUpdatedDate
ON [adi].[MPulseOptOuts]
AFTER UPDATE 
AS
    UPDATE [adi].[MPulseOptOuts]
    SET LastUpdatedDate = SYSDATETIME()
	   , LastUpdatedBy = SYSTEM_USER
    FROM Inserted i
    WHERE [adi].[MPulseOptOuts].MpulseOptOutKey= i.MpulseOptOutKey;
