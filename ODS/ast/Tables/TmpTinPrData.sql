CREATE TABLE [ast].[TmpTinPrData] (
    [astPrvdrLob]         VARCHAR (50)   NULL,
    [NPI]                 VARCHAR (8000) NULL,
    [TIN]                 VARCHAR (8000) NULL,
    [TinLOB]              VARCHAR (8000) NULL,
    [TinHealthPlan]       VARCHAR (8000) NULL,
    [TinHpEffectiveDate]  VARCHAR (8000) NULL,
    [TinHpExpirationDate] VARCHAR (8000) NULL,
    [PrimarySpeciality]   VARCHAR (8000) NULL,
    [Sub_Speciality]      VARCHAR (8000) NULL,
    [ClnLOB]              VARCHAR (8000) NULL,
    [CalcClientKey]       INT            NOT NULL
);

