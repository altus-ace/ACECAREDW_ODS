CREATE TABLE [amd].[ACE_ETL_Audit_Header] (
    [EtlAuditHeader_Pkey]  INT           IDENTITY (1, 1) NOT NULL,
    [EtlAudit_Status]      SMALLINT      DEFAULT ((0)) NULL,
    [PackageName]          VARCHAR (200) NULL,
    [ActionStartTime]      DATETIME2 (7) NULL,
    [ActionStopTime]       DATETIME2 (7) NULL,
    [InputSourceName]      VARCHAR (200) NULL,
    [InputCount]           INT           NULL,
    [DestinationName]      VARCHAR (200) NULL,
    [DestinationCount]     INT           NULL,
    [ErrorDestinationName] VARCHAR (200) NULL,
    [ErrorCount]           INT           NULL,
    [Created_Date]         DATETIME2 (7) DEFAULT (getdate()) NULL,
    [Created_By]           VARCHAR (200) DEFAULT (suser_sname()) NULL,
    PRIMARY KEY CLUSTERED ([EtlAuditHeader_Pkey] ASC)
);

