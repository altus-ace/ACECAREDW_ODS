CREATE VIEW  [dbo].[vw_AH_PE_NewMembers]     
As           
SELECT distinct           
    case when lc.ClientKey=2  then 'WellCare' 
    else lc.ClientName end as Client_id          
    , 'TOC1' AS Program_ID          
    , 'Newly Enrolled' AS Program_Name      
    , MbrCsPlan.effectivedate as Enroll_date      
    , MbrCsPlan.loaddate    As Create_date          
    , DATEADD(DAY, 90, MbrCsPlan.effectivedate) AS Enroll_End_date          
    , Mbr.ClientMemberkey AS Member_id      
    , 'ACTIVE' AS PROGRAM_STATUS       
    , 'Enrolled in a Program' AS REASON_DESCRIPTION       
    , 'External' AS REFERAL_TYPE          
    FROM [adw].[MbrMember] Mbr           
	   INNER JOIN [lst].[List_Client] lc 
		  ON lc.Clientkey = Mbr.clientkey 		  
	   INNER JOIN [adw].mbrCsPlanHistory MbrCsPlan
		  ON MbrCsPlan.mbrMemberKey = Mbr.mbrMemberKey 
		  AND MbrCsPlan.EffectiveDate >='11/01/2018'       
	   LEFT JOIN adw.MbrPcp MbrPcp
		  ON MbrPcp.mbrmemberkey=MbrCsPlan.mbrMemberKey        
    WHERE  MbrPcp.mbrmemberkey is not null       
	   and Mbr.ClientKey <> 1