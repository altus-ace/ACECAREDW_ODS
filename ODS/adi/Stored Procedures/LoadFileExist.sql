-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[LoadFileExist](
    @RecordsExist char(1) output,
   	@SrcFileName varchar(100),
	@TableName VARCHAR(100) 
	
	 
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
	DECLARE @sql_command NVARCHAR(MAX);
    DECLARE @ColumnName varchar(100) = '';
  

 SELECT @sql_command = 'Select COUNT(*) FROM  ' + 	@TableName   
 + ' WHERE SrcFileName =  ''' +  @SrcFileName + '''';

CREATE TABLE #tmpTable
(
    OutputValue VARCHAR(100)
)
--PRINT @sql_command
INSERT INTO #tmpTable (OutputValue)
EXEC sp_executesql @sql_command

IF CONVERT(int, (SELECT OutputValue FROM #tmpTable))  > 0 
    BEGIN 
      SET @RecordsExist = 'T'
    END
ELSE 
    BEGIN
	  SET @RecordsExist = 'F'  
	END

DROP TABLE #tmpTable

END






