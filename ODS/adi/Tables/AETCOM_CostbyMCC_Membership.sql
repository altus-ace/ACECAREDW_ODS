CREATE TABLE [adi].[AETCOM_CostbyMCC_Membership] (
    [AETCOM_CostbyMCC_MembershipKey] INT             IDENTITY (1, 1) NOT NULL,
    [SrcFileName]                    VARCHAR (100)   NOT NULL,
    [LoadDate]                       DATE            NOT NULL,
    [DataDate]                       DATE            NOT NULL,
    [CreatedDate]                    DATETIME        CONSTRAINT [DF_adiAETCOM_CostbyMCC_Membership_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                      VARCHAR (50)    CONSTRAINT [DF_adiAETCOM_CostbyMCC_Membership_CreatedBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]                DATETIME        CONSTRAINT [DF_adiAETCOM_CostbyMCC_Membership_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]                  VARCHAR (50)    CONSTRAINT [DF_adiAETCOM_CostbyMCC_Membership_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [Attributed_Provider_ID]         VARCHAR (20)    NULL,
    [Attributed_Provider_Name]       VARCHAR (50)    NULL,
    [Avg_Member_Count]               INT             NULL,
    [Member_Months]                  INT             NULL,
    [Avg_Retro_Risk]                 DECIMAL (10, 2) NULL,
    [Avg_Age]                        INT             NULL,
    [DOS]                            VARCHAR (50)    NULL,
    PRIMARY KEY CLUSTERED ([AETCOM_CostbyMCC_MembershipKey] ASC)
);

