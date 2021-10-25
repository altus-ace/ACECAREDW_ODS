CREATE VIEW dbo.vw_Get_MembersToAceId  
	 AS   
	 /* Purpose: Gets all members ever with all known MRNs to be used as 
	 a lookup for matching external data with internal data */  
	 SELECT  distinct OldMbrs.Client_Member_ID AS ClientMemberKey      
	 , OldMbrs.A_MSTR_MRN AS AceID      
	 , OldMbrs.A_Client_ID AS ClientKey      
	 , OldMbrs.CreatedDate      
	 , OldMbrs.CreatedBy  
	 FROM adw.A_Mbr_Members OldMbrs  
	 where active = 1    
	 UNION 
	 SELECT NewMembers.ClientMemberKey       
	 , NewMembers.MstrMrnKey AS AceId      
	 , NewMembers.ClientKey       
	 , NewMembers.CreatedDate      
	 , NewMembers.CreatedBy  
	 FROM adw.MbrMember  NewMembers  