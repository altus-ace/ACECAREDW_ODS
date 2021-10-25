CREATE PROCEDURE [ast].[PDW_UHC_UPdateNPI_FROM_RosterORHistory] (@LoadDate_ToUpdate Date, @LoadDate_ToSourceFrom DATE = '2020-11-17') -- last UHC load with NPI
AS
    /* Purpose: 	   get table of uhc data rows needing NPI Add from PR or Old data 
	   1. load rows needing NPI update, set status_NewBatch = 1 (we only work with values = 1, we keep history to have a trail)
	   2. update from PR
	   3. update form old data
	   4. write to dbo.Uhc_MembersByPcp
	   5. update the new batch to 0 so it will be out of scope next load.
	    */

    --DECLARE @LoadDate_ToUpdate date = '2021-02-22' 
    --declare @LoadDate_ToSourceFrom DATE = '2020-11-17' -- last UHC load with NPI
    /* get load dates */
    -- SELECT m.A_LAST_UPDATE_DATE
    -- FROM dbo.Uhc_MembersByPcp m
    -- group by m.A_LAST_UPDATE_DATE
    -- order by m.A_LAST_UPDATE_DATE desc
    /* review the NPI TIN VALUES in the load set */
    --SELECT distinct m.pcp_npi, m.PCP_PRACTICE_TIN
    --FROM dbo.Uhc_MembersByPcp m
    --WHERE m.A_LAST_UPDATE_DATE = '2021-02-22' 
    
    /* create working table---  
    --drop table dbo.Uhc_NpiFromPreviousTin 
    --Create Table dbo.Uhc_NpiFromPreviousTin (
    --    skey INT PRIMARY KEY NOT NULL IDENtITY (1,1)
    --    , Uhc_TableKey INT NOT NULL			   UHC_Member_BYPCP row to be updated (target Key)
    --    , loadDate Date 
    --    , UHC_SUBSCRIBER_ID VARCHAR(50) NOT NULL
    --    , PCP_PRACTICE_TIN VARCHAR(11) NULL
    --    , Best_Old_TIN VARCHAR(12)				  
    --    , BEST_OLD_NPI VARCHAR(12) 
    --    , BEST_OLD_NPI_SrcKey INT		    -- either a history row or a new 
    --    , CreatedBy VARCHAR(20) NOT NULL DEFAULT(system_USER)
    --    , CreatedDate DATETIME NOT NULL DEFAULT(getDate())
		, Status_NewB TINYINT default(1) -- values : 0 = no, 1 = Yes
    --    );
        */
    
    /* get records needing NPI */
    -- select * from dbo.Uhc_NpiFromPreviousTin where status_NewBatch = 1
    INSERT INTO dbo.Uhc_NpiFromPreviousTin(Uhc_subscriber_id, PCP_PRACTICE_TIN,  UHC_Tablekey, LoadDate)
    SELECT m.UHC_SUBSCRIBER_ID, m.PCP_PRACTICE_TIN, m.URN , m.A_LAST_UPDATE_DATE-- , m.PCP_NPI
    FROM dbo.Uhc_MembersByPcp m    
    --where m.A_LAST_UPDATE_FLAG = 'Y' and isnull(m.PCP_NPI, '') = ''
    where m.A_LAST_UPDATE_DATE =  @LoadDate_ToUpdate
	   and isnull(m.PCP_NPI, '') = ''
    --UNION
    --SELECT m.UHC_SUBSCRIBER_ID, m.PCP_PRACTICE_TIN, m.URN , m.A_LAST_UPDATE_DATE--, m.PCP_NPI
    --FROM dbo.Uhc_MembersByPcp m
    --where m.A_LAST_UPDATE_FLAG = 'L' and isnull(m.PCP_NPI, '') = ''
    
   
    
    -- get updated from roster: Join roster on tin, lastName, firstName , where effective
    SELECT Mbrs.UHC_SUBSCRIBER_ID, Mbrs.PCP_PRACTICE_TIN , Mbrs.PCP_NPI , Mbrs.urn , mbrs.PCP_LAST_NAME
        , t.loaddate, pr.NPI, pr.tin , pr.EffectiveDate, pr.ExpirationDate ,pr.RowEffectiveDate , pr.RowExpirationDate
    --UPDATE t SET t.BEST_OLD_NPI = pr.NPI, t.Best_Old_TIN = pr.TIN , t.BEST_OLD_NPI_SrcKey = Mbrs.urn 
    FROM dbo.Uhc_MembersByPcp Mbrs
        JOIN dbo.UHC_NpiFromPreviousTin t ON Mbrs.URN = t.Uhc_TableKey
        LEFT JOIN (SELECT distinct pr.TIN, pr.NPI, pr.LastName, pr.FirstName, pr.RowEffectiveDate, pr.RowExpirationDate, ISNULL(pr.EffectiveDate, '01/01/2020') EffectiveDate, pr.ExpirationDate
    		  FROM adw.fctProviderRoster pr 
    		  WHERE PR.ClientKey = 1 --and pr.TIN ='311756818'
    		  ) pr ON mbrs.PCP_PRACTICE_TIN = pr.TIN 
    			 and t.loadDate between pr.RowEffectiveDate and pr.RowExpirationDate
    			 --and t.loaddate between pr.EffectiveDate and  pr.ExpirationDate
    			 and LTRIM(RTRIM(mbrs.PCP_LAST_NAME)) = ltrim(rtrim(pr.LastName ))
    			 and LTRIM(RTRIM(mbrs.PCP_FIRST_NAME)) = ltrim(rtrim(pr.FirstName))
    WHERE not pr.npi is null and t.Status_NewBatch = 1
    
     
    /* update what is left from history */
    SELECT Mbrs.UHC_SUBSCRIBER_ID, Mbrs.PCP_PRACTICE_TIN BestOldTin, Mbrs.PCP_NPI BestOldNpi, Mbrs.urn BestOldSkey, t.loaddate
    --UPDATE t SET t.BEST_OLD_NPI = mbrs.PCP_NPI, t.Best_Old_TIN = mbrs.PCP_PRACTICE_TIN , t.BEST_OLD_NPI_SrcKey = Mbrs.urn 
    FROM dbo.Uhc_MembersByPcp Mbrs
        JOIN dbo.UHC_NpiFromPreviousTin t ON Mbrs.UHC_SUBSCRIBER_ID = t.UHC_SUBSCRIBER_ID
    WHERE isNULL(t.BEST_OLD_NPI, '') = ''
	   and t.Status_NewBatch = 1
        and mbrs.A_LAST_UPDATE_DATE = @LoadDate_ToSourceFrom
    
        
    /* review status */
    SELECT t.*    
    FROM dbo.UHC_NpiFromPreviousTin t     
    WHERE t.Status_NewBatch = 1
	   and ISNULL(t.BEST_OLD_NPI, '') = ''  -- these rows will not update 
    
    
    /* rows to update */
    SELECT t.BEST_OLD_NPI, Best_Old_TIN, m.UHC_SUBSCRIBER_ID, m.urn, m.PCP_PRACTICE_TIN , m.PCP_NPI
    --UPDATE m SET m.PCP_NPI = t.BEST_OLD_NPI, m.PCP_PRACTICE_TIN = t.Best_Old_TIN    
    FROM dbo.UHC_NpiFromPreviousTin t 
        JOIN dbo.Uhc_MembersByPcp m ON t.Uhc_TableKey = m.URN 
    WHERE t.Status_NewBatch = 1
	   and isNULL(t.BEST_OLD_NPI, '') <> '' 
	   and ISNULL(m.PCP_NPI, '') = ''
    
    /* update look up table ast.UHC_NpiFromUhcPcpId */
    INSERT INTO ast.Uhc_NpiFromUhcPcpID (UhcPcpID, NPI)
    SELECT distinct Mbr.PCP_UHC_ID, Mbr.PCP_NPI    
    FROM dbo.Uhc_MembersByPcp Mbr
	   LEFT JOIN ast.Uhc_NpiFromUhcPcpID NpiFromPcpID 
		  ON mbr.PCP_UHC_ID = NpiFromPcpID.UhcPcpID
			 AND mbr.PCP_NPI = NpiFromPcpID.NPI    
    WHERE NpiFromPcpID.NPI is null -- new
	   AND ISNULL(MBR.PCP_UHC_ID, '') <> ''
	   AND ISNULL(Mbr.PCP_NPI, '') <> ''

    
    --UPDATE m SET m.PCP_NPI = t.BEST_OLD_NPI, m.PCP_PRACTICE_TIN = t.Best_Old_TIN    
    SELECT t.*, m.PCP_NPI, m.A_LAST_UPDATE_DATE, NpiList.npi
    FROM dbo.UHC_NpiFromPreviousTin t 
        JOIN dbo.Uhc_MembersByPcp m ON t.Uhc_TableKey = m.URN 
	   JOIN ast.Uhc_NpiFromUhcPcpID NpiList ON m.PCP_UHC_ID = NpiList.UhcPcpID
    WHERE t.Status_NewBatch = 1	   
	   and ISNULL(m.PCP_NPI, '') = ''
	   and ISNULL(NpiList.NPI, '') <> ''
    
    
    

    
    

        -- get updated from roster: Join roster on tin, lastName, firstName , where effective
    SELECT Mbrs.UHC_SUBSCRIBER_ID, Mbrs.PCP_PRACTICE_TIN , Mbrs.PCP_NPI , Mbrs.urn , mbrs.PCP_LAST_NAME
        , t.loaddate, pr.NPI, pr.tin , pr.EffectiveDate, pr.ExpirationDate ,pr.RowEffectiveDate , pr.RowExpirationDate
    --UPDATE t SET t.BEST_OLD_NPI = pr.NPI, t.Best_Old_TIN = pr.TIN , t.BEST_OLD_NPI_SrcKey = Mbrs.urn 
    FROM dbo.Uhc_MembersByPcp Mbrs
        JOIN dbo.UHC_NpiFromPreviousTin t ON Mbrs.URN = t.Uhc_TableKey
        LEFT JOIN (SELECT distinct pr.TIN, pr.NPI, pr.LastName, pr.FirstName, pr.RowEffectiveDate, pr.RowExpirationDate, ISNULL(pr.EffectiveDate, '01/01/2020') EffectiveDate, pr.ExpirationDate
    		  FROM adw.fctProviderRoster pr 
    		  WHERE PR.ClientKey = 1 --and pr.TIN ='311756818'
    		  ) pr ON mbrs.PCP_PRACTICE_TIN = pr.TIN 
    			 and t.loadDate between pr.RowEffectiveDate and pr.RowExpirationDate
    			 --and t.loaddate between pr.EffectiveDate and  pr.ExpirationDate
    			 and LTRIM(RTRIM(mbrs.PCP_LAST_NAME)) = ltrim(rtrim(pr.LastName ))
    			 and LTRIM(RTRIM(mbrs.PCP_FIRST_NAME)) = ltrim(rtrim(pr.FirstName))
    WHERE not pr.npi is null and t.Status_NewBatch = 1

    
    /* update STatus Key  to 0 so the row is "OLD" */
    UPDATE n SET n.Status_NewBatch = 0
    FROM dbo.Uhc_NpiFromPreviousTin n
    where n. Status_NewBatch = 1
    ;