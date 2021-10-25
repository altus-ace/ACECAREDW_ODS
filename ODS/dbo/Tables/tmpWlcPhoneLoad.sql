CREATE TABLE [dbo].[tmpWlcPhoneLoad] (
    [mbrLoadHistoryKey] INT          NULL,
    [mbrMemberKey]      INT          NULL,
    [MbrPhoneKey]       INT          NULL,
    [adiPhone]          VARCHAR (30) NULL,
    [adiDataDate]       DATE         NULL,
    [phone]             VARCHAR (30) NULL,
    [phoneTypeKey]      INT          NULL,
    [CarrierType]       INT          NULL,
    [EffectiveDate]     DATE         NULL,
    [NewExpirationDate] DATE         NULL,
    [LoadType]          CHAR (1)     NULL
);

