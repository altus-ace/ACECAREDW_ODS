CREATE TABLE [dbo].[tmpIpNtf] (
    [ENTITY]                   VARCHAR (20)  NULL,
    [SITE]                     VARCHAR (20)  NULL,
    [UID_STATE]                VARCHAR (20)  NULL,
    [UID_PROVIDER]             VARCHAR (50)  NULL,
    [TREATMENT_TYPE]           VARCHAR (10)  NULL,
    [MEMEBR_ID]                VARCHAR (50)  NULL,
    [CASE_ID]                  INT           NULL,
    [CASE_TYPE]                VARCHAR (10)  NULL,
    [ADMIT_NOTIFICATION_DATE]  DATE          NULL,
    [ADIMSSION_DATE]           DATE          NULL,
    [DISCHARGE_DATE]           DATE          NULL,
    [DISCHARGE_DISPOSITION]    VARCHAR (100) NULL,
    [FOLLOW_UP_VISIT_DUE_DATE] DATE          NULL,
    [SCHEDULED_VISIT_DATE]     DATE          NULL,
    [PRIMARY_DIAGNOSIS]        VARCHAR (100) NULL,
    [ADMIT_HOSPITAL]           VARCHAR (100) NULL,
    [CLIENT_ID]                VARCHAR (10)  NULL
);

