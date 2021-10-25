CREATE TABLE [dbo].[ACE_JOB_EXPORTS] (
    [JobID]        INT            IDENTITY (1, 1) NOT NULL,
    [Active]       VARCHAR (1)    NOT NULL,
    [Description]  NVARCHAR (150) NULL,
    [SQLStatement] NVARCHAR (MAX) NULL,
    [OutputType]   NCHAR (10)     NULL,
    [OutputName]   NVARCHAR (50)  NULL,
    [OutputPath]   NVARCHAR (150) NULL,
    CONSTRAINT [PK_ACE_JOB_EXPORTS] PRIMARY KEY CLUSTERED ([JobID] ASC)
);

