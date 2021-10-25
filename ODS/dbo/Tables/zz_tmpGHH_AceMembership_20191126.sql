CREATE TABLE [dbo].[zz_tmpGHH_AceMembership_20191126] (
    [ID]               NUMERIC (18) NOT NULL,
    [LAST_NAME]        VARCHAR (50) NOT NULL,
    [FIRST_NAME]       VARCHAR (50) NOT NULL,
    [MIDDLE_NAME]      VARCHAR (50) NULL,
    [DOB]              INT          NOT NULL,
    [GENDER]           CHAR (10)    NOT NULL,
    [SSN]              CHAR (10)    NULL,
    [STREET_ADDRESS_1] VARCHAR (50) NOT NULL,
    [STREET_ADDRESS_2] VARCHAR (50) NULL,
    [CITY]             VARCHAR (50) NOT NULL,
    [STATE]            VARCHAR (50) NULL,
    [ZIP]              VARCHAR (50) NOT NULL,
    [PHONE]            VARCHAR (50) NULL,
    [ELIG_DATE]        INT          NOT NULL,
    [EXP_DATE]         INT          NOT NULL
);

