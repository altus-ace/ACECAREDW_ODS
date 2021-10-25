-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[NewFileLoad](
   	@RecordExist varchar(10)   output,
	@DBSrcFileName varchar(100),
   	@SrcFileName varchar(100),
	@TblName varchar(100)

	 
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
	   IF(EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @TblName))
        BEGIN
		DECLARE @SQL NVARCHAR(MAX) = N'SET ' +  @RecordExist + ' = (SELECT COUNT(*) FROM ' +  @TblName + 
		' WHERE SrcFileName = ' +  	@SrcFileName      

         END

     --DECLARE @Sql AS NVARCHAR(MAX);
  ;
 

--	Declare @RecordExist int  
	
	--SET @Sql = @Sql +  N'SET @RecordExist = (Select COUNT(*) FROM ' 
	 --       +  QUOTENAME(@DBName) 
	 --       + N' Where SrcFileName ='
--			+  QUOTENAME(@SrcFileName)
	-- SET @RecordExist = (Select COUNT(*) FROM ' +  QUOTENAME(@DBName) + N'WHERE  @DBSrcFileName = @SrcFileName'  

--	IF @RecordExist = 0
--	 SELECT @NewLoad = 'Y';
  --  Else 
	--If @RecordExist > 0 
--	 SELECT @NewLoad = 'N';

	 
--	IF @RecordExist =0
  --	BEGIN     
    -- Insert statements for procedure here
	PRINT 'Test'

  ---END
     EXECUTE(@SQL)
  -- EXECUTE sp_executesql @statement = @Sql

END
