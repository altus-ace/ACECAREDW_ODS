CREATE TABLE [dbo].[zz_temp_HRCOhortsmissing] (
    [Payor]                              VARCHAR (50)  NULL,
    [Patient_First]                      VARCHAR (100) NULL,
    [Patient_Last]                       VARCHAR (100) NULL,
    [dob]                                VARCHAR (50)  NULL,
    [Disenrolled_Date]                   VARCHAR (50)  NULL,
    [Last_PCP_Visit (Claims)]            VARCHAR (50)  NULL,
    [Last_PCP_Visit (Clinic Record)]     VARCHAR (50)  NULL,
    [Next_PCP_Visit (Schedule if blank)] VARCHAR (50)  NULL,
    [Assigned_PCP]                       VARCHAR (50)  NULL,
    [Total_ER_Visits_in_last_90_days]    VARCHAR (50)  NULL,
    [Overall_Risk_Score]                 VARCHAR (50)  NULL
);

