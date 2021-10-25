-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[FileExist](
   	@SrcFileName varchar(100),
	@TableName VARCHAR(100), 
	@RecordExist INT output
	 
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
	DECLARE @sql_command NVARCHAR(MAX);
    DECLARE @RowCount int;
--    DECLARE @table_name varchar(100) = 'adi.NtfUhcErCensus'


 SELECT @sql_command = 'SELECT COUNT(*) FROM  ' + @TableName  
 + ' WHERE SrcFileName =  ''' +  @SrcFileName + '''';


PRINT @sql_command;
EXEC sp_executesql @sql_command;
	 


END

