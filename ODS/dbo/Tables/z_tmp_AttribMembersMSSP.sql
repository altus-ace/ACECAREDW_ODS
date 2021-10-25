CREATE TABLE [dbo].[z_tmp_AttribMembersMSSP] (
    [URN]              INT          IDENTITY (1, 1) NOT NULL,
    [DataDate]         DATE         NULL,
    [EffectiveDate]    DATE         NULL,
    [C_EffectiveDate]  DATE         NULL,
    [C_TerminateDate]  DATE         NULL,
    [MbrCnt]           INT          NULL,
    [NPI]              VARCHAR (50) NULL,
    [ClientKey]        INT          NULL,
    [ClientMemberKey]  VARCHAR (50) NULL,
    [DOD]              VARCHAR (20) NULL,
    [RwEffectiveDate]  DATE         NULL,
    [RwExpirationDate] DATE         NULL,
    [Active]           INT          NULL,
    [adiPlan]          VARCHAR (5)  NULL,
    [CreateDate]       DATE         DEFAULT (getdate()) NULL,
    [CreateBy]         VARCHAR (50) DEFAULT (suser_sname()) NULL
);

