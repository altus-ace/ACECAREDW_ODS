
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[Import_AETCOM_CostbyMCC_Membership](
    @SrcFileName varchar(100) ,
	--@LoadDate date ,
	@DataDate varchar(10) ,
	--@CreatedDate datetime ,
	@CreatedBy varchar(50) ,
	--@LastUpdatedDate datetime ,
	@LastUpdatedBy varchar(50)  ,
	@Attributed_Provider_ID varchar(20) ,
	@Attributed_Provider_Name varchar(50) ,
	@Avg_Member_Count int ,
	@Member_Months int ,
	@Avg_Retro_Risk varchar(10) ,
	@Avg_Age int ,
	@DOS varchar(50) 
  
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

	 
	IF LEN(@Attributed_Provider_ID)!=0
	BEGIN
    -- Insert statements for procedure here
 INSERT INTO [adi].[AETCOM_CostbyMCC_Membership]
   (
      [SrcFileName]
      ,[LoadDate]
      ,[DataDate]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[LastUpdatedDate]
      ,[LastUpdatedBy]
      ,[Attributed_Provider_ID]
      ,[Attributed_Provider_Name]
      ,[Avg_Member_Count]
      ,[Member_Months]
      ,[Avg_Retro_Risk]
      ,[Avg_Age]
      ,[DOS]
            )
     VALUES
   (
    @SrcFileName  ,
	GETDate(),
	--@LoadDate date ,
	@DataDate  ,
	GETDATE(),
	--@CreatedDate datetime ,
	@CreatedBy  ,
	GETDATE(),
	--@LastUpdatedDate datetime ,
	@LastUpdatedBy   ,
	@Attributed_Provider_ID  ,
	@Attributed_Provider_Name  ,
	@Avg_Member_Count  ,
	@Member_Months  ,
	CASE WHEN @Avg_Retro_Risk = ''
	THEN NULL
	ELSE CONVERT(DECIMAL(10,2),
	@Avg_Retro_Risk )
	END,
	@Avg_Age ,
	@DOS 
   );
   END
END
