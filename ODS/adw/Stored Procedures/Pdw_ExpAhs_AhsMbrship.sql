--exec [adw].[Pdw_ExpAhs_AhsMbrship] 2 SELECT * FROM [adw].[AhsExpMembership]
CREATE PROCEDURE [adw].[Pdw_ExpAhs_AhsMbrship](@ClientKey INT)
AS 

	--DECLARE @OutputTbl TABLE (ID INT); 
	DECLARE @LoadDate Date = GETDATE() ;   
	DECLARE @AuditID INT 
    DECLARE @AuditStatus SmallInt= 1 -- 1 in process , 2 Completed
    DECLARE @JobType SmallInt     ;
    DECLARE @JobStatus tinyInt = 1	;
    DECLARE @JobName VARCHAR(200) ;
    DECLARE @ActionStartTime DATETIME = getdate();
    DECLARE @ActionStopTime DATETIME = getdate()
    DECLARE @InputSourceName VARCHAR(200) = 'No Name given';	   
    DECLARE @DestinationName VARCHAR(200) = 'No Name given';	   
    DECLARE @ErrorName VARCHAR(200)	  = 'No Name given';	   
    DECLARE @SourceCount int = 0;         
    DECLARE @DestinationCount int = 0;    
    DECLARE @ErrorCount int = 0;    
        
    SET @JobType				 = 9	   -- 9 ast load    
    SET @JobName				 = 'Pdw_ExpAhs_AhsMbrByPcp'
	SELECT @InputSourceName		 = DB_NAME() +  ' dbo.vw_Exp_AH_MemberPCP_dev'    
	SELECT @DestinationName		 = DB_NAME() + '.[adw].[AhsExpMemberByPcp]';    
	SELECT @ErrorName			 = DB_NAME() + '.[adw].[AhsExpMemberByPcp]';    
    
    EXEC AceMetaData.amd.sp_AceEtlAudit_Open   
	        
	     @AuditID = @AuditID OUTPUT          
	   , @AuditStatus = @AuditStatus          
	   , @JobType = @JobType          
	   , @ClientKey = @ClientKey          
	   , @JobName = @JobName          
	   , @ActionStartTime = @ActionStartTime          
	   , @InputSourceName = @InputSourceName          
	   , @DestinationName = @DestinationName          
	   , @ErrorName = @ErrorName          ;    


	     
	   BEGIN TRAN      
	   INSERT INTO adw.AhsExpMembership
	   (
			 [ClientMemberKey]							
			,[ClientKey]								
			,[fctMembershipKey]							
			,[Exp_MEMBER_ID]							
			,[Exp_CLIENT_ID]							
			,[Exp_MEDICAID_ID]							
			,[Exp_MEMBER_FIRST_NAME]					
			,[Exp_MEMBER_MI]							
			,[Exp_MEMBER_LAST_NAME]						
			,[Exp_DATE_OF_BIRTH]						
			,[Exp_MEMBER_GENDER]						
			,[Exp_HOME_ADDRESS]							
			,[Exp_HOME_CITY]							
			,[Exp_HOME_STATE]							
			,[Exp_HOME_ZIPCODE]							
			,[Exp_MAILING_ADDRESS]						
			,[Exp_MAILING_CITY]							
			,[Exp_MAILING_STATE]						
			,[Exp_MAILING_ZIP]							
			,[Exp_HOME_PHONE]							
			,[Exp_ADDITIONAL_PHONE]						
			,[Exp_CELL_PHONE]							
			,[Exp_Language]								
			,[Exp_Ethnicity]							
			,[Exp_Race]									
			,[Exp_Email]								
			,[Exp_MEDICARE_ID]							
			,[Exp_MEMBER_ORG_EFF_DATE]					
			,[Exp_MEMBER_CONT_EFF_DATE]					
			,[Exp_MEMBER_CUR_EFF_DATE]					
			,[Exp_MEMBER_CUR_TERM_DATE]					
			,[Exp_RESP_FIRST_NAME]						
			,[Exp_RESP_LAST_NAME]						
			,[Exp_RESP_RELATIONSHIP]					
			,[Exp_RESP_ADDRESS]							
			,[Exp_RESP_ADDRESS2]						
			,[Exp_RESP_CITY]							
			,[Exp_RESP_STATE]							
			,[Exp_RESP_ZIP]								
			,[Exp_RESP_PHONE]							
			,[Exp_PRIMARY_RISK_FACTOR]					
			,[Exp_COUNT_OPEN_CARE_OPPS]					
			,[Exp_INP_ADMITS_LAST_12_MOS]				
			,[Exp_LAST_INP_DISCHARGE]					
			,[Exp_POST_DISCHARGE_FUP_VISIT]				
			,[Exp_INP_FUP_WITHIN_7_DAYS]				
			,[Exp_ER_VISITS_LAST_12_MOS]				
			,[Exp_LAST_ER_VISIT]						
			,[Exp_POST_ER_FUP_VISIT]					
			,[Exp_ER_FUP_WITHIN_7_DAYS]					
			,[Exp_LAST_PCP_VISIT]						
			,[Exp_LAST_PCP_PRACTICE_SEEN]				
			,[Exp_LAST_BH_VISIT]						
			,[Exp_LAST_BH_PRACTICE_SEEN]				
			,[Exp_TOTAL_COSTS_LAST_12_MOS]				
			,[Exp_INP_COSTS_LAST_12_MOS]				
			,[Exp_ER_COSTS_LAST_12_MOS]					
			,[Exp_OUTP_COSTS_LAST_12_MOS]				
			,[Exp_PHARMACY_COSTS_LAST_12_MOS]			
			,[Exp_PRIMARY_CARE_COSTS_LAST_12_MOS]		
			,[Exp_BEHAVIORAL_COSTS_LAST_12_MOS]			
			,[Exp_OTHER_OFFICE_COSTS_LAST_12_MOS]		
			,[Exp_NEXT_PREVENTATIVE_VISIT_DUE]			
			,[Exp_ACE_ID]								
			,[Exp_carrier_Member_ID]					
			,[LoadDate]									
	   )
	 --declare @clientKey int = 3
	 --declare @LoadDate date = getdate();
	 SELECT  -- ACECAREDW  members
       m.MEMBER_ID AS Member_ID
	   , l.ClientKey AS CLIENTKEY     
	 , m.fctMembershipKey AS FctMemberKey
	 , m.MEMBER_ID AS exp_Mbrkey
	 , l.CS_Export_LobName as CLIENT_ID
     , m.MEDICAID_ID AS MEDICAID_ID
     , m.MEMBER_FIRST_NAME AS MEMBER_FIRST_NAME
     , m.MEMBER_MI AS MEMBER_MI
     , m.MEMBER_LAST_NAME AS MEMBER_LAST_NAME
     , m.DATE_OF_BIRTH AS DATE_OF_BIRTH
     , m.MEMBER_GENDER AS MEMBER_GENDER
     , m.HOME_ADDRESS AS HOME_ADDRESS
     , m.HOME_CITY AS HOME_CITY
     , m.HOME_STATE AS HOME_STATE
     , m.HOME_ZIPCODE AS HOME_ZIPCODE
     , m.MAILING_ADDRESS AS MAILING_ADDRESS
     , m.MAILING_CITY AS MAILING_CITY
     , m.MAILING_STATE AS MAILING_STATE
     , m.MAILING_ZIP AS MAILING_ZIP
     , m.HOME_PHONE AS HOME_PHONE
     , m.ADDITIONAL_PHONE AS ADDITIONAL_PHONE
     , m.CELL_PHONE AS CELL_PHONE
     , m.Language AS Language
     , m.Ethnicity AS Ethnicity
	 , m.Race AS Race
	 , m.Email AS Email
     , m.MEDICARE_ID AS MEDICARE_ID
     , CASE WHEN (m.MEMBER_ORG_EFF_DATE = '00/00/0000') THEN NULL ELSE m.MEMBER_ORG_EFF_DATE END AS MEMBER_ORG_EFF_DATE
     , CASE WHEN (m.MEMBER_CONT_EFF_DATE = '00/00/0000') THEN NULL ELSE m.MEMBER_CONT_EFF_DATE END  AS MEMBER_CONT_EFF_DATE
     , CASE WHEN (m.MEMBER_CUR_EFF_DATE = '00/00/0000') THEN NULL ELSE m.MEMBER_CUR_EFF_DATE END   AS MEMBER_CUR_EFF_DATE
     , CASE WHEN (m.MEMBER_CUR_TERM_DATE = '00/00/0000') THEN NULL ELSE m.MEMBER_CUR_TERM_DATE END  AS MEMBER_CUR_TERM_DATE
     , m.RESP_FIRST_NAME AS RESP_FIRST_NAME
     , m.RESP_LAST_NAME AS RESP_LAST_NAME
     , m.RESP_RELATIONSHIP AS RESP_RELATIONSHIP
     , m.RESP_ADDRESS AS RESP_ADDRESS
     , m.RESP_ADDRESS2 AS RESP_ADDRESS2
     , m.RESP_CITY AS RESP_CITY
     , m.RESP_STATE AS RESP_STATE
     , m.RESP_ZIP AS RESP_ZIP
     , m.RESP_PHONE AS RESP_PHONE
     , m.PRIMARY_RISK_FACTOR AS PRIMARY_RISK_FACTOR
     , m.COUNT_OPEN_CARE_OPPS AS COUNT_OPEN_CARE_OPPS
     , m.INP_ADMITS_LAST_12_MOS AS INP_ADMITS_LAST_12_MOS
     , m.LAST_INP_DISCHARGE AS LAST_INP_DISCHARGE
     , m.POST_DISCHARGE_FUP_VISIT AS POST_DISCHARGE_FUP_VISIT
     , m.INP_FUP_WITHIN_7_DAYS AS INP_FUP_WITHIN_7_DAYS
     , m.ER_VISITS_LAST_12_MOS AS ER_VISITS_LAST_12_MOS
     , CASE WHEN (m.LAST_ER_VISIT = '00/00/0000') THEN NULL ELSE m.LAST_ER_VISIT END  AS LAST_ER_VISIT
     , m.POST_ER_FUP_VISIT AS POST_ER_FUP_VISIT
     , m.ER_FUP_WITHIN_7_DAYS AS ER_FUP_WITHIN_7_DAYS
     , CASE WHEN (m.LAST_PCP_VISIT = '00/00/0000') THEN NULL ELSE m.LAST_PCP_VISIT END AS LAST_PCP_VISIT
     , m.LAST_PCP_PRACTICE_SEEN AS LAST_PCP_PRACTICE_SEEN
     , CASE WHEN (m.LAST_BH_VISIT = '00/00/0000') THEN NULL ELSE m.LAST_BH_VISIT END  AS LAST_BH_VISIT
     , m.LAST_BH_PRACTICE_SEEN AS LAST_BH_PRACTICE_SEEN
     , m.TOTAL_COSTS_LAST_12_MOS AS TOTAL_COSTS_LAST_12_MOS
     , m.INP_COSTS_LAST_12_MOS AS INP_COSTS_LAST_12_MOS
     , m.ER_COSTS_LAST_12_MOS AS ER_COSTS_LAST_12_MOS
     , m.OUTP_COSTS_LAST_12_MOS AS OUTP_COSTS_LAST_12_MOS
     , m.PHARMACY_COSTS_LAST_12_MOS AS PHARMACY_COSTS_LAST_12_MOS
     , m.PRIMARY_CARE_COSTS_LAST_12_MOS AS PRIMARY_CARE_COSTS_LAST_12_MOS
     , m.BEHAVIORAL_COSTS_LAST_12_MOS AS BEHAVIORAL_COSTS_LAST_12_MOS
     , m.OTHER_OFFICE_COSTS_LAST_12_MOS AS OTHER_OFFICE_COSTS_LAST_12_MOS
     , CASE WHEN (m.NEXT_PREVENTATIVE_VISIT_DUE = '00/00/0000') THEN NULL ELSE m.NEXT_PREVENTATIVE_VISIT_DUE END  AS NEXT_PREVENTATIVE_VISIT_DUE
    , ACE_ID  
    , m.carrier_Member_ID 
    , GETDATE() LOADDATE
	FROM ACECAREDW.dbo.vw_AH_WC_Membership m
		join lst.List_Client l ON m.CLIENT_ID = l.CS_Export_LobName
		LEFT JOIN adw.AhsExpMemberByPcp Adw  
				ON CONVERT(NVARCHAR(255), RTRIM(m.[MEMBER_ID]))= adw.ClientMemberKey					
					and @LoadDate  = adw.LoadDate
	WHERE l.ClientKey=@ClientKey
		and adw.AhsExpMemberByPcpKey is null
	   ;
	   COMMIT TRAN; 
	   
    
    EXEC AceMetaData.amd.sp_AceEtlAudit_Close           
	   @AuditId = @AuditID          
	   , @ActionStopTime = @ActionStopTime          
	   , @SourceCount = @SourceCount              
	   , @DestinationCount = @DestinationCount          
	   , @ErrorCount = @ErrorCount          
	   , @JobStatus = @JobStatus      
	   ;         
     
        
	   BEGIN TRAN      
	   
	   UPDATE adiData      
		  SET adiData.Exported = 1           	   
	   FROM adw.AhsExpMembership adiData         
	   WHERE adidata.Exported = 0
	   COMMIT TRAN  ;    
       
  
