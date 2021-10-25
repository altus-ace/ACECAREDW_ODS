CREATE TABLE [lst].[lstNtfAction] (
    [CreatedDate]     DATE          DEFAULT (CONVERT([date],getdate())) NULL,
    [CreatedBy]       VARCHAR (50)  DEFAULT (suser_name()) NULL,
    [LastUpdatedDate] DATETIME2 (7) DEFAULT (getdate()) NULL,
    [LastUpdatedBy]   VARCHAR (50)  DEFAULT (suser_name()) NULL,
    [lstNtfActionKey] INT           IDENTITY (1, 1) NOT NULL,
    [TypeDescription] VARCHAR (20)  NOT NULL,
    PRIMARY KEY CLUSTERED ([lstNtfActionKey] ASC)
);

