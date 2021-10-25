CREATE TABLE [adw].[MbrMember_OldMrn] (
    [mbrMemberKey]    INT           IDENTITY (1, 1) NOT NULL,
    [ClientMemberKey] VARCHAR (20)  NOT NULL,
    [ClientKey]       INT           NOT NULL,
    [MstrMrnKey]      NUMERIC (15)  NOT NULL,
    [mbrLoadKey]      INT           NOT NULL,
    [LoadDate]        DATE          NOT NULL,
    [DataDate]        DATE          NOT NULL,
    [CreatedDate]     DATETIME2 (7) NOT NULL,
    [CreatedBy]       VARCHAR (50)  NOT NULL,
    [LastUpdatedDate] DATETIME2 (7) NOT NULL,
    [LastUpdatedBy]   VARCHAR (50)  NOT NULL,
    PRIMARY KEY CLUSTERED ([mbrMemberKey] ASC)
);

