CREATE TABLE [adi].[MPulsePhoneScrubbed] (
    [mPulsePhoneScrubbedKey] INT           IDENTITY (1, 1) NOT NULL,
    [ClientMemberKey]        VARCHAR (50)  NOT NULL,
    [Client_ID]              INT           NOT NULL,
    [Ace_ID_Mrn]             NUMERIC (15)  NOT NULL,
    [phoneNumber]            VARCHAR (30)  NULL,
    [carrier_type]           VARCHAR (50)  NULL,
    [carrier_name]           VARCHAR (500) NULL,
    [NNID_CALLED]            VARCHAR (50)  NULL,
    [NNID_FAILURES]          VARCHAR (150) NULL,
    [srcFileName]            VARCHAR (100) NULL,
    [LoadDate]               DATE          NOT NULL,
    [DataDate]               DATE          NOT NULL,
    [CreatedDate]            DATETIME2 (7) CONSTRAINT [DF_MPulsePhoneScrubbed_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]              VARCHAR (50)  CONSTRAINT [DF_MPulsePhoneScrubbed_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [Status]                 CHAR (1)      NULL,
    PRIMARY KEY CLUSTERED ([mPulsePhoneScrubbedKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Ndx_mPulsePhoneScrubbed_CarrierType]
    ON [adi].[MPulsePhoneScrubbed]([carrier_type] ASC)
    INCLUDE([ClientMemberKey], [Ace_ID_Mrn], [phoneNumber], [LoadDate]);

