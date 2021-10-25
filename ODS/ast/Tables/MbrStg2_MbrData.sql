﻿CREATE TABLE [ast].[MbrStg2_MbrData] (
    [mbrStg2_MbrDataUrn]          INT           IDENTITY (1, 1) NOT NULL,
    [ClientSubscriberId]          VARCHAR (50)  NULL,
    [ClientKey]                   VARCHAR (50)  NULL,
    [MstrMrnKey]                  NUMERIC (15)  CONSTRAINT [DF_astMbrStg2_MbrData_MstrMrnKey] DEFAULT ((-1)) NOT NULL,
    [LoadType]                    VARCHAR (5)   CONSTRAINT [DF_astMbrStg2_MbrData_LoadType] DEFAULT ('P') NULL,
    [mbrLastName]                 VARCHAR (100) NULL,
    [mbrFirstName]                VARCHAR (100) NULL,
    [mbrMiddleName]               VARCHAR (100) CONSTRAINT [df_MI] DEFAULT ('') NULL,
    [mbrSSN]                      VARCHAR (15)  NULL,
    [mbrGENDER]                   VARCHAR (5)   CONSTRAINT [df_gender] DEFAULT ('') NULL,
    [mbrDob]                      DATE          NULL,
    [mbrInsuranceCardIdNum]       VARCHAR (20)  NULL,
    [mbrMEDICAID_NO]              VARCHAR (15)  NULL,
    [mbrMEDICARE_ID]              VARCHAR (15)  NULL,
    [HICN]                        VARCHAR (11)  NULL,
    [MBI]                         VARCHAR (11)  NULL,
    [mbrEthnicity]                VARCHAR (20)  NULL,
    [mbrRace]                     VARCHAR (20)  NULL,
    [mbrPrimaryLanguage]          VARCHAR (20)  NULL,
    [prvNPI]                      VARCHAR (10)  NULL,
    [prvTIN]                      VARCHAR (10)  NULL,
    [prvAutoAssign]               VARCHAR (10)  NULL,
    [prvClientEffective]          DATE          NULL,
    [prvClientExpiration]         DATE          NULL,
    [plnProductPlan]              VARCHAR (50)  NULL,
    [plnProductSubPlan]           VARCHAR (50)  NULL,
    [plnProductSubPlanName]       VARCHAR (50)  NULL,
    [plnMbrIsDualCoverage]        VARCHAR (20)  NULL,
    [plnClientPlanEffective]      DATE          NULL,
    [rspLastName]                 VARCHAR (100) NULL,
    [rspFirstName]                VARCHAR (100) NULL,
    [rspAddress1]                 VARCHAR (100) NULL,
    [rspAddress2]                 VARCHAR (100) NULL,
    [rspCITY]                     VARCHAR (65)  NULL,
    [rspSTATE]                    CHAR (25)     NULL,
    [rspZIP]                      VARCHAR (20)  NULL,
    [rspPhone]                    VARCHAR (30)  NULL,
    [SrcFileName]                 VARCHAR (100) NULL,
    [AdiTableName]                VARCHAR (100) NULL,
    [AdiKey]                      INT           NULL,
    [stgRowStatus]                VARCHAR (20)  CONSTRAINT [DF_astMbrStg2_MbrData_StgRowStatus] DEFAULT ('Not Valid') NOT NULL,
    [LoadDate]                    DATE          NULL,
    [DataDate]                    DATE          NULL,
    [CreateDate]                  DATETIME      CONSTRAINT [DF_astMbrStg2_MbrData_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreateBy]                    VARCHAR (50)  CONSTRAINT [DF_astMbrStg2_MbrData_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [MbrMemberKey]                INT           NULL,
    [MbrPlanKey]                  INT           NULL,
    [MbrPcpKey]                   INT           NULL,
    [MbrCsPlanKey]                INT           NULL,
    [MbrLoadHistoryKey]           INT           NULL,
    [plnClientPlanEndDate]        DATE          NULL,
    [stgRowAction]                VARCHAR (10)  DEFAULT ('Upsert') NOT NULL,
    [Member_Dual_Eligible_Flag]   VARCHAR (20)  NULL,
    [MbrState]                    CHAR (2)      NOT NULL,
    [MemberStatus]                VARCHAR (50)  NULL,
    [MemberOriginalEffectiveDate] DATE          NULL,
    [RiskScore]                   DECIMAL (5)   NULL,
    [OpportunityScore]            DECIMAL (5)   NULL,
    [MbrCity]                     VARCHAR (50)  NULL,
    [LastUpdatedDate]             DATETIME2 (7) CONSTRAINT [DF_astMbrStg2MbrDtl_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]               VARCHAR (50)  CONSTRAINT [DF_astMbrStg2MbrDtl_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [MbrNPIFlg]                   BIT           NULL,
    [MbrPlnFlg]                   BIT           NULL,
    [MbrFlgCount]                 TINYINT       NULL,
    [EffectiveDate]               DATE          NULL,
    [srcNPI]                      VARCHAR (50)  NULL,
    [srcPln]                      VARCHAR (50)  NULL,
    [LOB]                         VARCHAR (50)  NULL,
    [CsplnProductSubPlanName]     VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([mbrStg2_MbrDataUrn] ASC),
    CONSTRAINT [CK_MbrStg2_MbrData_stgRowStatus] CHECK ([stgRowStatus]='Exported' OR [stgRowStatus]='Valid' OR [stgRowStatus]='Loaded' OR [stgRowStatus]='Not Valid' OR [stgRowStatus]='Dups')
);


GO
CREATE NONCLUSTERED INDEX [astMbrStg2_MbrData_StgRowStatusLoadDate]
    ON [ast].[MbrStg2_MbrData]([stgRowStatus] ASC, [LoadDate] ASC)
    INCLUDE([ClientSubscriberId], [ClientKey], [mbrLastName], [mbrFirstName], [mbrMiddleName], [mbrSSN], [mbrGENDER], [mbrDob], [mbrMEDICAID_NO], [mbrMEDICARE_ID], [HICN], [MBI], [mbrEthnicity], [mbrRace], [mbrPrimaryLanguage], [AdiTableName], [AdiKey], [DataDate]);


GO
CREATE NONCLUSTERED INDEX [IX_MbrStg2_MbrData_LoadDate]
    ON [ast].[MbrStg2_MbrData]([LoadDate] ASC)
    INCLUDE([ClientSubscriberId], [plnProductPlan]);


GO

CREATE TRIGGER ast.AU_MbrStg2_MbrData
ON [ast].[MbrStg2_MbrData]
AFTER UPDATE 
AS
   UPDATE ast.MbrStg2_MbrData
   SET [LastUpdatedDate] = SYSDATETIME()
	   ,[LastUpdatedBy] = SYSTEM_USER	
   FROM Inserted i
   WHERE ast.MbrStg2_MbrData.[mbrStg2_MbrDataUrn] = i.[mbrStg2_MbrDataUrn]
   ;

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'MCO Subscriber ID, key Business Identifier ', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'ClientSubscriberId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Foreign key to Client', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'ClientKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'MRN: Unique id for member accross all mcos and subscriber ids', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'MstrMrnKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Is this a primary or secondary load, not all MCO''s have Secondary', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'LoadType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Last Name of member', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'mbrLastName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'First Name', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'mbrFirstName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Middle Name or initial', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'mbrMiddleName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'SSN if available', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'mbrSSN';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Gender as text', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'mbrGENDER';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date of birth', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'mbrDob';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Medicaid number', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'mbrMEDICAID_NO';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Medicare number', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'mbrMEDICARE_ID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'HICN: CMS provided HIC Number. Being phased out', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'HICN';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Medicare Beneficiary Identifier Number:', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'MBI';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ethnicity as text: will be mapped to Ace values further in model', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'mbrEthnicity';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Race as text: will be mapped to Ace Values further in model', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'mbrRace';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Prmary Language: will be mapped to Ace values further in model', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'mbrPrimaryLanguage';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PCP NPI number', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'prvNPI';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PCP TIN ', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'prvTIN';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Is Pcp Auto Assign: this should be transformed to be Auto/Self', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'prvAutoAssign';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date Member Effective with PCP', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'prvClientEffective';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date Member Expired with PCP', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'prvClientExpiration';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Member Benefit Plan Identifier', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'plnProductPlan';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Subplan code', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'plnProductSubPlan';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sub Plan name', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'plnProductSubPlanName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dual coverage indicator', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'plnMbrIsDualCoverage';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date plan effective', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'plnClientPlanEffective';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Responsible Party Last Name', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'rspLastName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Responsible Party First Name', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'rspFirstName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Responsible Party  Address 1', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'rspAddress1';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Responsible Party Address 2', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'rspAddress2';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Responsible Party City', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'rspCITY';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Responsible Party State', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'rspSTATE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Responsible Party Zip code', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'rspZIP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Responsible Party Phone', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'rspPhone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Source File Name ', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'SrcFileName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ADI table Name that holds source records', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'AdiTableName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ADI Primary Key', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'AdiKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date data was loaded into ACE (load date from adi)', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'LoadDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data Date: date data was created: data date from ADI', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'DataDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'datetime row was created', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'CreateDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'user id of system user who created the row.', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'MbrStg2_MbrData', @level2type = N'COLUMN', @level2name = N'CreateBy';

