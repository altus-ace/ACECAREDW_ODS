﻿CREATE TABLE [adw].[FctMembership] (
    [FctMembershipSkey]                     INT             IDENTITY (1, 1) NOT NULL,
    [CreatedDate]                           DATETIME        DEFAULT (getdate()) NULL,
    [CreatedBy]                             VARCHAR (20)    DEFAULT (suser_sname()) NULL,
    [LastUpdatedDate]                       DATETIME        DEFAULT (getdate()) NULL,
    [LastUpdatedBy]                         VARCHAR (20)    DEFAULT (suser_sname()) NULL,
    [AdiKey]                                INT             NULL,
    [SrcFileName]                           VARCHAR (100)   NULL,
    [AdiTableName]                          VARCHAR (100)   NULL,
    [LoadDate]                              DATE            NULL,
    [DataDate]                              DATE            NULL,
    [RwEffectiveDate]                       DATE            NULL,
    [RwExpirationDate]                      DATE            NULL,
    [ClientKey]                             INT             NULL,
    [Ace_ID]                                NUMERIC (15)    NULL,
    [ClientMemberKey]                       VARCHAR (50)    NULL,
    [MBI]                                   VARCHAR (50)    NULL,
    [HICN]                                  VARCHAR (50)    NULL,
    [SubscriberIndicator]                   CHAR (1)        DEFAULT ('') NULL,
    [MemberIndicator]                       CHAR (1)        DEFAULT ('') NULL,
    [Relationship]                          VARCHAR (20)    DEFAULT ('') NULL,
    [FirstName]                             VARCHAR (50)    NULL,
    [MiddleName]                            VARCHAR (50)    DEFAULT ('') NULL,
    [LastName]                              VARCHAR (50)    NULL,
    [Gender]                                VARCHAR (5)     NULL,
    [DOB]                                   DATE            NULL,
    [DOD]                                   DATE            CONSTRAINT [DF__FctMembersh__DOD] DEFAULT ('01/01/1900') NULL,
    [MemberSSN]                             VARCHAR (15)    DEFAULT ('') NULL,
    [CurrentAge]                            INT             NULL,
    [AgeGroup20Years]                       INT             DEFAULT ((0)) NULL,
    [AgeGroup10Years]                       INT             DEFAULT ((0)) NULL,
    [AgeGroup5Years]                        INT             DEFAULT ((0)) NULL,
    [MbrMonth]                              TINYINT         NULL,
    [MbrYear]                               SMALLINT        NULL,
    [LanguageCode]                          VARCHAR (100)   DEFAULT ('') NULL,
    [Ethnicity]                             VARCHAR (20)    DEFAULT ('') NULL,
    [Race]                                  VARCHAR (20)    DEFAULT ('') NULL,
    [MemberHomeAddress]                     VARCHAR (50)    DEFAULT ('') NULL,
    [MemberHomeAddress1]                    VARCHAR (50)    DEFAULT ('') NULL,
    [MemberHomeCity]                        VARCHAR (50)    DEFAULT ('') NULL,
    [MemberHomeState]                       VARCHAR (50)    DEFAULT ('') NULL,
    [CountyName]                            VARCHAR (50)    DEFAULT ('') NULL,
    [CountyNumber]                          VARCHAR (50)    DEFAULT ('') NULL,
    [Region]                                VARCHAR (50)    DEFAULT ('') NULL,
    [POD]                                   VARCHAR (50)    DEFAULT ('') NULL,
    [MemberHomeZip]                         VARCHAR (50)    DEFAULT ('') NULL,
    [MemberMailingAddress]                  VARCHAR (50)    DEFAULT ('') NULL,
    [MemberMailingAddress1]                 VARCHAR (50)    DEFAULT ('') NULL,
    [MemberMailingCity]                     VARCHAR (50)    DEFAULT ('') NULL,
    [MemberMailingState]                    VARCHAR (20)    DEFAULT ('') NULL,
    [MemberMailingZip]                      VARCHAR (50)    DEFAULT ('') NULL,
    [MemberPhone]                           VARCHAR (50)    DEFAULT ('') NULL,
    [MemberCellPhone]                       VARCHAR (50)    DEFAULT ('') NULL,
    [MemberHomePhone]                       VARCHAR (50)    DEFAULT ('') NULL,
    [MedicaidMedicareDualEligibleIndicator] CHAR (1)        DEFAULT ('') NULL,
    [PersonMonthCreatedfromClaimIndicator]  CHAR (1)        DEFAULT ('') NULL,
    [MemberStatus]                          VARCHAR (20)    DEFAULT ('') NULL,
    [EnrollementStatus]                     VARCHAR (10)    DEFAULT ('') NULL,
    [MemberID]                              VARCHAR (50)    DEFAULT ('') NULL,
    [MedicaidID]                            VARCHAR (50)    DEFAULT ('') NULL,
    [CardID]                                VARCHAR (50)    DEFAULT ('') NULL,
    [FamilyID]                              VARCHAR (50)    DEFAULT ('') NULL,
    [BenefitType]                           VARCHAR (50)    DEFAULT ('') NULL,
    [LOB]                                   VARCHAR (20)    DEFAULT ('') NULL,
    [PlanID]                                VARCHAR (50)    DEFAULT ('') NULL,
    [ProductCode]                           VARCHAR (50)    DEFAULT ('') NULL,
    [SubgrpID]                              VARCHAR (50)    DEFAULT ('') NULL,
    [SubgrpName]                            VARCHAR (50)    DEFAULT ('') NULL,
    [PlanName]                              VARCHAR (50)    DEFAULT ('') NULL,
    [PlanType]                              VARCHAR (10)    DEFAULT ('') NULL,
    [PlanTier]                              VARCHAR (10)    DEFAULT ('') NULL,
    [Contract]                              VARCHAR (20)    DEFAULT ('') NULL,
    [NPI]                                   VARCHAR (10)    DEFAULT ('') NULL,
    [PcpPracticeTIN]                        VARCHAR (50)    DEFAULT ('') NULL,
    [ProviderFirstName]                     VARCHAR (50)    DEFAULT ('') NULL,
    [ProviderMI]                            VARCHAR (50)    DEFAULT ('') NULL,
    [ProviderLastName]                      VARCHAR (50)    DEFAULT ('') NULL,
    [ProviderPracticeName]                  VARCHAR (50)    DEFAULT ('') NULL,
    [ProviderAddressLine1]                  VARCHAR (50)    DEFAULT ('') NULL,
    [ProviderAddressLine2]                  VARCHAR (50)    DEFAULT ('') NULL,
    [ProviderCity]                          VARCHAR (20)    DEFAULT ('') NULL,
    [ProviderCounty]                        VARCHAR (20)    DEFAULT ('') NULL,
    [ProviderZip]                           VARCHAR (10)    DEFAULT ('') NULL,
    [ProviderPhone]                         VARCHAR (20)    DEFAULT ('') NULL,
    [ProviderSpecialty]                     VARCHAR (100)   DEFAULT ('') NULL,
    [ProviderNetwork]                       VARCHAR (20)    DEFAULT ('') NULL,
    [SpecialistStatus]                      VARCHAR (20)    DEFAULT ('') NULL,
    [GroupOrPrivatePractice]                VARCHAR (20)    DEFAULT ('') NULL,
    [ProviderPOD]                           VARCHAR (20)    DEFAULT ('') NULL,
    [ProviderChapter]                       VARCHAR (20)    DEFAULT ('') NULL,
    [AceRiskScore]                          DECIMAL (5, 2)  DEFAULT ((0)) NULL,
    [AceRiskScoreLevel]                     DECIMAL (5, 2)  DEFAULT ((0)) NULL,
    [ClientRiskScore]                       DECIMAL (10, 2) DEFAULT ((0)) NULL,
    [ClientRiskScoreLevel]                  DECIMAL (25, 2) DEFAULT ((0)) NULL,
    [RiskScoreUtilization]                  DECIMAL (5, 2)  DEFAULT ((0)) NULL,
    [RiskScoreClinical]                     DECIMAL (5, 2)  DEFAULT ((0)) NULL,
    [RiskScoreHRA]                          DECIMAL (5, 2)  DEFAULT ((0)) NULL,
    [RiskScorePlaceHolder]                  DECIMAL (5, 2)  DEFAULT ((0)) NULL,
    [EnrollmentYear]                        SMALLINT        DEFAULT ((0)) NULL,
    [EnrollmentQuarter]                     TINYINT         DEFAULT ((0)) NULL,
    [EnrollmentYearQuarter]                 TINYINT         DEFAULT ((0)) NULL,
    [EnrollmentYearMonth]                   TINYINT         DEFAULT ((0)) NULL,
    [EligibleYear]                          SMALLINT        DEFAULT ((0)) NULL,
    [EligibilityQuarter]                    TINYINT         DEFAULT ((0)) NULL,
    [EligibilityYearQuarter]                TINYINT         DEFAULT ((0)) NULL,
    [EligibilityYearMonth]                  TINYINT         DEFAULT ((0)) NULL,
    [MemberCount]                           TINYINT         DEFAULT ((0)) NULL,
    [AvgMemberCount]                        TINYINT         DEFAULT ((0)) NULL,
    [SubscriberCount]                       TINYINT         DEFAULT ((0)) NULL,
    [AvgSubscriberCount]                    TINYINT         DEFAULT ((0)) NULL,
    [PersonCreatedCount]                    TINYINT         DEFAULT ((0)) NULL,
    [MemberMonths]                          TINYINT         DEFAULT ((0)) NULL,
    [SubscriberMonths]                      TINYINT         DEFAULT ((0)) NULL,
    [FamilyRatio]                           TINYINT         DEFAULT ((0)) NULL,
    [AvgAge]                                TINYINT         DEFAULT ((0)) NULL,
    [NoOfMonths]                            TINYINT         DEFAULT ((0)) NULL,
    [MemberCurrentEffectiveDate]            DATE            NULL,
    [MemberCurrentExpirationDate]           DATE            NULL,
    [Active]                                BIT             NULL,
    [Excluded]                              BIT             DEFAULT ((0)) NULL,
    PRIMARY KEY CLUSTERED ([FctMembershipSkey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ndx_FctMbrshp_RowEffDateRowExpDate]
    ON [adw].[FctMembership]([RwEffectiveDate] ASC, [RwExpirationDate] ASC)
    INCLUDE([ClientKey], [ClientMemberKey], [Gender], [DOB], [CurrentAge]);


GO
CREATE NONCLUSTERED INDEX [ndx_FctMbrshp_RwEffRwExp]
    ON [adw].[FctMembership]([RwEffectiveDate] ASC, [RwExpirationDate] ASC)
    INCLUDE([ClientKey], [ClientMemberKey], [MBI], [FirstName], [LastName], [Gender], [CurrentAge], [DOB], [LOB], [PlanName], [Contract], [NPI], [PcpPracticeTIN], [ProviderFirstName], [ProviderLastName], [ProviderPracticeName], [ProviderChapter], [ClientRiskScore]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctMembership_17_1219535428__K33_K32_K15]
    ON [adw].[FctMembership]([MbrYear] ASC, [MbrMonth] ASC, [ClientMemberKey] ASC);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctMembership_17_1219535428__K11_K12_13_15_72_73]
    ON [adw].[FctMembership]([RwEffectiveDate] ASC, [RwExpirationDate] ASC)
    INCLUDE([ClientKey], [ClientMemberKey], [NPI], [PcpPracticeTIN]);


GO
CREATE NONCLUSTERED INDEX [ndx_FctMbrShp_RwEffRwExpDodActive]
    ON [adw].[FctMembership]([RwEffectiveDate] ASC, [RwExpirationDate] ASC, [DOD] ASC, [Active] ASC)
    INCLUDE([ClientKey], [ClientMemberKey], [Gender], [DOB], [CurrentAge]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctMembership_17_1219535428__K33_118]
    ON [adw].[FctMembership]([MbrYear] ASC)
    INCLUDE([Active]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctMembership_17_1219535428__K72_73]
    ON [adw].[FctMembership]([NPI] ASC)
    INCLUDE([PcpPracticeTIN]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctMembership_17_1219535428__K72_K1_73_77]
    ON [adw].[FctMembership]([NPI] ASC, [FctMembershipSkey] ASC)
    INCLUDE([PcpPracticeTIN], [ProviderPracticeName]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctMembership_17_1219535428__K72_K1_73_74_76_77]
    ON [adw].[FctMembership]([NPI] ASC, [FctMembershipSkey] ASC)
    INCLUDE([PcpPracticeTIN], [ProviderFirstName], [ProviderLastName], [ProviderPracticeName]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctMembership_17_1219535428__K32_K1_K33_118]
    ON [adw].[FctMembership]([MbrMonth] ASC, [FctMembershipSkey] ASC, [MbrYear] ASC)
    INCLUDE([Active]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctMembership_17_1219535428__K33_K11]
    ON [adw].[FctMembership]([MbrYear] ASC, [RwEffectiveDate] ASC);


GO
CREATE NONCLUSTERED INDEX [_dta_index_FctMembership_17_1219535428__K33_K11_K12]
    ON [adw].[FctMembership]([MbrYear] ASC, [RwEffectiveDate] ASC, [RwExpirationDate] ASC);


GO
CREATE NONCLUSTERED INDEX [ndx_FctMbrshp_RwEffRwExpActiveLoadDate]
    ON [adw].[FctMembership]([RwEffectiveDate] ASC, [RwExpirationDate] ASC, [Active] ASC, [LoadDate] ASC)
    INCLUDE([FctMembershipSkey], [ClientMemberKey], [FirstName], [LastName], [DOB], [MemberHomeAddress], [MemberHomeAddress1], [MemberHomeCity], [MemberHomeState], [MemberHomeZip], [MemberHomePhone], [NPI], [PcpPracticeTIN], [ProviderFirstName], [ProviderLastName], [ProviderPracticeName], [ProviderChapter]);

