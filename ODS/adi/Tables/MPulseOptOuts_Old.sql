CREATE TABLE [adi].[MPulseOptOuts_Old] (
    [MpulseOptOutUrn]  INT           IDENTITY (1, 1) NOT NULL,
    [LoadDate]         DATE          NOT NULL,
    [DataDate]         DATE          NOT NULL,
    [SrcFileName]      VARCHAR (100) NOT NULL,
    [CreatedDate]      DATE          NOT NULL,
    [CreatedBy]        VARCHAR (50)  NOT NULL,
    [LastUpdatedDate]  DATE          NOT NULL,
    [LastUpdatedBy]    VARCHAR (50)  NOT NULL,
    [OptOut_Date_Time] DATETIME      NULL,
    [ClientMemberKey]  VARCHAR (50)  NULL,
    [ClientKey]        VARCHAR (50)  NULL,
    [Ace_ID]           NUMERIC (15)  NULL,
    [FirstName]        VARCHAR (50)  NULL,
    [LastName]         VARCHAR (50)  NULL,
    [PhoneNumber]      VARCHAR (35)  NULL,
    PRIMARY KEY CLUSTERED ([MpulseOptOutUrn] ASC)
);

