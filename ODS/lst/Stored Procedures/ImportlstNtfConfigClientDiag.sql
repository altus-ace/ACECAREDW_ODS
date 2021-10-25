-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [lst].[ImportlstNtfConfigClientDiag](
   
    @SrcFileName varchar(100),
	@CreatedBy varchar(50),
	@LastUpdatedBy varchar(50) ,
	@ClientKey varchar(5) ,
	@DiagCode [varchar](10),
	@NtfFollupDays varchar(5),
	@NtfFollupUpAnchorDate varchar(10)
	
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
   EXEC [AceMasterData].[lst].[ImportlstNtfConfigClientDiag]
    @SrcFileName ,
	@CreatedBy ,
	@LastUpdatedBy ,
	@ClientKey ,
	@DiagCode ,
	@NtfFollupDays ,
	@NtfFollupUpAnchorDate 

   END


