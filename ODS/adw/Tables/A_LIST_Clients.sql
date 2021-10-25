CREATE TABLE [adw].[A_LIST_Clients] (
    [A_Client_ID]      INT           IDENTITY (1, 1) NOT NULL,
    [Client_Name]      VARCHAR (150) NOT NULL,
    [Client_ShortName] VARCHAR (20)  NOT NULL,
    [A_IS_Client_ID]   VARCHAR (10)  NULL,
    [A_CREATED_DATE]   DATETIME      CONSTRAINT [DF__A_Clients__A_CRE__08C03A61] DEFAULT (getdate()) NULL,
    [A_CREATED_BY]     VARCHAR (50)  CONSTRAINT [DF__A_Clients__A_CRE__09B45E9A] DEFAULT (suser_sname()) NULL,
    [A_UPDATED_DATE]   DATETIME      NULL,
    [A_UPDATED_BY]     VARCHAR (50)  NULL,
    CONSTRAINT [PK__A_Client__231DFEA95EC5AADB] PRIMARY KEY CLUSTERED ([A_Client_ID] ASC)
);

