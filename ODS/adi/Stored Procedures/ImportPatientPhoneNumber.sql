-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportPatientPhoneNumber](
    @loadDate date,
	@DataDate date,
	@SrcFileName varchar(100),
	@CreatedDate date,
	@CreatedBy varchar(50),
	@LastUpdatedDate date,
	@LastUpdatedBy varchar(50),
    @LastName varchar(50),
	@FirstName varchar(50),
	@DOB varchar(10),
	@MemberID varchar(20),
	@TIN varchar(20),
	@PatientHomePhone varchar(20),
	@PatientMobilePhone varchar(20),
	@Language varchar(50)
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
 INSERT INTO [adi].[PatientPhoneNumber]
   (
   	[loadDate] ,
	[DataDate],
	[SrcFileName],
	[CreatedDate],
	[CreatedBy],
	[LastUpdatedDate] ,
	[LastUpdatedBy] ,
	[LastName] ,
	[FirstName] ,
	[DOB] ,
	[MemberID],
	TIN,
	[PatientHomePhone] ,
	[PatientMobilePhone] ,
	[Language] 
   	 
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
    @LastName ,
	@FirstName,
	@DOB ,
	@MemberID,
	@TIN ,
	@PatientHomePhone ,
	@PatientMobilePhone ,
	@Language 
   )
   END;

  -- SET @ActionStopDateTime = GETDATE(); 
  -- EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditID, @ActionStopDateTime, 1,1,0,2   

  --  EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, '[ACECARDW].[adi].[copUhcPcor]', '';

END




