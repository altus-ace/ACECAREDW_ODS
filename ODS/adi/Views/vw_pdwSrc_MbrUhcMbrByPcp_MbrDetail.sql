
CREATE VIEW [adi].[vw_pdwSrc_MbrUhcMbrByPcp_MbrDetail]
AS
     SELECT m.mbrMbrByPcpKey 
		,m.UHC_SUBSCRIBER_ID 		  		 
		,m.mbrFName 
		,m.mbrMName 
		,m.mbrLName 
		,m.GENDER 
		,m.DATE_OF_BIRTH 		  
		,m.MEDICARE_ID 
		,m.MEDICAID_ID 
		,'' AS SSN
		,'' AS HICN
		,'' AS MBI
		,m.ETHNICITY AS EthnicityCode
		,m.ETHNICITY_DESC 
		,'' Race 
		,m.LANG_CODE as PrimaryLanguage 
		,m.PCP_NPI 
		,m.PCP_PRACTICE_TIN 
		,m.PCP_GROUP_ID 
		,m.AUTO_ASSIGN 
		,m.PCP_EFFECTIVE_DATE 
		,m.PCP_TERM_DATE 
		,m.PLAN_ID             
		,m.SUBGRP_ID 
		,m.SUBGRP_NAME 
		,m.DUAL_COV_FLAG 
		,m.MEMBER_CUR_EFF_DATE 
		,'' AS MEMBER_CUR_TERM_DATE
		,'' AS RELATIONSHIP_CODE 
		,m.RESP_LAST_NAME
		,m.RESP_FIRST_NAME
		,m.RESP_ADDRESS
		,m.RESP_ADDRESS2
		,m.RESP_CITY
		,m.RESP_STATE
		,m.RESP_ZIP
		,m.RESP_PHONE
		,lc.ClientKey
		,m.SourceFileName 
		,'adi.MbrUhcMbrByPcp' as AdiTableName
		,m.mbrMbrByPcpKey AS AdiKey		
		,m.LoadType 
		,m.LoadDate 
		,m.DataDate 
		,'Loaded' AS stgRowStatus		
     FROM adi.MbrUhcMbrByPcp m
		JOIN lst.List_Client lc ON 1 = lc.ClientKey
     WHERE m.MbrLoadStatus = 0		
