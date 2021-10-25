CREATE TABLE [dbo].[ACE_MAP_CAREOPPS_PROGRAMS] (
    [URN]                      BIGINT         IDENTITY (1, 1) NOT NULL,
    [SOURCE]                   VARCHAR (50)   NULL,
    [SOURCE_MEASURE_NAME]      VARCHAR (1000) NULL,
    [SOURCE_SUB_MEASURE_NAME]  VARCHAR (1000) NULL,
    [DESTINATION]              VARCHAR (50)   NULL,
    [DESTINATION_PROGRAM_NAME] VARCHAR (1000) NULL,
    [A_LAST_UPDATE_DATE]       DATETIME       NULL,
    [A_LAST_UPDATE_BY]         VARCHAR (50)   NULL,
    [IS_ACTIVE]                INT            NULL,
    [Criteria]                 CHAR (10)      NULL,
    [ACE_PROG_ID]              VARCHAR (50)   NULL,
    [srcFilename]              VARCHAR (100)  NULL,
    CONSTRAINT [PK_ACE_MAP_CAREOPPS_PROGRAMS] PRIMARY KEY CLUSTERED ([URN] ASC)
);

