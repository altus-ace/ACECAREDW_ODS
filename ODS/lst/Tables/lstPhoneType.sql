CREATE TABLE [lst].[lstPhoneType] (
    [lstPhoneTypeKey] INT           NOT NULL,
    [PhoneTypeName]   VARCHAR (50)  NOT NULL,
    [PhoneTypeCode]   VARCHAR (10)  NULL,
    [LoadDate]        DATE          NOT NULL,
    [DataDate]        DATE          NOT NULL,
    [CreatedDate]     DATETIME2 (7) CONSTRAINT [DF_LstPhoneType_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       VARCHAR (50)  CONSTRAINT [DF_LstPhoneType_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate] DATETIME2 (7) CONSTRAINT [DF_LstPhoneType_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]   VARCHAR (50)  CONSTRAINT [DF_LstPhoneType_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([lstPhoneTypeKey] ASC)
);


GO

CREATE TRIGGER [lst].[TR_lstPhoneType_AU]
    ON [lst].[lstPhoneType]
    FOR UPDATE
    AS
    BEGIN
	   IF @@rowcount = 0 
		RETURN
        SET NoCount ON
	   if exists(SELECT * FROM inserted)
		  UPDATE lstPhoneType
			 SET LastUpdatedDate = GETDATE()
    				,LastUpdatedBy  = system_user
	   	  FROM inserted i, lstPhoneType a
		  WHERE i.lstPhoneTypeKey = a.lstPhoneTypeKey;	   
    END

    /* initial values 
insert into lst.lstPhoneType (lstPhoneTypeKey, PhoneTypeName, PhoneTypeCode, LoadDate, DataDate)
VALUES 
    (1,'Home', 'H', getdate(), getDate())
    , (2,'Mobile', 'M', getdate(), getDate())
    , (3,'Work', 'W', getdate(), getDate())
    , (4,'Mail', 'Ma', getdate(), getDate());

*/
