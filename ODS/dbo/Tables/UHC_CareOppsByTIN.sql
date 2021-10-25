CREATE TABLE [dbo].[UHC_CareOppsByTIN] (
    [URN]                 INT           IDENTITY (1, 1) NOT NULL,
    [PCP_PRACTICE_TIN]    VARCHAR (255) NULL,
    [Measure_Description] VARCHAR (255) NULL,
    [Sub_Meas]            VARCHAR (255) NULL,
    [Adherent]            INT           NULL,
    [NonAdherent]         INT           NULL,
    [Total]               INT           NULL,
    [Rate]                VARCHAR (20)  NULL,
    [Target]              VARCHAR (20)  NULL,
    [GapsToTarget]        INT           NULL,
    [Status]              VARCHAR (255) NULL,
    [Context]             VARCHAR (255) NULL,
    [IsInverted]          VARCHAR (255) NULL,
    [A_LAST_UPDATE_DATE]  DATETIME      DEFAULT (getdate()) NULL,
    [A_LAST_UPDATE_By]    VARCHAR (50)  DEFAULT (suser_sname()) NULL,
    [A_LAST_UPDATE_FLAG]  VARCHAR (1)   DEFAULT ('Y') NULL,
    PRIMARY KEY CLUSTERED ([URN] ASC)
);

