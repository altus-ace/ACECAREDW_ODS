


CREATE PROCEDURE [adw].[AceMrnMbrUhcMbrByPcp]
	@loadDate DATE	
AS
	/* Purpose: insertes a member in MRN. this is to be replaced with the MRN Pateint Matching code */ 
    
    /* 1. Identify members to insert into MRN  */
    INSERT INTO [adw].[MstrMrn]
           ([FirstName]
           ,[LastName]
           ,[MiddleName]
           ,[DateOfBirth]
           ,[Gender]
           ,[MedicareID]
           ,[MedicaidID]
           ,[srcUrn]
           ,[srcTableName]
           ,[Active]
           --,[MergeToMrn]
           ,[LoadDate]
           ,[DataDate]
		  )
    SELECT --m.UHC_SUBSCRIBER_ID, mbr.Client_Member_ID ,
        m.mbrFName
        ,m.mbrLName
        ,m.mbrMName
        ,m.DATE_OF_BIRTH
        ,m.GENDER
        ,m.Medicare_ID
        ,m.Medicaid_ID	
	   ,m.mbrMbrByPcpKey AS [src_URN] /* use stg urn to make location easy in second step */
        ,'UHC_MembersByPcp' AS srcTbl
	   , 1			   AS isActive
	   , CONVERT(DATE, GETDATE()) AS LoadDate
	   , m.DataDate
    FROM (Select m.UHC_Subscriber_id, m.mbrMbrByPcpKey, m.[mbrFName],m.mbrLName,m.[mbrMName]
		  ,m.[DATE_OF_BIRTH],m.[Gender],m.[Medicare_ID],m.[Medicaid_ID]	, m.DataDate
    		  , ROW_NUMBER() OVER (PARTITION BY m.UHC_SUBSCRIBER_ID ORDER BY m.LoadDate DESC) arn 
    		  FROM adi.MbrUhcMbrByPcp m
		  WHERE m.LoadDate >= @loadDate) M
			 LEFT JOIN adw.MbrMember mbr ON RTRIM(LTRIM(m.UHC_SUBSCRIBER_ID)) = mbr.ClientMemberKey
    WHERE m.arn = 1
	   AND mbr.ClientMemberKey is null;

/* insert into mbr 
    JOIn mrn to member by pcp on src urn and filter for today's inserts
     */ 
	/* this code would be replaced with a full member load */
/*    INSERT INTO [adw].[A_Mbr_Members]
           ([A_MSTR_MRN]
           ,[Client_Member_ID]
           ,[A_Client_ID])
    SELECT 
	   mrn.A_MSTR_MRN
	   ,  m.UHC_SUBSCRIBER_ID 
	   , c.[A_Client_ID]
    FROM adw.A_MSTR_MPI mrn
	   JOIN dbo.UHC_MembersByPCP m ON mrn.src_URN = m.URN
	   JOIN adw.A_List_Clients c ON 1 = 1
    WHERE mrn.A_CREATED_DATE >= DATEADD(day, -1, GETDATE());
    */
/* 3. update src id 
    This can be run after the Import to ADW */ 

    /*
    SELECT 
	   mrn.A_MSTR_MRN
	   ,  m.UHC_SUBSCRIBER_ID 
	   , c.[A_Client_ID]
    FROM adw.A_MSTR_MPI mrn
	   JOIN dbo.UHC_MembersByPCP m ON mrn.src_URN = m.URN
	   JOIN adw.A_List_Clients c ON 1 = 1
    WHERE mrn.A_CREATED_DATE >= DATEADD(day, -1, GETDATE());

    */
