CREATE TABLE [ast].[QmList_Temp] (
    [QmMsrID]        VARCHAR (50) NULL,
    [Invert]         BIT          DEFAULT ((0)) NOT NULL,
    [InContract]     BIT          DEFAULT ((1)) NOT NULL,
    [EffectiveDate]  DATE         NOT NULL,
    [ExpirationDate] DATE         NOT NULL,
    [CreatedDate]    DATETIME     DEFAULT (getdate()) NOT NULL,
    [CreatedBy]      VARCHAR (50) DEFAULT (suser_sname()) NULL
);

