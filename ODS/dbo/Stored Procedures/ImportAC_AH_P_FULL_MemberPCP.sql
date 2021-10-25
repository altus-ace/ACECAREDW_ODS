-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ImportAC_AH_P_FULL_MemberPCP](
   	@MEMBER_ID varchar(50) ,
	@MEMBER_PCP varchar(50) ,
	@PROVIDER_RELATIONSHIP_TYPE varchar(50),
	@LOB varchar(50),
	@PCP_EFFECTIVE_DATE varchar(12),
	@PCP_TERM_DATE varchar(12),
	@MEMBER_PCP_ADDITIONAL_INFORMATION_1 varchar(50),
	--[LoadDate] [datetime,
	@SrcFileName varchar(100)

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
 INSERT INTO [dbo].[tmp_AC_AH_P_FULL_MemberPCP]
   (
   	[MEMBER_ID] ,
	[MEMBER_PCP] ,
	[PROVIDER_RELATIONSHIP_TYPE] ,
	[LOB],
	[PCP_EFFECTIVE_DATE] ,
	[PCP_TERM_DATE],
	[MEMBER_PCP_ADDITIONAL_INFORMATION_1] ,
	--[LoadDate] ,
	[SrcFileName] 
    )
     VALUES
   (
    @MEMBER_ID ,
	@MEMBER_PCP ,
	@PROVIDER_RELATIONSHIP_TYPE ,
	@LOB ,
	CONVERT(date, @PCP_EFFECTIVE_DATE) ,
	CONVERT(DATE, @PCP_TERM_DATE) ,
	@MEMBER_PCP_ADDITIONAL_INFORMATION_1,
	--[LoadDate] [datetime,
	@SrcFileName 
    



   )
   END;

  -- SET @ActionStopDateTime = GETDATE(); 
  -- EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditID, @ActionStopDateTime, 1,1,0,2   

  --  EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, '[ACECARDW].[adi].[copUhcPcor]', '';

END




