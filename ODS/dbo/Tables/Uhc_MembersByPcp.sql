CREATE TABLE [dbo].[Uhc_MembersByPcp] (
    [URN]                  INT             IDENTITY (1, 1) NOT NULL,
    [MEMBER_FIRST_NAME]    VARCHAR (255)   NULL,
    [MEMBER_MI]            VARCHAR (255)   NULL,
    [MEMBER_LAST_NAME]     VARCHAR (255)   NULL,
    [UHC_SUBSCRIBER_ID]    VARCHAR (255)   NULL,
    [CLASS]                VARCHAR (255)   NULL,
    [PLAN_ID]              VARCHAR (255)   NULL,
    [PRODUCT_CODE]         VARCHAR (255)   NULL,
    [SUBGRP_ID]            VARCHAR (255)   NULL,
    [SUBGRP_NAME]          VARCHAR (255)   NULL,
    [MEDICARE_ID]          VARCHAR (255)   NULL,
    [MEDICAID_ID]          VARCHAR (255)   NULL,
    [AGE]                  VARCHAR (255)   NULL,
    [DATE_OF_BIRTH]        VARCHAR (255)   NULL,
    [GENDER]               VARCHAR (255)   NULL,
    [RELATIONSHIP_CODE]    VARCHAR (255)   NULL,
    [LANG_CODE]            VARCHAR (255)   NULL,
    [MEMBER_HOME_ADDRESS]  VARCHAR (255)   NULL,
    [MEMBER_HOME_ADDRESS2] VARCHAR (255)   NULL,
    [MEMBER_HOME_CITY]     VARCHAR (255)   NULL,
    [MEMBER_HOME_STATE]    VARCHAR (255)   NULL,
    [MEMBER_HOME_ZIP]      VARCHAR (255)   NULL,
    [MEMBER_HOME_PHONE]    VARCHAR (255)   NULL,
    [MEMBER_MAIL_ADDRESS]  VARCHAR (255)   NULL,
    [MEMBER_MAIL_ADDRESS2] VARCHAR (255)   NULL,
    [MEMBER_MAIL_CITY]     VARCHAR (255)   NULL,
    [MEMBER_MAIL_STATE]    VARCHAR (255)   NULL,
    [MEMBER_MAIL_ZIP]      VARCHAR (255)   NULL,
    [MEMBER_MAIL_PHONE]    VARCHAR (255)   NULL,
    [MEMBER_COUNTY_CODE]   VARCHAR (255)   NULL,
    [MEMBER_COUNTY]        VARCHAR (255)   NULL,
    [MEMBER_BUS_PHONE]     VARCHAR (255)   NULL,
    [DUAL_COV_FLAG]        VARCHAR (255)   NULL,
    [MEMBER_ORG_EFF_DATE]  VARCHAR (255)   NULL,
    [MEMBER_CONT_EFF_DATE] VARCHAR (255)   NULL,
    [MEMBER_CUR_EFF_DATE]  VARCHAR (255)   NULL,
    [MEMBER_CUR_TERM_DATE] VARCHAR (255)   NULL,
    [CLASS_PLAN_ID]        VARCHAR (255)   NULL,
    [RESP_LAST_NAME]       VARCHAR (255)   NULL,
    [RESP_FIRST_NAME]      VARCHAR (255)   NULL,
    [RESP_ADDRESS]         VARCHAR (255)   NULL,
    [RESP_ADDRESS2]        VARCHAR (255)   NULL,
    [RESP_CITY]            VARCHAR (255)   NULL,
    [RESP_STATE]           VARCHAR (255)   NULL,
    [RESP_ZIP]             VARCHAR (255)   NULL,
    [RESP_PHONE]           VARCHAR (255)   NULL,
    [BROKER_ID]            VARCHAR (255)   NULL,
    [PCP_UHC_ID]           VARCHAR (255)   NULL,
    [PCP_FIRST_NAME]       VARCHAR (255)   NULL,
    [PCP_LAST_NAME]        VARCHAR (255)   NULL,
    [PCP_MPIN]             VARCHAR (255)   NULL,
    [PCP_NPI]              VARCHAR (255)   NULL,
    [PCP_PROV_TYPE_ID]     VARCHAR (255)   NULL,
    [PCP_PROV_TYPE]        VARCHAR (255)   NULL,
    [PCP_INDICATOR]        VARCHAR (255)   NULL,
    [CMG]                  VARCHAR (255)   NULL,
    [PCP_PHONE]            VARCHAR (255)   NULL,
    [PCP_FAX]              VARCHAR (255)   NULL,
    [PCP_ADDRESS]          VARCHAR (255)   NULL,
    [PCP_ADDRESS2]         VARCHAR (255)   NULL,
    [PCP_CITY]             VARCHAR (255)   NULL,
    [PCP_STATE]            VARCHAR (255)   NULL,
    [PCP_ZIP]              VARCHAR (255)   NULL,
    [PCP_COUNTY]           VARCHAR (255)   NULL,
    [PCP_EFFECTIVE_DATE]   VARCHAR (255)   NULL,
    [PCP_TERM_DATE]        VARCHAR (255)   NULL,
    [PCP_PRACTICE_TIN]     VARCHAR (255)   NULL,
    [PCP_GROUP_ID]         VARCHAR (255)   NULL,
    [PCP_PRACTICE_NAME]    VARCHAR (255)   NULL,
    [IND_PRACT_ID]         VARCHAR (255)   NULL,
    [IND_PRACT_NAME]       VARCHAR (255)   NULL,
    [RECERT_DATE]          VARCHAR (255)   NULL,
    [ETHNICITY]            VARCHAR (255)   NULL,
    [ETHNICITY_DESC]       VARCHAR (255)   NULL,
    [AUTO_ASSIGN]          VARCHAR (255)   NULL,
    [ASAP_ID]              VARCHAR (255)   NULL,
    [FEW_ID]               VARCHAR (255)   NULL,
    [LST_HRA_DATE]         VARCHAR (255)   NULL,
    [NXT_HRA_DATE]         VARCHAR (255)   NULL,
    [HRA_ID]               VARCHAR (255)   NULL,
    [MEMBER_EMAIL]         VARCHAR (250)   NULL,
    [A_LAST_UPDATE_DATE]   DATE            CONSTRAINT [DF_dbUhcMemberByPcp_ALastUpdateDate] DEFAULT (getdate()) NULL,
    [A_LAST_UPDATE_BY]     VARCHAR (255)   CONSTRAINT [DF_dbUhcMemberByPcp_ALastUpdateBy] DEFAULT ('PKG Import') NULL,
    [A_LAST_UPDATE_FLAG]   VARCHAR (1)     CONSTRAINT [DF_dbUhcMemberByPcp_ALastUpdateFlag] DEFAULT ('Y') NULL,
    [MEMBER_STATUS]        CHAR (1)        CONSTRAINT [DF_dbUhcMemberByPcp_MemberStatus] DEFAULT ('N') NOT NULL,
    [MEMBER_TERM_DATE]     DATE            NULL,
    [LoadType]             CHAR (1)        NULL,
    [PCP_Specialty_Code]   VARCHAR (50)    NULL,
    [PCP_Specialty]        VARCHAR (255)   NULL,
    [SrcFileName]          VARCHAR (100)   NULL,
    [MbrNPIFlg]            TINYINT         NULL,
    [MbrPLNFlg]            TINYINT         NULL,
    [AdiKey]               INT             NULL,
    [ClientRiskScore]      DECIMAL (15, 2) NULL,
    [Result]               CHAR (10)       NULL,
    [DataDate]             DATE            NULL,
    [ClientKey]            TINYINT         NULL,
    [EffectiveDate]        DATE            NULL,
    [LoadDate]             DATE            NULL,
    [srcNPI]               VARCHAR (50)    NULL,
    [srcPln]               VARCHAR (50)    NULL,
    CONSTRAINT [PK_UHC_MembersByPCP] PRIMARY KEY CLUSTERED ([URN] ASC),
    CONSTRAINT [CK_UHC_MembersByPCP_LoadType] CHECK ([loadType]='S' OR [loadType]='P'),
    CONSTRAINT [CK_UHCMemberByPCP_MStatus] CHECK ([MEMBER_STATUS]='T' OR [MEMBER_STATUS]='N' OR [MEMBER_STATUS]='E')
);


GO
CREATE NONCLUSTERED INDEX [ndx_UhcMbrByPcp_LastUpdateFlag]
    ON [dbo].[Uhc_MembersByPcp]([A_LAST_UPDATE_FLAG] ASC);


GO
CREATE NONCLUSTERED INDEX [ndx_UhcMbrByPcp_SubId_LstUpdtDate]
    ON [dbo].[Uhc_MembersByPcp]([UHC_SUBSCRIBER_ID] ASC, [A_LAST_UPDATE_DATE] DESC)
    INCLUDE([PCP_NPI], [A_LAST_UPDATE_FLAG], [URN]);


GO
CREATE NONCLUSTERED INDEX [ndx_UhcMemberByPcpLastUpdateFlagLastUpdateDate]
    ON [dbo].[Uhc_MembersByPcp]([A_LAST_UPDATE_FLAG] ASC)
    INCLUDE([A_LAST_UPDATE_DATE]);


GO
CREATE NONCLUSTERED INDEX [ndx_UhcMbrByPcp_LoadType]
    ON [dbo].[Uhc_MembersByPcp]([LoadType] ASC)
    INCLUDE([A_LAST_UPDATE_DATE]);


GO
CREATE NONCLUSTERED INDEX [ndx_UhcMbrByPcp_SubGrp_LoadType]
    ON [dbo].[Uhc_MembersByPcp]([SUBGRP_ID] ASC, [LoadType] ASC)
    INCLUDE([UHC_SUBSCRIBER_ID], [A_LAST_UPDATE_DATE]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_Uhc_MembersByPcp_6_1431728203__K5_K84_K1_K9_K67_K87_14]
    ON [dbo].[Uhc_MembersByPcp]([UHC_SUBSCRIBER_ID] ASC, [A_LAST_UPDATE_FLAG] ASC, [URN] ASC, [SUBGRP_ID] ASC, [PCP_PRACTICE_TIN] ASC, [LoadType] ASC)
    INCLUDE([DATE_OF_BIRTH]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_Uhc_MembersByPcp_6_1431728203__K84_K87_1_2_4_5_9_13_14_15_22_23_49_50_52_57_67_69]
    ON [dbo].[Uhc_MembersByPcp]([A_LAST_UPDATE_FLAG] ASC, [LoadType] ASC)
    INCLUDE([URN], [MEMBER_FIRST_NAME], [MEMBER_LAST_NAME], [UHC_SUBSCRIBER_ID], [SUBGRP_ID], [AGE], [DATE_OF_BIRTH], [GENDER], [MEMBER_HOME_ZIP], [MEMBER_HOME_PHONE], [PCP_FIRST_NAME], [PCP_LAST_NAME], [PCP_NPI], [PCP_PHONE], [PCP_PRACTICE_TIN], [PCP_PRACTICE_NAME]);


GO
CREATE NONCLUSTERED INDEX [IX_Uhc_MembersByPcp_A_LAST_UPDATE_FLAG_LoadType_Result]
    ON [dbo].[Uhc_MembersByPcp]([A_LAST_UPDATE_FLAG] ASC, [LoadType] ASC, [Result] ASC)
    INCLUDE([UHC_SUBSCRIBER_ID]);


GO
CREATE STATISTICS [_dta_stat_1431728203_84_1]
    ON [dbo].[Uhc_MembersByPcp]([A_LAST_UPDATE_FLAG], [URN]);


GO
CREATE STATISTICS [_dta_stat_1431728203_5_1]
    ON [dbo].[Uhc_MembersByPcp]([UHC_SUBSCRIBER_ID], [URN]);


GO
CREATE STATISTICS [_dta_stat_1431728203_67_87_1]
    ON [dbo].[Uhc_MembersByPcp]([PCP_PRACTICE_TIN], [LoadType], [URN]);


GO
CREATE STATISTICS [_dta_stat_1431728203_87_9_67]
    ON [dbo].[Uhc_MembersByPcp]([LoadType], [SUBGRP_ID], [PCP_PRACTICE_TIN]);


GO
CREATE STATISTICS [_dta_stat_1431728203_1_9_67]
    ON [dbo].[Uhc_MembersByPcp]([URN], [SUBGRP_ID], [PCP_PRACTICE_TIN]);


GO
CREATE STATISTICS [_dta_stat_1431728203_9_67_5_1]
    ON [dbo].[Uhc_MembersByPcp]([SUBGRP_ID], [PCP_PRACTICE_TIN], [UHC_SUBSCRIBER_ID], [URN]);


GO
CREATE STATISTICS [_dta_stat_1431728203_84_87_9_67_5]
    ON [dbo].[Uhc_MembersByPcp]([A_LAST_UPDATE_FLAG], [LoadType], [SUBGRP_ID], [PCP_PRACTICE_TIN], [UHC_SUBSCRIBER_ID]);


GO
CREATE STATISTICS [_dta_stat_1431728203_87_1_9_67_5_84]
    ON [dbo].[Uhc_MembersByPcp]([LoadType], [URN], [SUBGRP_ID], [PCP_PRACTICE_TIN], [UHC_SUBSCRIBER_ID], [A_LAST_UPDATE_FLAG]);


GO
CREATE STATISTICS [_dta_stat_1431728203_9_84]
    ON [dbo].[Uhc_MembersByPcp]([SUBGRP_ID], [A_LAST_UPDATE_FLAG]);


GO
CREATE STATISTICS [_dta_stat_1431728203_67_84_87]
    ON [dbo].[Uhc_MembersByPcp]([PCP_PRACTICE_TIN], [A_LAST_UPDATE_FLAG], [LoadType]);


GO
CREATE STATISTICS [_dta_stat_1431728203_87_9_67_5]
    ON [dbo].[Uhc_MembersByPcp]([LoadType], [SUBGRP_ID], [PCP_PRACTICE_TIN], [UHC_SUBSCRIBER_ID]);


GO
CREATE STATISTICS [_dta_stat_1431728203_84_87_1_67_9]
    ON [dbo].[Uhc_MembersByPcp]([A_LAST_UPDATE_FLAG], [LoadType], [URN], [PCP_PRACTICE_TIN], [SUBGRP_ID]);


GO
CREATE STATISTICS [_dta_stat_1431728203_67_1_84]
    ON [dbo].[Uhc_MembersByPcp]([PCP_PRACTICE_TIN], [URN], [A_LAST_UPDATE_FLAG]);

