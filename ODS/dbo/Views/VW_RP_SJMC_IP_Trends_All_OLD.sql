



CREATE VIEW [dbo].[VW_RP_SJMC_IP_Trends_All_OLD]
AS
    /* JK: OBJECTIVE: get claims and Ntf for all IP Admits, for the targetd list of facilities
	05/21/2021 JK: Added ICDCCS effective date and version
	 */
	
 
SELECT DISTINCT 
            'UHC' AS Client, 1 AS ClientKey,
             ClmHdr.subscriber_id as Member_id, 
             ClmHdr.VEND_FULL_NAME, 
             Mbrs.pcp_practice_name, Mbrs.MEMBER_FIRST_NAME, Mbrs.MEMBER_LAST_NAME,    
             COUNT(DISTINCT CONCAT (ClmHdr.subscriber_id, ClmHdr.PRIMARY_SVC_DATE)) AS IP_Visits,
             ClmHdr.PRIMARY_SVC_DATE AS VisitDate, 
             ClmHdr.ICD_PRIM_DIAG AS Prim_diag_code,
		     ClmHdr.DRG_CODE ,
             case when IcdCcs.MULTI_CCS_LVL1_LABEL is not null 
             then  first_value(IcdCcs.MULTI_CCS_LVL1_LABEL) over(partition by IcdCcs.MULTI_CCS_LVL1_LABEL order by ClmHdr.ICD_PRIM_DIAG desc) 
             end AS CCS_Desc, 
             'UHC_Claims' Src
 FROM ACECAREDW_TEST.dbo.claims_headers ClmHdr
     LEFT JOIN ACECAREDW.dbo.Uhc_MembersbyPCP Mbrs     -- THIS IS ONLY FOR ACE MEMBERS ADMITS TO THE TRAGET FACILTY LIST 
     ON Mbrs.uhc_subscriber_id = ClmHdr.subscriber_id 
             and month(ClmHdr.primary_svc_date) = month(Mbrs.A_last_update_date) 
             and YEAR(ClmHdr.primary_svc_date) = YEAR(Mbrs.a_last_update_date)
     LEFT JOIN [ACDW_CLMS_SHCN_MSSP].[lst].[LIST_ICDCCS] IcdCcs
     ON LEFT(IcdCcs.[ICD-10-CM_CODE], 3) = replace(LEFT(ClmHdr.ICD_PRIM_DIAG, 3), '.', '')
	 and Icdccs.EffectiveDate = '2017-01-01'
	 AND Icdccs.Version = 'ICD10CM'
              WHERE ClmHdr.CATEGORY_OF_SVC = 'INPATIENT'
              AND (ClmHdr.VEND_FULL_NAME IN( 'TEXAS CHILDREN''S HOSPITAL','WOMANS HOSPITAL OF TEXAS LP',
              'PARK PLAZA HOSPITAL','HARRIS COUNTY HOSPITAL DISTRICT','ST LUKES MEDICAL CENTER','CHI ST LUKES BAYLOR COL'
              ,'MEMORIAL MEDICAL CENTER','MHHS HERMANN HOSPITAL','MEMORIAL HERMANN MEDICAL GROUP','METHODIST HOSPITAL','BEN TAUB HOSPITAL') 
              or ClmHdr.VEND_FULL_NAME like '%ST JOSEPH MEDICAL%')
              AND PRIMARY_SVC_DATE >= '1/1/2018'
     GROUP BY ClmHdr.Subscriber_id, 
              ClmHdr.VEND_FULL_NAME, 
              Mbrs.pcp_practice_name, Mbrs.Member_first_Name, mbrs.member_last_Name,
              ClmHdr.PRIMARY_SVC_DATE, 
            ClmHdr.ICD_PRIM_DIAG,
		    ClmHdr.DRG_CODE ,
             IcdCcs.MULTI_CCS_LVL1_LABEL
            
    UNION ALL -- sHCN CLAIMS
    SELECT DISTINCT 
            Client.ClientShortName AS Client, Client.ClientKey, 
            ClmHdr.subscriber_id as Member_id, 
            ClmHdr.VEND_FULL_NAME, 
            Mbrs.PcpPracticeTIN, Mbrs.FirstName, Mbrs.LastName,    
            COUNT(DISTINCT CONCAT (ClmHdr.subscriber_id, ClmHdr.PRIMARY_SVC_DATE)) AS IP_Visits,
            ClmHdr.PRIMARY_SVC_DATE AS VisitDate, 
            ClmHdr.ICD_PRIM_DIAG AS Prim_diag_code,
		    ClmHdr.DRG_CODE ,
            case when IcdCcs.MULTI_CCS_LVL1_LABEL is not null 
            then  first_value(IcdCcs.MULTI_CCS_LVL1_LABEL) over(partition by IcdCcs.MULTI_CCS_LVL1_LABEL order by ClmHdr.ICD_PRIM_DIAG desc) 
            end AS CCS_Desc, 
            Client.ClientShortName + 'Claims_Src'    Src
 FROM ACDW_CLMS_SHCN_MSSP.adw.claims_headers  ClmHdr
--where clmhdr.category_of_svc <> 'Pharmacy'
     LEFT JOIN ACDW_CLMS_SHCN_MSSP.adw.vw_Dashboard_Membership Mbrs     
     ON Mbrs.ClientMemberKey = ClmHdr.subscriber_id 
             and month(ClmHdr.primary_svc_date) = mbrs.MbrMonth
             and YEAR(ClmHdr.primary_svc_date) = mbrs.MbrYear
     LEFT JOIN [ACDW_CLMS_SHCN_MSSP].[lst].[LIST_ICDCCS] IcdCcs
     ON LEFT(IcdCcs.[ICD-10-CM_CODE], 3) = replace(LEFT(ClmHdr.ICD_PRIM_DIAG, 3), '.', '')
	 AND Icdccs.EffectiveDate = '2017-01-01'
	 AND Icdccs.Version = 'ICD10CM'
     JOIN ACDW_CLMS_SHCN_MSSP.lst.List_Client Client 
     ON Mbrs.ClientKey = Client.ClientKey
            WHERE --ClmHdr.CATEGORY_OF_SVC = 'INPATIENT' AND 
            ClmHdr.VENDOR_ID IN ('1154361475') -- SJMC Vendor ID
            AND CLAIM_TYPE = '60'
            AND PRIMARY_SVC_DATE >= '1/1/2018'
			--where VEND_FULL_NAME like '%%'
     GROUP BY ClmHdr.Subscriber_id, 
            ClmHdr.VEND_FULL_NAME, 
            Mbrs.PcpPracticeTIN,    Mbrs.FirstName, Mbrs.LastName,            
            ClmHdr.PRIMARY_SVC_DATE, 
            ClmHdr.ICD_PRIM_DIAG, 
		  ClmHdr.DRG_CODE ,
            IcdCcs.MULTI_CCS_LVL1_LABEL,
            Client.ClientShortName, client.ClientKey
     UNION ALL
     -- from IP census
SELECT DISTINCT 
            Client.ClientShortName AS Client, Client.ClientKey,             
            Ntf.ClientMemberKey as Member_id, 
            Ntf.AdmitHospital AS VEND_FULL_NAME, 
            mbrs.PcpFullName, mbrs.FirstName, Mbrs.LastName, 
            count(DISTINCT CONCAT (Ntf.ClientMemberKey, CONVERT(DATE, NTF.[AdmitDateTime]))) AS IP_Visits, 
            CONVERT(date, Ntf.AdmitDateTime) AS VisitDate, 
            Ntf.DiagnosisCode AS Prim_diag_code, 
		  'No DRG' AS DRG_CODE ,
            IcdCcs.MULTI_CCS_LVL1_LABEL AS CCS_Desc,            
            'Census - GHH' Src
FROM ACECAREDW.adw.NtfNotification Ntf
     JOIN lst.List_Client Client ON ntf.ClientKey = Client.ClientKey
     JOIN (SELECT Src.ClientMemberKey, Src.Ace_ID, Src.ClientKey, Src.PcpFullName, Src.FirstName, Src.LastName
                FROM (select s.*, ROW_NUMBER() OVER (PARTITION BY s.ClientMemberKey, s.ClientKey, s.Ace_ID ORDER BY s.PcpFullName) arn
                       FROM (SELECT mbr.ClientMemberKey, mbr.MstrMrnKey AS Ace_ID, mbr.ClientKey, demo.lastName, demo.FirstName, PcpFullName
                             FROM adw.MbrMember Mbr
                             JOIN (SELECT d.mbrMemberKey, d.LastName , d.FirstName 
                                    , ROW_NUMBER() OVER (PARTITION BY d.mbrMemberKey ORDER BY d.EffectiveDate DESC) arn
                                    FROM adw.MbrDemographic d 
                                    WHERE d.EffectiveDate < d.ExpirationDate
                                    )demo On mbr.mbrMemberKey = demo.mbrMemberKey and demo.arn = 1    
					   JOIN (SELECT p.mbrMemberKey, p.npi, pr.PcpFullName
								, ROW_NUMBER() OVER (PARTITION BY p.mbrMemberKey ORDER BY p.EffectiveDate DESC) arn
							 FROM adw.MbrPcp p 
							     JOIN (SELECT pr.npi, pr.tin, pr.LastName + ', '+  pr.FirstName PcpFullName
							 	      FROM vw_AllClient_ProviderRoster pr 
							 		 GROUP BY pr.npi, pr.tin, pr.LastName, pr.FirstName
							 	   ) pr ON p.NPI = pr.NPI and p.TIN = pr.TIN
							 WHERE p.EffectiveDate < p.ExpirationDate
							 )pcp On mbr.mbrMemberKey = pcp.mbrMemberKey and pcp.arn = 1      
                             UNION 
                             SELECT src.ClientMemberKey, src.Ace_ID, src.ClientKey, src.LastName, src.FirstName, src.PcpName
                             FROM (SELECT mbr.ClientMemberKey, mbr.Ace_ID, mbr.ClientKey, mbr.LastName, mbr.FirstName, mbr.ProviderLastName + ',' + mbr.ProviderFirstName PcpName
                                  , ROW_NUMBER() OVER (PARTITION BY MBR.clientMemberKey ORDER BY mbr.RwEffectiveDate DESC) Arn 
                                  FROM ACDW_CLMS_SHCN_MSSP.adw.FctMembership  Mbr
                                  WHERE mbr.RwEffectiveDate >= '01/01/2020'
                                  ) src
                             WHERE src.Arn = 1
                             UNION 
					    SELECT src.UHC_SUBSCRIBER_ID, src.Ace_ID, src.ClientKey, src.MEMBER_LAST_NAME , src.MEMBER_FIRST_NAME, src.Pcp_Name
					    FROM (SELECT a.UHC_SUBSCRIBER_ID, a.Ace_ID, 1 As ClientKey, a.MEMBER_LAST_NAME, a.MEMBER_FIRST_NAME, a.PCP_LAST_NAME + ', '+ a.PCP_FIRST_NAME AS Pcp_Name
							 ,ROW_NUMBER() OVER (PARTITION BY a.UHC_SUBSCRIBER_ID ORDER BY a_Last_update_date desc) arn						  
							 FROM dbo.vw_UHC_ActiveMembers_ALL a -- need to check 
							 WHERE a.PCP_LAST_NAME is NOT null 
							 ) src where src.arn = 1
                          ) s            
                       ) src
                    WHERE src.arn    = 1
                ) Mbrs
                ON Mbrs.ClientMemberKey = Ntf.ClientMemberKey
                and Mbrs.clientKey = ntf.ClientKey                
          LEFT JOIN [ACDW_CLMS_SHCN_MSSP].[lst].[LIST_ICDCCS] IcdCcs 
          ON LEFT(IcdCcs.[ICD-10-CM_CODE], 3) = replace(LEFT(Ntf.DiagnosisCode, 3), '.', '')
		  AND Icdccs.EffectiveDate = '2017-01-01'
	      AND Icdccs.Version = 'ICD10CM'
     WHERE Ntf.AdmitDateTime >= '1/1/2018'
         AND  (ntf.AdmitHospital IN( 'TEXAS CHILDREN''S HOSPITAL','WOMANS HOSPITAL OF TEXAS LP',
           'PARK PLAZA HOSPITAL','HARRIS COUNTY HOSPITAL DISTRICT','ST LUKES MEDICAL CENTER','CHI ST LUKES BAYLOR COL'
           ,'MEMORIAL MEDICAL CENTER','MHHS HERMANN HOSPITAL','MEMORIAL HERMANN MEDICAL GROUP','METHODIST HOSPITAL','BEN TAUB HOSPITAL') 
           or ntf.AdmitHospital like '%ST JOSEPH MEDICAL%')
           AND ntf.ntfEventType IN('ADM', 'DIS')
           AND ntf.ntfpatienttype IN ('IP','Inpatient')
     GROUP BY Ntf.ClientMemberKey,
          Ntf.AdmitDateTime,
		mbrs.PcpFullName, mbrs.FirstName, Mbrs.LastName, 
        --Mbrs.PCP_PRACTICE_NAME,
          Ntf.AdmitHospital,
          Ntf.DiagnosisCode,
          IcdCcs.MULTI_CCS_LVL1_LABEL,
          Client.ClientKey, Client.ClientShortName
    ;

