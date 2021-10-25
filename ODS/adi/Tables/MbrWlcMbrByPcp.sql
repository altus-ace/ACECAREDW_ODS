CREATE TABLE [adi].[MbrWlcMbrByPcp] (
    [mbrWlcMbrByPcpKey]     INT           IDENTITY (1, 1) NOT NULL,
    [SEQ_Mem_ID]            VARCHAR (50)  NULL,
    [Sub_ID]                VARCHAR (50)  NULL,
    [FirstName]             VARCHAR (75)  NULL,
    [LastName]              VARCHAR (75)  NULL,
    [GENDER]                VARCHAR (10)  NULL,
    [IPA]                   VARCHAR (20)  NULL,
    [BirthDate]             DATE          NULL,
    [MEDICAID_NO]           VARCHAR (10)  NULL,
    [MEDICAL_REC_NO]        VARCHAR (50)  NULL,
    [EffDate]               DATE          NULL,
    [TermDate]              DATE          NULL,
    [Prov_id]               VARCHAR (50)  NULL,
    [Prov_Name]             VARCHAR (150) NULL,
    [LOB]                   VARCHAR (50)  NULL,
    [BenePLAN]              VARCHAR (15)  NULL,
    [ADDRESS_TYPE]          VARCHAR (50)  NULL,
    [Address]               VARCHAR (100) NULL,
    [City]                  VARCHAR (40)  NULL,
    [State]                 VARCHAR (35)  NULL,
    [Zip]                   VARCHAR (20)  NULL,
    [County]                VARCHAR (35)  NULL,
    [PhoneNumber]           VARCHAR (35)  NULL,
    [MOBILE_PHONE]          VARCHAR (35)  NULL,
    [ALT_PHONE]             VARCHAR (35)  NULL,
    [AGENT_NUM]             VARCHAR (10)  NULL,
    [Enrollment_Source]     VARCHAR (10)  NULL,
    [SrcFileName]           VARCHAR (100) NOT NULL,
    [InQuarantine]          TINYINT       NULL,
    [LoadDate]              DATE          NOT NULL,
    [DataDate]              DATE          NOT NULL,
    [CreateDate]            DATETIME2 (7) CONSTRAINT [Df_astWlcMbrByPcp_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreateBy]              VARCHAR (50)  CONSTRAINT [Df_astWlcMbrByPcp_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]       DATETIME2 (7) CONSTRAINT [DF_astWlcMbrByPcp_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]         VARCHAR (50)  CONSTRAINT [DF_astWlcMbrByPcp_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [Name]                  VARCHAR (100) NULL,
    [MbrLoadStatus]         TINYINT       CONSTRAINT [DF_WlcMbrLoadStatus] DEFAULT ((0)) NULL,
    [MEMBER_EFFECTIVE_DATE] DATE          NULL,
    [VENDOR_NAME]           VARCHAR (50)  NULL,
    [IRS_TAX_ID]            VARCHAR (50)  NULL,
    [reporting_pcp_npi]     VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([mbrWlcMbrByPcpKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ndx_adiMbrWlcMbrByPcp]
    ON [adi].[MbrWlcMbrByPcp]([LoadDate] ASC)
    INCLUDE([DataDate]);


GO

CREATE TRIGGER adi.[UpdateMbrWlcMbrByPcp_LastUpDated]
ON adi.MbrWlcMbrByPcp
AFTER UPDATE 
AS
   UPDATE adi.MbrWlcMbrByPcp
   SET [LastUpdatedDate] = SYSDATETIME()
    , [LastUpdatedBy] = SYSTEM_USER
   FROM Inserted i
   WHERE adi.MbrWlcMbrByPcp.mbrWlcMbrByPcpKey= i.mbrWlcMbrByPcpKey
