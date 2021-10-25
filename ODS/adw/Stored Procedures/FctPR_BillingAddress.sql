CREATE PROCEDURE	[adw].[FctPR_BillingAddress]
					(@ConnectionString NVARCHAR(MAX)
					, @debug TinyInt = 0)

AS

BEGIN
				
				DECLARE	@SqlString NVARCHAR(MAX)
				


	SET @SqlString = N'DROP TABLE ' +  @ConnectionString 
	IF @debug = 0 EXECUTE sp_executesql @SqlString
		ELSE Select @SqlString;
	
 
--B Create all Targets
  
--Create Triggers 
	SET @SqlString = 
	N'CREATE TABLE ' + @ConnectionString + '(' +
	'[FctProviderPracticeBillingSkey] [int] IDENTITY(1,1) NOT NULL,'+
	'[SourceJobName] [varchar](50) NULL,'+
	'[LoadDate] [date] DEFAULT CONVERT(DATE,GETDATE()) NULL,'+
	'[DataDate] [date] DEFAULT CONVERT(DATE,GETDATE()) NULL,'+
	'[CreatedDate] [datetime] DEFAULT GETDATE() NOT NULL,'+
	'[CreatedBy] [varchar](50) DEFAULT SUSER_SNAME()  NOT NULL,'+
	'[LastUpdatedDate] [date] DEFAULT GETDATE()  NOT NULL,'+
	'[LastUpdatedBy] [varchar](50) DEFAULT SUSER_SNAME() NOT NULL,'+
	'[TIN] VARCHAR(50) NOT NULL,'+
	'[TIN_NAME] VARCHAR(100) NOT NULL, '+
	'[AddType] VARCHAR(20) DEFAULT ''Billing'','+
	'[BillingAddress] VARCHAR(100), '+
	'[BillingCity] VARCHAR(50), '+
	'[BillingState] VARCHAR(50), '+
	'[BillingZipcode] VARCHAR(50), '+
	'[BillingPOD] VARCHAR(50), '+
	'[BillingAddressPhoneNumber] VARCHAR(50),'+
	')'
		
	IF @debug = 0 EXECUTE sp_executesql @SqlString
		ELSE Select @SqlString;


	--C Insert into all Target 
	SET  @SqlString = 
		N'INSERT INTO ' + @ConnectionString + '('
		+	' [SourceJobName],[TIN], TIN_NAME, [BillingAddress], [BillingCity]
		, [BillingState], [BillingZipcode], [BillingPOD]
		, [BillingAddressPhoneNumber]'   + ')' +

		'SELECT	DISTINCT ''[ast].[vw_Get_FctProvRoster_TINData_DevPR]'',[TIN], GROUPNAME
				, [BillingAddress], [BillingCity], [BillingState], [BillingZipcode]
					,[BillingPOD],[BillingAddressPhoneNumber]'
				+
		' FROM		[ast].[vw_Get_FctProvRoster_TINData_DevPR]'
		

		
		IF @debug = 0 EXECUTE sp_executesql @SqlString
		ELSE Select @SqlString;

END

		