CREATE PROCEDURE [adi].[AceValidCopUhcCareOps]
    (
	   @ReturnDetails CHAR(1) = 'N'
    )
AS 
    /* how do we make this useful?
	   as it is, it returns a great result
    */
    IF OBJECT_ID('tempdb..#MissingMapping') IS NOT NULL 
	   DROP TABLE #MissingMapping;
    CREATE TABLE #MissingMapping (ValidationType VARCHAR(100), MeasureID VARCHAR(100), SubMeasureId VARCHAR(100), QmMsrID VARCHAR(20), DestProgramName VARCHAR(200));
    
    INSERT INTO #MissingMapping (ValidationType, MeasureID, SubMeasureId, QmMsrID, DestProgramName)
    SELECT 'QM Mapping IS NULL' AS ValidationType, adiData.MeasureId, adiData.SubmeasureId, qm.QM QmMsrID, lstAceMap.Destination DestProgramName    
    FROM [adi].UHCQualityGapReport adiData
	   JOIN lst.List_Client Client ON 1 = Client.ClientKey
	   LEFT JOIN aceMasterData.lst.ListAceMapping lstAceMap
	      ON Client.ClientShortName +'_'+adiData.MeasureId + '_'+ adidata.SubmeasureId = lstAceMap.Source
	   	  and lstAceMap.MappingTypeKey = 14 and lstAceMap.IsActive = 1
	      LEFT JOIN (SELECT QM, QM_DESC, qm.EffectiveDate, qm.ExpirationDate
	   			    FROM aceMasterData.[lst].[LIST_QM_Mapping] qm  
				    WHERE qm.qm like 'UHC%'
				) qm 
	      ON lstAceMap.Destination = qm.QM	
	      --AND adiData.DataDate BETWEEN qm.EffectiveDate and qm.ExpirationDate
	      WHERE adiData.MemberID <> '' 
	      AND ISNULL(adiData.[COMPLIANCE], '') <> ''
	      AND adiData.CopLoadStatus = 0	   
	      AND qm.qm is null 
		 AND lstAceMap.Destination <> 'NOT MAPPED'
	      GROUP BY adiData.MeasureId, adiData.SubmeasureId, qm.QM , lstAceMap.Destination 
    UNION
    SELECT 'Ahs Program Map IS NULL' AS ValidationType, adiData.MeasureId, adiData.SubmeasureId, qm.QM QmMsrID, lstAceMap.Destination DestProgramName
    FROM [adi].UHCQualityGapReport adiData
         JOIN lst.List_Client Client ON 1 = Client.ClientKey
    	LEFT JOIN aceMasterData.lst.ListAceMapping lstAceMap
    	   ON Client.ClientShortName +'_'+adiData.MeasureId + '_'+ adidata.SubmeasureId = lstAceMap.Source
    		  and lstAceMap.MappingTypeKey = 14 and lstAceMap.IsActive = 1
        LEFT JOIN (SELECT QM, QM_DESC, qm.EffectiveDate, qm.ExpirationDate
    			 FROM aceMasterData.[lst].[LIST_QM_Mapping] qm  ) qm 
    	   ON lstAceMap.Destination = qm.QM	
    	   AND adiData.DataDate BETWEEN qm.EffectiveDate and qm.ExpirationDate
        WHERE adiData.MemberID <> '' 
    	   AND ISNULL(adiData.[COMPLIANCE], '') <> ''
    	   AND adiData.CopLoadStatus = 0	   
    	   AND lstAceMap.Destination is null 
        GROUP BY adiData.MeasureId, adiData.SubmeasureId, qm.QM , lstAceMap.Destination 
    
    --SELECT * FROM #MissingMapping

    DECLARE @cntMissingMapping INT = 0
    SELECT @cntMissingMapping = COUNT(*)
    FROM #MissingMapping;

    /* write rows to table */

    IF @cntMissingMapping > 0 
	   BEGIN -- write to log
		  INSERT INTO ast.AceValidationLog (JobName, ValidationTYpe, Details)
			 SELECT DISTINCT OBJECT_NAME(@@PROCID) JobName, m.ValidationType
				, 'MeasureID: ' + m.MeasureID + '  SubMeasureID: ' + ISNULL(m.SubmeasureID, 'none')  AS Details
			 FROM #MissingMapping m
	   END
    IF (@ReturnDetails = 'Y') 
	   BEGIN
		  SELECT *
		  FROM #MissingMapping;
	   END;

    RETURN @cntMissingMapping;


