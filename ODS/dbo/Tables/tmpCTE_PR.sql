CREATE TABLE [dbo].[tmpCTE_PR] (
    [RowEffectiveDate]  DATE         NOT NULL,
    [RowExpirationDate] DATE         NOT NULL,
    [PR_NPI]            VARCHAR (10) NULL,
    [ActiveFlg]         INT          NOT NULL,
    [UHCMedicaid]       INT          NULL,
    [MSSP]              INT          NULL,
    [AetnaMA]           INT          NULL,
    [CignaMA]           INT          NULL,
    [DevotedMA]         INT          NULL,
    [WellcareMA]        INT          NULL,
    [AetnaComm]         INT          NULL,
    [BCBSComm]          INT          NULL,
    [Other]             INT          NULL,
    [Total]             INT          NULL
);

