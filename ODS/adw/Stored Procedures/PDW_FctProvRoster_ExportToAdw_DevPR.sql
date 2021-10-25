CREATE PROCEDURE [adw].[PDW_FctProvRoster_ExportToAdw_DevPR]
as
BEGIN
    DECLARE @LoadDate DATE = GETDATE();
     /* update Staging previous load, that is active on the load date to be termed the day before*/    
    DECLARE @TermDate DATE = DATEADD(day, -1, @LoadDate);
    --SELECT pr.RowEffectiveDate, pr.RowExpirationDate, @TermDate
    UPDATE pr set pr.RowExpirationDate = @TermDate
    FROM adw.fctProviderRoster_DevPR pr
    WHERE @LoadDate between pr.RowEffectiveDate AND pr.RowExpirationDate	 
    ;

    INSERT INTO [adw].[fctProviderRoster_DevPR]
           ([SourceJobName],[LoadDate],[DataDate]
           ,[IsActive],[RowEffectiveDate],[RowExpirationDate]
           ,[TinClientKey],[TinLob],[TinHealthPlan],[TinHpEffDate],[TinHpExpDate]
           ,[PrvdrTin],[PrvdrClientKey],[PrvdrLOB],[PrvdrHealthPlan],[PrvdrHpEffDate],[PrvdrHpExpDate]
           ,[ClientProviderID], ClientKey, [NPI], TIN
           ,[LastName],[FirstName],[Degree],[PrimarySpeciality],[Sub_Speciality]
           ,[GroupName]
           ,[PrimaryAddress],[PrimaryCity],[PrimaryState],[PrimaryZipcode],[PrimaryPOD],[PrimaryQuadrant],[PrimaryAddressPhoneNum]
           ,[BillingAddress],[BillingCity],[BillingState],[BillingZipcode],[BillingPOD],[BillingAddressPhoneNum]
		 ,[Comments],[AccountType],[NetworkContact],[Chapter],[ProviderType]
           ,[AceProviderID],[AceAccountID],[Ethnicity],[LanguagesSpoken]
           ,[Provider_DOB],[Provider_Gender],[PrimaryCounty]
		 )		 
   SELECT ast.SourceJobName, ast.LoadDate, ast.DataDate, 
	   ast.IsActive, ast.RowEffectiveDate, ast.RowExpirationDate, 
	   ast.TinClientKey, ast.TinLob, ast.TinHealthPlan, ast.TinHpEffDate, ast.TinHpExpDate, 
	   ast.PrvdrTin, ast.PrvdrClientKey, ast.PrvdrLOB, ast.PrvdrHealthPlan, ast.PrvdrHpEffDate, ast.PrvdrHpExpDate,
	   ast.ClientProviderID, ast.PrvdrClientKey, ast.NPI, ast.TIN,
	   ast.LastName, ast.FirstName, ast.Degree, ast.PrimarySpeciality, ast.Sub_Speciality, 
	   ast.GroupName, --ast.TIN, 
	   ast.PrimaryAddress, ast.PrimaryCity, ast.PrimaryState, ast.PrimaryZipcode, ast.PrimaryPOD, ast.PrimaryQuadrant, ast.PrimaryAddressPhoneNum, 
	   ast.BillingAddress, ast.BillingCity, ast.BillingState, ast.BillingZipcode, ast.BillingPOD, ast.BillingAddressPhoneNum, 
	   ast.Comments, ast.AccountType, ast.NetworkContact, ast.Chapter, ast.ProviderType, 
	   ast.AceProviderID, ast.AceAccountID, ast.Ethnicity, ast.LanguagesSpoken, 
	   ast.Provider_DOB, ast.Provider_Gender, ast.PrimaryCounty
   FROM ast.fctProviderRoster_DevPR ast
   WHERE @LoadDate between ast.RowEffectiveDate and ast.RowExpirationDate


END;
