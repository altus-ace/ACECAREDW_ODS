CREATE PROCEDURE [ast].[MbrPst2MbrCignaMaTxMbrPhnAdd]
  (@DataDate DATE   
    , @InsertCount INT OUTPUT)
AS	

    DECLARE @adiDataDate DATE = @DataDate;
    DECLARE @AdiTableName VARCHAR(50) = 'MbrAetMaTx';
    DECLARE @ClientKey INT = 12;
    DECLARE @stgRowStatus VARCHAR(20) = 'Loaded'
    DECLARE @OutputTbl TABLE (ActionType VARCHAR(50), ID INT);  

    MERGE ast.MbrStg2_PhoneAddEmail trg
    USING(SELECT 
				/* 'default' identity			as mbrStg2_PhoneAddEmailUrn */
					adiData.memberid				    AS ClientMemberKey		--ClientMemberKey
				, adidata.SrcFileName				    AS SrcFileName 			--SrcFileName, 	
				,'P'								    AS LoadType				--LoadType		
				,adiData.LoadDate	 					AS LoadDate 			-- LoadDate 	
				,adiData.DataDate 					    AS DataDate 		 	-- DataDate 	
				,'tmp_CignaMAMembership'				    AS AdiTableName 	 	-- AdiTableName 
				,adiData.MbrKey					    AS AdiKey 		 		-- AdiKey 		 
				,@stgRowStatus						    AS stgRowStatus 		-- stgRowStatus 
				,PhoneType.lstPhoneTypeKey			    AS lstPhoneTypeKey 		-- lstPhoneTypeKey
				,adiData.homephone					    AS PhoneNumber 	 		-- PhoneNumber 	 
				,PhoneCarrier.lstPhoneCarrierTypeKey	    AS PhoneCarrierType		-- PhoneCarrierTyp
				,0								    AS PhoneIsPrimary 		-- PhoneIsPrimary 
				,AddressType.lstAddressTypeKey 		    AS lstAddressTypeKey		-- lstAddressTypeK
				,adiData.AddressLine1				    AS AddAddress1 	 		-- AddAddress1 	 
				,adiData.addressline2				    AS AddAddress2 	 		-- AddAddress2 	 
				,adiData.city						    AS AddCity 		 	-- AddCity 	
				,adiData.[state] 					    AS AddState 		 	-- AddState 	
				,adiData.zip 						    AS AddZip 		 		-- AddZip 		 
				,adiData.County 					    AS AddCounty 		 	-- AddCounty 	
				,''								    AS lstEmailTypeKey		-- lstEmailTypeKey
				,''								    AS EmailAddress			-- EmailAddress 
				,''								    AS EmailIsPrimary		-- EmailIsPrimary 
				,getDate()						    AS CreateDate 	 		-- CreateDate 	 
				,System_User						    AS CreateBy 		 	-- CreateBy 	
				,NULL							    AS mbrEmailKey			-- mbrEmailKey	
				,Client.ClientKey					    -- Client.ClientKey		-- Client.ClientKe
				,ROW_NUMBER() OVER(PARTITION BY adiData.MEMBERID ORDER BY adiData.dataDate DESC) aRowNumber  
		FROM (SELECT ROW_NUMBER() OVER(PARTITION BY adi.memberID ORDER BY adi.datadate DESC) aRowNumber, 
				REPLACE(adi.memberid,'*', '') AS memberid, adi.effectivedate, 
				adi.AddressLine1, adi.addressline2, adi.city, adi.[state], adi.zip, adi.homephone,        
				adi.NPID, adi.County, adi.SrcFileName, adi.MbrKey, adi.DataDate, adi.FileDate, adi.MbrLoadStatus
				,adi.LoadDate
			 FROM ACDW_CLMS_CIGNA_MA.adi.tmp_CignaMAMembership adi
			  WHERE adi.DataDate = @DataDate ---Have to select the latest DataDate
			  AND	adi.MbrLoadStatus = 0				
			 ) adiData 			 
		    JOIN lst.List_Client Client		
			 ON Client.ClientKey = @ClientKey
		    JOIN ast.MbrStg2_MbrData AstData	
			 ON adiData.MbrKey = AstData.AdiKey -- filters for mbrs who have been staged.
				AND astData.clientKey = Client.ClientKey		    
		    LEFT JOIN lst.lstPhoneType		PhoneType		 ON PhoneType.PhoneTypeCode  = 'H'
		    LEFT JOIN lst.lstPhoneCarrierType	PhoneCarrier	 ON PhoneCarrier.PhoneCarrierTypeCode = 'NK'
		    LEFT JOIN lst.lstAddressType	     AddressType	 ON AddressType.AddressTypeCode = 'H'
		WHERE adiData.aRowNumber = 1    
	) src
    ON trg.ClientMemberKey = src.ClientMemberKey
	   AND trg.ClientKey = src.ClientKey
	   AND trg.LoadDate = src.LoadDate
	   AND src.aRowNumber = 1
    WHEN NOT MATCHED THEN 
	   INSERT (ClientMemberKey,SrcFileName,LoadType
				,LoadDate ,DataDate ,AdiTableName,AdiKey 
				,stgRowStatus ,lstPhoneTypeKey ,PhoneNumber ,PhoneCarrierType
				,PhoneIsPrimary ,lstAddressTypeKey,AddAddress1 ,AddAddress2 	 	
				,AddCity ,AddState ,AddZip ,AddCounty 
				,lstEmailTypeKey	,EmailAddress ,EmailIsPrimary 
				,CreateDate ,CreateBy ,mbrEmailKey,ClientKey		   
			 )
	   VALUES (src.ClientMemberKey,src.SrcFileName,src.LoadType
				,src.LoadDate ,src.DataDate ,src.AdiTableName,src.AdiKey 
				,src.stgRowStatus ,src.lstPhoneTypeKey ,src.PhoneNumber ,src.PhoneCarrierType
				,src.PhoneIsPrimary ,src.lstAddressTypeKey,src.AddAddress1 ,src.AddAddress2 	 	
				,src.AddCity ,src.AddState ,src.AddZip ,src.AddCounty 
				,src.lstEmailTypeKey,src.EmailAddress ,src.EmailIsPrimary 
				,src.CreateDate ,src.CreateBy ,src.mbrEmailKey,src.ClientKey	
			  )
    WHEN MATCHED THEN UPDATE
	   SET  trg.[SrcFileName]		= src.SrcFileName 
		  ,trg.[DataDate]			= src.DataDate
		  ,trg.[AdiTableName]		= src.adiTableName
		  ,trg.[AdiKey]			= src.adiKey
		  ,trg.[PhoneNumber]		= src.PhoneNumber
		  ,trg.lstPhoneTypeKey		= src.lstPhoneTypeKey
		  ,trg.lstAddressTypeKey		= src.lstAddressTypeKey
		  ,trg.AddAddress1			= src.AddAddress1
		  ,trg.AddAddress2	  		= src.AddAddress2
		  ,trg.AddCity	   			= src.AddCity
		  ,trg.AddState	  		= src.AddState
		  ,trg.AddCounty	  		= src.AddCounty  
		  ,trg.AddZip	   		  	= src.AddZip  
		  ,trg.stgRowStatus			= src.stgRowStatus
     OUTPUT $Action, Inserted.mbrStg2_PhoneAddEmailUrn INTO @OutputTbl
    ;
	       
    SELECT @InsertCount = COUNT(ID) 
    FROM @OutputTbl;
