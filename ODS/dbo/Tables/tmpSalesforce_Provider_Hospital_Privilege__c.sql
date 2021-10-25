CREATE TABLE [dbo].[tmpSalesforce_Provider_Hospital_Privilege__c] (
    [Id]                       VARCHAR (50)  NULL,
    [OwnerId]                  VARCHAR (50)  NULL,
    [IsDeleted]                VARCHAR (50)  NULL,
    [Name]                     VARCHAR (100) NULL,
    [CreatedDate]              DATETIME      NULL,
    [CreatedById]              VARCHAR (50)  NULL,
    [LastModifiedDate]         DATETIME      NULL,
    [LastModifiedById]         VARCHAR (50)  NULL,
    [SystemModstamp]           VARCHAR (50)  NULL,
    [LastActivityDate]         DATETIME      NULL,
    [Provider_Name__c]         VARCHAR (100) NULL,
    [Hospital_Name__c]         VARCHAR (200) NULL,
    [Privilege_Discription__c] VARCHAR (200) NULL,
    [EndDate__c]               DATETIME      NULL,
    [Affiliation_Type__c]      VARCHAR (100) NULL,
    [A_LAST_UPDATE_DATE]       DATETIME      DEFAULT (getdate()) NULL,
    [A_LAST_UPDATE_BY]         VARCHAR (20)  DEFAULT ('PKG Import_Tmp') NULL,
    [A_LAST_UPDATE_FLAG]       VARCHAR (1)   DEFAULT ('Y') NULL
);

