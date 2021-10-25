CREATE PROCEDURE [amd].[sp_GetInsertRowCount](
	  @RowCount INT output,
	  @SrcFileName varchar(100),
	  @DBName varchar(100)
	
)
AS 
BEGIN

DECLARE   @Sql varchar(max)  

SET @Sql =  'SET @RowCount = (Select COUNT(*) FROM ' 
SET @Sql = @Sql + @DBName 
SET @Sql = @Sql + 'WHERE SrcFileName = '
SET @Sql = @Sql + @SrcFileName   
--'SrcFileName = ' +
--             +  QUOTENAME(@DBName) 
--			   + N' Where SrcFileName = '
--			   + '' + @SrcFileName +  ''

EXECUTE(@Sql) 
--sp_executesql @Sql

END
