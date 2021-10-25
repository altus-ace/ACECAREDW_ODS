CREATE TABLE [ast].[MPulsePhoneScrubbed] (
    [mPulsePhoneScrubbedKey] INT           IDENTITY (1, 1) NOT NULL,
    [ClientMemberKey]        VARCHAR (255) NOT NULL,
    [Client_ID]              VARCHAR (255) NOT NULL,
    [Ace_ID_Mrn]             VARCHAR (255) NOT NULL,
    [phoneNumber]            VARCHAR (255) NULL,
    [carrier_type]           VARCHAR (255) NULL,
    [carrier_name]           VARCHAR (255) NULL,
    [NNID_CALLED]            VARCHAR (255) NULL,
    [NNID_FAILURES]          VARCHAR (255) NULL,
    [srcFileName]            VARCHAR (255) NOT NULL,
    [LoadDate]               DATE          NOT NULL,
    [DataDate]               DATE          NOT NULL,
    [CreatedDate]            DATETIME2 (7) CONSTRAINT [DF_astMPulsePhoneScrubbed_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]              VARCHAR (50)  CONSTRAINT [DF_astMPulsePhoneScrubbed_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([mPulsePhoneScrubbedKey] ASC)
);

