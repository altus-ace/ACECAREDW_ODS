CREATE TABLE [adi].[MbrUhcMemberSummary] (
    [mbrUhcMbrSummaryKey]            INT           IDENTITY (1, 1) NOT NULL,
    [SrcFileName]                    VARCHAR (100) NOT NULL,
    [LoadDate]                       DATE          NOT NULL,
    [DataDate]                       DATE          NOT NULL,
    [CreatedDate]                    DATETIME      NOT NULL,
    [CreatedBy]                      VARCHAR (50)  NOT NULL,
    [LastUpdatedDate]                DATETIME      NOT NULL,
    [LastUpdatedBy]                  VARCHAR (50)  NOT NULL,
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
    PRIMARY KEY CLUSTERED ([mbrUhcMbrSummaryKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ndx_MbrUhcMemberSummary_DataDate]
    ON [adi].[MbrUhcMemberSummary]([DataDate] ASC)
    INCLUDE([IPRO_ADMIT_RISK_SCORE], [UHC_SUBSCRIBER_ID]);


GO

CREATE TRIGGER adi.AU_MbrUhcMemberSummary
ON adi.MbrUhcMemberSummary
AFTER UPDATE 
AS
   UPDATE adi.MbrUhcMemberSummary
   SET [LastUpdatedDate] = SYSDATETIME()
    , [LastUpdatedBy] = SYSTEM_USER
   FROM Inserted i
   WHERE adi.MbrUhcMemberSummary.mbrUhcMbrSummaryKey= i.mbrUhcMbrSummaryKey
   ;
