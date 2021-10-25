
CREATE view  [abo].[vw_Exp_MSSP8x8ProgramList]
AS
SELECT l.MembersIDNumber, 
             Replace(l.CustomersFirst_name,  ',', ' ')CustomersFirst_name, 
             Replace(l.CustomersLast_name,   ',', ' ')CustomersLast_name, 
             Replace(l.CustomersEmail, 	     ',', ' ')CustomersEmail, 
		   CASE WHEN (ISNULL(l.CustomersAlternative,'') = '') then ''
			 WHEN (l.CustomersAlternative like '1%') THEN  l.CustomersAlternative
			 ELSE '1' + l.CustomersAlternative
			 END AS CustomersAlternative,              
             CASE WHEN (ISNULL(l.CustomersVoice,'') = '') then ''
			 WHEN (l.CustomersVoice like '1%') THEN  l.CustomersVoice 
			 ELSE '1' + l.CustomersVoice 
			 END AS CustomersVoice, 
             l.DateOfBirth, 
             Replace(l.PrimaryAddress	, ',', ' ') PrimaryAddress, 
             Replace(l.MemberHomeCity 	, ',', ' ') MemberHomeCity, 
             Replace(l.MemberHomeState 	, ',', ' ') MemberHomeState, 
             Replace(l.MEMBERHOMEZIP 	, ',', ' ') MEMBERHOMEZIP, 
             Replace(l.SecondaryAddress , ',', ' ') SecondaryAddress,
             Replace(l.SecondaryCity	, ',', ' ') SecondaryCity, 
             Replace(l.ScondaryState	, ',', ' ') ScondaryState, 
             Replace(l.SecondaryZip  	, ',', ' ') SecondaryZip, 
             Replace(l.gender,	 ',', ' ') gender, 
             Replace(l.PCPName, 	 ',', ' ') PCPName, 
		   CASE WHEN (ISNULL(l.PCPPhone, '') = '') then ''
			 WHEN (l.PCPPhone like '1%') THEN  l.PCPPhone
			 ELSE '1' + l.PCPPhone
			 END AS PCPPhone,                                    
		   Replace(l.MCO,				',', ' ') MCO, 
             Replace(l.MCOEffectiveDate, 	',', ' ') MCOEffectiveDate, 
             Replace(l.MCOProduct, 		',', ' ') MCOProduct, 
             Replace(l.LineOfBusiness, 		',', ' ') LineOfBusiness, 
             Replace(l.HEDISGap, 			',', ' ') HEDISGap, 
             Replace(l.HedisDateRange, 		',', ' ') HedisDateRange, 
             Replace(l.HEDISStatus, 		',', ' ') HEDISStatus, 
             Replace(l.Age,				',', ' ') Age,	    
             Replace(l.Language,				  ',', ' ') 		Language,              
             Replace(l.CaregiverName, 			  ',', ' ') 	CaregiverName, 
             Replace(l.PatientidentifiedHighRisk,	  ',', ' ') 	PatientidentifiedHighRisk,
             Replace(l.Rank	,				  ',', ' ') 	Rank
		  
FROM [ACDW_CLMS_SHCN_MSSP].[adw].[vw_Exp_8x8ProgramList] l


