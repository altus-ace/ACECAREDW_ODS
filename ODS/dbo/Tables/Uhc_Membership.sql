﻿CREATE TABLE [dbo].[Uhc_Membership] (
    [URN]                            INT           IDENTITY (1, 1) NOT NULL,
    [ACE_MBR_ID]                     VARCHAR (255) NULL,
    [MEDICAID_ID]                    VARCHAR (255) NULL,
    [MEMBER_LAST_NAME]               VARCHAR (255) NULL,
    [MEMBER_FIRST_NAME]              VARCHAR (255) NULL,
    [DATE_OF_BIRTH]                  VARCHAR (255) NULL,
    [IPRO_ADMIT_RISK_SCORE]          VARCHAR (255) NULL,
    [UHC_SUBSCRIBER_ID]              VARCHAR (255) NULL,
    [UHC_UNIQUE_SYSTEM_ID]           VARCHAR (255) NULL,
    [MEMBER_ADDRESS]                 VARCHAR (255) NULL,
    [MEMBER_CITY]                    VARCHAR (255) NULL,
    [MEMBER_STATE]                   VARCHAR (255) NULL,
    [MEMBER_COUNTY]                  VARCHAR (255) NULL,
    [MEMBER_ZIP]                     VARCHAR (255) NULL,
    [MEMBER_PHONE]                   VARCHAR (255) NULL,
    [LINE_OF_BUSINESS]               VARCHAR (255) NULL,
    [PLAN_CODE]                      VARCHAR (255) NULL,
    [PLAN_DESC]                      VARCHAR (255) NULL,
    [REGION_CODE]                    VARCHAR (255) NULL,
    [REGION_DESC]                    VARCHAR (255) NULL,
    [PCP_NAME]                       VARCHAR (255) NULL,
    [PCP_ADDRESS]                    VARCHAR (255) NULL,
    [PCP_CITY]                       VARCHAR (255) NULL,
    [PCP_STATE]                      VARCHAR (255) NULL,
    [PCP_COUNTY]                     VARCHAR (255) NULL,
    [PCP_ZIP]                        VARCHAR (255) NULL,
    [PCP_PRACTICE_TIN]               VARCHAR (255) NULL,
    [PCP_PRACTICE_NAME]              VARCHAR (255) NULL,
    [PRIMARY_RISK_FACTOR]            VARCHAR (255) NULL,
    [TOTAL_COSTS_LAST_12_MOS]        VARCHAR (255) NULL,
    [COUNT_OPEN_CARE_OPPS]           VARCHAR (255) NULL,
    [INP_COSTS_LAST_12_MOS]          VARCHAR (255) NULL,
    [ER_COSTS_LAST_12_MOS]           VARCHAR (255) NULL,
    [OUTP_COSTS_LAST_12_MOS]         VARCHAR (255) NULL,
    [PHARMACY_COSTS_LAST_12_MOS]     VARCHAR (255) NULL,
    [PRIMARY_CARE_COSTS_LAST_12_MOS] VARCHAR (255) NULL,
    [BEHAVIORAL_COSTS_LAST_12_MOS]   VARCHAR (255) NULL,
    [OTHER_OFFICE_COSTS_LAST_12_MOS] VARCHAR (255) NULL,
    [INP_ADMITS_LAST_12_MOS]         VARCHAR (255) NULL,
    [LAST_INP_DISCHARGE]             VARCHAR (255) NULL,
    [POST_DISCHARGE_FUP_VISIT]       VARCHAR (255) NULL,
    [INP_FUP_WITHIN_7_DAYS]          VARCHAR (255) NULL,
    [ER_VISITS_LAST_12_MOS]          VARCHAR (255) NULL,
    [LAST_ER_VISIT]                  VARCHAR (255) NULL,
    [POST_ER_FUP_VISIT]              VARCHAR (255) NULL,
    [ER_FUP_WITHIN_7_DAYS]           VARCHAR (255) NULL,
    [LAST_PCP_VISIT]                 VARCHAR (255) NULL,
    [LAST_PCP_PRACTICE_SEEN]         VARCHAR (255) NULL,
    [LAST_BH_VISIT]                  VARCHAR (255) NULL,
    [LAST_BH_PRACTICE_SEEN]          VARCHAR (255) NULL,
    [MEMBER_MONTH_COUNT]             VARCHAR (255) NULL,
    [FILE_GENERATION_DATE]           VARCHAR (255) NULL,
    [REPORT_MONTH]                   VARCHAR (255) NULL,
    [A_LAST_UPDATE_DATE]             DATE          DEFAULT (getdate()) NULL,
    [A_LAST_UPDATE_BY]               VARCHAR (255) DEFAULT ('PKG Import') NULL,
    [A_LAST_UPDATE_FLAG]             VARCHAR (1)   DEFAULT ('Y') NULL,
    [SrcFileName]                    VARCHAR (100) NULL,
    CONSTRAINT [PK_UHC_Membership] PRIMARY KEY CLUSTERED ([URN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ndx_UHC_Membership_LastUpdateFlag]
    ON [dbo].[Uhc_Membership]([A_LAST_UPDATE_FLAG] ASC)
    INCLUDE([URN], [UHC_SUBSCRIBER_ID]);


GO
CREATE NONCLUSTERED INDEX [ndx_UHC_Membership_SubscriberID]
    ON [dbo].[Uhc_Membership]([UHC_SUBSCRIBER_ID] ASC)
    INCLUDE([URN], [LINE_OF_BUSINESS]);


GO
CREATE NONCLUSTERED INDEX [ndx_UHC_Membership_LastUpdateDate]
    ON [dbo].[Uhc_Membership]([A_LAST_UPDATE_DATE] ASC)
    INCLUDE([UHC_SUBSCRIBER_ID], [LINE_OF_BUSINESS], [TOTAL_COSTS_LAST_12_MOS], [INP_COSTS_LAST_12_MOS], [ER_COSTS_LAST_12_MOS], [OUTP_COSTS_LAST_12_MOS], [PHARMACY_COSTS_LAST_12_MOS], [PRIMARY_CARE_COSTS_LAST_12_MOS], [BEHAVIORAL_COSTS_LAST_12_MOS], [OTHER_OFFICE_COSTS_LAST_12_MOS], [INP_ADMITS_LAST_12_MOS], [MEMBER_MONTH_COUNT]);


GO
CREATE STATISTICS [_dta_stat_1447728260_56_8]
    ON [dbo].[Uhc_Membership]([A_LAST_UPDATE_FLAG], [UHC_SUBSCRIBER_ID]);

