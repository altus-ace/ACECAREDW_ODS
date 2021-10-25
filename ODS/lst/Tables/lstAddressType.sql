CREATE TABLE [lst].[lstAddressType] (
    [lstAddressTypeKey] INT           NOT NULL,
    [AddressTypeName]   VARCHAR (50)  NOT NULL,
    [AddressTypeCode]   VARCHAR (10)  NULL,
    [LoadDate]          DATE          NOT NULL,
    [DataDate]          DATE          NOT NULL,
    [CreatedDate]       DATETIME2 (7) CONSTRAINT [DF_LstAddressType_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]         VARCHAR (50)  CONSTRAINT [DF_LstAddressType_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]   DATETIME2 (7) CONSTRAINT [DF_LstAddressType_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]     VARCHAR (50)  CONSTRAINT [DF_LstAddressType_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([lstAddressTypeKey] ASC)
);


GO

CREATE TRIGGER [lst].[TR_lstAddressType_AU]
    ON [lst].[lstAddressType]
    FOR UPDATE
    AS
    BEGIN
	   IF @@rowcount = 0 
		RETURN
        SET NoCount ON
	   if exists(SELECT * FROM inserted)
		  UPDATE lstAddressType
			 SET LastUpdatedDate = GETDATE()
    				,LastUpdatedBy  = system_user
	   	  FROM inserted i, lstAddressType a
		  WHERE i.lstAddressTypeKey = a.lstAddressTypeKey;	   
    END
