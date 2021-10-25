
CREATE PROCEDURE [adw].[z_AcePdwMbrWlcMbrByPcp_02_0025_LoadMember]
	@loadDate DATE ,
	@InsertCount INT OUTPUT
AS
   DECLARE @OutputTbl TABLE (ID INT);
   DECLARE @adiTableName VARCHAR(50) = 'MbrWlcMbrByPcp';	

    /*Update where new data  
	   Nothing changes here, The Load key is the load key of inital load of the member
	   THE Only data that can change is the MRN.
		  IF the MRN does change it will be updated by seperate process in a way 
		  that is outside the scope of this definition*/
    
    IF OBJECT_ID('dbo.tmpWlcMbrMember') IS NOT NULL 
        DROP TABLE dbo.tmpWlcMbrMember
    
    CREATE TABLE dbo.tmpWlcMbrMember([ClientMemberKey]   VARCHAR(50) not null Primary Key       ,[ClientKey]   INT        ,[MstrMrnKey]     NUMERIC(15,0)
	   ,[mbrLoadKey]    int       ,[LoadDate]    date       ,[DataDate] date, ExistingMbrMemberKey INT );
	   
    
    INSERT INTO dbo.tmpWlcMbrMember
           ([ClientMemberKey]
           ,[ClientKey]
           ,[MstrMrnKey]
           ,[mbrLoadKey]
           ,[LoadDate]
           ,[DataDate]
		 ,ExistingMbrMemberKey
	   )    
	  --	DECLARE @LoadDate DATE = '2021-04-20'  DECLARE @adiTableName VARCHAR(50) = 'MbrWlcMbrByPcp'
    SELECT DISTINCT AdiMbrs.SUB_ID NewClientMemberKey
        , c.ClientKey 
	   , mrn.MstrMrnKey         
        , lh.mbrLoadHistoryKey
        , CONVERT(DATE, GETDATE()) AS LoadDate
        , AdiMbrs.DataDate	        
	   , mbr.MbrMemberKey 
    FROM adi.tvf_PdwSrc_Wlc_MemberByPcp( @LoadDate) AdiMbrs
        left JOIN adw.MbrLoadHistory lh ON AdiMbrs.mbrWlcMbrByPcpKey = lh.adiKey AND lh.adiTableName = @adiTableName
	   LEFT JOIN adw.MbrMember mbr ON AdiMbrs.SUB_ID = mbr.ClientMemberKey
        JOIN (SELECT c.ClientKey FROM lst.List_Client c ) c ON 2 = c.ClientKey        
	   left JOIN ast.MbrStg2_MbrData mrn ON AdiMbrs.mbrWlcMbrByPcpKey = mrn.AdiKey
    					   AND mrn.SrcFileName = 'adi.MbrWlcMbrByPcp'	
	   JOIN adw.MbrWlcProviderLookup pl ON AdiMbrs.Prov_id = pl.Prov_id  
		  AND @loaddate <= pl.Term_Date   
    WHERE AdiMbrs.BestMemberRow = 1
	   ; -- get only new, IE MbrMemberKey is null

	   
    INSERT INTO [adw].[MbrMember] (ClientMemberKey, ClientKey, MstrMrnKey, MbrLoadKey, LoadDate, DataDate)
    OUTPUT inserted.MbrMemberKey INTO @OutputTbl(ID)   
    SELECT ClientMemberKey, ClientKey, MstrMrnKey, MbrLoadKey, LoadDate, DataDate
    FROM dbo.tmpWlcMbrMember
    WHERE ExistingMbrMemberKey is null
    ORDER by clientmemberkey;



    SELECT @InsertCount = COUNT(*)
    FROM @OutputTbl ;
    
    RETURN;

  
	/* Old Query
	SELECT AdiMbrs.SUB_ID NewClientMemberKey
        , c.ClientKey 
	   , mrn.MstrMrnKey         
        , lh.mbrLoadHistoryKey
        , CONVERT(DATE, GETDATE()) AS LoadDate
        , AdiMbrs.DataDate	        
	   , mbr.MbrMemberKey 
    FROM adi.tvf_PdwSrc_Wlc_MemberByPcp( @LoadDate) AdiMbrs
        left JOIN adw.MbrLoadHistory lh ON AdiMbrs.mbrWlcMbrByPcpKey = lh.adiKey AND lh.adiTableName = @adiTableName
	   LEFT JOIN adw.MbrMember mbr ON AdiMbrs.SUB_ID = mbr.ClientMemberKey
        JOIN (SELECT c.ClientKey FROM lst.List_Client c ) c ON 2 = c.ClientKey        
	   left JOIN adw.MstrMrn mrn ON AdiMbrs.mbrWlcMbrByPcpKey = mrn.srcUrn
    					   AND mrn.srcTableName = 'adi.MbrWlcMbrByPcp'	
	   JOIN adw.MbrWlcProviderLookup pl ON AdiMbrs.Prov_id = pl.Prov_id  
		  AND @loaddate <= pl.Term_Date   
    WHERE AdiMbrs.BestMemberRow = 1
	   ; -- get only new, IE MbrMemberKey is null
	**/