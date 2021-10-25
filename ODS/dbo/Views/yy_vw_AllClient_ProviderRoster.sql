



CREATE VIEW [dbo].[yy_vw_AllClient_ProviderRoster]
AS													   
     SELECT ProviderRoster.NPI, 							   
		  ProviderRoster.LastName, 						   
            ProviderRoster.FirstName,             			   
            ProviderRoster.Degree, 						   
            ProviderRoster.TIN, 							   
            ProviderRoster.PrimarySpeciality, 				   
            ProviderRoster.Sub_Speciality, 					   
            ProviderRoster.GroupName, 						   
            ProviderRoster.PrimaryAddress, 					   
            ProviderRoster.PrimaryCity, 					   
            ProviderRoster.PrimaryState, 					   
            ProviderRoster.PrimaryZipcode, 	
		  ProviderRoster.PrimaryCounty,				   
            ProviderRoster.PrimaryPOD, 						   
            ProviderRoster.PrimaryQuadrant, 					   
            ProviderRoster.PrimaryAddressPhoneNum, 			   
            ProviderRoster.BillingAddress, 					   
            ProviderRoster.BillingCity, 					   
            ProviderRoster.BillingState, 					   
            ProviderRoster.BillingZipcode, 					   
            ProviderRoster.BillingPOD, 						   
            ProviderRoster.BillingAddressPhoneNum, 			   
            ProviderRoster.Comments, 						   
		  ProviderRoster.HealthPlan, 						   
		  ProviderRoster.LOB, 							   
		  ProviderRoster.EffectiveDate, 					   
            ProviderRoster.ExpirationDate,					   
            ProviderRoster.ClientProviderID,                        
            CASE WHEN (ProviderRoster.IsActive = 1) THEN 'Active'	
			 ELSE 'Termed' 							   
			 END AS STATUS,            					   
            ProviderRoster.AccountType, 					   
            ProviderRoster.NetworkContact, 					   
            ProviderRoster.Chapter,						   
		  ProviderRoster.ClientKey CalcClientKey,			   
		  ProviderRoster.ProviderType,													   
		  ProviderRoster.fctProviderRosterSkey, 			   
            ProviderRoster.SourceJobName, 					   
            --ProviderRoster.LoadDate, 			  -- Metadata not exposed					   
            ProviderRoster.DataDate, 						   
            ProviderRoster.CreatedDate, 					   
            --ProviderRoster.CreatedBy, 		  -- Metadata not exposed			   
            --ProviderRoster.LastUpdatedDate, 	  -- Metadata not exposed			   
            --ProviderRoster.LastUpdatedBy, 		  -- Metadata not exposed
            --ProviderRoster.IsActive, 			  -- Metadata not exposed
		  ProviderRoster.AceProviderID	,
		  ProviderRoster.AceAccountID	,
		  ProviderRoster.Ethnicity	,	
		  ProviderRoster.LanguagesSpoken	,
		  ProviderRoster.Provider_DOB,
		  ProviderRoster.Provider_Gender	,
            ProviderRoster.RowEffectiveDate, 
            ProviderRoster.RowExpirationDate
    FROM adw.fctProviderRoster ProviderRoster 
    WHERE GETDATE() BETWEEN ProviderRoster.RowEffectiveDate and ProviderRoster.RowExpirationDate;
