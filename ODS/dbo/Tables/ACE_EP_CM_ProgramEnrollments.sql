CREATE TABLE [dbo].[ACE_EP_CM_ProgramEnrollments] (
    [URN]                       INT           IDENTITY (1, 1) NOT NULL,
    [Client_id]                 VARCHAR (50)  NOT NULL,
    [Program_Name]              VARCHAR (50)  NOT NULL,
    [Enroll_date]               VARCHAR (50)  NOT NULL,
    [Create_date]               VARCHAR (50)  NOT NULL,
    [Member_id]                 VARCHAR (50)  NOT NULL,
    [Enroll_END_DATE]           VARCHAR (50)  NOT NULL,
    [External_unique_indicator] VARCHAR (2)   NOT NULL,
    [A_Created_Date]            DATETIME2 (7) DEFAULT (getdate()) NOT NULL,
    [A_CREATED_BY]              VARCHAR (100) DEFAULT (suser_sname()) NOT NULL,
    [A_EXPORTED]                TINYINT       DEFAULT ((0)) NULL,
    [A_EXPORTED_DATE]           DATETIME2 (7) DEFAULT ('01/01/1980') NULL,
    [A_AUDIT_ID]                INT           NULL,
    PRIMARY KEY CLUSTERED ([URN] ASC)
);

