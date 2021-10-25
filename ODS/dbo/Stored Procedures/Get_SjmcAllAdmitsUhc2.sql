
CREATE Procedure dbo.Get_SjmcAllAdmitsUhc2
AS
BEGIN
    /* set up tmp tables */
    IF OBJECT_ID('tempdb..#tmpUhcClaims') IS NOT NULL DROP TABLE #tmpUhcClaims;
    IF OBJECT_ID('tempdb..#tmpNtf') IS NOT NULL DROP TABLE #tmpNtf;


    /* Load tmp tables */
        SELECT DISTINCT 
               'UHC' AS Client, 
               subscriber_id AS Member_id, 
               --CASE WHEN (det.REVENUE_CODE IN ('450', '451','452','459')) THEN 'EMERGENCY'
			--	ELSE 
			 CATEGORY_OF_SVC ,
			 --END AS CategoryOfSvc, 
               VEND_FULL_NAME AS VendorName, 
               b.pcp_practice_name AS PracticeName, 
               1 AS IP_Visits, 
               PRIMARY_SVC_DATE AS VisitDate, 
               ICD_PRIM_DIAG AS Prim_diag_code, 
               'UHC_Claims' AS Src
        INTO #tmpUhcClaims	   
        FROM ACECAREDW_TEST.dbo.claims_headers a
	--	  JOIN (SELECT det.seq_claim_ID, det.LINE_NUMBER, det.REVENUE_CODE 
	--			FROM ACECAREDW_TEST.dbo.Claims_Details Det 
	--			    JOIN (SELECT seq.seq_claim_ID, MIN(seq.LINE_NUMBER) LINE_NUMBER
	--					  FROM ACECAREDW_TEST.dbo.Claims_Details seq
	--					  GROUP BY seq.SEQ_CLAIM_ID) SEQ
	--					  ON det.SEQ_CLAIM_ID = seq.SEQ_CLAIM_ID
	--					  and det.LINE_NUMBER = seq.LINE_NUMBER
	--					  ) det
	--		 ON a.SEQ_CLAIM_ID = det.SEQ_CLAIM_ID     
             JOIN(SELECT DISTINCT 
				    UHC_SUBSCRIBER_ID, 
				    PCP_PRACTICE_NAME, 
				    MONTH(b.A_LAST_UPDATE_DATE) rowMonth,
				    Year(b.A_LAST_UPDATE_DATE) rowYear
			 FROM ACECAREDW.dbo.Uhc_MembersbyPCP b
			 WHERE YEAR(a_last_update_date) > 2018 
				and b.LoadType = 'P' 					  ) b 
			 ON b.uhc_subscriber_id = a.subscriber_id
				AND Year(a.PRIMARY_SVC_DATE) = b.rowYear
				AND Month(a.PRIMARY_SVC_DATE) = b.rowMonth
        WHERE a.CATEGORY_OF_SVC IN('INPATIENT')
             AND VEND_FULL_NAME IN(
			 --'TEXAS CHILDREN''S HOSPITAL', 'WOMANS HOSPITAL OF TEXAS LP', 'ST JOSEPH REGIONAL HEALTH CENTER', 
			 'ST JOSEPH MEDICAL CENTER LLC', 'ST JOSEPH MEDICAL CENTER', 'ST JOSEPH MEDICAL CENTER LLC', 'ST JOSEPHS HOSP & MEDICAL CTR', 'ST JOSEPHS HOSPITAL INC'
			 --, 'PARK PLAZA HOSPITAL', 'HARRIS COUNTY HOSPITAL DISTRICT', 'ST LUKES MEDICAL CENTER', 'CHI ST LUKES BAYLOR COL', 'MEMORIAL MEDICAL CENTER', 'MHHS HERMANN HOSPITAL', 'MEMORIAL HERMANN MEDICAL GROUP', 'METHODIST HOSPITAL', 'BEN TAUB HOSPITAL', 'ST JOSEPH MEDICAL CENTER', 'ST JOSEPH MEDICAL CENTER LLC', 'ST JOSEPH REGIONAL HEALTH CENTER', 'ST JOSEPHS HOSP & MEDICAL CTR', 'ST JOSEPHS HOSPITAL INC')
			 )
		  AND YEAR(a.PRIMARY_SVC_DATE) > 2018;
        
        
        
        
        SELECT 'UHC' AS Client, 
               ClientMemberKey AS Member_id, 
               NtfPatientType AS CategoryOfSvc, 
               AdmitHospital AS VendorName, 
               ' ' AS PracticeName, 
               1 AS IP_Visits, 
               AdmitDateTime AS VisitDate, 	                 
               'GHH' AS Src
        INTO #tmpNtf
        FROM (SELECT *, CASE WHEN (ntf.ActualDischargeDate IS NULL) AND (ntf.AdmitDateTime IS NULL) THEN 0
					   WHEN (ntf.ActualDischargeDate IS NULL) THEN ntf.AdmitDateTime
					   WHEN (ntf.AdmitDateTime IS NULL) THEN ntf.ActualDischargeDate
					   ELSE ntf.AdmitDateTime END AS CalcEventDate
			 FROM (SELECT DISTINCT n.ClientMemberKey, n.NtfPatientType, n.AdmitDateTime, n.ActualDischargeDate, n.AdmitHospital, n.ntfEventType  
        			    , ROW_NUMBER() OVER (PARTITION BY n.ClientMemberKey, n.NtfPatientType, n.AdmitDateTime, n.AdmitHospital, n.ntfEventType  ORDER BY CreatedDate) arn
				    FROM [adw].[NtfNotification] n
				    WHERE n.clientKey = 1 AND n.NtfPatientType= 'IP') Ntf
				    WHERE ntf.arn = 1 
				    ) N
                     JOIN(SELECT DISTINCT 
				    UHC_SUBSCRIBER_ID, 
				    PCP_PRACTICE_NAME, 
				    MONTH(b.A_LAST_UPDATE_DATE) rowMonth,
				    Year(b.A_LAST_UPDATE_DATE) rowYear			
			 FROM ACECAREDW.dbo.Uhc_MembersbyPCP b
			 WHERE 1 = 1
				AND YEAR(a_last_update_date) > 2018 
				and b.LoadType = 'P' 					  ) b 
			 ON b.uhc_subscriber_id = n.ClientMemberKey
				AND Year(N.AdmitDateTime) = b.rowYear
				AND Month(N.AdmitDateTime) = b.rowMonth
        WHERE N.CalcEventDate<> 0 AND YEAR(AdmitDateTime) IN(2019, 2020)
             AND AdmitHospital IN('ST JOSEPH MEDICAL CENTER LLC', 'ST JOSEPH MEDICAL CENTER', 'ST JOSEPH MEDICAL CENTER LLC', 'ST JOSEPHS HOSP & MEDICAL CTR', 'ST JOSEPHS HOSPITAL INC')

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
    FROM (SELECT n.Member_id, n. CategoryOfSvc, n.AdmDate, n.VendorName
		  FROM (SELECT ntf.Member_id, ntf.CategoryOfSvc,convert(date, ntf.VisitDate) AdmDate
			     , Case WHEN (ntf.VendorName = 'ST JOSEPH MEDICAL CENTER') THEN 'ST JOSEPH MEDICAL CENTER LLC' END AS VendorName
				FROM #tmpNtf ntf) n
				group by n.Member_id, n. CategoryOfSvc, n.AdmDate, n.VendorName
				having count(*) > 1

		  UNION
		  SELECT * 
		  FROM (SELECT c.Member_id, CASE WHEN (c.CATEGORY_OF_SVC = 'INPATIENT') THEN 'IP' ELSE c.CATEGORY_OF_SVC END as Category_Of_svc, c.VisitDate AdmDate, c.VendorName
				FROM #tmpUhcClaims c) s
		  GROUP BY s.Member_id, s.Category_Of_svc , s.AdmDate, s.VendorName
    	   ) Visits
        JOIN dbo.Uhc_MembersByPcp mbr
    	   ON visits.Member_id = mbr.UHC_SUBSCRIBER_ID  and mbr.LoadType = 'P'
    		  and MONTH(visits.AdmDate) = MONTH(mbr.A_LAST_UPDATE_Date)
    		  and YEAR(visits.admDate) = YEAR(mbr.A_LAST_UPDATE_Date)    
    ;

    /*

    Raw data union to remove dups
    SELECT n.Member_id, n. CategoryOfSvc, n.AdmDate, n.VendorName
    FROM (
    SELECT ntf.Member_id, ntf.CategoryOfSvc,convert(date, ntf.VisitDate) AdmDate
        , Case WHEN (ntf.VendorName = 'ST JOSEPH MEDICAL CENTER') THEN 'ST JOSEPH MEDICAL CENTER LLC' END AS VendorName
    FROM #tmpNtf ntf
    ) n
    group by n.Member_id, n. CategoryOfSvc, n.AdmDate, n.VendorName
    having count(*) > 1
    
    UNION
    SELECT * 
    FROM (
    SELECT c.Member_id, CASE WHEN (c.CATEGORY_OF_SVC = 'INPATIENT') THEN 'IP' ELSE c.CATEGORY_OF_SVC END as Category_Of_svc, c.VisitDate AdmDate, c.VendorName
    FROM #tmpUhcClaims c
    ) s
    GROUP BY s.Member_id, s.Category_Of_svc , s.AdmDate, s.VendorName


    */


END;


