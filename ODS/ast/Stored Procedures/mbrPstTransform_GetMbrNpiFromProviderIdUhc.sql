

CREATE PROCEDURE ast.mbrPstTransform_GetMbrNpiFromProviderIdUhc    
	   @LoadDate DATE
AS
    
    /* get providers needing NPIs */

    --CREATE TABLE ast.ListUhcProviderIdToNpi (providerID Varchar(20) PRIMARY KEY NOT NULL, LName VARCHAR(50), FName VARCHAR(50), NPI varchar(20), TIN varchar(20));
    TRUNCATE TABLE ast.ListUhcProviderIdToNpi;
    
    INSERT INTO ast.ListUhcProviderIdToNpi (providerId, LName, FName, TIN)    
    SELECT DISTINCT p.PROVIDER_ID, p.PROV_LNAME, p.PROV_FNAME,p.IRS_TAX_ID AS TIN
    FROM adi.mbrUhcMbrByProvider p
    
    /* ast.ListUhcProvToNpiHistory get a working table of KNONW UHC NPI to UHC Provider ID associations */    
    -- CREATE TABLE ast.ListUhcProvToNpiHistory( npi varchar(20) NOT NULL, UhcPcpId Varchar(50) NOT NULL
    --	  , PRIMARY KEY CLUSTERED (	npi, UhcPcpId ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) );
    TRUNCATE TABLE ast.ListUhcProvToNpiHistory;
     
    INSERT INTO ast.ListUhcProvToNpiHistory(npi, uhcPcpId)
    SELECT UhcNpiHst.PCP_NPI, UhcNpiHst.PCP_UHC_ID
    FROM (SELECT m.PCP_NPI, m. PCP_UHC_ID   
		  , ROW_NUMBER() OVER(PARTITION BY m.pcp_Uhc_id, m.Pcp_NPI ORDER BY m.CreateDate DESC) OrderOfCreate
		  FROM adi.mbrUhcMbrByPcp m
		  ) UhcNpiHst
	WHERE UhcNpiHst.OrderOfCreate = 1;

    /* validate data set 		  
    SELECT mbrPcp.providerID, mbrPcp.LName, mbrPcp.FName, mbrPcp.TIN, mbrPcp.npi
    FROM #tmpUhcProviderIdToNpi mbrPcp
    */
        
    /* Update Npi from history of uHC Provider ID to NPI data */
    -- SELECT PcpNpi.providerID, PcpNpi.LName, PcpNpi.FName, PcpNpi.TIN, PcpHist.NPI
    UPDATE PcpNpi SET PcpNpi.NPI = PcpHist.npi
    FROM ast.ListUhcProviderIdToNpi PcpNpi
        JOIN ast.ListUhcProvToNpiHistory PcpHist ON PcpNpi.providerID = PcpHist.UhcPcpId
    WHERE PcpNpi.NPI is null
        and NOT PcpHist.npi IS NULL;
    
    /* UPDATE Npi By Provider Roster by Last Name, FIrst Name */
    --SELECT PcpNpi.providerID, PcpNpi.LName, PcpNpi.FName, PcpNpi.TIN, PcpNpi.NPI, pr.NPI PR_NPI, pr.LastName, pr.FirstName 
    UPDATE PcpNpi SET PcpNpi.NPI = pr.npi
    FROM ast.ListUhcProviderIdToNpi PcpNpi
        JOIN (SELECT p.NPI, p.LastName, p.FirstName FROM dbo.vw_AllClient_ProviderRoster p WHERE p.CalcClientKey = 1  GROUP BY p.npi, p.LastName, p.FirstName
		  )PR ON PcpNpi.LName = pr.lastName
    WHERE ISNULL(PcpNpi.Npi,'') = '';
    
    /* anything left set to Unknown Value */
    DECLARE @UnknownNpi VARCHAR(10) =   '1111111111' ;
    --SELECT mbrPcp.providerID, mbrPcp.LName, mbrPcp.FName, mbrPcp.TIN, mbrPcp.NPI, @UnknownNpi
    UPDATE mbrPcp SET mbrPcp.NPI = @UnknownNpi
    FROM ast.ListUhcProviderIdToNpi mbrPcp    
    WHERE ISNULL(mbrPcp.Npi,'') = ''	;

    /* validate all NPI have a value */
    --SELECT COUNT(*) 
    --FROM ast.ListUhcProviderIdToNpi mbrPcp    
    --WHERE ISNULL(mbrPcp.Npi,'') = ''	

    /* Use the tmp table to update the staging table */
    --SELECT ast.mbrStg2_MbrDataUrn, ast.prvNPI, adi.PROVIDER_ID, ProvToNpi.*
    UPDATE ast SET ast.prvNPI = ProvToNpi.NPI
    FROM ast.MbrStg2_MbrData ast
	   Join adi.mbrUhcMbrByProvider adi ON ast.AdiKey = adi.UHCMbrMbrByProviderKey
	   JOIN (SELECT PcpNpi.providerID, PcpNpi.NPI FROM ast.ListUhcProviderIdToNpi PcpNpi) ProvToNpi ON adi.PROVIDER_ID = ProvToNpi.providerID
    where ast.ClientKey = 1 and ast.LoadDate = '12/18/2020' and ISNULL(ast.prvNPI, '') = ''
    ;

