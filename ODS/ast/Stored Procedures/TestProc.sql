CREATE Procedure ast.TestProc 
as
begin
    
	   if (1 = 1 )
	   begin	 
		  declare @s varchar(50) = 'EmployeeID does not exist.';
		  THROW 10000 , @s, 1
		  SELECT 'this worked'
	   end
    
    Select 'this failed';
end;