CREATE TABLE [adi].[MPulseMOs] (
    [MpulseMoUrn]     INT            IDENTITY (1, 1) NOT NULL,
    [LoadDate]        DATE           NOT NULL,
    [DataDate]        DATE           NOT NULL,
    [SrcFileName]     VARCHAR (100)  NOT NULL,
    [CreatedDate]     DATE           CONSTRAINT [DF_adiMpulseMOs_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       VARCHAR (50)   CONSTRAINT [DF_adiMpulseMOs_CreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate] DATE           CONSTRAINT [DF_adiMpulseMOs_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]   VARCHAR (50)   CONSTRAINT [DF_adiMpulseMOs_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [MO_Date_Time]    DATETIME       NULL,
    [ClientMemberKey] VARCHAR (50)   NULL,
    [ClientKey]       VARCHAR (50)   NULL,
    [Ace_ID]          NUMERIC (15)   NULL,
    [FirstName]       VARCHAR (50)   NULL,
    [LastName]        VARCHAR (50)   NULL,
    [PhoneNumber]     VARCHAR (35)   NULL,
    [MessageReceived] VARCHAR (1000) NULL,
    [Status]          CHAR (1)       NULL,
    PRIMARY KEY CLUSTERED ([MpulseMoUrn] ASC)
);

