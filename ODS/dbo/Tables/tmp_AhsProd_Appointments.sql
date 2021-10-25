CREATE TABLE [dbo].[tmp_AhsProd_Appointments] (
    [Appointment_id] INT            NOT NULL,
    [Member_id]      NVARCHAR (50)  NOT NULL,
    [Appt_Status]    NVARCHAR (500) NOT NULL,
    [Created_on]     DATETIME       NOT NULL,
    [ApptDate]       DATETIME       NULL,
    [Provider_NPI]   NVARCHAR (200) NULL,
    [provider_name]  NVARCHAR (200) NULL,
    [Practice_Name]  NVARCHAR (200) NULL,
    [Practice_Tin]   NVARCHAR (200) NULL
);

