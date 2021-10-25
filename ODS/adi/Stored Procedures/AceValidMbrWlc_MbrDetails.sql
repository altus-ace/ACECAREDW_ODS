CREATE PROCEDURE [adi].[AceValidMbrWlc_MbrDetails](
    @ClientMemberKey VARCHAR(50)
    , @DetailLevel CHAR = 'N'
    , @getHelp CHAR(1) = 'Y')
AS
   
    IF @getHelp = 'Y' 
	   SELECT 'Usage Details' AS HelpType
	   	   , 'Gets details about a member from the ADW.' [AceValidMbrWlc_MbrDetails Description]
	   	   , 'Client Member Key is the client Subscriber Key' AS [Param Help: ClientMemberKey]
	   	   , 'DetailLevel: Values ''N'' Normal, ''V'' Verbose: has detailed table content.' AS [Param Help: DetailLevel]
	   	   ;

    IF @DetailLevel <> 'V' 
	   SET @DetailLevel = 'N';


    DECLARE @MbrSubID VARCHAR(50)= @ClientMemberKey;	
    DECLARE @DL CHAR(1) = @DetailLevel;           


     /* get each load the member was on */

     SELECT 'Adi Load history' AS MbrDetailType,             
            w.LoadDate, 
            @mbrSubID AS ClientSubscriberID
     FROM adi.MbrWlcMbrByPcp w	
     WHERE w.SEQ_Mem_ID = @mbrSubID
	GROUP BY w.LoadDate
     ORDER BY w.LoadDate ASC;
	
	/* XXXXXXXX Valid Provider XXXXX */
	SELECT 'Adi PCP Contract Status' AS [Adi.PCPContract Status],             
		  CASE WHEN (pl.NPI is null) THEN 0 ELSE 1 END AS PcpUnderContract,
		  w.Prov_id WLC_Prov_Identifier,
		  pl.NPI, pl.Prov_Name AS ProviderName,
		  pl.TIN, pl.PracticeName AS PracticeName,
            w.LoadDate, 
            @mbrSubID AS ClientSubscriberID
     FROM adi.MbrWlcMbrByPcp w
	   LEFT JOIN [adw].[MbrWlcProviderLookup] pl ON w.Prov_id = pl.Prov_id 
     WHERE w.SEQ_Mem_ID = @mbrSubID

	/* XXXXX get member provider details XXXXXX */
     SELECT 'adi.MbrWlcMbrByPcp' AS [adi.MbrWlcMbrByPcp], 
            pl.NPI ProvNpi, 
            pl.TIN ProvTin, 
            w.LoadDate, 
            w.mbrWlcMbrByPcpKey, 
            w.Sub_ID, 
            w.IPA, 
            w.BirthDate, 
            w.MEDICAID_NO, 
            w.EffDate, 
            w.TermDate, 
            w.Prov_id, 
            w.Prov_Name, 
            w.LOB, 
            w.BenePLAN, 
            w.ADDRESS_TYPE, 
            w.SrcFileName, 
            w.InQuarantine, 
            w.CreateDate
     FROM adi.MbrWlcMbrByPcp w
          LEFT JOIN [adw].[MbrWlcProviderLookup] pl ON w.Prov_id = pl.Prov_id
     WHERE w.Sub_ID = @mbrSubID;

	/* XXXXX get Load history details XXXXXX */
     SELECT 'adw.LoadHistory' AS [adw.LoadHistory], 
            h.*
     FROM adw.mbrLoadHistory h
     WHERE h.AdiKey IN
     (
         SELECT w.mbrWlcMbrByPcpKey
         FROM adi.MbrWlcMbrByPcp w
         WHERE w.sub_ID = @mbrSubID
     );
	/* XXXXX get member Model details XXXXXX */
     SELECT 'MbrModelSummary' AS MbrModelSummary,

            /* mbr data */

            mbr.mbrMemberKey, 
            mbr.ClientKey, 
            mbr.MstrMrnKey,

            /* pcp Data */

            pcp.mbrPcpKey, 
            pcp.EffectiveDate AS pcpEffDate, 
            pcp.ExpirationDate AS pcpExpDate,

            /* plan Data */

            p.mbrPlanKey AS PlanKey, 
            p.EffectiveDate AS PlanEffDate, 
            p.ExpirationDate AS PlanExpDate,

            /* clinical Plan Data */

            csp.mbrCsPlanKey AS CPlnKey, 
            csp.EffectiveDate AS CPlnEffDate, 
            csp.ExpirationDate AS CPlnExpDate,

            /* demo data */

            d.mbrDemographicKey, 
            d.EffectiveDate AS DemoEffDate, 
            d.ExpirationDate AS DemoExpDate,

            /* Load dates */

            mbr.LoadDate AS mbrLoadDate, 
            d.LoadDate AS demoLoadDate, 
            p.LoadDate AS PlanLoadDate, 
            csp.LoadDate AS CPlnLoadDate, 
            pcp.LoadDate AS pcpLoadDate,

            /*  Load keys */

            mbr.MbrLoadKey, 
            d.mbrLoadKey AS DemoLoadKey, 
            p.mbrLoadKey AS PlanLoadKey, 
            p.MbrLoadKey AS CPlnLoadKey, 
            pcp.mbrLoadKey AS pcpLoadKey
     FROM adw.MbrMember mbr
          LEFT JOIN adw.mbrDemographic d ON mbr.mbrMemberKey = d.mbrMemberKey -- validation: there should be at least on valid mbrDemo for ever member
          LEFT JOIN adw.MbrPlan p ON mbr.mbrMemberKey = p.mbrMemberKey
          LEFT JOIN adw.mbrCsPlanHistory csp ON mbr.mbrMemberKey = csp.MbrMemberKey
          LEFT JOIN adw.MbrPcp pcp ON mbr.mbrMemberKey = pcp.mbrMemberKey
     WHERE mbr.ClientMemberKey = @mbrSubID;


	IF @DetailLevel = 'V'
	BEGIN

	   SELECT 'adw.MbrMember' As [adw.MbrMember], *
	   FROM adw.MbrMember m
	   where M.CLIentmemberKey = @mbrSubID
	   
	   SELECT 'adw.MbrPlan' As [adw.MbrPlan], m.ClientMemberkey, m.ClientKey, p.*
	   FROM adw.MbrMember m
	       LEFT JOIN adw.MbrPlan p ON m.mbrMemberKey = p.mbrMemberKey
	   where M.CLIentmemberKey = @mbrSubID
	   
	   SELECT 'adw.MbrCsPlanHistory' As [adw.MbrCsPlanHistory], m.ClientMemberkey, m.ClientKey, p.*
	   FROM adw.MbrMember m
	       LEFT JOIN adw.MbrCsPlanHistory p ON m.mbrMemberKey = p.mbrMemberKey
	   where M.CLIentmemberKey = @mbrSubID
	   
	   SELECT 'adw.MbrPCP' As [adw.MbrPCP], m.ClientMemberkey, m.ClientKey, p.*
	   FROM adw.MbrMember m
	       LEFT JOIN adw.MbrPCP p ON m.mbrMemberKey = p.mbrMemberKey
	   where M.CLIentmemberKey = @mbrSubID
	   
	   SELECT 'adw.MbrDemographics' As [adw.MbrDemographics], m.ClientMemberkey, m.ClientKey, p.*
	   FROM adw.MbrMember m
	       LEFT JOIN adw.MbrDemographic p ON m.mbrMemberKey = p.mbrMemberKey
	   where M.CLIentmemberKey = @mbrSubID
    END;