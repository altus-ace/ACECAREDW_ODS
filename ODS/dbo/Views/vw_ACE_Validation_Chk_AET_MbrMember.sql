

CREATE VIEW [dbo].[vw_ACE_Validation_Chk_AET_MbrMember]
AS
     SELECT DISTINCT
         P.AetSubscriberID,
            p.LoadDate AS adiloaddate,
		      m.ClientMemberKey,
			   m.mbrmemberkey AS mbrmembermbrkey,
      Pr.[TAX ID]
     FROM ACECAREDW.adi.[MbrAetMbrByPcp] p
	INNER JOIN vw_Aetna_ProviderRoster Pr ON convert(int,Pr.[TAX ID])=convert(int,p.TIN) AND Pr.effective_date__C<=GETDATE()
          LEFT JOIN acecaredw.[adw].[MbrMember] m ON m.ClientMemberKey = p.AetSubscriberID
       --  LEFT JOIN [ACECAREDW].[lst].[List_Client] lc ON lc.Clientkey = m.clientkey
       --   LEFT JOIN [ACECAREDW].[adw].[MbrDemographic] md ON md.[mbrMemberKey] = m.[mbrMemberKey] 
     WHERE MONTH(p.LoadDate) = MONTH(GETDATE())
           AND YEAR(p.loaddate) = YEAR(GETDATE())
		 and  pr.lob in ('Medicare Advantage') and pr.term_date__C is null
           --AND M.ClientKey = 3
		 and m.mbrMemberKey is null
	

