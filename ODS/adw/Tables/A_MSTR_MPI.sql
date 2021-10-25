CREATE TABLE [adw].[A_MSTR_MPI] (
    [A_MSTR_MRN]     NUMERIC (15)  IDENTITY (100000000000000, 1) NOT NULL,
    [First_Name]     VARCHAR (100) NULL,
    [Last_Name]      VARCHAR (100) NULL,
    [Middle_Initial] VARCHAR (50)  NULL,
    [Date_Of_Birth]  DATETIME      NOT NULL,
    [Gender]         CHAR (1)      NULL,
    [Medicare_ID]    VARCHAR (20)  NULL,
    [Medicaid_ID]    NUMERIC (11)  NULL,
    [src_URN]        VARCHAR (50)  NOT NULL,
    [src_TblName]    VARCHAR (50)  NOT NULL,
    [ACTIVE]         TINYINT       DEFAULT ((1)) NOT NULL,
    [Merged_To_MRN]  NUMERIC (15)  DEFAULT ((0)) NOT NULL,
    [A_CREATED_DATE] DATETIME2 (7) DEFAULT (getdate()) NULL,
    [A_CREATED_BY]   VARCHAR (50)  DEFAULT (suser_sname()) NULL,
    [A_UPDATED_DATE] DATETIME2 (7) DEFAULT (getdate()) NULL,
    [A_UPDATED_BY]   VARCHAR (50)  DEFAULT (suser_sname()) NULL,
    [A_Mstr_Mrn1]    NUMERIC (15)  NULL,
    PRIMARY KEY CLUSTERED ([A_MSTR_MRN] ASC)
);

