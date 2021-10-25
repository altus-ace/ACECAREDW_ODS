CREATE TABLE [dbo].[ACE_PHARMACY_CLAIMS] (
    [REF_ID]             BIGINT         NOT NULL,
    [RX_FILL_DATE]       DATE           NOT NULL,
    [NDC_CD]             NVARCHAR (20)  NOT NULL,
    [GENERIC_FLAG]       SMALLINT       NOT NULL,
    [PRESCRIBED_QTY]     INT            NOT NULL,
    [DAYS_SUPPLY]        INT            NOT NULL,
    [CONTROLLED_DRUG_CD] SMALLINT       NULL,
    [NETPAID_AMT]        NUMERIC (9, 2) NULL,
    [PAID_DATE]          DATE           NULL,
    [CREATE_DATE]        DATE           NOT NULL,
    [LAST_UPDATE_DATE]   DATE           NOT NULL,
    PRIMARY KEY CLUSTERED ([REF_ID] ASC, [NDC_CD] ASC, [RX_FILL_DATE] ASC)
);

