CREATE TABLE [dbo].[tmp_vw_ACE_Get_PM_Calls] (
    [sKey_tmp_vw_ACE_Get_PM_Calls] INT             IDENTITY (1, 1) NOT NULL,
    [pid]                          BIGINT          NULL,
    [program_name]                 NVARCHAR (2000) NULL,
    [member_id]                    NVARCHAR (100)  NULL,
    [create_date]                  DATETIME        NULL,
    [FOLLOWUP_DATE]                DATETIME        NULL,
    [create_month]                 CHAR (3)        NULL,
    [care_activity_type_name]      VARCHAR (200)   NULL,
    [activity_outcome]             NTEXT           NULL,
    [performed_date]               DATETIME        NULL,
    [created_by]                   NVARCHAR (200)  NULL,
    [activity_duration]            NVARCHAR (20)   NULL,
    PRIMARY KEY CLUSTERED ([sKey_tmp_vw_ACE_Get_PM_Calls] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ace_Ndx_tmp_vw_ACE_Get_PM_Calls_MemberId_ProgramName]
    ON [dbo].[tmp_vw_ACE_Get_PM_Calls]([member_id] ASC, [program_name] ASC)
    INCLUDE([create_date], [FOLLOWUP_DATE], [performed_date], [created_by], [care_activity_type_name]);

