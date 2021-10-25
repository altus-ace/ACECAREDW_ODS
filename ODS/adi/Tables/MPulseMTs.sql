CREATE TABLE [adi].[MPulseMTs] (
    [MpulseMtUrn]     INT            IDENTITY (1, 1) NOT NULL,
    [LoadDate]        DATE           NOT NULL,
    [DataDate]        DATE           NOT NULL,
    [SrcFileName]     VARCHAR (100)  NOT NULL,
    [CreatedDate]     DATE           CONSTRAINT [DF_adiMpulseMTs_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       VARCHAR (50)   CONSTRAINT [DF_adiMpulseMTs_CreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate] DATE           CONSTRAINT [DF_adiMpulseMTs_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]   VARCHAR (50)   CONSTRAINT [DF_adiMpulseMTs_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [Mt_Date_Time]    DATETIME       NULL,
    [Mt_Content]      VARCHAR (1000) NULL,
    [Appt_ID]         VARCHAR (50)   NULL,
    [ClientMemberKey] VARCHAR (50)   NULL,
    [ClientKey]       VARCHAR (50)   NULL,
    [Ace_ID]          NUMERIC (20)   NULL,
    [FirstName]       VARCHAR (50)   NULL,
    [LastName]        VARCHAR (50)   NULL,
    [PhoneNumber]     VARCHAR (35)   NULL,
    [Status]          CHAR (1)       NULL,
    PRIMARY KEY CLUSTERED ([MpulseMtUrn] ASC)
);

