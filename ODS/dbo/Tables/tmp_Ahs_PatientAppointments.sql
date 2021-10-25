CREATE TABLE [dbo].[tmp_Ahs_PatientAppointments] (
    [tmpAhsPatientAppointmentsSKey] INT            IDENTITY (1, 1) NOT NULL,
    [ClientMemberKey]               VARCHAR (50)   NULL,
    [AppointmentStatusName]         VARCHAR (50)   NULL,
    [AppointmentDate]               DATETIME       NULL,
    [AppointmentScheduledBy]        VARCHAR (50)   NULL,
    [AppointmentNote]               VARCHAR (5000) NULL,
    [AppointmentCreatedDate]        DATETIME       NULL,
    [LOB]                           VARCHAR (50)   NULL,
    [ShcnMsspLoadStatus]            TINYINT        CONSTRAINT [DF_dboTmpAhsPatientAppt] DEFAULT ((0)) NULL,
    [srcFileName]                   VARCHAR (100)  NULL,
    [LoadDate]                      DATE           NULL,
    [CreatedDate]                   DATETIME       DEFAULT (getdate()) NULL,
    [CreatedBy]                     VARCHAR (100)  DEFAULT (suser_sname()) NULL,
    PRIMARY KEY CLUSTERED ([tmpAhsPatientAppointmentsSKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ndx_tmpAhsPatientAppointments_ClientMemberKey_AppointmentCreatedDate]
    ON [dbo].[tmp_Ahs_PatientAppointments]([ClientMemberKey] ASC, [AppointmentCreatedDate] ASC)
    INCLUDE([tmpAhsPatientAppointmentsSKey], [AppointmentStatusName], [AppointmentScheduledBy]);

