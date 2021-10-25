CREATE TABLE [dbo].[tmp_vw_ACE_Get_PM_Appt] (
    [sKey_tmp_vw_ACE_Get_PM_Appt] INT             IDENTITY (1, 1) NOT NULL,
    [Member_id]                   NVARCHAR (100)  NULL,
    [PROG_ID]                     NVARCHAR (2000) NULL,
    [PROGRAM_START_DATE]          DATETIME        NULL,
    [PROGRAM_MONTH]               CHAR (3)        NULL,
    [PROGRAM_YEAR]                INT             NULL,
    [PROG_MEMBER_STATUS]          NVARCHAR (2000) NULL,
    [APPT_SCH_BY]                 NVARCHAR (200)  NULL,
    [APPT_CREATED_ON]             DATETIME        NULL,
    [APPOINTMENT_ID]              INT             NULL,
    [APPT_STATUS]                 NVARCHAR (1000) NULL,
    [Appointment_date]            DATETIME        NULL,
    [APPT_NOTES]                  NTEXT           NULL,
    [CARE_TEAM]                   NVARCHAR (202)  NULL,
    [PHYSICIAN_NAME]              NVARCHAR (400)  NULL,
    [PRACTICE_NAME]               NVARCHAR (400)  NULL,
    [APPOINTMENT_PROVIDER]        NVARCHAR (400)  NULL,
    PRIMARY KEY CLUSTERED ([sKey_tmp_vw_ACE_Get_PM_Appt] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ace_Ndx_tmp_vw_ACE_Get_PM_Appt_MemberId_ProgId]
    ON [dbo].[tmp_vw_ACE_Get_PM_Appt]([Member_id] ASC, [PROG_ID] ASC)
    INCLUDE([CARE_TEAM], [APPT_SCH_BY], [APPT_CREATED_ON], [APPOINTMENT_ID], [Appointment_date], [APPT_STATUS], [APPOINTMENT_PROVIDER], [PHYSICIAN_NAME], [PRACTICE_NAME]);

