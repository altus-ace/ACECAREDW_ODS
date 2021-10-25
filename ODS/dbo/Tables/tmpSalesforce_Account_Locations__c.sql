CREATE TABLE [dbo].[tmpSalesforce_Account_Locations__c] (
    [Id]                             VARCHAR (50)  NULL,
    [OwnerId]                        VARCHAR (50)  NULL,
    [IsDeleted]                      VARCHAR (50)  NULL,
    [Name]                           VARCHAR (100) NULL,
    [CreatedDate]                    DATETIME      NULL,
    [CreatedById]                    VARCHAR (50)  NULL,
    [LastModifiedDate]               DATETIME      NULL,
    [LastModifiedById]               VARCHAR (50)  NULL,
    [SystemModstamp]                 VARCHAR (50)  NULL,
    [LastActivityDate]               DATETIME      NULL,
    [Location_Tax_ID__c]             VARCHAR (50)  NULL,
    [Location_Type__c]               VARCHAR (50)  NULL,
    [Address_1__c]                   VARCHAR (100) NULL,
    [Address_2__c]                   VARCHAR (100) NULL,
    [City__c]                        VARCHAR (50)  NULL,
    [State__c]                       VARCHAR (50)  NULL,
    [Phone__c]                       VARCHAR (50)  NULL,
    [Alternate_Phone__c]             VARCHAR (50)  NULL,
    [Fax__c]                         VARCHAR (50)  NULL,
    [Location_Email__c]              VARCHAR (50)  NULL,
    [Monday_Open__c]                 VARCHAR (50)  NULL,
    [Monday_Close__c]                VARCHAR (50)  NULL,
    [Tuesday_Open__c]                VARCHAR (50)  NULL,
    [Tuesday_Close__c]               VARCHAR (50)  NULL,
    [Wednesday_Open__c]              VARCHAR (50)  NULL,
    [Wednesday_Close__c]             VARCHAR (50)  NULL,
    [Thrusday__c]                    VARCHAR (50)  NULL,
    [Thrusday_Close__c]              VARCHAR (50)  NULL,
    [Friday_Open__c]                 VARCHAR (50)  NULL,
    [Friday_Close__c]                VARCHAR (50)  NULL,
    [Saturday_Open__c]               VARCHAR (50)  NULL,
    [Saturday_Close__c]              VARCHAR (50)  NULL,
    [Sunday_Open__c]                 VARCHAR (50)  NULL,
    [Sunday_Close__c]                VARCHAR (50)  NULL,
    [Account_Name__c]                VARCHAR (50)  NULL,
    [Note__c]                        VARCHAR (200) NULL,
    [County__c]                      VARCHAR (50)  NULL,
    [Zip_Code__c]                    VARCHAR (50)  NULL,
    [Medicare_Advantage_Capacity__c] VARCHAR (50)  NULL,
    [Medicaid_Capacity__c]           VARCHAR (50)  NULL,
    [Capacity_Last_Modified__c]      VARCHAR (50)  NULL,
    [New_Commercial_Members__c]      VARCHAR (100) NULL,
    [A_LAST_UPDATE_DATE]             DATETIME      DEFAULT (getdate()) NULL,
    [A_LAST_UPDATE_BY]               VARCHAR (20)  DEFAULT ('PKG Import_Tmp') NULL,
    [A_LAST_UPDATE_FLAG]             VARCHAR (1)   DEFAULT ('Y') NULL
);


GO
CREATE NONCLUSTERED INDEX [ndx_TmpSF_AccountLocation_LocType_AccntName]
    ON [dbo].[tmpSalesforce_Account_Locations__c]([Location_Type__c] ASC, [Account_Name__c] ASC)
    INCLUDE([Address_1__c], [Address_2__c], [City__c], [State__c], [Phone__c], [Zip_Code__c]);

