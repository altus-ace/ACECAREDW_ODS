CREATE TABLE [lst].[lstPhoneCarrierType] (
    [lstPhoneCarrierTypeKey] INT           NOT NULL,
    [PhoneCarrierTypeName]   VARCHAR (50)  NOT NULL,
    [PhoneCarrierTypeCode]   VARCHAR (10)  NULL,
    [LoadDate]               DATE          NOT NULL,
    [DataDate]               DATE          NOT NULL,
    [CreatedDate]            DATETIME2 (7) CONSTRAINT [DF_LstPhoneCarrierType_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]              VARCHAR (50)  CONSTRAINT [DF_LstPhoneCarrierType_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]        DATETIME2 (7) CONSTRAINT [DF_LstPhoneCarrierType_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]          VARCHAR (50)  CONSTRAINT [DF_LstPhoneCarrierType_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([lstPhoneCarrierTypeKey] ASC)
);


GO

CREATE TRIGGER [lst].[TR_lstPhoneCarrierType_AU]
    ON [lst].[lstPhoneCarrierType]
    FOR UPDATE
    AS
    BEGIN
	   IF @@rowcount = 0 
		RETURN
        SET NoCount ON
	   if exists(SELECT * FROM inserted)
		  UPDATE lstPhoneCarrierType
			 SET LastUpdatedDate = GETDATE()
    				,LastUpdatedBy  = system_user
	   	  FROM inserted i, lstPhoneCarrierType a
		  WHERE i.lstPhoneCarrierTypeKey = a.lstPhoneCarrierTypeKey;	   
    END

/* initial values 
insert into lst.lstPhoneCarrierType (lstPhoneCarrierTypeKey, PhoneCarrierTypeName, PhoneCarrierTypeCode, LoadDate, DataDate)
VALUES , (5,'Not known', 'NK', GETDATE(), GETDATE();
      (1,'Landline', 'L', getdate(), getDate())
    , (2,'Mobile', 'M', getdate(), getDate())
    , (3,'INVALID NUMBER', 'I', getdate(), getDate())
    , (4,'Unsupported Carrier', 'U', getdate(), getDate())
    , (5,'Not known', 'NK', GETDATE(), GETDATE());


*/
