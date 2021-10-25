-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportmPulseMTs](
	--@loadDate date,
	@DataDate varchar(12),
	@SrcFileName varchar(100),
--	@CreatedDate date,
	@CreatedBy varchar(50),
--	@LastUpdatedDate date,
	@LastUpdatedBy varchar(50),
    @Mt_Date_Time varchar(20),
	@Mt_Content varchar(1000),
	@Appt_ID varchar(50),
	@ClientMemberKey varchar(50),
	@ClientKey varchar(50),
	@Ace_ID varchar(20),
	@FirstName varchar(50) ,
	@LastName varchar(50),
	@PhoneNumber varchar(35)
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	-- ADD ACE ETL AUDIT
	--DECLARE @AuditID AS INT, @ActionStartDateTime AS datetime2, @ActionStopDateTime as datetime2
	
	--SET @ActionStartDateTime = GETDATE(); 
	
	--'2017-12-16 11:15:23.2393473'
    
--	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 1, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, '[ACECARDW].[adi].[copUhcPcor]', '';
--	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR',  @ActionStartDateTime , 'Test', '[ACECARDW].[adi].[copUhcPcor]', '' ;



 --IF (@Physician <>'' AND @FirstName <> '' AND @LastName <> ''  AND @MemberID <> '') 

 INSERT INTO [adi].[MPulseMTs]
   (
    [LoadDate],
	[DataDate],
	[SrcFileName],
	[CreatedDate] ,
	[CreatedBy] ,
	[LastUpdatedDate],
	[LastUpdatedBy] ,
    [Mt_Date_Time],
	[Mt_Content],
	[Appt_ID] ,
	[ClientMemberKey] ,
	[ClientKey] ,
	[Ace_ID],
	[FirstName],
	[LastName],
	[PhoneNumber]
    )
     VALUES
   (

	GETDATE(),
	CASE WHEN (@DataDate = '')
	THEN NULL
	ELSE CONVERT(date, @DataDate)
	END ,
	@SrcFileName,
	GETDATE(),
	@CreatedBy ,
	GETDATE(),
	@LastUpdatedBy,
	CASE WHEN(@Mt_Date_Time = '')
	THEN NULL
	ELSE CONVERT(datetime, @Mt_Date_Time)
	END,
	@Mt_Content,
	@Appt_ID ,
	@ClientMemberKey ,
	@ClientKey,
	CASE WHEN (@Ace_ID = '')
	THEN NULL
	ELSE CONVERT(numeric(15,0), @Ace_ID)
	END,
	@FirstName  ,
	@LastName ,
	@PhoneNumber 
	
   )


  -- SET @ActionStopDateTime = GETDATE(); 
  -- EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditID, @ActionStopDateTime, 1,1,0,2   

  --  EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, '[ACECARDW].[adi].[copUhcPcor]', '';

END




