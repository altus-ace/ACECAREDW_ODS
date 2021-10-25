CREATE TABLE [dbo].[tmpSalesforce_Location_Language__c] (
    [Id]                 VARCHAR (50)  NULL,
    [OwnerId]            VARCHAR (50)  NULL,
    [IsDeleted]          VARCHAR (50)  NULL,
    [Name]               VARCHAR (100) NULL,
    [CreatedDate]        DATETIME      NULL,
    [CreatedById]        VARCHAR (50)  NULL,
    [LastModifiedDate]   DATETIME      NULL,
    [LastModifiedById]   VARCHAR (50)  NULL,
    [SystemModstamp]     VARCHAR (50)  NULL,
    [LastActivityDate]   DATETIME      NULL,
    [Practice_Name__c]   VARCHAR (100) NULL,
    [Language_Type__c]   VARCHAR (50)  NULL,
    [Language_Name__c]   VARCHAR (100) NULL,
    [Employee_Type__c]   VARCHAR (50)  NULL,
    [A_LAST_UPDATE_DATE] DATETIME      DEFAULT (getdate()) NULL,
    [A_LAST_UPDATE_BY]   VARCHAR (20)  DEFAULT ('PKG Import_Tmp') NULL,
    [A_LAST_UPDATE_FLAG] VARCHAR (1)   DEFAULT ('Y') NULL
);

