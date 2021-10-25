
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[Import_AETCOM_CostbyMCC_AllMCC](
    @SrcFileName varchar(100) ,
	--@LoadDate date ,
	@DataDate varchar(10) ,
	--@CreatedDate datetime ,
	@CreatedBy varchar(50) ,
	--@LastUpdatedDate datetime ,
	@LastUpdatedBy varchar(50)  ,
	@AttributedProviderID varchar(20) ,
	@AttributedProviderName varchar(50) ,
	@Paid varchar(10) ,
	@Paid_ACOProvider varchar(10) ,
	@Paid_Non_ACOProviderInNetwork varchar(10) ,
	@Paid_ParProviderNotInNetwork varchar(10) ,
	@Paid_AetnaNon_Par_Provider varchar(10) ,
	@PercentPaid_ACOProvider varchar(10) ,
	@PercentPaid_NonACOProviderInNetwork varchar(10) ,
	@PercentPaid_ParProviderNotInNetwork varchar(10) ,
	@PercentPaid_AetnaNonParProvider varchar(10) ,
	@DistintMembersWithClaims varchar(50) ,
	@Members_ACO_Provider varchar(50) ,
	@Members_Non_ACOProviderInNetwork varchar(50) ,
	@Members_ParProviderNotInNetwork varchar(50) ,
	@Members_AetnaNon_ParProvider varchar(50) ,
	@PercentMembers_ACOProvider varchar(10) ,
	@PercentMembers_NonACO_ProviderInNetwork varchar(10) ,
	@PercentMembers_ParProviderNot_In_Network varchar(10) ,
	@PercentMembers_Aetna_Non_ParProvider varchar(10) ,
	@DOS varchar(20) 
  
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

	 
	IF LEN(@AttributedProviderID)!=0
	BEGIN
    -- Insert statements for procedure here
 INSERT INTO [adi].[AETCOM_CostbyMCC_AllMCC]
   (
       [SrcFileName]
      ,[LoadDate]
      ,[DataDate]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[LastUpdatedDate]
      ,[LastUpdatedBy]
      ,[AttributedProviderID]
      ,[AttributedProviderName]
      ,[Paid]
      ,[Paid_ACOProvider]
      ,[Paid_Non_ACOProviderInNetwork]
      ,[Paid_ParProviderNotInNetwork]
      ,[Paid_AetnaNon_Par_Provider]
      ,[PercentPaid_ACOProvider]
      ,[PercentPaid_NonACOProviderInNetwork]
      ,[PercentPaid_ParProviderNotInNetwork]
      ,[PercentPaid_AetnaNonParProvider]
      ,[DistintMembersWithClaims]
      ,[Members_ACO_Provider]
      ,[Members_Non_ACOProviderInNetwork]
      ,[Members_ParProviderNotInNetwork]
      ,[Members_AetnaNon_ParProvider]
      ,[PercentMembers_ACOProvider]
      ,[PercentMembers_NonACO_ProviderInNetwork]
      ,[PercentMembers_ParProviderNot_In_Network]
      ,[PercentMembers_Aetna_Non_ParProvider]
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
	@AttributedProviderID  ,
	@AttributedProviderName  ,
	CASE WHEN @Paid = ''
	THEN NULL
	ELSE CONVERT(money,@Paid)
	END,
	CASE WHEN @Paid_ACOProvider = ''
	THEN NULL
	ELSE CONVERT(money,@Paid_ACOProvider)
	END,
	CASE WHEN @Paid_Non_ACOProviderInNetwork = ''
	THEN NULL
	ELSE CONVERT(money,@Paid_Non_ACOProviderInNetwork)
	END,	  
	CASE WHEN @Paid_ParProviderNotInNetwork = ''
	THEN NULL
	ELSE CONVERT(money,@Paid_ParProviderNotInNetwork)
	END,	
	CASE WHEN @Paid_AetnaNon_Par_Provider = ''
	THEN NULL
	ELSE CONVERT(money,@Paid_AetnaNon_Par_Provider)
	END,	
	CASE WHEN @PercentPaid_ACOProvider  = ''
	THEN NULL
	ELSE CONVERT(decimal(10,2),REPLACE(@PercentPaid_ACOProvider, '%', ''))
	END,
	CASE WHEN @PercentPaid_NonACOProviderInNetwork  = ''
	THEN NULL
	ELSE CONVERT(decimal(10,2),REPLACE(@PercentPaid_NonACOProviderInNetwork, '%', ''))
	END, 
	CASE WHEN @PercentPaid_ParProviderNotInNetwork = ''
	THEN NULL
	ELSE CONVERT(decimal(10,2),	REPLACE(@PercentPaid_ParProviderNotInNetwork, '%', ''))
	END, 	 
	CASE WHEN @PercentPaid_AetnaNonParProvider = ''
	THEN NULL
	ELSE CONVERT(decimal(10,2),REPLACE(@PercentPaid_AetnaNonParProvider, '%', ''))
	END,  
	@DistintMembersWithClaims  ,
	@Members_ACO_Provider  ,
	@Members_Non_ACOProviderInNetwork  ,
	@Members_ParProviderNotInNetwork  ,
	@Members_AetnaNon_ParProvider  ,
	CASE WHEN @PercentMembers_ACOProvider = ''
	THEN NULL
	ELSE CONVERT(decimal(10,2),REPLACE(@PercentMembers_ACOProvider, '%', ''))
	END,  
	CASE WHEN 	@PercentMembers_NonACO_ProviderInNetwork  = ''
	THEN NULL
	ELSE CONVERT(decimal(10,2),	REPLACE(@PercentMembers_NonACO_ProviderInNetwork, '%', ''))
	END, 
	CASE WHEN @PercentMembers_ParProviderNot_In_Network  = ''
	THEN NULL
	ELSE CONVERT(decimal(10,2),	REPLACE(@PercentMembers_ParProviderNot_In_Network, '%', ''))
	END, 
	CASE WHEN @PercentMembers_Aetna_Non_ParProvider  = ''
	THEN NULL
	ELSE CONVERT(decimal(10,2),	REPLACE(@PercentMembers_Aetna_Non_ParProvider, '%', ''))
	END, 
	@DOS   
   );
   END
END
