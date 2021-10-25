CREATE TABLE [dbo].[tmp_vw_ACE_ALT_PE] (
    [sKey_tmp_vw_ACE_ALT_PE] INT             IDENTITY (1, 1) NOT NULL,
    [CLIENT_PATIENT_ID]      NVARCHAR (100)  NULL,
    [LOB]                    NVARCHAR (2000) NULL,
    [PROGRAM_NAME]           NVARCHAR (2000) NULL,
    [START_DATE]             DATETIME        NULL,
    [end_date]               DATETIME        NULL,
    [plan_start_date]        DATETIME        NULL,
    [plan_end_date]          DATETIME        NULL,
    [PROGRAM_STATUS_NAME]    VARCHAR (2000)  NULL,
    PRIMARY KEY CLUSTERED ([sKey_tmp_vw_ACE_ALT_PE] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ndx_tmp_vw_Ace_Alt_PE_CLientPatientID_ProgramName]
    ON [dbo].[tmp_vw_ACE_ALT_PE]([CLIENT_PATIENT_ID] ASC, [PROGRAM_NAME] ASC)
    INCLUDE([LOB], [START_DATE], [plan_end_date], [PROGRAM_STATUS_NAME]);

