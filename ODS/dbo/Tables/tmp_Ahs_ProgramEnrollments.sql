CREATE TABLE [dbo].[tmp_Ahs_ProgramEnrollments] (
    [tmpAhsPatientAppointmentsSKey] INT           IDENTITY (1, 1) NOT NULL,
    [ClientMemberKey]               VARCHAR (50)  NOT NULL,
    [LOB]                           VARCHAR (50)  NOT NULL,
    [ProgramName]                   VARCHAR (100) NOT NULL,
    [StartDate]                     DATETIME      NULL,
    [EndDate]                       DATETIME      NULL,
    [PlanStartDate]                 DATETIME      NULL,
    [PlanEndDate]                   DATETIME      NULL,
    [ProgramStatusName]             VARCHAR (100) NULL,
    [UpdatedOnDate]                 DATETIME      NULL,
    [srcFileName]                   VARCHAR (100) NULL,
    [LoadDate]                      DATE          NULL,
    [CreatedDate]                   DATETIME      CONSTRAINT [DF_dboTmpAhsProgEnroll_CreatedDate] DEFAULT (getdate()) NULL,
    [CreatedBy]                     VARCHAR (100) CONSTRAINT [DF_dboTmpAhsProgEnroll_CreatedBy] DEFAULT (suser_sname()) NULL,
    [ShcnMsspLoadStatus]            TINYINT       CONSTRAINT [DF_dboTmpAhsProgEnroll] DEFAULT ((0)) NULL,
    [ShcnBcbsLoadStatus]            TINYINT       DEFAULT ((0)) NULL,
    [LoadStatus_AcdwClmsUhc]        TINYINT       DEFAULT ((0)) NOT NULL,
    [LoadStatus_AcdwClmsAMGTX_MA]   TINYINT       DEFAULT ((0)) NULL,
    [LoadStatus_AcdwClmsAMGTX_MCD]  TINYINT       DEFAULT ((0)) NULL,
    PRIMARY KEY CLUSTERED ([tmpAhsPatientAppointmentsSKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ndx_tmpAhsProgEnrol_LoadDate]
    ON [dbo].[tmp_Ahs_ProgramEnrollments]([LoadDate] ASC);


GO
CREATE NONCLUSTERED INDEX [ndx_tmpAhsProgEnrol_ProgNameEndDateProgStatus]
    ON [dbo].[tmp_Ahs_ProgramEnrollments]([ProgramName] ASC, [EndDate] ASC, [ProgramStatusName] ASC)
    INCLUDE([ClientMemberKey], [LoadDate]);

