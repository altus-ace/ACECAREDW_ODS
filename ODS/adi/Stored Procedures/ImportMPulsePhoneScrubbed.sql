-- =============================================
-- Author:		Bing
-- Create date: 01/22/2020
-- Description:	To load Ace_PhoneScrub
-- =============================================
CREATE PROCEDURE [adi].[ImportMPulsePhoneScrubbed](
   -- @loadDate date,
	--@DataDate date,
	@SrcFileName varchar(100),
	@CreatedDate date,
	@CreatedBy varchar(50),

	@ClientMemberKey varchar(20),
	@Client_ID varchar(10),
	@Ace_ID_Mrn varchar(20),
	@phoneNumber varchar(30),
	@carrier_type varchar(30),
	@carrier_name varchar(100)
--	[NNID_CALLED] [varchar](50) NULL,
--	[NNID_FAILURES] [varchar](150) NULL,

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



 IF (@ClientMemberKey <>'' ) 
 --AND @FirstName <> '' AND @LastName <> ''  AND @MemberID <> '') 
 BEGIN
INSERT INTO [adi].[MPulsePhoneScrubbed]
   (
    [ClientMemberKey],
	[Client_ID] ,
	[Ace_ID_Mrn],
	[phoneNumber] ,
	[carrier_type] ,
	[carrier_name] ,
--	[NNID_CALLED] ,
--	[NNID_FAILURES] ,
	[srcFileName] ,
	[LoadDate] ,
	[DataDate],
	[CreatedDate] ,
	[CreatedBy] 
   	 
            )
     VALUES
   (

	@ClientMemberKey,
	CASE WHEN @Client_ID = ''
	THEN NULL
	ELSE CONVERT(int, @Client_ID)
	END, 
	CASE WHEN @Ace_ID_Mrn = ''
	THEN NULL
	ELSE CONVERT(numeric(15,0),@Ace_ID_Mrn)
	END, 
	@phoneNumber ,
	@carrier_type ,
	@carrier_name ,
	@SrcFileName,
	GETDATE(),
	--@loadDate ,
	CONVERT(DATE, SUBSTRING(RIGHT( Substring(@SrcFileName,1, (PATINDEX('%.txt%', @SrcFileName)-1)), 8), 5,4) +  SUBSTRING(RIGHT( Substring(@SrcFileName,1, (PATINDEX('%.txt%', @SrcFileName)-1)), 8),1,4)),
	GETDATE(),
	--@CreatedDate date,
	@CreatedBy 
   )
   END;

  -- SET @ActionStopDateTime = GETDATE(); 
  -- EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditID, @ActionStopDateTime, 1,1,0,2   

  --  EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, '[ACECARDW].[adi].[copUhcPcor]', '';
END


--- CONVERT(date, RIGHT( Substring(@SrcFileName,1, (PATINDEX('%.csv%', @SrcFileName)-1)), 8)),

SELECT CONVERT(DATE, SUBSTRING(RIGHT( Substring('Srubbed_Ace_PhoneScrub_01172020.txt',1, (PATINDEX('%.txt%', 'Srubbed_Ace_PhoneScrub_01172020.txt')-1)), 8), 5,4) +  SUBSTRING(RIGHT( Substring('Srubbed_Ace_PhoneScrub_01172020.txt',1, (PATINDEX('%.txt%', 'Srubbed_Ace_PhoneScrub_01172020.txt')-1)), 8),1,4))
