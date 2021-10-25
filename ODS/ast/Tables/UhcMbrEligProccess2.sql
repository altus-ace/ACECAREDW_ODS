CREATE TABLE [ast].[UhcMbrEligProccess2] (
    [batchID]        INT          NULL,
    [LoadDate]       DATE         NULL,
    [ProcessedState] TINYINT      DEFAULT ((0)) NULL,
    [createdDate]    DATETIME     DEFAULT (getdate()) NULL,
    [createdBy]      VARCHAR (50) DEFAULT (suser_sname()) NULL
);

