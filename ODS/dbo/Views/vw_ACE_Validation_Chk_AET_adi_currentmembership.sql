CREATE VIEW [dbo].[vw_ACE_Validation_Chk_AET_adi_currentmembership]
AS
     SELECT DISTINCT
	   'Get Current Active Members for AET' ValidationCheck,
         P.AetSubscriberID,
            p.LoadDate AS adiloaddate,
		      m.ClientMemberKey,
			   m.mbrmemberkey AS mbrmembermbrkey,
      Pr.[TAX ID],
	 p.tin,
	 p.TINName
     FROM ACECAREDW.adi.[MbrAetMbrByPcp] p
	 JOIN (select * from vw_Aetna_ProviderRoster where   lob in ('Medicare Advantage') and term_date__C is null )Pr 
	ON convert(int,Pr.[TAX ID])=convert(int,p.TIN) AND Pr.effective_date__C<=GETDATE()
          LEFT JOIN acecaredw.[adw].[MbrMember] m ON m.ClientMemberKey = p.AetSubscriberID
       --  LEFT JOIN [ACECAREDW].[lst].[List_Client] lc ON lc.Clientkey = m.clientkey
       --   LEFT JOIN [ACECAREDW].[adw].[MbrDemographic] md ON md.[mbrMemberKey] = m.[mbrMemberKey] 
     WHERE MONTH(p.LoadDate) = MONTH(GETDATE())
           AND YEAR(p.loaddate) = YEAR(GETDATE())
		
	


