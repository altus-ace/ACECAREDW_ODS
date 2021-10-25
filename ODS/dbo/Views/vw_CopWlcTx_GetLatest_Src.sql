CREATE VIEW dbo.vw_CopWlcTx_GetLatest_Src
AS 
    SELECT CopWlcTxM.URN
        , CASE WHEN (PATINDEX('%-%', CopWlcTxM.Subscriber) = 0) THEN CopWlcTxM.Subscriber
		  ELSE SUBSTRING(CopWlcTxM.Subscriber, 1, (PATINDEX('%-%', CopWlcTxM.Subscriber)-1))
		  END as Subscriber
        , CopWlcTxM.Measure    
        , CASE WHEN(CopWlcTxM.ComplianceStatus NOT LIKE 'In%') THEN CopWlcTxM.ComplianceStatus /* if it isn't like IN then it is Comp/Non value */
    	   WHEN  (CONVERT(INT, /* if it is at least 80% it is comp?*/
    		  CASE WHEN(CopWlcTxM.ComplianceStatus = 'In-Play - 100%') 
    				THEN RIGHT(LEFT(RIGHT(CopWlcTxM.ComplianceStatus, (LEN(CopWlcTxM.ComplianceStatus) - 7)), 6), 3)
    			 WHEN(CopWlcTxM.ComplianceStatus LIKE 'in%') AND CopWlcTxM.ComplianceStatus <> 'In-Play - 100%' 
    				THEN LEFT(RIGHT(LEFT(RIGHT(CopWlcTxM.ComplianceStatus, (LEN(CopWlcTxM.ComplianceStatus) - 7)), 6), 3), 2)
    			 END)) BETWEEN 80 AND 100 
    		  THEN 'Compliant'
                ELSE 'Non-Compliant'
               END AS ComplianceStatus
        , CONVERT(DATE, CopWlcTxM.ServiceStartDate) AS EnrollDate
        , CopWlcTxM.ServiceEndDate
        , CopWlcTxM.ComplianceDetail
        , CopWlcTxM.FileDate
        , CopWlcTxM.CreateDate
    FROM adi.CopWlcTxM CopWlcTxM
         JOIN (SELECT MAX(FileDate) MaxFileDate
    		  FROM adi.CopWlcTxM lc
    		  GROUP BY FileDate
    		  ) AS LatestCareOps 
    		  ON CopWlcTxM.FileDate = LatestCareOps.MaxFileDate;
