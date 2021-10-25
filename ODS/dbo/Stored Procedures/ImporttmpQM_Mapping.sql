-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [dbo].[ImporttmpQM_Mapping]
@QM_DESC VARCHAR(400)
--@CreatedBy VARCHAR(50),
--@LastUpdatedBy VARCHAR(50)
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--UPDATE adi.[stg_claims] 
	--SET FirstName = @FirstName,
	--    LastName = @LastName

 --   WHERE SUBSCRIBER_ID = @SUBSCRIBER_ID
--	and 
	 
--	IF @@ROWCOUNT = 0

	BEGIN

	-- Remove Anything 
	
	--- DELETE dbo.tmp_QM_Mapping 


    -- Insert statements 
    INSERT INTO dbo.tmp_QM_Mapping
    (
--	[QM],
	[QM_DESC],
	[CreatedBy],
	[CreatedDateTime],
	[LastUpdatedBy],
	[LastUpdatedDate]
	)
		
 VALUES   (
     
 --	@QM,
	@QM_DESC,
	'BoomiDbUser',
	--@CreatedBy,
	GETDATE(),
	--[CreatedDateTime],
	'BoomiDbUser',
	--@LastUpdatedBy,
	GETDATE()
	--[LastUpdatedDate] 

)
    END

END



--SELECT REPLACE( CONVERT(date, GETDATE()) ,'1900-01-01',  null)