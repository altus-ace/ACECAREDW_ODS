CREATE TABLE [dbo].[ACE_MEDICAL_CLAIMS] (
    [REF_ID]           BIGINT         NOT NULL,
    [CLAIM_NBR]        NVARCHAR (20)  NOT NULL,
    [LINE_SEQ]         INT            NOT NULL,
    [PROVIDER_ID]      INT            NULL,
    [PROCEDURE_CD]     NVARCHAR (10)  NULL,
    [REV_CD]           NVARCHAR (10)  NULL,
    [BILL_TYPE]        NVARCHAR (3)   NULL,
    [DIAGNOSIS_CD]     NVARCHAR (10)  NULL,
    [HSERVICE_DESC]    NVARCHAR (50)  NULL,
    [QTY]              INT            NULL,
    [NETPAID_AMT]      NUMERIC (9, 2) NULL,
    [FROM_DOS]         DATE           NOT NULL,
    [TO_DOS]           DATE           NOT NULL,
    [PAID_DATE]        DATE           NULL,
    [CREATE_DATE]      DATE           NOT NULL,
    [LAST_UPDATE_DATE] DATE           NOT NULL,
    PRIMARY KEY CLUSTERED ([REF_ID] ASC, [CLAIM_NBR] ASC, [LINE_SEQ] ASC)
);

