-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportlstScoringSystem]
    @ClientKey varchar(5),
	@LOB [varchar](20) ,
	@LOB_State [varchar](10),
	@EffectiveDate varchar(10),
	@ExpirationDate varchar(10),
	@Active varchar(5),
	@ScoringType [varchar](10),
	@P4qIndicator [char](1) ,
	@MeasureID [varchar](20) ,
	@MeasureDesc [varchar](80) ,
	@Score_A varchar(10),
	@Score_B varchar(10),
	@Score_C varchar(10),
	@Score_D varchar(10),
	@Score_E varchar(10),
	@Weight_1 varchar(5),
	@Weight_2 varchar(5),
	@Weight_3 varchar(5),
	@Weight_4 varchar(5),
	@Weight_5 varchar(5),
	@AceQmWeight varchar(5),
	@AceCmWeight varchar(5),
	@Pq4BaseValue varchar(10),
	@CreatedDate varchar(10),
	@CreatedBy [varchar](50) ,
	@LastUpdatedDate varchar(10) ,
	@LastUpdatedBy [varchar](50) 
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    EXEC [ACDW_CLMS_SHCN_MSSP].[adi].[ImportlstScoringSystem]
	@ClientKey ,
	@LOB ,
	@LOB_State ,
	@EffectiveDate ,
	@ExpirationDate ,
	@Active ,
	@ScoringType ,
	@P4qIndicator ,
	@MeasureID  ,
	@MeasureDesc ,
	@Score_A ,
	@Score_B ,
	@Score_C ,
	@Score_D ,
	@Score_E ,
	@Weight_1 ,
	@Weight_2 ,
	@Weight_3 ,
	@Weight_4 ,
	@Weight_5 ,
	@AceQmWeight ,
	@AceCmWeight ,
	@Pq4BaseValue ,
	@CreatedDate ,
	@CreatedBy  ,
	@LastUpdatedDate  ,
	@LastUpdatedBy     

END


