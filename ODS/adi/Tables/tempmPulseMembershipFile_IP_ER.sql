CREATE TABLE [adi].[tempmPulseMembershipFile_IP_ER] (
    [tempMbrIPKey]       INT           IDENTITY (1, 1) NOT NULL,
    [Client]             VARCHAR (10)  NULL,
    [MemberID]           VARCHAR (50)  NULL,
    [MemberFirstName]    VARCHAR (50)  NULL,
    [MemberLastName]     VARCHAR (50)  NULL,
    [DOB]                DATE          NULL,
    [phonenumber]        VARCHAR (15)  NULL,
    [Discharge_Flag]     VARCHAR (50)  NULL,
    [Language]           VARCHAR (50)  NULL,
    [loadDate]           DATE          NOT NULL,
    [DataDate]           DATE          NOT NULL,
    [OrignalSrcFileName] VARCHAR (100) NOT NULL,
    [SrcFileName]        VARCHAR (100) NOT NULL,
    [CreatedDate]        DATETIME2 (7) CONSTRAINT [DF_tempmPulseMembershipFile_IP_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]          VARCHAR (50)  CONSTRAINT [DF_tempmPulseMembershipFile_IP_CreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]    DATETIME2 (7) CONSTRAINT [DF_tempmPulseMembershipFile_IP_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]      VARCHAR (50)  CONSTRAINT [DF_tempmPulseMembershipFile_IP_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([tempMbrIPKey] ASC)
);

