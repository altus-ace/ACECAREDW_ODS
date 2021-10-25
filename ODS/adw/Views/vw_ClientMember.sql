
CREATE VIEW [adw].[vw_ClientMember]
AS  
    /* version history:
	   12/02/2019: GK: added a MbrMember.ClientKey <> 1 clause for member model rollout 
	   */
   --  SELECT mbr.Client_Member_ID, 
       --     mbr.A_MSTR_MRN
   --  FROM adw.A_Mbr_Members Mbr
   --  WHERE mbr.Active = 1
   --  UNION
   --  SELECT NMbr.ClientMemberKey, 
   --         NMbr.MstrMrnKey
   --  FROM adw.MbrMember NMbr
---	WHERE NMbr.ClientKey <> 1;

SELECT ClientMemberKey,MstrMrnKey
      
FROM [AceMPI].[adw].[MPI_ClientMemberAssociationHistoryODS]

