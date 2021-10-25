﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportmPulseMOs](
	--@loadDate date,
	@DataDate date,
	@SrcFileName varchar(100),
--	@CreatedDate date,
	@CreatedBy varchar(50),
--	@LastUpdatedDate date,
	@LastUpdatedBy varchar(50),
    @MO_Date_Time varchar(20),
	@ClientMemberKey varchar(50),
	@ClientKey varchar(50),
	@Ace_ID numeric,
	@FirstName varchar(50) ,
	@LastName varchar(50),
	@PhoneNumber varchar(50),
	@MessageReceived varchar(1000)
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
 BEGIN
 INSERT INTO [adi].[MPulseMOs]
   (

	[LoadDate],
	[DataDate],
	[SrcFileName],
	[CreatedDate] ,
	[CreatedBy] ,
	[LastUpdatedDate],
	[LastUpdatedBy] ,
    [MO_Date_Time],
	[ClientMemberKey],
	[ClientKey],
	[Ace_ID] ,
	[FirstName] ,
	[LastName] ,
	[PhoneNumber] ,
	[MessageReceived]
    )
     VALUES
   (
    --@loadDate,
	GETDATE(),
	@DataDate ,
	@SrcFileName,
	GETDATE(),
	-- @CreatedDate,
	@CreatedBy ,
	GETDATE(),
	--@LastUpdatedDate,
	@LastUpdatedBy,
	@MO_Date_Time,
	@ClientMemberKey ,
	@ClientKey ,
	@Ace_ID,
	@FirstName ,
	@LastName ,
	@PhoneNumber,
	@MessageReceived 
   )
   END;

  -- SET @ActionStopDateTime = GETDATE(); 
  -- EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditID, @ActionStopDateTime, 1,1,0,2   

  --  EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, '[ACECARDW].[adi].[copUhcPcor]', '';

END




