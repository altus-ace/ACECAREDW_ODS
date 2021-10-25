CREATE PROCEDURE [ast].[MbrPst2MbrAetMaTxMbrPhnAdd] --  [ast].[MbrPst2MbrAetMaTxMbrPhnAdd]'2021-09-01',3
    (@loadDate DATE    
    , @InsertCount INT OUTPUT)
AS	

    DECLARE @adiLoadDate DATE = @LoadDate;
    DECLARE @AdiTableName VARCHAR(50) = 'adi.MbrAetMaTx';
    DECLARE @ClientKey INT = 3;

    DECLARE @OutputTbl TABLE (ActionType VARCHAR(50), ID INT);  

		--  DECLARE @LoadDate DATE = '2021-09-01' DECLARE @ClientKey INT = 3 
	IF OBJECT_ID('tempdb..#Prr') IS NOT NULL DROP TABLE #Prr
	CREATE TABLE #Prr(NPI VARCHAR(50),ClientNPI VARCHAR(50),AttribTIN VARCHAR(50),ClientTIN VARCHAR(50),MemberID VARCHAR(50))

	INSERT INTO #Prr(NPI,ClientNPI,AttribTIN,ClientTIN,MemberID)
	EXECUTE  [adi].[GetMbrNpiAndTin_AetnaMA] @LoadDate,0,@ClientKey 

    MERGE ast.MbrStg2_PhoneAddEmail trg
    USING( --- DECLARE @AdiTableName char(1) = 'p' DECLARE @ClientKey INT = 0 DECLARE @adiLoadDate DATE = '2021-09-01'
		SELECT DISTINCT mf.ClientMemberKey, m.SrcFileName, mf.LoadDate, m.DataDate
	   	       , @AdiTableName AS adiTableName, mf.adiKey AS adiKey, adw.AceCleanPhoneNumber(m.Member_PhoneNUm) AS PhoneNumber
	   	       , [pt].lstPhoneTypeKey, [at].lstAddressTypeKey
	   	       , m.Member_Address_Line1, m.Member_Address_Line2, m.Member_City, m.Member_State
	   	       , m.Member_County_code  , m.Member_Zipcode  , 'Loaded' AS stgRowStatus, c.ClientKey    
	   	   FROM adi.mbrAetMaTx m
	   	       JOIN lst.List_Client c ON c.ClientKey = @ClientKey
	   	       JOIN (SELECT t.ClientMemberKey, t.EffectiveMonth, t.CurrentLoadingEffectiveMonth, t.adiKey, t.adiTableName, t.LoadDate
	   	   		  FROM adi.tvf_MbrAetMaTx_GetCurrentMembers(@adiLoadDate) t
	   	   		  ) mf ON m.mbrAetMaTxKey = mf.AdiKey    
	   	       /* add this join to make mbrs and Phone match in stg */
	   	        LEFT JOIN (	SELECT		ClientKey, TargetSystem, SourceValue,ExpirationDate
								,EffectiveDate,TargetValue
					FROM		lst.lstPlanMapping
					WHERE		ClientKey = 3
					AND			Active = 'Y'
					AND			TargetSystem = 'ACDW') PlanProduct  
		  	  ON m.[Line_of_Business] = PlanProduct.SourceValue  
	   	   		  --ON m.[Line_of_Business] = PlanProduct.SourceValue 
	   	   			 --AND PlanProduct.ClientKey = @ClientKey
	   	   			 --AND PlanProduct.TargetSystem = 'ACDW'
	   	   			 --AND @adiLoadDate BETWEEN PlanProduct.EffectiveDate and PlanProduct.ExpirationDate	        
	   	       --JOIN lst.lstPlanMapping SubPlanName
	   	   		  --ON PlanProduct.TargetValue = SubPlanName.SourceValue
	   	   			 --AND SubPlanName.ClientKey = @ClientKey
	   	   			 --AND SubPlanName.TargetSystem = 'ACDW'
	   	   			 --AND @adiLoadDate BETWEEN SubPlanName.EffectiveDate and SubPlanName.ExpirationDate	        
	   	       JOIN (SELECT pt.lstPhoneTypeKey
	   	   		  FROM lst.lstPhoneType pt
	   	   		  WHERE pt.PhoneTypeCode = 'H') pt ON 1 = 1
	   	       JOIN (SELECT pt.lstAddressTypeKey
	   	   		  FROM lst.lstAddressType pt
	   	   		  WHERE pt.AddressTypeCode = 'H') [at] ON 1 = 1
	   	       /* Checking for NPIs */
	   	       LEFT JOIN (SELECT pr.AttribTIN, pr.NPI
		  				FROM #Prr PR
								 
					 ) VP
	   	   	   ON m.[Attributed_Provider_NPI_Number] = vp.NPI	   
		  ) src
    ON trg.ClientMemberKey = src.ClientMemberKey
	   AND trg.ClientKey = src.ClientKey	   
	   AND trg.adiKey = src.adiKey -- added this to make sure it only adds the row 1 time becuause it does it by ADIKEY
    WHEN NOT MATCHED THEN 
	   INSERT ([ClientMemberKey],[SrcFileName],[LoadDate],[DataDate]
			 ,[AdiTableName],[AdiKey],[PhoneNumber], lstPhoneTypeKey, lstAddressTypeKey
			 ,AddAddress1, [AddAddress2], [AddCity],[AddState]
			 ,[AddCounty], [AddZip], stgRowStatus, clientKey)
	   VALUES (src.ClientMemberKey, src.SrcFileName , src.LoadDate, src.DataDate
	   	       , src.adiTableName, src.adiKey, src.PhoneNumber
	   	       , src.lstPhoneTypeKey, src.lstAddressTypeKey
	   	       , src.Member_Address_Line1, src.Member_Address_Line2, src.Member_City, src.Member_State
	   	       , src.Member_County_code  , src.Member_Zipcode  , src.stgRowStatus, src.ClientKey
			  )
    WHEN MATCHED THEN UPDATE
	   SET  trg.[SrcFileName]	= src.SrcFileName 
		  ,trg.[DataDate]		= src.DataDate
		  ,trg.[AdiTableName]	= src.adiTableName
		  ,trg.[AdiKey]		= src.adiKey
		  ,trg.[PhoneNumber]	= src.PhoneNumber
		  ,trg.lstPhoneTypeKey	= src.lstPhoneTypeKey
		  ,trg.lstAddressTypeKey	= src.lstAddressTypeKey
		  ,trg.AddAddress1		= src.Member_Address_Line1
		  ,trg.[AddAddress2]	= src.Member_Address_Line2
		  ,trg.[AddCity]		= src.Member_City
		  ,trg.[AddState]		= src.Member_State
		  ,trg.[AddCounty]		= src.Member_County_code  
		  ,trg.[AddZip]		= src.Member_Zipcode  
		  ,trg.stgRowStatus		= src.stgRowStatus
     OUTPUT $Action, Inserted.mbrStg2_PhoneAddEmailUrn INTO @OutputTbl
    ;
	       
    SELECT @InsertCount = COUNT(ID) 
    FROM @OutputTbl;
