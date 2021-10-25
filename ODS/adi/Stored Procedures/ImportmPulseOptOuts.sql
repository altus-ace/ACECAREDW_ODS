-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportmPulseOptOuts](
    
	
	@OriginalFileName VARCHAR(100),
	@SrcFileName varchar(100),
	@DataDate VARCHAR(10),

--	@CreatedDate date,
	@CreatedBy varchar(50),
--	@LastUpdatedDate date,
	@LastUpdatedBy varchar(50),
    @OptOut_Date_Time varchar(20),
	@ClientMemberKey varchar(50),
	@ClientKey varchar(50),
	@Ace_ID varchar(25),
	@FirstName varchar(50),
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
 IF (@ACE_ID NOT LIKE '%E+%')
 BEGIN
 INSERT INTO [adi].[MPulseOptOuts]
   (
    [OriginalFileName] ,
	[SrcFileName],
	[DataDate],
	[CreatedDate] ,
	[CreatedBy] ,
	[LastUpdatedDate],
	[LastUpdatedBy] ,
	[OptOut_Date_Time] ,
	[ClientMemberKey],
	[ClientKey],
	[Ace_ID] ,
	[FirstName] ,
	[LastName],
	[PhoneNumber]

    )
     VALUES
   (
    @OriginalFileName,
	@SrcFileName,
	CASE WHEN @OptOut_Date_Time = '' --- use OptOut_Date_Time as DataDate
	THEN NULL
	ELSE CONVERT(datetime, @OptOut_Date_Time)
	END ,
	--GETDATE(),
	GETDATE(),
	--@DataDate
	@CreatedBy ,
	GETDATE(),
	-- @CreatedDate,

	@LastUpdatedBy,
	@OptOut_Date_Time ,
	@ClientMemberKey ,
	@ClientKey,
	@Ace_ID,
	--CASE WHEN @Ace_ID = ''
	--THEN NULL
	--ELSE CONVERT(numeric(15,0) ,@Ace_ID)
	--END,
	@FirstName ,
	@LastName ,
	@PhoneNumber  
	
   )
   END;

  -- SET @ActionStopDateTime = GETDATE(); 
  -- EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditID, @ActionStopDateTime, 1,1,0,2   

  --  EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, '[ACECARDW].[adi].[copUhcPcor]', '';

END




