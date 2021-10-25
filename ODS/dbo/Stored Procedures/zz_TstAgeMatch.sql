Create Procedure [zz_TstAgeMatch] 
(
@LastName nvarchar(20),
@Gender varchar(10),
@PercentContribution nvarchar(4) OUT, @PatientName nvarchar(20) out
)
As
declare @temp int 
DECLARE @Query nvarchar(500)
   if Exists(select * from adw.A_MSTR_MPI where Last_Name = @LastName and Left(Gender,1) = + @Gender)
   Begin
   set @PatientName = @LastName
   set @query = 'select * from dbo.PatientDetails where Name = ' + @LastName + ' and Left(Gender,1) = '+ @Gender + ' '
   set @temp = 0.2*100
   set @PercentContribution = @temp + '%'
   Execute(@query)
   Return
End