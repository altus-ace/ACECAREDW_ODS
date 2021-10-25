﻿CREATE TABLE [adi].[MSSPPatientAttributionList] (
    [MSSPPatientAttributionKey]   INT            IDENTITY (1, 1) NOT NULL,
    [SrcFileName]                 VARCHAR (100)  NOT NULL,
    [CreateDate]                  DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [CreateBy]                    VARCHAR (100)  DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]             DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [LastUpdatedBy]               VARCHAR (100)  DEFAULT (suser_sname()) NOT NULL,
    [DataDate]                    DATE           NOT NULL,
    [MBI_ID]                      VARCHAR (50)   NULL,
    [PatientFirstName]            VARCHAR (50)   NULL,
    [PatientLastName]             VARCHAR (50)   NULL,
    [DOB]                         DATE           NULL,
    [Sex]                         VARCHAR (10)   NULL,
    [AttributedNPI]               VARCHAR (50)   NULL,
    [ProviderName]                VARCHAR (50)   NULL,
    [HCCRiskScore]                DECIMAL (5, 2) NULL,
    [NEW_2021_Patient]            VARCHAR (10)   NULL,
    [Patient_AWV_Last_12Month]    DATE           NULL,
    [UnplannedIPVisit_12Month]    SMALLINT       NULL,
    [PatientIdentified_High_Risk] VARCHAR (10)   NULL,
    [PatientDiagnosedDiabetes]    VARCHAR (10)   NULL,
    PRIMARY KEY CLUSTERED ([MSSPPatientAttributionKey] ASC)
);

