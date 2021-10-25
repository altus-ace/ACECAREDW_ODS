CREATE TABLE [lst].[lstEmailType] (
    [lstEmailTypeKey] INT           NOT NULL,
    [EmailTypeName]   VARCHAR (50)  NOT NULL,
    [EmailTypeCode]   VARCHAR (10)  NULL,
    [LoadDate]        DATE          NOT NULL,
    [DataDate]        DATE          NOT NULL,
    [CreatedDate]     DATETIME2 (7) CONSTRAINT [DF_LstEmailType_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       VARCHAR (50)  CONSTRAINT [DF_LstEmailType_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate] DATETIME2 (7) CONSTRAINT [DF_LstEmailType_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]   VARCHAR (50)  CONSTRAINT [DF_LstEmailType_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([lstEmailTypeKey] ASC)
);


GO

CREATE TRIGGER [lst].[TR_lstEmailType_AU]
    ON [lst].[lstEmailType]
    FOR UPDATE
    AS
    BEGIN
	   IF @@rowcount = 0 
		RETURN
        SET NoCount ON
	   if exists(SELECT * FROM inserted)
		  UPDATE lstEmailType
			 SET LastUpdatedDate = GETDATE()
    				,LastUpdatedBy  = system_user
	   	  FROM inserted i, lstEmailType a
		  WHERE i.lstEmailTypeKey = a.lstEmailTypeKey;	   
    END

    
/* initial values 
insert into lst.lstEmailType (lstEmailTypeKey, EmailTypeName, EmailTypeCode, LoadDate, DataDate)
VALUES 
    (1,'Home', 'H', getdate(), getDate())    
    , (2,'Work', 'W', getdate(), getDate())
    , (3, 'Default', 'D', GETDATE(), GETDATE())
    ;    

*/
