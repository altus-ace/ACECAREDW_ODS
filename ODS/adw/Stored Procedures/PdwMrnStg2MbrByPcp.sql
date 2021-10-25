CREATE PROCEDURE [adw].[PdwMrnStg2MbrByPcp]
	@loadDate DATE	
AS
	
    /* Insert new MstrMrn */
    INSERT INTO [adw].[MstrMrn]
           ([FirstName]
           ,[LastName]
           ,[MiddleName]
           ,[DateOfBirth]
           ,[Gender]
           ,[MedicareID]
           ,[MedicaidID]
           ,[srcUrn]
           ,[srcTableName]
           ,[Active]           
           ,[LoadDate]
           ,[DataDate]
		  )            
    SELECT 
	    m.mbrFirstName
	    ,m.mbrLastName
	    ,m.mbrMiddleName
	    ,m.mbrDob
	    ,m.mbrGENDER
	    ,m.mbrMEDICARE_ID
	    ,m.mbrMEDICAID_NO        
	    ,m.adiKey
	    ,m.adiTableName
	    , 1	AS isActive
	    , CONVERT(DATE, GETDATE()) AS LoadDate
	    , m.DataDate
	    --, m.MstrMrnKey
	    --, m.ClientMemberKey 
	  FROM (SELECT DISTINCT m.ClientSubscriberId ,m.adiKey SRC_URN ,m.AdiTableName SRC_TABLE ,m.MbrFirstName
				, m.MbrLastName,m.mbrMiddleName ,m.mbrDob ,m.mbrGender ,m.mbrMedicaid_No ,m.mbrMedicare_ID ,m.HICN
				, m.DataDate,m.AdiTableName, m.AdiKey, mrn.MstrMrnKey
				,m.MBI ,ROW_NUMBER() OVER(PARTITION BY m.ClientSubscriberId ORDER BY m.LoadDate DESC) arn
	    		 FROM ast.MbrStg2_MbrData m    
	   			LEFT JOIN (SELECT r.MstrMrnKey, r.MedicaidID, r.MedicareID, r.FirstName, r.LastName, r.Gender, r.DateOfBirth
	   				      FROM adw.MstrMrn r 
	   					  WHERE Active = 1) mrn 
						  ON (m.mbrMedicare_id = mrn.MedicareID OR m.mbrMEDICAID_NO = mrn.MedicaidID)
	   						 OR (m.mbrLastName = mrn.LastName 
	   							    AND m.mbrFirstName = mrn.FirstName 
	   							    AND m.mbrGENDER = mrn.Gender 
	   							    AND m.mbrDob = mrn.DateOfBirth)
	    		  WHERE m.LoadDate >= @loadDate) M
	    	   LEFT JOIN adw.MbrMember mbr ON m.ClientSubscriberId = mbr.ClientMemberKey
	        WHERE m.arn = 1
	   		 AND mbr.ClientMemberKey is null;

	   /* UPDATE MRN */
	   MERGE adw.MstrMrn trg
	   USING(SELECT DISTINCT m.ClientSubscriberId ,m.adiKey SRC_URN ,m.AdiTableName SRC_TABLE ,m.MbrFirstName
				, m.MbrLastName,m.mbrMiddleName ,m.mbrDob ,m.mbrGender ,m.mbrMedicaid_No ,m.mbrMedicare_ID ,m.HICN
				, m.AdiTableName, m.AdiKey, m.LoadDate, m.DataDate
				, mbr.MstrMrnKey, mbr.ClientMemberKey
				, m.MBI ,ROW_NUMBER() OVER(PARTITION BY m.ClientSubscriberId ORDER BY m.LoadDate DESC) arn			 
			 FROM ast.MbrStg2_MbrData m    
				JOIN adw.MbrMember mbr ON m.ClientSubscriberId = mbr.ClientMemberKey) src
	   ON trg.MstrMrnKey = src.MstrMrnKey
	   WHEN Matched THEN 
	   UPDATE SET trg.[FirstName]		= src.[mbrFirstName]			   
				,trg.[LastName]	= src.[mbrLastName]
				,trg.[MiddleName]	= src.[mbrMiddleName]
				,trg.[DateOfBirth]	= src.[mbrDob]
				,trg.[Gender]		= src.[mbrGender]
				,trg.[MedicareID]	= src.[mbrMedicare_ID]
				,trg.[MedicaidID]	= src.[mbrMedicaid_NO]
				,trg.[srcUrn]		= src.adiKey
				,trg.[srcTableName]	= src.AdiTableName
				,trg.[Active]       = 1
				,trg.[LoadDate]	= src.[LoadDate]
				,trg.[DataDate]	= src.[DataDate]
	   ;
