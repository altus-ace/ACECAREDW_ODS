CREATE Procedure dbo.Get_SjmcAllAdmitsUhc
AS
BEGIN
    /* set up tmp tables */
    IF OBJECT_ID('tempdb..#tmpClaims') IS NOT NULL DROP TABLE #tmpClaims;
    IF OBJECT_ID('tempdb..#tmpGHH') IS NOT NULL DROP TABLE #tmpGHH;


    /* Load tmp tables */
        SELECT DISTINCT 
               'UHC' AS Client, 
               subscriber_id AS Member_id, 
               CASE WHEN (det.REVENUE_CODE IN ('450', '451','452','459')) THEN 'EMERGENCY'
				ELSE CATEGORY_OF_SVC END AS CategoryOfSvc, 
               VEND_FULL_NAME AS VendorName, 
               b.pcp_practice_name AS PracticeName, 
               1 AS IP_Visits, 
               PRIMARY_SVC_DATE AS VisitDate, 
               ICD_PRIM_DIAG AS Prim_diag_code, 
               'UHC_Claims' AS Src
        INTO #tmpClaims	   
        FROM ACECAREDW_TEST.dbo.claims_headers a
		  JOIN (SELECT det.seq_claim_ID, det.LINE_NUMBER, det.REVENUE_CODE 
				FROM ACECAREDW_TEST.dbo.Claims_Details Det 
				    JOIN (SELECT seq.seq_claim_ID, MIN(seq.LINE_NUMBER) LINE_NUMBER
						  FROM ACECAREDW_TEST.dbo.Claims_Details seq
						  GROUP BY seq.SEQ_CLAIM_ID) SEQ
						  ON det.SEQ_CLAIM_ID = seq.SEQ_CLAIM_ID
						  and det.LINE_NUMBER = seq.LINE_NUMBER
						  ) det
			 ON a.SEQ_CLAIM_ID = det.SEQ_CLAIM_ID     
             JOIN(
            SELECT DISTINCT 
                   UHC_SUBSCRIBER_ID, 
                   PCP_PRACTICE_NAME
            FROM ACECAREDW.dbo.Uhc_MembersbyPCP b
            WHERE YEAR(a_last_update_date) = 2020
            ) b ON b.uhc_subscriber_id = a.subscriber_id
        WHERE CATEGORY_OF_SVC IN('INPATIENT', 'OUTPATIENT')
             AND VEND_FULL_NAME IN('TEXAS CHILDREN''S HOSPITAL', 'WOMANS HOSPITAL OF TEXAS LP', 'ST JOSEPH MEDICAL CENTER LLC', 'PARK PLAZA HOSPITAL', 'HARRIS COUNTY HOSPITAL DISTRICT', 'ST LUKES MEDICAL CENTER', 'CHI ST LUKES BAYLOR COL', 'MEMORIAL MEDICAL CENTER', 'MHHS HERMANN HOSPITAL', 'MEMORIAL HERMANN MEDICAL GROUP', 'METHODIST HOSPITAL', 'BEN TAUB HOSPITAL', 'ST JOSEPH MEDICAL CENTER', 'ST JOSEPH MEDICAL CENTER LLC', 'ST JOSEPH REGIONAL HEALTH CENTER', 'ST JOSEPHS HOSP & MEDICAL CTR', 'ST JOSEPHS HOSPITAL INC')
        AND YEAR(PRIMARY_SVC_DATE) >= 2018;
        
        
        
        
        SELECT 'UHC' AS Client, 
               ClientMemberKey AS Member_id, 
               NtfPatientType AS CategoryOfSvc, 
               AdmitHospital AS VendorName, 
               ' ' AS PracticeName, 
               1 AS IP_Visits, 
               AdmitDateTime AS VisitDate, 	  
               DiagnosisCode AS Prim_diag_code, 
               'GHH' AS Src
        INTO #tmpGHH
        FROM (SELECT DISTINCT n.ClientMemberKey, n.NtfPatientType, n.AdmitDateTime, n.AdmitHospital, n.ntfEventType  , DiagnosisCode
        	   , ROW_NUMBER() OVER (PARTITION BY n.ClientMemberKey, n.NtfPatientType, n.AdmitDateTime, n.AdmitHospital, n.ntfEventType  ORDER BY CreatedDate) arn
            FROM [adw].[NtfNotification] n
            WHERE n.clientKey = 1) N
             JOIN(
            SELECT DISTINCT 
                   UHC_SUBSCRIBER_ID, 
                   PCP_PRACTICE_NAME
            FROM ACECAREDW.dbo.Uhc_MembersbyPCP b
            WHERE YEAR(a_last_update_date) = 2020
            ) b ON b.uhc_subscriber_id = n.ClientMemberKey
        WHERE n.arn =1 and YEAR(AdmitDateTime) IN(2018, 2019, 2020)
             AND AdmitHospital IN('TEXAS CHILDREN''S HOSPITAL', 'WOMANS HOSPITAL OF TEXAS LP', 'ST JOSEPH MEDICAL CENTER LLC'
        	   , 'PARK PLAZA HOSPITAL', 'HARRIS COUNTY HOSPITAL DISTRICT', 'ST LUKES MEDICAL CENTER', 'CHI ST LUKES BAYLOR COL'
        	   , 'MEMORIAL MEDICAL CENTER', 'MHHS HERMANN HOSPITAL', 'MEMORIAL HERMANN MEDICAL GROUP', 'METHODIST HOSPITAL', 'BEN TAUB HOSPITAL'
        	   , 'ST JOSEPH MEDICAL CENTER', 'ST JOSEPH MEDICAL CENTER LLC', 'ST JOSEPH REGIONAL HEALTH CENTER', 'ST JOSEPHS HOSP & MEDICAL CTR', 'ST JOSEPHS HOSPITAL INC')
    	
    
    SELECT visits.*
	   , mbr.MEMBER_LAST_NAME
	   , mbr.MEMBER_FIRST_NAME
	   , MBR.UHC_SUBSCRIBER_ID, 
	   MBR.[MEMBER_HOME_ADDRESS], 
	   MBR.[MEMBER_HOME_ADDRESS2], 
	   MBR.[MEMBER_HOME_CITY], 
	   MBR.[MEMBER_HOME_STATE], 
	   MBR.[MEMBER_HOME_ZIP], 
	   MBR.[MEMBER_HOME_PHONE], 
	   MBR.[MEMBER_MAIL_ADDRESS], 
	   MBR.[MEMBER_MAIL_ADDRESS2], 
	   MBR.[MEMBER_MAIL_CITY], 
	   MBR.[MEMBER_MAIL_STATE], 
	   MBR.[MEMBER_MAIL_ZIP], 
	   MBR.[MEMBER_MAIL_PHONE], 
	   MBR.[MEMBER_COUNTY_CODE], 
	   MBR.[MEMBER_COUNTY], 
	   MBR.[PCP_FIRST_NAME], 
	   MBR.[PCP_LAST_NAME], 
	   MBR.[PCP_NPI], 
	   MBR.[PCP_PHONE], 
	   MBR.[PCP_ADDRESS], 
	   MBR.[PCP_ADDRESS2], 
	   MBR.[PCP_CITY], 
	   MBR.[PCP_STATE], 
	   MBR.[PCP_ZIP], 
	   MBR.[PCP_COUNTY], 
	   MBR.[PCP_PRACTICE_TIN], 
	   MBR.[PCP_PRACTICE_NAME]
    /* get result */
    FROM (SELECT *
    	   FROM #tmpClaims
    	   UNION
    	   SELECT tghh.*  
    	   FROM #tmpGHH Tghh
    	   ) Visits
        JOIN dbo.Uhc_MembersByPcp mbr
    	   ON visits.Member_id = mbr.UHC_SUBSCRIBER_ID 
    		  and MONTH(visits.VisitDate) = MONTH(mbr.A_LAST_UPDATE_Date)
    		  and YEAR(visits.VisitDate) = YEAR(mbr.A_LAST_UPDATE_Date)    
    ;
END;