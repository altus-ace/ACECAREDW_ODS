CREATE PROCEDURE [ast].[MbrPst2MbrUhcTxMbrDetail]
    @loadDate DATE     
    , @InsertCount INT OUTPUT
AS	
    /* OBJECTIVE: Load data from Adi to Ast
	   1. get data from adi
	   2. add mapped values
    */    
    
    DECLARE @adiLoadDate DATE = @LoadDate;
    DECLARE @stgRowStatus VARCHAR(10) = 'Loaded';    

    DECLARE @OutputTbl TABLE (ActionType VARCHAR(50), ID INT);
    	
    MERGE ast.[MbrStg2_MbrData] trg
    USING (  SELECT mbr.[SUBSCRIBER_ID] AS ClientSUbscriberID, 1 AS ClientKey, 'P' AS MbrLoadType
	           ,mbr.[MEMB_LAST_NAME] ,mbr.[MEMB_FIRST_NAME], '' AS Memb_Middle_Name,mbr.[MEMB_GENDER],mbr.[DATE_OF_BIRTH]
	           ,mbr.[MEDICAID_NO],mbr.[MEDICARE_NO], '' HICN, ''PrvNpi, mbr.[IRS_TAX_ID] AS Pcp_Practice_Tin ,mbr.AUTO_ASSIGNED 			 
			 ,mbr.[PROV_EFF_DATE] ,mbr.[PROV_TERM_DATE]	 
			 , mbr.[MEMB_ETHNICITY],mbr.MEMB_LANGUAGE		
	           , mbr.LINE_OF_BUSINESS PlnProductPlan, PlanMapping.TargetValue AS plnProductSubPlan , '' plnSubPlanName, '01/01/1900' plnClientPlanEffective
	           ,mbr.[SrcFileName],'adi.mbrUhcMbrByProvider' AS adiTableName ,mbr.UHCMbrMbrByProviderKey AS adiKey	,mbr.LoadDate,mbr.datadate	   
	           ,@stgRowStatus AS stgRowStatus	, 'TX' AS MbrState		    
	       FROM adi.mbrUhcMbrByProvider mbr
	            /* convert to mapped/cleaned values */
	            LEFT JOIN lst.lstPlanMapping PlanMapping ON Mbr.PLAN_CODE = PlanMapping.SourceValue
				AND PlanMapping.ClientKey = 1
	               AND PlanMapping.TargetSystem = 'ACDW'
	               AND @adiLoadDate BETWEEN PlanMapping.EffectiveDate AND PlanMapping.ExpirationDate
	            /* get contracted tins so we can only load members who are associated to a contracted tin */
	            JOIN (SELECT pr.TIN
	       			 FROM dbo.vw_AllClient_ProviderRoster pr
	       			 WHERE pr.HealthPlan = 'UHC'
	       				AND pr.providerType IN('PCP')
	       				AND GETDATE() BETWEEN pr.EffectiveDate AND pr.ExpirationDate
	       			 GROUP BY pr.TIN
	       		  ) AS contractedTins
	           /* CONVERT TO INT to allow zero padded and non-zero padded values to compare properly */
	           ON TRY_CONVERT( INT, mbr.IRS_TAX_ID) = TRY_CONVERT(INT, contractedTins.TIN)
	       WHERE mbr.MbrLoadStatus = 0   
    	   )src
    ON trg.ClientKey = src.ClientKey
        AND trg.LoadDate = src.LoadDate
        AND trg.AdiKey = src.AdiKey
    WHEN NOT MATCHED THEN  
        INSERT 
        (ClientSubscriberId, ClientKey,LoadType
        		  ,mbrLastName,mbrFirstName,mbrMiddleName, mbrGENDER,mbrDob
        		  , mbrMEDICARE_ID, mbrMEDICAID_NO,HICN ,prvNPI ,prvTIN ,prvAutoAssign
        		  , prvClientEffective, prvClientExpiration    
			  , mbrEthnicity, mbrPrimaryLanguage
        		  , plnProductPlan, plnProductSubPlan ,plnProductSubPlanName ,plnClientPlanEffective
        		  ,SrcFileName,AdiTableName,AdiKey,LoadDate,DataDate, stgRowStatus, MbrState)
        VALUES (Src.ClientSubscriberId, src.ClientKey, src.MbrLoadType 
            , src.[MEMB_LAST_NAME], src.[MEMB_FIRST_NAME], src.Memb_Middle_Name, src.Memb_GEnder, src.DATE_OF_BIRTH
        	  , src.MEDICARE_NO, src.MEDICAID_NO, src.HICN, src.prvNPI, src.Pcp_Practice_Tin, src.AUTO_ASSIGNED
            , src.PROV_EFF_DATE, src.PROV_TERM_DATE
		  , src.Memb_ETHNICITY, src.MEMB_LANGUAGE
            , src.plnProductPlan, src.plnProductSubPlan, src.PlnSubPlanName, src.plnClientPlanEffective
        	  , src.srcFileName, src.adiTableName, src.AdiKey, src.LoadDate, src.DataDate, src.stgRowStatus, src.MbrState)
    /*WHEN MATCHED THEN  	  UPDATE set blah blah blah*/
    OUTPUT $Action, Inserted.mbrStg2_MbrDataUrn INTO @OutputTbl
    ;
           
    SELECT @InsertCount = COUNT(*) 
    FROM @OutputTbl;
 
