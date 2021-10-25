CREATE TABLE [dbo].[zz_ALT_Membership] (
    [Member_ID]                      VARCHAR (100) NULL,
    [Alternate_ID_1]                 VARCHAR (100) NULL,
    [Alternate_ID_2]                 VARCHAR (100) NULL,
    [Alternate_ID_n]                 VARCHAR (100) NULL,
    [Status]                         VARCHAR (20)  NULL,
    [Person_Code]                    VARCHAR (5)   NULL,
    [Relationship_Code]              VARCHAR (20)  NULL,
    [Member_First_Name]              VARCHAR (200) NULL,
    [Member_Middle_Name]             VARCHAR (50)  NULL,
    [Member_Last_Name]               VARCHAR (200) NULL,
    [Birth_Date]                     DATETIME      NULL,
    [Gender]                         VARCHAR (20)  NULL,
    [Address_1]                      VARCHAR (200) NULL,
    [Address_2]                      VARCHAR (200) NULL,
    [City]                           VARCHAR (100) NULL,
    [State]                          VARCHAR (100) NULL,
    [County]                         VARCHAR (100) NULL,
    [Zip_Code]                       VARCHAR (20)  NULL,
    [Member_Phone_1]                 VARCHAR (20)  NULL,
    [Member_Phone_2]                 VARCHAR (20)  NULL,
    [Member_Phone_3]                 VARCHAR (20)  NULL,
    [Ethnicity]                      VARCHAR (200) NULL,
    [Languages_Spoken]               VARCHAR (100) NULL,
    [Member_Addtional_Information_1] VARCHAR (100) NULL,
    [Member_Addtional_Information_2] VARCHAR (100) NULL,
    [Member_Addtional_Information_n] VARCHAR (100) NULL,
    [LAST_UPDATE_BY]                 VARCHAR (50)  NULL,
    [LAST_UPDATE_DATE]               DATETIME      NULL
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20170126-164653]
    ON [dbo].[zz_ALT_Membership]([Member_ID] ASC);

