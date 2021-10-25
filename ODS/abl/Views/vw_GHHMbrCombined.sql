

CREATE  VIEW [abl].[vw_GHHMbrCombined]
AS
    /* history: 
	   gk: 12/18/2020: Removed union becuase we removed the ClientKey and ClientMemberKey from the vw_Ghh_MemberRoster 

	   */
	   
    /*  : there is a doc UpdateMrnToMpl that details how to use this table and how to update the changes from the MRN fixes
		  I:\Geoff\dbScript\UpdateMrnToMulipleDB_forMrnUpkeep.sql
    Validate: This view should produce 0 rows from this query	   
	   drop table dbo.tmpGhhDuplicates
	   SELECT g.AceID, count(*) cnt
	   into dbo.tmpGhhDuplicates
	   FROM [abl].[vw_GHHMbrCombined] g
	   GROUP BY g.AceID
	   HAVING COUNT(*) > 1
	   SELECT * FROM dbo.tmpGhhDuplicates
	   If there are results go study.
    */
    SELECT mbr.AceID, mbr.LAST_NAME, mbr.FIRST_NAME, mbr.MIDDLE_NAME, mbr.GENDER, mbr.DATE_OF_BIRTH, mbr.SSN, 
       mbr.MEMBER_HOME_ADDRESS, mbr.MEMBER_HOME_ADDRESS2, mbr.MEMBER_HOME_CITY, mbr.MEMBER_HOME_STATE, mbr.MEMBER_HOME_ZIP, 
       mbr.Member_Home_Phone, mbr.MinEligDate, mbr.MinExpDate, 	  
	  mbr.MEMBER_POD_DESC
    FROM [abl].[vw_GHH_MemberRoster] mbr
    WHERE mbr.MEMBER_POD_DESC <> 'Greater Odessa';
	 
	 -- includes all MCo's     THIS WAS Changed as 
     --UNION ALL
     --SELECT *
     --FROM [ACDW_CLMS_SHCN_MSSP].[ADW].[vw_Exp_GHH_MSSPMembership]; 
