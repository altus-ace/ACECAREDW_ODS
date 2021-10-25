CREATE TABLE [dbo].[ACE_MAP_PROGRAMS_HEDIS] (
    [URN]                      BIGINT         IDENTITY (1, 1) NOT NULL,
    [SOURCE]                   VARCHAR (50)   NULL,
    [SOURCE_MEASURE_ID]        VARCHAR (1000) NULL,
    [SOURCE_MEASURE_NAME]      VARCHAR (1000) NULL,
    [DESTINATION]              VARCHAR (50)   NULL,
    [DESTINATION_PROGRAM_NAME] VARCHAR (1000) NULL,
    [A_LAST_UPDATE_DATE]       DATETIME       NULL,
    [A_LAST_UPDATE_BY]         VARCHAR (50)   NULL,
    [IS_ACTIVE]                INT            NULL,
    [ACE_PROG_ID]              VARCHAR (50)   NULL,
    PRIMARY KEY CLUSTERED ([URN] ASC)
);

