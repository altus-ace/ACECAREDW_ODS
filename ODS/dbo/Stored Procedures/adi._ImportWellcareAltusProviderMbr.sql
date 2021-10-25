
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi.[ImportWellcareAltusProviderMbr](
    @IPA_NAME varchar(50) ,
	@PCP_NAME varchar(50) ,
	@SUBSCRIBER_ID varchar(50) ,
	@DOB varchar(12) ,
	@LANGUAGE varchar(50) ,
	@MEMBER_NAME varchar(50) ,
	@ADDRESS_1 varchar(100) ,
	@ADDRESS_2 varchar(50) ,
	@CITY varchar(50) ,
	@STATE varchar(20) ,
	@ZIP_CODE varchar(20) ,
	@HOME_PHONE_NUMBER varchar(20) ,
	@MOBILE_PHONE varchar(20) ,
	@MEMBER_EFFECTIVE_DATE varchar(12),
	@SrcFileName varchar(100),
	--@LoadDate varchar(12),
	@DataDate varchar(12) ,
	--@CreateDate datetime2(7)  ,
	@CreateBy varchar(50)  ,
	--@LastUpdatedDate datetime2(7),
	@LastUpdatedBy varchar(50)

)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--UPDATE adi.MbrAetCom
--	SET MEMBER_ID  =  @MEMBER_ID 

--    WHERE  MEMBER_ID = @MEMBER_ID

	 
--	IF @@ROWCOUNT = 0

    -- Insert statements for procedure here

BEGIN
 INSERT INTO [adi.[WellcareAltusProviderMbr]
   (
       IPA_NAME
      ,PCP_NAME
      ,SUBSCRIBER_ID
      ,DOB
      ,[LANGUAGE]
      ,MEMBER_NAME
      ,ADDRESS_1
      ,ADDRESS_2
      ,CITY
      ,[STATE]
      ,ZIP_CODE
      ,HOME_PHONE_NUMBER
      ,MOBILE_PHONE
      ,MEMBER_EFFECTIVE_DATE
      ,SrcFileName
      ,LoadDate
      ,DataDate
      ,CreateDate
      ,CreateBy
      ,LastUpdatedDate
      ,LastUpdatedBy
    
    )
     VALUES
   (   
     @IPA_NAME  ,
	@PCP_NAME  ,
	@SUBSCRIBER_ID  ,
	@DOB ,
	@LANGUAGE ,
	@MEMBER_NAME  ,
	@ADDRESS_1  ,
	@ADDRESS_2 ,
	@CITY  ,
	@STATE ,
	@ZIP_CODE,
	@HOME_PHONE_NUMBER  ,
	@MOBILE_PHONE  ,
	@MEMBER_EFFECTIVE_DATE ,
	@SrcFileName ,
	GETDATE(),
	--@LoadDate varchar(12),
	@DataDate ,
	GETDATE(),
	--@CreateDate datetime2(7)  ,
	@CreateBy   ,
	GETDATE(),
	--@LastUpdatedDate datetime2(7),
	@LastUpdatedBy 
   )
END

END






