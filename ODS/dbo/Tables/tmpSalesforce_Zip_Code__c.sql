CREATE TABLE [dbo].[tmpSalesforce_Zip_Code__c] (
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
    [POD__c]             VARCHAR (50)  NULL,
    [Quadrant__c]        VARCHAR (50)  NULL,
    [A_LAST_UPDATE_DATE] DATETIME      DEFAULT (getdate()) NULL,
    [A_LAST_UPDATE_BY]   VARCHAR (20)  DEFAULT ('PKG ImportTmp') NULL,
    [A_LAST_UPDATE_FLAG] VARCHAR (1)   DEFAULT ('Y') NULL
);


GO
CREATE NONCLUSTERED INDEX [ndx_tmpSalesForce_ZipCode_ID]
    ON [dbo].[tmpSalesforce_Zip_Code__c]([Id] ASC)
    INCLUDE([Name], [POD__c], [Quadrant__c]);

