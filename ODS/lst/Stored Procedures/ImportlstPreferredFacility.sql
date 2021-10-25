-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [lst].[ImportlstPreferredFacility](
    @SourceJobName [varchar](50) ,
	@LoadDate varchar(10),
	@DataDate varchar(10),
	--[CreatedDate] [datetime] NOT NULL,
	@CreatedBy [varchar](50),
	-- [LastUpdatedDate] [date] NOT NULL,
	@LastUpdatedBy [varchar](50) ,
	@EffectiveDate varchar(10),
	@ExpirationDate varchar(10),
	@FacilityName varchar(50),
	@FacilityType varchar(10),
	@State varchar(35) ,
	@Region varchar(35),
	@NPI varchar(10),
	@Active char(1) 	
	
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
	  
	--DECLARE @RecordExist INT
	--SET @RecordExist = (Select COUNT(*)
	--FROM adi.NtfUhcErCensus 
	--WHERE SrcFileName = @SrcFileName)
	 
--	IF @RecordExist =0
	
EXEC [AceMasterData].[lst].[ImportlstPreferredFacility]
      @SourceJobName ,
	@LoadDate ,
	@DataDate ,
	--[CreatedDate] [datetime] NOT NULL,
	@CreatedBy ,
	-- [LastUpdatedDate] [date] NOT NULL,
	@LastUpdatedBy  ,
	@EffectiveDate ,
	@ExpirationDate ,
	@FacilityName ,
	@FacilityType ,
	@State ,
	@Region ,
	@NPI ,
	@Active  	
END


