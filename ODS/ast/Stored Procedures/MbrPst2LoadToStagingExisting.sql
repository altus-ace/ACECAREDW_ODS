
CREATE PROCEDURE [ast].[MbrPst2LoadToStagingExisting] @LoadDate DATE, @ClientKey INT
AS
    /* Purpose: get existing members key values: */    
    MERGE ast.mbrStg2_MbrData trg 
    USING (SELECT stg.mbrStg2_MbrDataUrn, stg.ClientSubscriberId, mbr.mbrMemberKey
		  FROM ast.MbrStg2_MbrData Stg
			 LEFT JOIN Adw.MbrMember Mbr ON stg.ClientSubscriberId = mbr.ClientMemberKey
		  WHERE Stg.stgRowStatus = 'Loaded'  
			 AND NOT mbr.mbrMemberKey IS NULL 
			 AND stg.ClientKey = @ClientKey
			 AND stg.LoadDate = @LoadDate
			 )src
    ON trg.mbrStg2_MbrDataUrn = src.mbrStg2_MbrDataUrn
    WHEN MATCHED THEN UPDATE SET
	   trg.mbrMemberKey = src.mbrMemberKey
    ;
    
    
    /* Purpose: Get Term Members: These are inserts */       
    DECLARE @TermDate Date = DATEADD(day, -1*(Day(@LoadDate)), @LoadDate); /* last day of prior Month */
    DECLARE @StgRowStatus varchar(20) = 'Loaded';
    MERGE ast.MbrStg2_MbrData trg
    USING(SELECT DISTINCT 0 AS mbrStg2_MbrDataUrn
			 , ActiveMembers.CLIENT_SUBSCRIBER_ID, @CLientKey ClientKey, ActiveMembers.Ace_ID
			 , ActiveMembers.mbrMemberKey, ActiveMembers.mbrPlanKey, ActiveMembers.mbrPcpKey, ActiveMembers.mbrCsPlanKey
			 , ActiveMembers.mbrDemographicKey 
			 , @TermDate AS TermDate, @StgRowStatus AS StgRowStatus, @LoadDate AS LoadDate, @LoadDate AS DataDate
		  FROM [dbo].[tvf_Activemembers](GETDATE()) ActiveMembers 
			 LEFT JOIN ast.MbrStg2_MbrData Stg 
				ON ActiveMembers.CLIENT_SUBSCRIBER_ID = stg.ClientSubscriberId 
				AND Stg.stgRowStatus = 'Loaded' 
		  WHERE ActiveMembers.ClientKey = @ClientKey 
			 AND stg.mbrStg2_MbrDataUrn is NULL 
		  ) src
    ON trg.mbrStg2_MbrDataUrn = src.mbrStg2_MbrDataUrn
    WHEN NOT MATCHED THEN 
	   INSERT  ([ClientSubscriberId],[ClientKey],[MstrMrnKey]
			 ,[MbrMemberKey],MbrPlanKey,MbrPcpKey,MbrCsPlanKey 
			 ,TransfromPcpExpirationDate, TransfromPlanExpirationDate, TransfromCsPlanExpirationDate 
			 ,[stgRowStatus],[LoadDate],[DataDate]           
			 )
	   VALUES (src.CLIENT_SUBSCRIBER_ID, src.ClientKey, src.Ace_ID
			 , src.MbrMemberKey, src.mbrPlanKey, src.MbrPcpKey, src.MbrCsPlanKey
			 , src.TermDate, src.TermDate, src.TermDate
			 , src.StgRowStatus, src.LoadDate, src.DataDate
			 )
		  ;
